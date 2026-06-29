import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/format_helpers.dart';
import '../models/service.dart';

/// Consumer-facing card for a single [Service].
///
/// Three visual variants driven by [Service.bookingMode]:
/// - **standard** — title · price · duration · optional description
/// - **tableReservation** — title · price · optional description (no duration)
/// - **ticketSystem** — title · price · optional description · ticket accent
///
/// Display-only for now — tap interaction deferred to booking flow grill.
class ServiceCard extends StatelessWidget {
  const ServiceCard({
    required this.service,
    this.icon,
    super.key,
  });

  /// The service to display.
  final Service service;

  /// Optional leading icon. If null, no icon is shown.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card.outlined(
      margin: const EdgeInsets.symmetric(vertical: DittoSpacing.xs / 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DittoSpacing.base,
          vertical: DittoSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading icon (optional)
            if (icon != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  icon,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: DittoSpacing.sm),
            ],

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          service.title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: DittoSpacing.sm),
                      Text(
                        formatPrice(service.price, service.currency),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: DittoSpacing.xs / 2),

                  // Metadata row — duration + booking mode accent
                  _buildMetadataRow(theme, colorScheme),

                  // Description (if present)
                  if (service.description != null &&
                      service.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: DittoSpacing.xs),
                    Text(
                      service.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the metadata row beneath the title.
  ///
  /// - standard: duration chip
  /// - tableReservation: nothing (restaurants don't show minutes)
  /// - ticketSystem: ticket accent chip
  Widget _buildMetadataRow(ThemeData theme, ColorScheme colorScheme) {
    final chips = <Widget>[];

    switch (service.bookingMode) {
      case 'standard':
        chips.add(_MetadataChip(
          label: formatDuration(service.duration),
          icon: Icons.schedule_outlined,
          theme: theme,
          colorScheme: colorScheme,
        ));
      case 'ticketSystem':
        if (service.duration > 0) {
          chips.add(_MetadataChip(
            label: formatDuration(service.duration),
            icon: Icons.schedule_outlined,
            theme: theme,
            colorScheme: colorScheme,
          ));
        }
        chips.add(_MetadataChip(
          label: 'Billett',
          icon: Icons.confirmation_number_outlined,
          theme: theme,
          colorScheme: colorScheme,
          accent: true,
        ));
      case 'tableReservation':
        // No duration for table reservations.
        break;
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: DittoSpacing.xs,
      runSpacing: DittoSpacing.xs / 2,
      children: chips,
    );
  }
}

/// A small inline metadata chip (duration, ticket badge, etc.).
class _MetadataChip extends StatelessWidget {
  const _MetadataChip({
    required this.label,
    required this.icon,
    required this.theme,
    required this.colorScheme,
    this.accent = false,
  });

  final String label;
  final IconData icon;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final bgColor = accent
        ? colorScheme.tertiaryContainer
        : colorScheme.surfaceContainerHighest;
    final fgColor = accent
        ? colorScheme.onTertiaryContainer
        : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fgColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}
