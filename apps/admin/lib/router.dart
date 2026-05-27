import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/shell/admin_shell.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/users/users_screen.dart';
import 'features/companies/companies_screen.dart';
import 'features/categories/categories_screen.dart';
import 'features/inbox/inbox_screen.dart';

/// Route paths.
abstract final class AppRoutes {
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
/// Phase 1: No auth guard — all screens accessible.
/// Phase 2 adds login screen + auth redirect.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
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
