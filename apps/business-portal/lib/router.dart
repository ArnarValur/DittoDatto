import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mercury_client/mercury_client.dart';

import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/shell/portal_shell.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/establishments/establishments_screen.dart';
import 'features/appointments/appointments_screen.dart';
import 'features/table_reservations/table_reservations_screen.dart';
import 'features/staff/staff_screen.dart';
import 'features/services/services_screen.dart';
import 'features/inbox/inbox_screen.dart';

/// Route paths for the Business Portal.
abstract final class PortalRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const establishments = '/establishments';
  static const appointments = '/appointments';
  static const tableReservations = '/table-reservations';
  static const staff = '/staff';
  static const services = '/services';
  static const inbox = '/inbox';
}

/// Maps shell index to route path.
const shellRoutes = [
  PortalRoutes.dashboard,
  PortalRoutes.establishments,
  PortalRoutes.appointments,
  PortalRoutes.tableReservations,
  PortalRoutes.staff,
  PortalRoutes.services,
  PortalRoutes.inbox,
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

/// GoRouter configuration for the Business Portal.
///
/// Auth guard redirects to /login if unauthenticated.
/// ShellRoute wraps authenticated screens in the PortalShell.
///
/// Uses [refreshListenable] so the single GoRouter instance re-evaluates
/// redirects when auth state changes, instead of recreating the router.
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthChangeNotifier(ref);

  return GoRouter(
    initialLocation: PortalRoutes.dashboard,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authAsync = ref.read(authProvider);
      final isLoginRoute = state.matchedLocation == PortalRoutes.login;

      // While loading (initial restore or login in progress), don't redirect.
      if (authAsync.isLoading) return null;

      final isAuthenticated = authAsync.value is Authenticated;

      if (!isAuthenticated && !isLoginRoute) {
        return PortalRoutes.login;
      }
      if (isAuthenticated && isLoginRoute) {
        return PortalRoutes.dashboard;
      }
      return null;
    },
    routes: [
      // Login — no shell
      GoRoute(
        path: PortalRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Authenticated shell
      ShellRoute(
        builder: (context, state, child) {
          final location = state.matchedLocation;
          final index = shellRoutes.indexOf(location);

          return PortalShell(
            currentIndex: index >= 0 ? index : 0,
            onDestinationSelected: (i) {
              context.go(shellRoutes[i]);
            },
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: PortalRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: PortalRoutes.establishments,
            builder: (context, state) => const EstablishmentsScreen(),
          ),
          GoRoute(
            path: PortalRoutes.appointments,
            builder: (context, state) => const AppointmentsScreen(),
          ),
          GoRoute(
            path: PortalRoutes.tableReservations,
            builder: (context, state) => const TableReservationsScreen(),
          ),
          GoRoute(
            path: PortalRoutes.staff,
            builder: (context, state) => const StaffScreen(),
          ),
          GoRoute(
            path: PortalRoutes.services,
            builder: (context, state) => const ServicesScreen(),
          ),
          GoRoute(
            path: PortalRoutes.inbox,
            builder: (context, state) => const InboxScreen(),
          ),
        ],
      ),
    ],
  );
});
