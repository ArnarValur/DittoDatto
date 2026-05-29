import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/providers.dart';

/// Provider for dashboard statistics — auto-disposes when dashboard is off-screen.
final dashboardStatsProvider = FutureProvider.autoDispose<AdminStats>((ref) {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getStats();
});

/// Dashboard screen with 4 stat cards and pull-to-refresh.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(dashboardStatsProvider.future),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final windowClass = DittoWindowClass.of(constraints.maxWidth);
          final crossAxisCount = switch (windowClass) {
            DittoWindowClass.compact => 1,
            DittoWindowClass.medium => 2,
            _ => 4,
          };

          return statsAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => DittoErrorView(
              message: 'Failed to load dashboard stats',
              onRetry: () => ref.invalidate(dashboardStatsProvider),
            ),
            data: (stats) => ListView(
              padding: const EdgeInsets.all(DittoSpacing.lg),
              children: [
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: DittoSpacing.lg),
                GridView.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: DittoSpacing.base,
                  crossAxisSpacing: DittoSpacing.base,
                  childAspectRatio: crossAxisCount == 1 ? 3.5 : 1.6,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _StatCard(
                      icon: Icons.people_rounded,
                      iconColor: const Color(0xFF818cf8),
                      value: stats.userCount.toString(),
                      label: 'Users',
                    ),
                    _StatCard(
                      icon: Icons.business_rounded,
                      iconColor: const Color(0xFF34d399),
                      value: stats.companyCount.toString(),
                      label: 'Companies',
                    ),
                    _StatCard(
                      icon: Icons.category_rounded,
                      iconColor: const Color(0xFFfbbf24),
                      value: stats.categoryCount.toString(),
                      label: 'Categories',
                    ),
                    _StatCard(
                      icon: stats.engineHealthy
                          ? Icons.check_circle_rounded
                          : Icons.error_rounded,
                      iconColor: stats.engineHealthy
                          ? DittoColors.success
                          : DittoColors.error,
                      value: stats.engineHealthy ? 'Healthy' : 'Down',
                      label: 'Engine',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A stat card with colored icon circle, large value, and label.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DittoSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: DittoBorderRadius.smallAll,
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(height: DittoSpacing.md),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: DittoSpacing.xs),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
