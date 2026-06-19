import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mercury_client/mercury_client.dart';

import 'surreal_connection.dart';
import 'web_storage.dart';

/// Authenticates Business Portal users via RECORD ACCESS on `users/users`.
///
/// Login flow (ADR-0016):
/// 1. RECORD ACCESS signin on `users/users` — validates email + password_hash
/// 3. Query `$auth` for role and company_slug (token is scoped to user's record)
/// 4. Reject non-business roles
/// 5. Connect to `company_{slug}` using DB-level service credentials
/// 6. Store JWT tokens + slug for session persistence
///
/// The user's password is NEVER used as a database credential. It's validated
/// against `password_hash` in their profile via `crypto::argon2::compare()`.
class SurrealAuthService implements AuthService {
  SurrealAuthService({
    this.wsUrl,
    this.serviceUser,
    this.servicePass,
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  /// Optional explicit WebSocket URL. If null, derived from page origin.
  final String? wsUrl;

  /// DB-level service credentials for company DB access.
  /// Injected via `--dart-define` at build time — never the user's password.
  final String? serviceUser;
  final String? servicePass;

  final FlutterSecureStorage _storage;

  static const _companiesTokenKey = 'dd_portal_companies_token';
  static const _usersTokenKey = 'dd_portal_users_token';
  static const _emailKey = 'dd_portal_email';
  static const _slugKey = 'dd_portal_company_slug';

  /// Roles permitted to access the Business Portal.
  static const _allowedRoles = {'business', 'admin', 'super_admin'};

  /// Default service account name for company DB access.
  static const _defaultServiceUser = 'bp_portal';

  /// The active connection, available after successful login.
  SurrealConnection? _connection;

  /// Expose the active connection for the repository layer.
  SurrealConnection? get connection => _connection;

  @override
  Future<AuthState> login(String email, String password) async {
    try {
      // ── Phase 1: RECORD ACCESS auth on users/users ──
      // Validates full email + password against password_hash in user record.
      // No database admin credentials involved.
      final authResult = await SurrealConnection.authenticateUser(
        email: email.trim().toLowerCase(),
        password: password,
        url: wsUrl,
      );

      final profile = authResult.profile;

      // ── Role check ──
      final role = profile['role'] as String?;
      if (role == null || !_allowedRoles.contains(role)) {
        authResult.usersDb.close();
        return const Unauthenticated();
      }

      final rawSlug = profile['company_slug'] as String?;
      if (rawSlug == null || rawSlug.trim().isEmpty) {
        authResult.usersDb.close();
        return const Unauthenticated();
      }

      // Single-company MVP: take the first slug.
      final slug = rawSlug.split(',').first.trim();

      // ── Phase 2: Connect to tenant DB with service credentials ──
      final svcUser = serviceUser ?? _defaultServiceUser;
      final svcPass = servicePass ?? '';
      if (svcPass.isEmpty) {
        authResult.usersDb.close();
        throw AuthenticationException(
          'BP_PORTAL_PASS not configured. '
          'Set via --dart-define=BP_PORTAL_PASS=<value>',
        );
      }

      final tenantResult = await SurrealConnection.connectTenant(
        usersDb: authResult.usersDb,
        usersToken: authResult.usersToken,
        slug: slug,
        serviceUser: svcUser,
        servicePass: svcPass,
        url: wsUrl,
      );

      _connection = tenantResult.connection;

      // Persist tokens, email, and slug for session restore.
      await _writeAll({
        _companiesTokenKey: tenantResult.companiesToken,
        _usersTokenKey: tenantResult.usersToken,
        _emailKey: email,
        _slugKey: slug,
      });

      return Authenticated(accessToken: tenantResult.companiesToken, email: email);
    } on AuthenticationException {
      // Config error — rethrow so it surfaces.
      rethrow;
    } catch (e) {
      // Auth failure (wrong password, nonexistent user, etc.) — silent fail per PRD.
      return const Unauthenticated();
    }
  }

  @override
  Future<AuthState> logout() async {
    _connection?.close();
    _connection = null;
    await _deleteAll([
      _companiesTokenKey,
      _usersTokenKey,
      _emailKey,
      _slugKey,
    ]);
    return const Unauthenticated();
  }

  @override
  Future<AuthState> tryRestore() async {
    try {
      final companiesToken = await _read(_companiesTokenKey);
      final usersToken = await _read(_usersTokenKey);
      final email = await _read(_emailKey);
      final slug = await _read(_slugKey);

      if (companiesToken == null ||
          usersToken == null ||
          email == null ||
          slug == null) {
        return const Unauthenticated();
      }

      final conn = await SurrealConnection.connectWithTokens(
        companiesToken: companiesToken,
        usersToken: usersToken,
        slug: slug,
        url: wsUrl,
      );

      _connection = conn;
      return Authenticated(accessToken: companiesToken, email: email);
    } catch (e) {
      // Tokens expired or storage access failed — require fresh login.
      await _deleteAll([
        _companiesTokenKey,
        _usersTokenKey,
        _emailKey,
        _slugKey,
      ]);
      return const Unauthenticated();
    }
  }

  // ── Storage helpers ──

  Future<String?> _read(String key) async {
    if (kIsWeb) return WebStorage.read(key);
    return _storage.read(key: key);
  }

  Future<void> _writeAll(Map<String, String> entries) async {
    for (final entry in entries.entries) {
      if (kIsWeb) {
        await WebStorage.write(entry.key, entry.value);
      } else {
        await _storage.write(key: entry.key, value: entry.value);
      }
    }
  }

  Future<void> _deleteAll(List<String> keys) async {
    for (final key in keys) {
      if (kIsWeb) {
        await WebStorage.delete(key);
      } else {
        await _storage.delete(key: key);
      }
    }
  }
}
