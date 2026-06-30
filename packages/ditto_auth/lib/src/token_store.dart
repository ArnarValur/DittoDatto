import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'web_storage.dart';

/// Secure token persistence layer.
///
/// Abstracts FlutterSecureStorage (native) vs localStorage (web, ADR-0009).
/// Stores all session data needed for restore-on-startup.
class TokenStore {
  TokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _usersTokenKey = 'ditto_auth_users_token';
  static const _tenantTokenKey = 'ditto_auth_tenant_token';
  static const _refreshTokenKey = 'ditto_auth_refresh_token';
  static const _emailKey = 'ditto_auth_email';
  static const _slugKey = 'ditto_auth_slug';
  static const _nameKey = 'ditto_auth_name';
  static const _roleKey = 'ditto_auth_role';
  static const _companyNameKey = 'ditto_auth_company_name';
  static const _sessionTypeKey = 'ditto_auth_session_type';
  static const _userIdKey = 'ditto_auth_user_id';

  /// Save a business session for later restore.
  Future<void> saveBusinessSession({
    required String usersToken,
    required String tenantToken,
    required String email,
    required String slug,
    String? refreshToken,
    String? name,
    String? role,
    String? companyName,
  }) async {
    await _writeAll({
      _sessionTypeKey: 'business',
      _usersTokenKey: usersToken,
      _tenantTokenKey: tenantToken,
      _emailKey: email,
      _slugKey: slug,
      _refreshTokenKey: ?refreshToken,
      _nameKey: ?name,
      _roleKey: ?role,
      _companyNameKey: ?companyName,
    });
  }

  /// Load a previously stored business session.
  ///
  /// Returns null if any required key is missing.
  Future<StoredBusinessSession?> loadBusinessSession() async {
    final usersToken = await _read(_usersTokenKey);
    final tenantToken = await _read(_tenantTokenKey);
    final email = await _read(_emailKey);
    final slug = await _read(_slugKey);

    if (usersToken == null ||
        tenantToken == null ||
        email == null ||
        slug == null) {
      return null;
    }

    return StoredBusinessSession(
      usersToken: usersToken,
      tenantToken: tenantToken,
      refreshToken: await _read(_refreshTokenKey),
      email: email,
      slug: slug,
      name: await _read(_nameKey),
      role: await _read(_roleKey),
      companyName: await _read(_companyNameKey),
    );
  }

  /// Save a consumer session for later restore.
  Future<void> saveConsumerSession({
    required String usersToken,
    required String email,
    String? name,
    String? userId,
  }) async {
    await _writeAll({
      _sessionTypeKey: 'consumer',
      _usersTokenKey: usersToken,
      _emailKey: email,
      _nameKey: ?name,
      _userIdKey: ?userId,
    });
  }

  /// Load a previously stored consumer session.
  ///
  /// Returns null if any required key is missing or session type is not consumer.
  Future<StoredConsumerSession?> loadConsumerSession() async {
    final sessionType = await _read(_sessionTypeKey);
    if (sessionType != 'consumer') return null;

    final usersToken = await _read(_usersTokenKey);
    final email = await _read(_emailKey);

    if (usersToken == null || email == null) return null;

    return StoredConsumerSession(
      usersToken: usersToken,
      email: email,
      name: await _read(_nameKey),
      userId: await _read(_userIdKey),
    );
  }

  /// Clear all stored tokens and session data.
  Future<void> clear() async {
    await _deleteAll([
      _usersTokenKey,
      _tenantTokenKey,
      _refreshTokenKey,
      _emailKey,
      _slugKey,
      _nameKey,
      _roleKey,
      _companyNameKey,
      _sessionTypeKey,
      _userIdKey,
    ]);
  }

  // ── Platform-aware storage helpers ──

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

/// Data from a previously stored business session.
class StoredBusinessSession {
  const StoredBusinessSession({
    required this.usersToken,
    required this.tenantToken,
    this.refreshToken,
    required this.email,
    required this.slug,
    this.name,
    this.role,
    this.companyName,
  });

  final String usersToken;
  final String tenantToken;
  final String? refreshToken;
  final String email;
  final String slug;
  final String? name;
  final String? role;
  final String? companyName;
}

/// Data from a previously stored consumer session.
class StoredConsumerSession {
  const StoredConsumerSession({
    required this.usersToken,
    required this.email,
    this.name,
    this.userId,
  });

  final String usersToken;
  final String email;
  final String? name;
  final String? userId;
}

