import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/surreal_auth_service.dart';

/// Whether to use mock implementations (set via `--dart-define=USE_MOCKS=true`).
const _useMocks = bool.fromEnvironment('USE_MOCKS');

/// Provider for the auth service.
///
/// In mock mode: [MockAuthService] with hardcoded dev credentials.
/// In production mode: [SurrealAuthService] authenticating against real SurrealDB.
final authServiceProvider = Provider<AuthService>((ref) {
  if (_useMocks) return MockAuthService();
  return SurrealAuthService();
});

/// Provider for the current auth state.
///
/// Uses a [Notifier] to manage auth lifecycle (login, logout, restore).
/// GoRouter watches this provider for redirect decisions.
final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Manages authentication state transitions.
///
/// On app start, attempts to restore a previous session. On login,
/// delegates to the [AuthService]. On logout, clears state.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Attempt to restore on first build.
    _tryRestore();
    return const Unauthenticated();
  }

  AuthService get _authService => ref.read(authServiceProvider);

  /// Attempt to restore a previous session from secure storage.
  Future<void> _tryRestore() async {
    state = const AuthLoading();
    state = await _authService.tryRestore();
  }

  /// Log in with email and password.
  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    state = await _authService.login(email, password);
  }

  /// Log out and clear stored credentials.
  Future<void> logout() async {
    state = const AuthLoading();
    state = await _authService.logout();
  }
}
