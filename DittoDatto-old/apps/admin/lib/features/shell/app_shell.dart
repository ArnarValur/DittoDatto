import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../auth/auth_provider.dart';

/// App shell with permanent sidebar drawer — tablet-optimized.
///
/// Inspired by the Chapter 1 Nuxt admin panel layout:
/// - Permanent sidebar with icon + label nav items
/// - App branding at top
/// - User info + logout at bottom
class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  static const _destinations = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.people_rounded, label: 'Users'),
    _NavItem(icon: Icons.business_rounded, label: 'Companies'),
    _NavItem(icon: Icons.category_rounded, label: 'Categories'),
    _NavItem(icon: Icons.inbox_rounded, label: 'Inbox'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // ─── Sidebar ──────────────────────────────────────────────
          Container(
            width: 240,
            color: AppColors.sidebarBg,
            child: Column(
              children: [
                // App branding
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.moodyBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings_rounded,
                          size: 18,
                          color: AppColors.moodyBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'DittoDatto Admin',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Navigation items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _destinations.length,
                    itemBuilder: (context, index) {
                      final dest = _destinations[index];
                      final selected = index == currentIndex;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => onDestinationSelected(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.moodyBlue
                                        .withValues(alpha: 0.12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    dest.icon,
                                    size: 20,
                                    color: selected
                                        ? AppColors.moodyBlue
                                        : Colors.white54,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    dest.label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: selected
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                      color: selected
                                          ? AppColors.moodyBlue
                                          : Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Divider
                Divider(
                  color: Colors.white.withValues(alpha: 0.06),
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),

                // User profile + logout
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            AppColors.moodyBlue.withValues(alpha: 0.2),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 18,
                          color: AppColors.moodyBlue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Admin',
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
              ],
            ),
          ),

          // Vertical divider
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.white.withValues(alpha: 0.06),
          ),

          // ─── Content ──────────────────────────────────────────────
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
