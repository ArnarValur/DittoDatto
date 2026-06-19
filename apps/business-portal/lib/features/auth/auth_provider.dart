import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/surreal_auth_service.dart';

/// WebSocket URL injected at build time via `--dart-define=SURREAL_URL=...`.
///
/// When empty (default), [SurrealConnection] derives the URL from the page
/// origin — which only works when SurrealDB is reverse-proxied on the same
/// host (e.g. Saturn deployment behind Caddy).
const _surrealUrl = String.fromEnvironment('SURREAL_URL');

/// DB-level service credentials for company DB access (ADR-0016).
/// Injected at build time — NEVER the user's password.
const _bpPortalUser = String.fromEnvironment('BP_PORTAL_USER', defaultValue: 'bp_portal');
const _bpPortalPass = String.fromEnvironment('BP_PORTAL_PASS');

/// Provider for the auth service.
///
/// Uses [SurrealAuthService] with RECORD ACCESS for user auth
/// and DB-level service credentials for company DB access.
final authServiceProvider = Provider<AuthService>((ref) {
  return SurrealAuthService(
    wsUrl: _surrealUrl.isNotEmpty ? _surrealUrl : null,
    serviceUser: _bpPortalUser.isNotEmpty ? _bpPortalUser : null,
    servicePass: _bpPortalPass.isNotEmpty ? _bpPortalPass : null,
  );
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
