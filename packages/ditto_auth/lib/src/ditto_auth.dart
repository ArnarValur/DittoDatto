import 'dart:async';

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

  /// The active tenant connection (available after successful
  /// [businessSignin] or [tryRestoreBusiness]).
  TenantConnection? _activeTenant;

  /// The active tenant connection, if any.
  TenantConnection? get activeTenant => _activeTenant;

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

    // Persist session for restore.
    await _tokenStore.saveBusinessSession(
      usersToken: userAuth.usersToken,
      tenantToken: tenantAuth.companiesToken,
      email: email.trim().toLowerCase(),
      slug: slug,
      name: name,
      role: role,
    );

    return BusinessAuthResult(
      email: email.trim().toLowerCase(),
      name: name,
      role: role,
      companySlug: slug,
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
    await _tokenStore.clear();
    await _backend.disconnect();
  }

  // ── Consumer Auth (Phase 4 — designed, not implemented) ──

  /// RECORD ACCESS `consumer_auth` signin on users/users.
  ///
  /// Returns [ConsumerAuthResult] with user connection and profile.
  /// Not implemented yet — throws [UnimplementedError].
  Future<ConsumerAuthResult> consumerSignin({
    required String email,
    required String password,
  }) {
    throw UnimplementedError(
      'Consumer signin is not yet implemented — Phase 4',
    );
  }

  /// RECORD ACCESS `consumer_auth` signup on users/users.
  ///
  /// Creates user record with role='customer', returns JWT immediately.
  /// Not implemented yet — throws [UnimplementedError].
  Future<ConsumerAuthResult> consumerSignup({
    required String name,
    required String email,
    required String password,
  }) {
    throw UnimplementedError(
      'Consumer signup is not yet implemented — Phase 4',
    );
  }
}
