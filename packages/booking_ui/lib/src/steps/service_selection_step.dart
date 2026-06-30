import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';

import '../models/booking_state.dart';

/// Step 1: Service selection with real data.
///
/// Displays service groups with item count chips. Each service shows
/// image + title + duration + price + checkbox/radio. Respects the
/// per-group `multiSelect` flag. Sticky bottom bar with running total.
class ServiceSelectionStep extends StatelessWidget {
  const ServiceSelectionStep({
    super.key,
    required this.services,
    required this.serviceGroups,
    required this.state,
    required this.onStateChanged,
    required this.onContinue,
  });

  final List<Service> services;
  final List<ServiceGroup> serviceGroups;
  final BookingState state;
  final ValueChanged<BookingState> onStateChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Filter groups that should appear on the booking panel.
    final visibleGroups = serviceGroups
        .where((g) => g.showOnBookingPanel)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    // Group services by their groupId.
    final servicesByGroup = <String?, List<Service>>{};
    for (final service in services.where((s) => s.isActive)) {
      (servicesByGroup[service.groupId] ??= []).add(service);
    }

    // Ungrouped services.
    final ungrouped = servicesByGroup[null] ?? [];

    return Column(
      children: [
        // Scrollable content.
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Velg tjenester',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Velg én eller flere tjenester for å fortsette bestillingen.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Grouped services.
                for (final group in visibleGroups) ...[
                  if (servicesByGroup[group.id]?.isNotEmpty ?? false) ...[
                    _buildGroupHeader(
                      context,
                      group: group,
                      count: servicesByGroup[group.id]!.length,
                    ),
                    const SizedBox(height: 12),
                    ...servicesByGroup[group.id]!.map(
                      (service) => _buildServiceCard(
                        context,
                        service: service,
                        isMultiSelect: group.multiSelect,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],

                // Ungrouped services.
                if (ungrouped.isNotEmpty) ...[
                  _buildGroupHeader(
                    context,
                    groupName: 'Andre tjenester',
                    count: ungrouped.length,
                  ),
                  const SizedBox(height: 12),
                  ...ungrouped.map(
                    (service) => _buildServiceCard(
                      context,
                      service: service,
                      isMultiSelect: true,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Sticky bottom bar.
        _buildBottomBar(context),
      ],
    );
  }

  Widget _buildGroupHeader(
    BuildContext context, {
    ServiceGroup? group,
    String? groupName,
    required int count,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final name = group?.name ?? groupName ?? '';

    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$count ${count == 1 ? 'tjeneste' : 'tjenester'}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required Service service,
    required bool isMultiSelect,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = state.isServiceSelected(service);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onStateChanged(state.toggleService(service, serviceGroups));
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant.withValues(alpha: 0.5),
                width: isSelected ? 2 : 1,
              ),
              color: isSelected
                  ? colorScheme.primaryContainer.withValues(alpha: 0.1)
                  : null,
            ),
            child: Row(
              children: [
                // Cover image or placeholder.
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: service.coverImage != null
                        ? Image.network(
                            service.coverImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildImagePlaceholder(colorScheme),
                          )
                        : _buildImagePlaceholder(colorScheme),
                  ),
                ),
                const SizedBox(width: 12),

                // Title + duration + price.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${service.duration} min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kr ${service.price.toStringAsFixed(service.price.truncateToDouble() == service.price ? 0 : 2)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkbox / Radio indicator.
                SizedBox(
                  width: 24,
                  height: 24,
                  child: isMultiSelect
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (_) {
                            onStateChanged(
                              state.toggleService(service, serviceGroups),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )
                      : Radio<bool>(
                          value: true,
                          groupValue: isSelected ? true : null,
                          onChanged: (_) {
                            onStateChanged(
                              state.toggleService(service, serviceGroups),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.content_cut,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        size: 28,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Total price.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Totalpris',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Kr ${state.subtotal.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Continue button.
            FilledButton.icon(
              onPressed: state.hasServices ? onContinue : null,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Fortsett'),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
