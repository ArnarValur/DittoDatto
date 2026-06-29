import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';
import '../models/service.dart';
import '../models/service_group.dart';
import '../widgets/service_group_section.dart';

/// Services section for the EstablishmentPage.
///
/// Displays services grouped by [ServiceGroup], sorted by
/// [ServiceGroup.sortOrder]. Services with no group are placed
/// in a fallback "Øvrige tjenester" group at the end.
///
/// Only active services (`isActive == true`) are shown.
/// Returns an empty [SliverToBoxAdapter] when there are no active services.
///
/// Renders as a [SliverToBoxAdapter] inside a [CustomScrollView].
class EstablishmentServicesSection extends StatelessWidget {
  const EstablishmentServicesSection({
    required this.data,
    this.sectionIcon,
    this.sectionTitle = 'Tjenester',
    super.key,
  });

  /// Establishment data containing services and service groups.
  final EstablishmentData data;

  /// Optional icon displayed next to the section title.
  /// If null, no icon is shown.
  final IconData? sectionIcon;

  /// Section title. Defaults to 'Tjenester'.
  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    // Filter to active services only.
    final activeServices =
        data.services.where((s) => s.isActive).toList();

    if (activeServices.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sort groups by sortOrder.
    final sortedGroups = List<ServiceGroup>.from(data.serviceGroups)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    // Build a map of groupId → services.
    final grouped = <String, List<Service>>{};
    final ungrouped = <Service>[];

    for (final service in activeServices) {
      if (service.groupId != null) {
        grouped.putIfAbsent(service.groupId!, () => []).add(service);
      } else {
        ungrouped.add(service);
      }
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DittoSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: DittoSpacing.md),

            // Section header
            Row(
              children: [
                if (sectionIcon != null) ...[
                  Icon(
                    sectionIcon,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: DittoSpacing.sm),
                ],
                Text(
                  sectionTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DittoSpacing.sm),

            // Grouped services — in sortOrder
            for (final group in sortedGroups)
              if (grouped.containsKey(group.id))
                ServiceGroupSection(
                  group: group,
                  services: grouped[group.id]!,
                ),

            // Ungrouped fallback
            if (ungrouped.isNotEmpty)
              UngroupedServiceSection(services: ungrouped),

            const SizedBox(height: DittoSpacing.sm),
          ],
        ),
      ),
    );
  }
}
