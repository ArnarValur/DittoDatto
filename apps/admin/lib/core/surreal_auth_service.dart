import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mercury_client/mercury_client.dart';

import 'surreal_connection.dart';
import 'web_storage.dart';

/// Authenticates admin users against SurrealDB namespace-level users.
///
/// Login flow:
/// 1. Extract username from email (e.g. `arnarvalur@dittodatto.no` → `arnarvalur`)
/// 2. Connect two WebSocket clients to SurrealDB
/// 3. Signin as namespace user on both `companies` and `users` namespaces
/// 4. Store the returned JWT tokens in secure storage for persistence
/// 5. If both succeed → [Authenticated]; if either fails → [Unauthenticated]
///
/// Session restore:
/// On cold start, reads stored tokens and reconnects via `authenticate()`.
/// Tokens have a 1h TTL (set by SurrealDB DEFINE USER ... DURATION FOR TOKEN 1h).
/// If tokens are expired, SurrealDB rejects the authenticate call and we
/// fall back to [Unauthenticated].
class SurrealAuthService implements AuthService {
  SurrealAuthService({this.wsUrl, FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Optional explicit WebSocket URL. If null, derived from page origin.
  final String? wsUrl;

  final FlutterSecureStorage _storage;

  static const _companiesTokenKey = 'dd_admin_companies_token';
  static const _usersTokenKey = 'dd_admin_users_token';
  static const _emailKey = 'dd_admin_email';

  /// The active connection, available after successful login.
  SurrealConnection? _connection;

  /// Expose the active connection for the repository layer.
  SurrealConnection? get connection => _connection;

  @override
  Future<AuthState> login(String email, String password) async {
    try {
      // Extract username from email prefix.
      final username = email.split('@').first;

      final result = await SurrealConnection.connect(
        user: username,
        pass: password,
        url: wsUrl,
      );

      _connection = result.connection;

      // Persist tokens and email for session restore.
      if (kIsWeb) {
        await WebStorage.write(_companiesTokenKey, result.companiesToken);
        await WebStorage.write(_usersTokenKey, result.usersToken);
        await WebStorage.write(_emailKey, email);
      } else {
        await _storage.write(key: _companiesTokenKey, value: result.companiesToken);
        await _storage.write(key: _usersTokenKey, value: result.usersToken);
        await _storage.write(key: _emailKey, value: email);
      }

      return Authenticated(accessToken: result.companiesToken, email: email);
    } catch (e) {
      // Per PRD: no error feedback. Return unauthenticated silently.
      // Also catches JS runtime errors (like missing Web Crypto under HTTP) to prevent UI freeze.
      return const Unauthenticated();
    }
  }

  @override
  Future<AuthState> logout() async {
    _connection?.close();
    _connection = null;
    if (kIsWeb) {
      await WebStorage.delete(_companiesTokenKey);
      await WebStorage.delete(_usersTokenKey);
      await WebStorage.delete(_emailKey);
    } else {
      await _storage.delete(key: _companiesTokenKey);
      await _storage.delete(key: _usersTokenKey);
      await _storage.delete(key: _emailKey);
    }
    return const Unauthenticated();
  }

  @override
  Future<AuthState> tryRestore() async {
    try {
      final String? companiesToken;
      final String? usersToken;
      final String? email;

      if (kIsWeb) {
        companiesToken = await WebStorage.read(_companiesTokenKey);
        usersToken = await WebStorage.read(_usersTokenKey);
        email = await WebStorage.read(_emailKey);
      } else {
        companiesToken = await _storage.read(key: _companiesTokenKey);
        usersToken = await _storage.read(key: _usersTokenKey);
        email = await _storage.read(key: _emailKey);
      }

      if (companiesToken == null || usersToken == null || email == null) {
        return const Unauthenticated();
      }

      // Reconnect using stored JWT tokens.
      // If tokens are expired, SurrealDB will reject authenticate() and throw.
      final conn = await SurrealConnection.connectWithTokens(
        companiesToken: companiesToken,
        usersToken: usersToken,
        url: wsUrl,
      );

      _connection = conn;
      return Authenticated(accessToken: companiesToken, email: email);
    } catch (e) {
      // Tokens expired, invalid, or storage access failed — clean up and require fresh login.
      if (kIsWeb) {
        await WebStorage.delete(_companiesTokenKey);
        await WebStorage.delete(_usersTokenKey);
        await WebStorage.delete(_emailKey);
      } else {
        await _storage.delete(key: _companiesTokenKey);
        await _storage.delete(key: _usersTokenKey);
        await _storage.delete(key: _emailKey);
      }
      return const Unauthenticated();
    }
  }
}
