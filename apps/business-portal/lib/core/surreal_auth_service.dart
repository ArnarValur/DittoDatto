import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mercury_client/mercury_client.dart';

import 'surreal_connection.dart';
import 'web_storage.dart';

/// Authenticates Business Portal users against SurrealDB namespace-level users.
///
/// Login flow (per ADR-0013):
/// 1. Extract username from email (e.g. `arnarvalur@dittodatto.no` → `arnarvalur`)
/// 2. Connect two WebSocket clients to SurrealDB
/// 3. Signin as namespace user on both `companies` and `users` namespaces
/// 4. Query `users/profiles` for the user's role and `company_slug`
/// 5. Reject non-business roles (customer accounts cannot access the portal)
/// 6. Route the companies connection to `company_{slug}` (tenant isolation)
/// 7. Store JWT tokens + slug in secure storage for persistence
class SurrealAuthService implements AuthService {
  SurrealAuthService({this.wsUrl, FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Optional explicit WebSocket URL. If null, derived from page origin.
  final String? wsUrl;

  final FlutterSecureStorage _storage;

  static const _companiesTokenKey = 'dd_portal_companies_token';
  static const _usersTokenKey = 'dd_portal_users_token';
  static const _emailKey = 'dd_portal_email';
  static const _slugKey = 'dd_portal_company_slug';

  /// Roles permitted to access the Business Portal.
  static const _allowedRoles = {'business', 'admin', 'super_admin'};

  /// The active connection, available after successful login.
  SurrealConnection? _connection;

  /// Expose the active connection for the repository layer.
  SurrealConnection? get connection => _connection;

  @override
  Future<AuthState> login(String email, String password) async {
    try {
      final username = email.split('@').first;

      final result = await SurrealConnection.connect(
        user: username,
        pass: password,
        url: wsUrl,
      );

      final conn = result.connection;

      // ── Step 2: Role verification + slug discovery ──
      // The users connection is already routed to users/profiles by connect().
      // Look up by username — the NS identity we authenticated with. This
      // decouples the login form from the real email on the user record.
      // (The email domain in the form is irrelevant for NS auth.)
      final profileResult = await conn.users.query(
        r'SELECT role, company_slug FROM user WHERE username = $username LIMIT 1',
        {'username': username},
      );

      final profile = _extractFirstRow(profileResult);
      if (profile == null) {
        conn.close();
        return const Unauthenticated();
      }

      final role = profile['role'] as String?;
      if (role == null || !_allowedRoles.contains(role)) {
        conn.close();
        return const Unauthenticated();
      }

      final rawSlug = profile['company_slug'] as String?;
      if (rawSlug == null || rawSlug.trim().isEmpty) {
        conn.close();
        return const Unauthenticated();
      }

      // Option A: take the first slug (single-company MVP).
      // company_slug can be comma-separated for multi-company users.
      final slug = rawSlug.split(',').first.trim();

      // ── Step 3: Tenant routing ──
      await conn.routeToTenant(slug);

      _connection = conn;

      // Persist tokens, email, and slug for session restore.
      await _writeAll({
        _companiesTokenKey: result.companiesToken,
        _usersTokenKey: result.usersToken,
        _emailKey: email,
        _slugKey: slug,
      });

      return Authenticated(accessToken: result.companiesToken, email: email);
    } catch (e) {
      // Per PRD: no error feedback. Return unauthenticated silently.
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

  /// Extract the first row from a SurrealDB query result.
  ///
  /// The Dart SDK can return results in different shapes depending on version:
  /// `[{result: [...]}]` or a flat `[{...}]`.
  Map<String, dynamic>? _extractFirstRow(dynamic result) {
    if (result is! List || result.isEmpty) return null;

    final first = result.first;
    if (first is Map && first.containsKey('result')) {
      final inner = first['result'];
      if (inner is List && inner.isNotEmpty && inner.first is Map) {
        return Map<String, dynamic>.from(inner.first as Map);
      }
      return null;
    }

    if (first is Map) {
      return Map<String, dynamic>.from(first);
    }

    return null;
  }

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
