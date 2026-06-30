import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';
import '../models/format_helpers.dart';
import '../models/service.dart';
import '../models/service_group.dart';
import '../widgets/service_card.dart';

/// Services section for the EstablishmentPage.
///
/// Displays ALL active services with the first service from the primary
/// group (sortOrder 0 or `isFeatured`) rendered as a hero card. All
/// remaining services follow seamlessly below.
///
/// The entire section has a subtle `secondaryContainer` background tint.
///
/// Returns an empty [SliverToBoxAdapter] when no services exist.
class EstablishmentFeaturedSection extends StatelessWidget {
  const EstablishmentFeaturedSection({
    required this.data,
    super.key,
  });

  /// Establishment data containing services and service groups.
  final EstablishmentData data;

  @override
  Widget build(BuildContext context) {
    // All active services, sorted by group sortOrder then service sortOrder.
    final allServices = _buildSortedServices();
    if (allServices.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final heroService = allServices.first;
    final heroGroup = _groupForService(heroService);
    final remainingServices = allServices.skip(1).toList();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: DittoSpacing.sm,
          vertical: DittoSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(DittoSpacing.base),
        ),
        padding: const EdgeInsets.all(DittoSpacing.compact),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card
            _HeroServiceCard(
              service: heroService,
              groupName: heroGroup?.name ?? '',
            ),

            // Remaining services — seamless list
            if (remainingServices.isNotEmpty)
              ...remainingServices.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(top: DittoSpacing.xs),
                  child: ServiceCard(service: s),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Returns all active services sorted by their group's sortOrder,
  /// then by their own sortOrder within the group.
  List<Service> _buildSortedServices() {
    final activeServices =
        data.services.where((s) => s.isActive).toList();
    if (activeServices.isEmpty) return [];

    // Build a map of groupId → group sortOrder for sorting.
    final groupOrder = <String, int>{};
    for (final g in data.serviceGroups) {
      groupOrder[g.id] = g.sortOrder;
    }

    activeServices.sort((a, b) {
      final aGroup = groupOrder[a.groupId] ?? 999;
      final bGroup = groupOrder[b.groupId] ?? 999;
      return aGroup.compareTo(bGroup);
    });

    return activeServices;
  }

  /// Finds the ServiceGroup for a given service.
  ServiceGroup? _groupForService(Service service) {
    try {
      return data.serviceGroups
          .firstWhere((g) => g.id == service.groupId);
    } catch (_) {
      return null;
    }
  }
}

/// Hero card for the primary service.
///
/// Shows a group label chip, service title, description,
/// price + duration row, and a CTA button.
class _HeroServiceCard extends StatelessWidget {
  const _HeroServiceCard({
    required this.service,
    required this.groupName,
  });

  final Service service;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(DittoSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group label chip
            if (groupName.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DittoSpacing.sm,
                  vertical: DittoSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(DittoSpacing.xs),
                ),
                child: Text(
                  groupName.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            if (groupName.isNotEmpty)
              const SizedBox(height: DittoSpacing.compact),

            // Service title
            Text(
              service.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            // Description
            if (service.description != null &&
                service.description!.trim().isNotEmpty) ...[
              const SizedBox(height: DittoSpacing.sm),
              Text(
                service.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: DittoSpacing.compact),

            // Price + duration row
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: DittoSpacing.xs),
                Text(
                  formatDuration(service.duration),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: DittoSpacing.md),
                Text(
                  formatPrice(service.price, service.currency),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DittoSpacing.md),

            // CTA button
            const SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: null,
                child: Text('Bestill'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
