import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../auth/auth_provider.dart';

/// Admin-specific shell that wraps [DittoDashboardShell] with
/// the admin panel's navigation destinations, branding, and footer.
class AdminShell extends ConsumerWidget {
  const AdminShell({
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
    DittoNavItem(icon: Icons.people_rounded, label: 'Users'),
    DittoNavItem(icon: Icons.business_rounded, label: 'Companies'),
    DittoNavItem(icon: Icons.category_rounded, label: 'Categories'),
    DittoNavItem(icon: Icons.inbox_rounded, label: 'Inbox'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

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
                Icons.admin_panel_settings_rounded,
                size: 18,
                color: DittoColors.moodyBlue,
              ),
            ),
            const SizedBox(width: DittoSpacing.md),
            Text(
              'Admin',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
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
                authState is Authenticated ? authState.email.split('@').first : 'Admin',
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
