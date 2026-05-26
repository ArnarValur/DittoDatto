import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/auth_api.dart';
import '../api/mercury_api.dart';
import '../models/auth.dart';

/// Token lifecycle management.
///
/// Handles login, JWT storage in secure storage, and expiry detection.
/// Biometric re-auth (local_auth) deferred to future slice.
class AuthService {
  AuthService({
    required MercuryApi api,
    FlutterSecureStorage? storage,
  }) : _authApi = AuthApi(api),
       _api = api,
       _storage = storage ?? const FlutterSecureStorage();

  final AuthApi _authApi;
  final MercuryApi _api;
  final FlutterSecureStorage _storage;

  static const _tokenKey = 'mercury_jwt';

  /// Login with email + password via dev-login endpoint.
  ///
  /// On success: stores JWT in secure storage and sets it on the API client.
  Future<TokenResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _authApi.devLogin(
      email: email,
      password: password,
    );

    // Persist and activate
    await _storage.write(key: _tokenKey, value: response.accessToken);
    _api.setToken(response.accessToken);

    return response;
  }

  /// Try to restore a previously stored token.
  ///
  /// Returns the token if found and not expired, null otherwise.
  Future<String?> restoreToken() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) return null;

    if (isTokenExpired(token)) {
      await _storage.delete(key: _tokenKey);
      return null;
    }

    _api.setToken(token);
    return token;
  }

  /// Clear stored token and remove from API client.
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    _api.setToken(null);
  }

  /// Check if a JWT's exp claim has passed.
  ///
  /// Decodes the payload without verification — the engine verifies on
  /// every request. We only need this to decide whether to prompt re-login.
  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      // Decode the payload (base64url, may need padding)
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final claims = jsonDecode(decoded) as Map<String, dynamic>;

      final exp = claims['exp'] as int?;
      if (exp == null) return true;

      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      // Add 30-second buffer to avoid edge-case rejections
      return DateTime.now().isAfter(expiry.subtract(const Duration(seconds: 30)));
    } catch (_) {
      return true;
    }
  }
}
