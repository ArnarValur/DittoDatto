import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

// TODO: Render upcoming events/tickets from establishment data

/// Placeholder section for establishment events and tickets.
///
/// Displays a styled empty state until event data is wired up.
/// Renders as a [SliverToBoxAdapter] inside a [CustomScrollView].
class EstablishmentEventsSection extends StatelessWidget {
  const EstablishmentEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DittoSpacing.base),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: DittoSpacing.md),
              Text(
                'Arrangementer',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: DittoSpacing.md),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.event_outlined,
                      size: 48,
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    Text(
                      'Arrangementer kommer snart',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DittoSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
