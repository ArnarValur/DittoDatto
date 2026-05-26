import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import 'server_config_provider.dart';

/// Auth state — either authenticated (with token) or unauthenticated.
sealed class AuthState {
  const AuthState();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.token});
  final String token;
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

/// Provider for the MercuryApi instance. Rebuilds when server URL changes.
final mercuryApiProvider = Provider<MercuryApi>((ref) {
  final urlAsync = ref.watch(serverUrlProvider);
  final url = urlAsync.valueOrNull ?? serverPresets.first.url;
  return MercuryApi(baseUrl: url);
});

/// Provider for AuthService. Depends on MercuryApi.
final authServiceProvider = Provider<AuthService>((ref) {
  final api = ref.watch(mercuryApiProvider);
  return AuthService(api: api);
});

/// Provider for AdminApi. Depends on MercuryApi.
final adminApiProvider = Provider<AdminApi>((ref) {
  final api = ref.watch(mercuryApiProvider);
  return AdminApi(api);
});

/// Auth state notifier — manages login/logout lifecycle.
final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Try to restore token on first build
    _tryRestore();
    return const AuthUnauthenticated();
  }

  Future<void> _tryRestore() async {
    final authService = ref.read(authServiceProvider);
    final token = await authService.restoreToken();
    if (token != null) {
      state = AuthAuthenticated(token: token);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.login(
        email: email,
        password: password,
      );
      state = AuthAuthenticated(token: response.accessToken);
    } on MercuryApiException catch (e) {
      state = AuthError(e.message);
    } on MercuryConnectionException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError('Unexpected error: $e');
    }
  }

  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    state = const AuthUnauthenticated();
  }
}
