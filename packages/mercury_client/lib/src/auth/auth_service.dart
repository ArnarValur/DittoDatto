import 'dart:convert';

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

/// Mock auth service for development without a real backend.
///
/// Accepts a known set of credentials and returns a fake JWT.
class MockAuthService implements AuthService {
  MockAuthService({
    this.validCredentials = const {
      'arnar@dittodatto.no': 'admin123',
      'hoddi@dittodatto.no': 'admin123',
    },
    this.latency = const Duration(milliseconds: 800),
  });

  /// Map of email → password that will succeed.
  final Map<String, String> validCredentials;

  /// Simulated network latency.
  final Duration latency;

  AuthState _state = const Unauthenticated();

  @override
  Future<AuthState> login(String email, String password) async {
    await Future<void>.delayed(latency);

    if (validCredentials[email] == password) {
      // Generate a fake JWT-like token (not cryptographically valid).
      final payload = base64Encode(
        utf8.encode('{"sub":"$email","exp":${DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000}}'),
      );
      final fakeToken = 'eyJhbGciOiJIUzI1NiJ9.$payload.mock-signature';

      _state = Authenticated(accessToken: fakeToken, email: email);
      return _state;
    }

    _state = const AuthError(message: 'Invalid credentials');
    return _state;
  }

  @override
  Future<AuthState> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _state = const Unauthenticated();
    return _state;
  }

  @override
  Future<AuthState> tryRestore() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // Mock has no persistence — always unauthenticated on cold start.
    return const Unauthenticated();
  }
}
