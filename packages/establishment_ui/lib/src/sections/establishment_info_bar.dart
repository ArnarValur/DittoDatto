import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Identity bar showing the establishment's logo, name, address,
/// and opening status in a centered vertical stack.
///
/// Mobile layout (matching the Nuxt mobile screenshot):
/// ```
///      ┌──────┐
///      │ Logo │  (circular, centered)
///      └──────┘
///   House of the North
///  Skolegata 9, Drammen
///    🔴 Stengt i dag
/// ```
///
/// TODO: Implement responsive horizontal layout for tablet/desktop
/// breakpoints (logo left, name/address inline, buttons right).
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
          children: [
            // Logo avatar (or type icon fallback) — centered.
            CircleAvatar(
              radius: 36,
              backgroundColor: colorScheme.secondaryContainer,
              backgroundImage: data.logoUrl != null
                  ? NetworkImage(data.logoUrl!)
                  : null,
              child: data.logoUrl == null
                  ? Icon(
                      data.businessType.icon,
                      size: 32,
                      color: colorScheme.onSecondaryContainer,
                    )
                  : null,
            ),
            const SizedBox(height: DittoSpacing.md),

            // Establishment name — centered, bold.
            Text(
              data.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DittoSpacing.xs),

            // Address line — centered, subdued.
            Text(
              data.addressLine,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Opening status — centered, color-coded.
            // TODO: Derive from opening_schedule when schedule parsing
            // is implemented. Currently uses the placeholder string
            // from EstablishmentData.openingStatus.
            if (data.openingStatus != null) ...[
              const SizedBox(height: DittoSpacing.xs),
              Text(
                data.openingStatus!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: data.isOpen == true
                      ? colorScheme.primary
                      : colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
