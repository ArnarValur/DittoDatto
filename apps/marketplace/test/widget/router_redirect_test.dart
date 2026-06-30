import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:marketplace/core/auth_provider.dart';
import 'package:marketplace/core/router.dart';
import 'package:marketplace/features/home/discovery_providers.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Mock
// ---------------------------------------------------------------------------

class _MockAuthNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  _MockAuthNotifier(this._state);
  final AuthState _state;

  @override
  Future<AuthState> build() async => _state;

  @override
  Future<void> signup(String name, String email, String password) async {}

  @override
  Future<void> login(String email, String password) async {
    state = AsyncData(Authenticated(accessToken: 'test-jwt', email: email));
  }

  @override
  Future<void> logout() async {
    state = const AsyncData(Unauthenticated());
  }
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

Widget _buildTestApp({required AuthState initialState}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => _MockAuthNotifier(initialState)),
      // Provide empty discovery data so HomeScreen renders without WS.
      listingsProvider.overrideWith((ref) async => []),
      categoriesProvider.overrideWith((ref) async => []),
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

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() async {
    // ProfileScreen uses DateFormat with nb_NO locale.
    await initializeDateFormatting('nb_NO');
  });

  group('Router redirects', () {
    testWidgets('unauthenticated at / → sees HomeScreen', (tester) async {
      await tester
          .pumpWidget(_buildTestApp(initialState: const Unauthenticated()));
      await tester.pumpAndSettle();

      // HomeScreen now shows discovery content — empty state when no listings.
      expect(
          find.text('Ingen virksomheter funnet'), findsOneWidget);
    });

    testWidgets('unauthenticated at /bookings → sees BookingsScreen',
        (tester) async {
      await tester
          .pumpWidget(_buildTestApp(initialState: const Unauthenticated()));
      await tester.pumpAndSettle();

      // Navigate to /bookings.
      final navState =
          tester.state<NavigatorState>(find.byType(Navigator).last);
      GoRouter.of(navState.context).go(MarketplaceRoutes.bookings);
      await tester.pumpAndSettle();

      expect(find.text('Booking-historikk kommer snart'), findsOneWidget);
    });

    testWidgets('unauthenticated at /profile → redirected to /profile/login',
        (tester) async {
      await tester
          .pumpWidget(_buildTestApp(initialState: const Unauthenticated()));
      await tester.pumpAndSettle();

      final navState =
          tester.state<NavigatorState>(find.byType(Navigator).last);
      GoRouter.of(navState.context).go(MarketplaceRoutes.profile);
      await tester.pumpAndSettle();

      expect(find.text('Logg inn på kontoen din'), findsOneWidget);
      expect(find.text('E-post'), findsOneWidget);
    });

    testWidgets('authenticated at /profile → sees ProfileScreen',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(
        initialState: const Authenticated(
          accessToken: 'test-jwt',
          email: 'test@example.com',
          name: 'Test User',
        ),
      ));
      await tester.pumpAndSettle();

      final navState =
          tester.state<NavigatorState>(find.byType(Navigator).last);
      GoRouter.of(navState.context).go(MarketplaceRoutes.profile);
      await tester.pumpAndSettle();

      expect(find.text('Hei, Test 👋'), findsOneWidget);
    });

    testWidgets('authenticated at /profile/login → redirected to /profile',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(
        initialState: const Authenticated(
          accessToken: 'test-jwt',
          email: 'test@example.com',
          name: 'Test User',
        ),
      ));
      await tester.pumpAndSettle();

      final navState =
          tester.state<NavigatorState>(find.byType(Navigator).last);
      GoRouter.of(navState.context).go(MarketplaceRoutes.login);
      await tester.pumpAndSettle();

      expect(find.text('Hei, Test 👋'), findsOneWidget);
      expect(find.text('Logg inn på kontoen din'), findsNothing);
    });
  });
}
