import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

// TODO: Render ServiceGroup → Service list from establishment data

/// Placeholder section for establishment services / offers.
///
/// Displays a styled empty state until service data is wired up.
/// Renders as a [SliverToBoxAdapter] inside a [CustomScrollView].
class EstablishmentServicesSection extends StatelessWidget {
  const EstablishmentServicesSection({super.key});

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
                'Tilbud',
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
                      Icons.storefront_outlined,
                      size: 48,
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    Text(
                      'Tjenester kommer snart',
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
