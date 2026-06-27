import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Identity bar showing establishment name, type badge, address, and category.
///
/// Renders as a [SliverToBoxAdapter] for use inside a [CustomScrollView].
/// Matches the legacy Nuxt `EstablishmentInfoBar` layout: name prominently
/// displayed with a business type chip and address line beneath.
class EstablishmentInfoBar extends StatelessWidget {
  const EstablishmentInfoBar({
    required this.data,
    super.key,
  });

  final EstablishmentData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DittoSpacing.base,
          vertical: DittoSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo + Name + type badge row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo avatar (or type icon fallback)
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.secondaryContainer,
                  backgroundImage: data.logoUrl != null
                      ? NetworkImage(data.logoUrl!)
                      : null,
                  child: data.logoUrl == null
                      ? Icon(
                          data.businessType.icon,
                          size: 24,
                          color: colorScheme.onSecondaryContainer,
                        )
                      : null,
                ),
                const SizedBox(width: DittoSpacing.sm),
                Expanded(
                  child: Text(
                    data.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: DittoSpacing.sm),
                _BusinessTypeBadge(type: data.businessType),
              ],
            ),
            const SizedBox(height: DittoSpacing.xs),

            // Address line
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: DittoSpacing.xs),
                Text(
                  data.addressLine,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            // Category (optional)
            if (data.category != null) ...[
              const SizedBox(height: DittoSpacing.xs),
              Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: DittoSpacing.xs),
                  Text(
                    data.category!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Chip badge showing the business type with icon and Norwegian label.
class _BusinessTypeBadge extends StatelessWidget {
  const _BusinessTypeBadge({required this.type});

  final EstablishmentType type;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.sm,
        vertical: DittoSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: DittoBorderRadius.mediumAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type.icon,
            size: 16,
            color: colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: DittoSpacing.xs),
          Text(
            type.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
