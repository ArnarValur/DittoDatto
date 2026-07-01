import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:mercury_client/mercury_client.dart';

import 'auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/booking/booking_screen.dart';
import '../features/establishment/establishment_detail_screen.dart';
import '../features/solar_demo/solar_demo_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/home/home_screen.dart';
import '../features/bookings/bookings_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/shell/marketplace_shell.dart';

/// Route paths for the Public Marketplace.
abstract final class MarketplaceRoutes {
  static const home = '/';
  static const bookings = '/bookings';
  static const profile = '/profile';
  static const login = '/profile/login';
  static const signup = '/profile/signup';
  static const solarDemo = '/solar';
  static const establishment = '/establishment';
  static const booking = '/booking';
}

/// Listenable that fires when authProvider changes.
///
/// Bridges Riverpod's [AsyncValue] to [ChangeNotifier] for GoRouter.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(this._ref) {
    _ref.listen(authProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;
}

/// GoRouter configuration for the Marketplace.
///
/// Anonymous browsing (ADR-0020): Home and Bookings tabs are public.
/// Profile tab shows login/signup when unauthenticated — bottom bar persists.
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthChangeNotifier(ref);

  return GoRouter(
    initialLocation: MarketplaceRoutes.home,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authAsync = ref.read(authProvider);

      // While loading (initial restore or auth in progress), don't redirect.
      if (authAsync.isLoading) return null;

      final isAuthenticated = authAsync.value is Authenticated;
      final location = state.matchedLocation;
      final isAuthRoute = location == MarketplaceRoutes.login ||
          location == MarketplaceRoutes.signup;

      // Authenticated user on login/signup → send to profile.
      if (isAuthenticated && isAuthRoute) {
        return MarketplaceRoutes.profile;
      }

      // Unauthenticated user on profile root → send to login.
      if (!isAuthenticated && location == MarketplaceRoutes.profile) {
        return MarketplaceRoutes.login;
      }

      return null;
    },
    routes: [
      // SolarTheme demo — full-screen, outside the shell.
      GoRoute(
        path: MarketplaceRoutes.solarDemo,
        builder: (context, state) => const SolarDemoScreen(),
      ),
      // Booking flow — full-screen, outside the shell (hides bottom nav).
      GoRoute(
        path: MarketplaceRoutes.booking,
        builder: (context, state) {
          final extra = state.extra!
              as ({EstablishmentData data, String companySlug});
          return BookingScreen(
            data: extra.data,
            companySlug: extra.companySlug,
          );
        },
      ),
      // Main app shell — bottom nav always visible.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MarketplaceShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: MarketplaceRoutes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  // Establishment detail — dynamic route from discovery.
                  GoRoute(
                    path: 'establishment/:companySlug/:slug',
                    builder: (context, state) {
                      final companySlug =
                          state.pathParameters['companySlug']!;
                      final slug = state.pathParameters['slug']!;
                      return EstablishmentDetailScreen(
                        companySlug: companySlug,
                        slug: slug,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: MarketplaceRoutes.bookings,
                builder: (context, state) => const BookingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: MarketplaceRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'login',
                    builder: (context, state) => const LoginScreen(),
                  ),
                  GoRoute(
                    path: 'signup',
                    builder: (context, state) => const SignupScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
