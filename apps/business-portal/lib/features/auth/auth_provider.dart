import 'package:ditto_auth/ditto_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

/// WebSocket URL injected at build time via `--dart-define=SURREAL_URL=...`.
///
/// When empty (default), [SurrealAuthBackend] derives the URL from the page
/// origin — which only works when SurrealDB is reverse-proxied on the same
/// host (e.g. Saturn deployment behind Caddy).
const _surrealUrl = String.fromEnvironment('SURREAL_URL');

/// DB-level service credentials for company DB access (ADR-0016).
/// Injected at build time — NEVER the user's password.
const _bpPortalUser = String.fromEnvironment('BP_PORTAL_USER', defaultValue: 'bp_portal');
const _bpPortalPass = String.fromEnvironment('BP_PORTAL_PASS');

/// Provider for the shared [DittoAuth] instance.
///
/// Replaces the old [SurrealAuthService] — same two-phase flow,
/// now behind the swappable [AuthBackend] interface.
final dittoAuthProvider = Provider<DittoAuth>((ref) {
  return DittoAuth(
    backend: SurrealAuthBackend(
      wsUrl: _surrealUrl.isNotEmpty ? _surrealUrl : null,
      serviceUser: _bpPortalUser.isNotEmpty ? _bpPortalUser : 'bp_portal',
      servicePass: _bpPortalPass,
    ),
  );
});

/// Provider for the active [TenantConnection] from [DittoAuth].
///
/// The repository layer reads this for CRUD queries.
/// Returns null if not authenticated.
final tenantConnectionProvider = Provider<TenantConnection?>((ref) {
  // Watch authProvider to trigger re-evaluation on auth state changes.
  ref.watch(authProvider);
  return ref.read(dittoAuthProvider).activeTenant;
});

/// Provider for the company name from the auth result.
///
/// Set during login / session restore. The shell reads this for the sidebar.
final companyNameProvider =
    NotifierProvider<CompanyNameNotifier, String?>(CompanyNameNotifier.new);

/// Simple notifier to hold the authenticated company name.
class CompanyNameNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? name) => state = name;
}

/// Provider for the current auth state.
///
/// Uses an [AsyncNotifier] to handle the async restore-on-startup correctly.
/// GoRouter watches this provider for redirect decisions.
final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Manages authentication state transitions.
///
/// On app start, attempts to restore a previous session (async, properly
/// awaited). On login, delegates to [DittoAuth]. On logout, clears state.
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final result = await _dittoAuth.tryRestoreBusiness();
    if (result == null) return const Unauthenticated();
    ref.read(companyNameProvider.notifier).set(result.companyName);
    return Authenticated(
      accessToken: result.companySlug,
      email: result.email,
      name: result.name,
    );
  }

  DittoAuth get _dittoAuth => ref.read(dittoAuthProvider);

  /// Log in with email and password.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final result = await _dittoAuth.businessSignin(
        email: email,
        password: password,
      );
      ref.read(companyNameProvider.notifier).set(result.companyName);
      state = AsyncData(Authenticated(
        accessToken: result.companySlug,
        email: result.email,
        name: result.name,
      ));
    } on DittoAuthException catch (e) {
      debugPrint('⚠️ BP Auth error: $e');
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
