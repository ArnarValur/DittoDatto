
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/token_response.dart';
import 'auth_state.dart';

/// Service responsible for JWT lifecycle — login, logout, persist, restore.
///
/// Uses [FlutterSecureStorage] for token persistence across app restarts.
/// Checks token expiry with a 30-second buffer to prevent edge-case failures.
abstract class AuthService {
  /// Attempt login with email and password.
  ///
  /// Returns [Authenticated] on success, [AuthError] on failure.
  Future<AuthState> login(String email, String password);

  /// Clear the stored token and return [Unauthenticated].
  Future<AuthState> logout();

  /// Try to restore a previously stored token.
  ///
  /// Returns [Authenticated] if a valid (non-expired) token exists,
  /// [Unauthenticated] otherwise.
  Future<AuthState> tryRestore();
}

/// Auth service backed by [FlutterSecureStorage] and a real or mock API.
class SecureAuthService implements AuthService {
  SecureAuthService({
    required this.loginCallback,
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  /// Callback that performs the actual login API call.
  /// Implementations provide either a real HTTP call or a mock.
  final Future<TokenResponse> Function(String email, String password)
      loginCallback;

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'mercury_access_token';
  static const _emailKey = 'mercury_user_email';
  static const _expiryKey = 'mercury_token_expiry';

  /// Buffer before token expiry (30 seconds).
  static const _expiryBuffer = Duration(seconds: 30);

  @override
  Future<AuthState> login(String email, String password) async {
    try {
      final response = await loginCallback(email, password);
      final expiry = DateTime.now().add(Duration(seconds: response.expiresIn));

      await _storage.write(key: _tokenKey, value: response.accessToken);
      await _storage.write(key: _emailKey, value: email);
      await _storage.write(key: _expiryKey, value: expiry.toIso8601String());

      return Authenticated(
        accessToken: response.accessToken,
        email: email,
      );
    } on Exception catch (e) {
      return AuthError(message: e.toString());
    }
  }

  @override
  Future<AuthState> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _expiryKey);
    return const Unauthenticated();
  }

  @override
  Future<AuthState> tryRestore() async {
    final token = await _storage.read(key: _tokenKey);
    final email = await _storage.read(key: _emailKey);
    final expiryStr = await _storage.read(key: _expiryKey);

    if (token == null || email == null || expiryStr == null) {
      return const Unauthenticated();
    }

    final expiry = DateTime.parse(expiryStr);
    if (DateTime.now().isAfter(expiry.subtract(_expiryBuffer))) {
      // Token expired or about to expire — clean up.
      await logout();
      return const Unauthenticated();
    }

    return Authenticated(accessToken: token, email: email);
  }
}
