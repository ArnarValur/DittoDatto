import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mercury_client/mercury_client.dart';

import 'auth_provider.dart';
import '../features/auth/login_screen.dart';
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
  static const login = '/login';
  static const signup = '/signup';
}

/// Maps shell tab index to route path.
const shellRoutes = [
  MarketplaceRoutes.home,
  MarketplaceRoutes.bookings,
  MarketplaceRoutes.profile,
];

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
/// Profile tab redirects to login if unauthenticated.
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

      // Unauthenticated user on profile → send to login.
      if (!isAuthenticated && location == MarketplaceRoutes.profile) {
        return MarketplaceRoutes.login;
      }

      return null;
    },
    routes: [
      // Auth routes — no shell.
      GoRoute(
        path: MarketplaceRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: MarketplaceRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // Main app shell with bottom navigation.
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
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
