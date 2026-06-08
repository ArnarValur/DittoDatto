import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:business_portal/features/auth/auth_provider.dart';
import 'package:business_portal/features/dashboard/dashboard_screen.dart';
import 'package:business_portal/router.dart';

/// Creates a testable app with the router under the given auth state.
///
/// Overrides [authServiceProvider] with a mock that returns [initialState].
/// Overrides [authProvider] to immediately resolve to [initialState].
Widget _buildTestApp({required AuthState initialState}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => _MockAuthNotifier(initialState)),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          routerConfig: router,
        );
      },
    ),
  );
}

/// Mock auth notifier that resolves to a fixed state immediately.
class _MockAuthNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  _MockAuthNotifier(this._state);

  final AuthState _state;

  @override
  Future<AuthState> build() async => _state;

  @override
  Future<void> login(String email, String password) async {
    state = const AsyncData(
      Authenticated(accessToken: 'test-token', email: 'test@test.no'),
    );
  }

  @override
  Future<void> logout() async {
    state = const AsyncData(Unauthenticated());
  }
}

void main() {
  group('Router auth guard', () {
    testWidgets(
      'redirects unauthenticated user to /login',
      (tester) async {
        await tester.pumpWidget(
          _buildTestApp(initialState: const Unauthenticated()),
        );
        await tester.pumpAndSettle();

        // Verify Login screen content is visible (Email field label).
        expect(find.text('Email'), findsOneWidget);

        // Verify Dashboard is NOT visible.
        expect(find.text('Dashboard'), findsNothing);
      },
    );

    testWidgets(
      'authenticated user sees Dashboard (not redirected to /login)',
      (tester) async {
        await tester.pumpWidget(
          _buildTestApp(
            initialState: const Authenticated(
              accessToken: 'test-jwt',
              email: 'arnarvalur@dittodatto.no',
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify Dashboard screen is in the widget tree.
        expect(find.byType(DashboardScreen), findsOneWidget);

        // Verify Login screen is NOT visible.
        expect(find.text('Sign In'), findsNothing);
      },
    );

    testWidgets(
      'authenticated user on /login gets redirected to /dashboard',
      (tester) async {
        // Create a custom router that starts on /login while authenticated.
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(
                () => _MockAuthNotifier(
                  const Authenticated(
                    accessToken: 'test-jwt',
                    email: 'arnarvalur@dittodatto.no',
                  ),
                ),
              ),
            ],
            child: Consumer(
              builder: (context, ref, _) {
                final router = ref.watch(routerProvider);
                // Navigate to login after build.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  router.go(PortalRoutes.login);
                });
                return MaterialApp.router(routerConfig: router);
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should redirect away from login to dashboard.
        expect(find.byType(DashboardScreen), findsOneWidget);
        expect(find.text('Sign In'), findsNothing);
      },
    );

    testWidgets(
      'unauthenticated user navigating to /establishments is blocked',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(
                () => _MockAuthNotifier(const Unauthenticated()),
              ),
            ],
            child: Consumer(
              builder: (context, ref, _) {
                final router = ref.watch(routerProvider);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  router.go(PortalRoutes.establishments);
                });
                return MaterialApp.router(routerConfig: router);
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should be redirected to login.
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Establishments'), findsNothing);
      },
    );
  });
}
