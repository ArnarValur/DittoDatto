import 'package:flutter/material.dart';

import '../models/service.dart';
import '../models/service_group.dart';
import '../widgets/service_card.dart';

/// A collapsible group of [ServiceCard]s under a [ServiceGroup] header.
///
/// Displays the group name and optional description, with an
/// [ExpansionTile]-style expand/collapse toggle. Starts expanded.
///
/// Services are sorted alphabetically by title within the group.
class ServiceGroupSection extends StatelessWidget {
  const ServiceGroupSection({
    required this.group,
    required this.services,
    super.key,
  });

  /// The group header info.
  final ServiceGroup group;

  /// Services belonging to this group (pre-filtered to active only).
  final List<Service> services;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sort services by title within the group.
    final sorted = List<Service>.from(services)
      ..sort((a, b) => a.title.compareTo(b.title));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header
        Theme(
          // Remove the default divider lines from ExpansionTile.
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (group.description != null &&
                    group.description!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      group.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
            children: [
              for (final service in sorted) ServiceCard(service: service),
            ],
          ),
        ),
      ],
    );
  }
}

/// Fallback group for services with no assigned group.
///
/// Same visual as [ServiceGroupSection] but with a hardcoded
/// "Øvrige tjenester" header.
class UngroupedServiceSection extends StatelessWidget {
  const UngroupedServiceSection({
    required this.services,
    super.key,
  });

  /// Ungrouped services (pre-filtered to active only).
  final List<Service> services;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    final sorted = List<Service>.from(services)
      ..sort((a, b) => a.title.compareTo(b.title));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: Text(
              'Øvrige tjenester',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              for (final service in sorted) ServiceCard(service: service),
            ],
          ),
        ),
      ],
    );
  }
}
