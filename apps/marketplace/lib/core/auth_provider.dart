import 'package:ditto_auth/ditto_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

/// WebSocket URL injected at build time via `--dart-define=SURREAL_URL=...`.
///
/// When empty (default), [SurrealAuthBackend] derives the URL from the page
/// origin — works when SurrealDB is reverse-proxied on the same host.
const _surrealUrl = String.fromEnvironment('SURREAL_URL');

/// Provider for the shared [DittoAuth] instance.
///
/// Consumer auth only — no service credentials needed (unlike BP).
/// consumer_auth RECORD ACCESS handles signup/signin directly.
final dittoAuthProvider = Provider<DittoAuth>((ref) {
  return DittoAuth(
    backend: SurrealAuthBackend(
      wsUrl: _surrealUrl.isNotEmpty ? _surrealUrl : null,
      // Consumer auth doesn't need service credentials —
      // no tenant routing. Empty values are fine.
      serviceUser: '',
      servicePass: '',
    ),
  );
});

/// Provider for the current auth state.
///
/// Uses an [AsyncNotifier] to handle the async restore-on-startup correctly.
/// GoRouter watches this provider for redirect decisions.
final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Manages consumer authentication state transitions.
///
/// On app start, attempts to restore a previous session.
/// On login/signup, delegates to [DittoAuth].
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final result = await _dittoAuth.tryRestoreConsumer();
    if (result == null) return const Unauthenticated();
    return Authenticated(
      accessToken: result.userId,
      email: result.email,
      name: result.name,
    );
  }

  DittoAuth get _dittoAuth => ref.read(dittoAuthProvider);

  /// Sign up with name, email, and password.
  Future<void> signup(String name, String email, String password) async {
    state = const AsyncLoading();
    try {
      final result = await _dittoAuth.consumerSignup(
        name: name,
        email: email,
        password: password,
      );
      state = AsyncData(Authenticated(
        accessToken: result.userId,
        email: result.email,
        name: result.name,
      ));
    } on DittoAuthException catch (e) {
      debugPrint('⚠️ Consumer signup error: $e');
      state = AsyncData(AuthError(message: e.message));
    }
  }

  /// Log in with email and password.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final result = await _dittoAuth.consumerSignin(
        email: email,
        password: password,
      );
      state = AsyncData(Authenticated(
        accessToken: result.userId,
        email: result.email,
        name: result.name,
      ));
    } on DittoAuthException catch (e) {
      debugPrint('⚠️ Consumer login error: $e');
      state = const AsyncData(Unauthenticated());
    }
  }

  /// Log out and clear stored credentials.
  Future<void> logout() async {
    state = const AsyncLoading();
    await _dittoAuth.signOut();
    state = const AsyncData(Unauthenticated());
  }
}
