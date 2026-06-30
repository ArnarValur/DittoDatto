import 'dart:async';

import 'package:surrealdb/surrealdb.dart';

import 'auth_backend.dart';
import 'auth_result.dart';
import 'exceptions.dart';
import 'surreal_auth_backend.dart';
import 'tenant_connection.dart';
import 'token_store.dart';

/// Shared authentication entry point for all DittoDatto Flutter apps.
///
/// Encapsulates SurrealDB RECORD ACCESS auth (consumer + business),
/// token lifecycle, and tenant routing behind a swappable [AuthBackend].
///
/// Usage:
/// ```dart
/// final auth = DittoAuth(
///   backend: SurrealAuthBackend(
///     serviceUser: 'bp_portal',
///     servicePass: portalPassword,
///   ),
/// );
///
/// final result = await auth.businessSignin(
///   email: 'user@example.com',
///   password: 'secret',
/// );
/// ```
class DittoAuth {
  DittoAuth({
    required this._backend,
    TokenStore? tokenStore,
  })  : _tokenStore = tokenStore ?? TokenStore();

  final AuthBackend _backend;
  final TokenStore _tokenStore;

  /// The auth backend, for callers that need connection parameters
  /// (e.g. opening a read-only discovery DB connection).
  AuthBackend get backend => _backend;

  /// The active tenant connection (available after successful
  /// [businessSignin] or [tryRestoreBusiness]).
  TenantConnection? _activeTenant;

  /// The active consumer DB connection (available after consumer auth).
  SurrealDB? _consumerDb;

  /// The active tenant connection, if any.
  TenantConnection? get activeTenant => _activeTenant;

  /// The active consumer DB connection, if any.
  SurrealDB? get consumerDb => _consumerDb;

  // ── Business Portal Auth ──

  /// Two-phase business signin:
  ///   Phase 1: RECORD ACCESS `bp_auth` on users/users → user identity + role check
  ///   Phase 2: `bp_portal` service user signin on company_{slug} → tenant connection
  ///
  /// Returns [BusinessAuthResult] with both connections and user profile.
  /// Throws [DittoAuthException] on failure.
  Future<BusinessAuthResult> businessSignin({
    required String email,
    required String password,
  }) async {
    // Phase 1: Authenticate user identity.
    final userAuth = await _backend.authenticateUser(
      email: email.trim().toLowerCase(),
      password: password,
      accessMethod: 'bp_auth',
    );

    final profile = userAuth.profile;

    // Role check — enforce business-only access.
    final role = profile['role'] as String?;
    if (role == null ||
        !SurrealAuthBackend.allowedBusinessRoles.contains(role)) {
      userAuth.usersDb.close();
      throw InsufficientRole(role ?? 'null');
    }

    // Extract company slug.
    final rawSlug = profile['company_slug'] as String?;
    if (rawSlug == null || rawSlug.trim().isEmpty) {
      userAuth.usersDb.close();
      throw const NoCompanyAssigned();
    }
    final slug = rawSlug.split(',').first.trim();

    // Phase 2: Connect to tenant DB.
    final tenantAuth = await _backend.connectTenant(
      usersDb: userAuth.usersDb,
      usersToken: userAuth.usersToken,
      slug: slug,
    );

    final tenant = TenantConnection(
      companies: tenantAuth.companiesDb,
      users: userAuth.usersDb,
      slug: slug,
    );

    _activeTenant = tenant;

    final name = profile['name'] as String?;
    final companyName = profile['company_name'] as String?;

    // Persist session for restore.
    await _tokenStore.saveBusinessSession(
      usersToken: userAuth.usersToken,
      tenantToken: tenantAuth.companiesToken,
      email: email.trim().toLowerCase(),
      slug: slug,
      name: name,
      role: role,
      companyName: companyName,
    );

    return BusinessAuthResult(
      email: email.trim().toLowerCase(),
      name: name,
      role: role,
      companySlug: slug,
      companyName: companyName,
      tenant: tenant,
    );
  }

  // ── Session Management ──

  /// Attempt to restore a previous business session from stored tokens.
  ///
  /// If access token expired but refresh token is valid → auto-refresh.
  /// If both expired → returns null (caller redirects to login).
  Future<BusinessAuthResult?> tryRestoreBusiness() async {
    final stored = await _tokenStore.loadBusinessSession();
    if (stored == null) return null;

    try {
      final restored = await _backend.restoreSession(
        usersToken: stored.usersToken,
        tenantToken: stored.tenantToken,
        tenantSlug: stored.slug,
      ).timeout(const Duration(seconds: 5));

      if (restored.companiesDb == null || restored.slug == null) {
        restored.usersDb.close();
        restored.companiesDb?.close();
        await _tokenStore.clear();
        return null;
      }

      final tenant = TenantConnection(
        companies: restored.companiesDb!,
        users: restored.usersDb,
        slug: restored.slug!,
      );

      _activeTenant = tenant;

      return BusinessAuthResult(
        email: stored.email,
        name: stored.name,
        role: stored.role ?? 'business',
        companySlug: stored.slug,
        companyName: stored.companyName,
        tenant: tenant,
      );
    } catch (e) {
      // Tokens expired or connection failed — clear and require fresh login.
      await _tokenStore.clear();
      return null;
    }
  }

  /// Sign out: close connections, clear stored tokens.
  Future<void> signOut() async {
    _activeTenant?.close();
    _activeTenant = null;
    _consumerDb?.close();
    _consumerDb = null;
    await _tokenStore.clear();
    await _backend.disconnect();
  }

  // ── Consumer Auth ──

  /// RECORD ACCESS `consumer_auth` signin on users/users.
  ///
  /// Returns [ConsumerAuthResult] with user profile.
  /// Throws [DittoAuthException] on failure.
  Future<ConsumerAuthResult> consumerSignin({
    required String email,
    required String password,
  }) async {
    final userAuth = await _backend.authenticateUser(
      email: email.trim().toLowerCase(),
      password: password,
      accessMethod: 'consumer_auth',
    );

    final profile = userAuth.profile;
    final userId = _extractId(profile);
    final name = profile['name'] as String?;

    // Persist session for restore.
    await _tokenStore.saveConsumerSession(
      usersToken: userAuth.usersToken,
      email: email.trim().toLowerCase(),
      name: name,
      userId: userId,
    );

    // Keep connection reference for profile queries.
    _consumerDb = userAuth.usersDb;

    return ConsumerAuthResult(
      email: email.trim().toLowerCase(),
      name: name,
      userId: userId,
    );
  }

  /// RECORD ACCESS `consumer_auth` signup on users/users.
  ///
  /// Creates user record with role='customer', returns JWT immediately.
  /// Throws [DittoAuthException] on failure.
  Future<ConsumerAuthResult> consumerSignup({
    required String name,
    required String email,
    required String password,
  }) async {
    final wsEndpoint = switch (_backend) {
      SurrealAuthBackend(wsUrl: final url?) => url,
      SurrealAuthBackend() => SurrealAuthBackend.deriveWsUrl(),
      _ => SurrealAuthBackend.deriveWsUrl(),
    };

    final usersDb = SurrealDB(wsEndpoint);
    usersDb.connect();
    await usersDb.wait();

    try {
      final usersToken = await usersDb.signup(
        namespace: 'users',
        database: 'users',
        access: 'consumer_auth',
        extra: {
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'pass': password,
        },
      );

      // Query the newly created user's profile.
      final profileResult = await usersDb.query(
        r'SELECT id, name FROM $auth',
      );

      final profile = SurrealAuthBackend.extractFirstRow(profileResult);
      final userId = profile != null ? _extractId(profile) : '';

      // Persist session.
      await _tokenStore.saveConsumerSession(
        usersToken: usersToken,
        email: email.trim().toLowerCase(),
        name: name.trim(),
        userId: userId,
      );

      _consumerDb = usersDb;

      return ConsumerAuthResult(
        email: email.trim().toLowerCase(),
        name: name.trim(),
        userId: userId,
      );
    } catch (e) {
      usersDb.close();
      if (e is DittoAuthException) rethrow;
      throw InvalidCredentials(e.toString());
    }
  }

  /// Attempt to restore a previous consumer session from stored tokens.
  ///
  /// Returns null if no stored session or tokens expired.
  Future<ConsumerAuthResult?> tryRestoreConsumer() async {
    final stored = await _tokenStore.loadConsumerSession();
    if (stored == null) return null;

    try {
      final restored = await _backend.restoreSession(
        usersToken: stored.usersToken,
      ).timeout(const Duration(seconds: 5));

      _consumerDb = restored.usersDb;

      return ConsumerAuthResult(
        email: stored.email,
        name: stored.name,
        userId: stored.userId ?? '',
      );
    } catch (e) {
      await _tokenStore.clear();
      return null;
    }
  }

  /// Extract record ID from profile map.
  static String _extractId(Map<String, dynamic> profile) {
    final id = profile['id'];
    if (id is String) return id;
    if (id is Map && id.containsKey('tb') && id.containsKey('id')) {
      return '${id['tb']}:${id['id']}';
    }
    return id?.toString() ?? '';
  }
}
