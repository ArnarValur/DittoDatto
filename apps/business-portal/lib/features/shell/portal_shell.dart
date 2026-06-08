import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

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
    DittoNavItem(icon: Icons.store_rounded, label: 'Establishments'),
    DittoNavItem(icon: Icons.calendar_month_rounded, label: 'Appointments'),
    DittoNavItem(icon: Icons.table_restaurant_rounded, label: 'Table Reservations'),
    DittoNavItem(icon: Icons.people_rounded, label: 'Staff'),
    DittoNavItem(icon: Icons.design_services_rounded, label: 'Services'),
    DittoNavItem(icon: Icons.inbox_rounded, label: 'Inbox'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider).value;

    return DittoDashboardShell(
      destinations: _destinations,
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: DittoColors.moodyBlue.withValues(alpha: 0.2),
                borderRadius: DittoBorderRadius.smallAll,
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 18,
                color: DittoColors.moodyBlue,
              ),
            ),
            const SizedBox(width: DittoSpacing.sm),
            Expanded(
              child: Text(
                'Business Portal',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.all(DittoSpacing.base),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: DittoColors.moodyBlue.withValues(alpha: 0.2),
              child: const Icon(
                Icons.person_rounded,
                size: 18,
                color: DittoColors.moodyBlue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                authState is Authenticated
                    ? authState.email.split('@').first
                    : 'Operator',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.logout_rounded,
                size: 18,
                color: Colors.white38,
              ),
              tooltip: 'Logout',
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
