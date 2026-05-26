import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/categories/categories_screen.dart';
import 'features/companies/companies_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/inbox/inbox_screen.dart';
import 'features/shell/app_shell.dart';
import 'features/users/users_screen.dart';

/// Route paths.
abstract class AppRoutes {
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

/// GoRouter configuration for the admin panel.
///
/// Auth guard redirects to /login if unauthenticated.
/// ShellRoute wraps authenticated screens in the sidebar shell.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    redirect: (context, state) {
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;

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
          // Determine current index from location
          final location = state.matchedLocation;
          final index = _shellRoutes.indexOf(location);

          return AppShell(
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
