import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/categories/categories_screen.dart';
import 'features/companies/companies_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/inbox/inbox_screen.dart';
import 'features/shell/admin_shell.dart';
import 'features/users/users_screen.dart';

import 'package:mercury_client/mercury_client.dart';

/// Route paths.
abstract final class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const users = '/users';
  static const companies = '/companies';
  static const categories = '/categories';
  static const inbox = '/inbox';
}

/// Maps shell index to route path.
const _shellRoutes = [
  AppRoutes.dashboard,
  AppRoutes.users,
  AppRoutes.companies,
  AppRoutes.categories,
  AppRoutes.inbox,
];

/// Listenable that fires when authProvider changes.
///
/// GoRouter needs a [Listenable] to know when to re-evaluate redirects.
/// This bridges Riverpod's [AsyncValue] to [ChangeNotifier].
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(this._ref) {
    _ref.listen(authProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;
}

/// GoRouter configuration for the admin panel.
///
/// Auth guard redirects to /login if unauthenticated.
/// ShellRoute wraps authenticated screens in the sidebar shell.
///
/// Uses [refreshListenable] so the single GoRouter instance re-evaluates
/// redirects when auth state changes, instead of recreating the router.
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthChangeNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authAsync = ref.read(authProvider);
      final isLoginRoute = state.matchedLocation == AppRoutes.login;

      // While loading (initial restore or login in progress), don't redirect.
      if (authAsync.isLoading) return null;

      final isAuthenticated = authAsync.value is Authenticated;

      if (!isAuthenticated && !isLoginRoute) {
        return AppRoutes.login;
      }
      if (isAuthenticated && isLoginRoute) {
        return AppRoutes.dashboard;
      }
      return null;
    },
    routes: [
      // Login — no shell
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Authenticated shell
      ShellRoute(
        builder: (context, state, child) {
          // Determine current index from location.
          final location = state.matchedLocation;
          final index = _shellRoutes.indexOf(location);

          return AdminShell(
            currentIndex: index >= 0 ? index : 0,
            onDestinationSelected: (i) {
              context.go(_shellRoutes[i]);
            },
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.users,
            builder: (context, state) => const UsersScreen(),
          ),
          GoRoute(
            path: AppRoutes.companies,
            builder: (context, state) => const CompaniesScreen(),
          ),
          GoRoute(
            path: AppRoutes.categories,
            builder: (context, state) => const CategoriesScreen(),
          ),
          GoRoute(
            path: AppRoutes.inbox,
            builder: (context, state) => const InboxScreen(),
          ),
        ],
      ),
    ],
  );
});
