import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/surreal_auth_service.dart';

/// Provider for the auth service.
///
/// Uses [SurrealAuthService] authenticating against real SurrealDB.
final authServiceProvider = Provider<AuthService>((ref) {
  return SurrealAuthService();
});

/// Provider for the current auth state.
///
/// Uses an [AsyncNotifier] to handle the async restore-on-startup correctly.
/// GoRouter watches this provider for redirect decisions.
final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Manages authentication state transitions.
///
/// On app start, attempts to restore a previous session (async, properly
/// awaited). On login, delegates to the [AuthService]. On logout, clears state.
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    return _authService.tryRestore();
  }

  AuthService get _authService => ref.read(authServiceProvider);

  /// Log in with email and password.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = AsyncData(await _authService.login(email, password));
  }

  /// Log out and clear stored credentials.
  Future<void> logout() async {
    state = const AsyncLoading();
    state = AsyncData(await _authService.logout());
  }
}
