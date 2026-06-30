import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/theme_provider.dart';
import '../auth/auth_provider.dart';


/// Business Portal shell wrapping [DittoDashboardShell] with
/// portal-specific navigation destinations, branding, and footer.
class PortalShell extends ConsumerWidget {
  const PortalShell({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  static const _destinations = [
    DittoNavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    DittoNavItem(icon: Icons.inbox_rounded, label: 'Inbox'),
    DittoNavItem(icon: Icons.store_rounded, label: 'Establishments'),
    DittoNavItem(icon: Icons.photo_library_rounded, label: 'Media'),
    DittoNavItem(icon: Icons.calendar_month_rounded, label: 'Appointments'),
    DittoNavItem(icon: Icons.table_restaurant_rounded, label: 'Table Reservations'),
    DittoNavItem(icon: Icons.people_rounded, label: 'Staff'),
    DittoNavItem(icon: Icons.design_services_rounded, label: 'Services'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).value;
    final connection = ref.watch(tenantConnectionProvider);
    final slug = connection?.slug;

    final isDark = ref.watch(isDarkModeProvider);

    final storedCompanyName = ref.watch(companyNameProvider);

    final companyName = storedCompanyName
        ?? (slug != null ? slug.replaceAll('-', ' ').toUpperCase() : 'DittoDatto');

    final userName = authState is Authenticated
        ? (authState.name ?? authState.email.split('@').first)
        : 'Operator';

    return DittoDashboardShell(
      destinations: _destinations,
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      workspaceName: companyName,
      userName: userName,
      onLogout: () {
        ref.read(authProvider.notifier).logout();
      },
      onThemeToggle: () {
        ref.read(isDarkModeProvider.notifier).toggle();
      },
      isDarkMode: isDark,
      body: child,
    );
  }
}
