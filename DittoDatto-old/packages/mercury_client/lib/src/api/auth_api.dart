import '../models/auth.dart';
import 'mercury_api.dart';

/// Auth-specific API methods.
///
/// Wraps POST /auth/dev-login for the development authentication flow.
class AuthApi {
  const AuthApi(this._api);

  final MercuryApi _api;

  /// Authenticate with email + password (development only).
  ///
  /// Returns JWT token response matching the Vipps OIDC format.
  /// Endpoint: POST /auth/dev-login
  Future<TokenResponse> devLogin({
    required String email,
    required String password,
  }) async {
    final json = await _api.post('/auth/dev-login', body: {
      'email': email,
      'password': password,
    });
    return TokenResponse.fromJson(json as Map<String, dynamic>);
  }
}
