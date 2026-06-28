import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Identity bar showing the establishment's logo, name, address,
/// and opening status.
///
/// Responsive layout:
/// - **Mobile** (compact): Centered vertical stack.
///   ```
///        ┌──────┐
///        │ Logo │  (circular, centered)
///        └──────┘
///     House of the North
///    Skolegata 9, Drammen
///      🔴 Stengt i dag
///   ```
/// - **Tablet/Desktop** (medium+): Horizontal row with action buttons.
///   ```
///   [Logo]  House of the North          [🗓 Book] [♡ Fav]
///           Skolegata 9 · Stengt i dag
///   ```
class EstablishmentInfoBar extends StatelessWidget {
  const EstablishmentInfoBar({
    required this.data,
    this.isWide = false,
    this.isPreview = false,
    super.key,
  });

  final EstablishmentData data;

  /// Whether to use the wide (tablet/desktop) horizontal layout.
  final bool isWide;

  /// Whether this is preview mode (hides action buttons).
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return _buildWideLayout(context);
    }
    return _buildMobileLayout(context);
  }

  /// Mobile: centered vertical stack.
  Widget _buildMobileLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.base,
        vertical: DittoSpacing.md,
      ),
      child: Column(
        children: [
          // Logo avatar (or type icon fallback) — centered.
          _buildAvatar(colorScheme, radius: 36),
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
    );
  }

  /// Desktop: horizontal row — logo + info left, action buttons right.
  Widget _buildWideLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.base,
        vertical: DittoSpacing.md,
      ),
      child: Row(
        children: [
          // Logo avatar.
          _buildAvatar(colorScheme, radius: 28),
          const SizedBox(width: DittoSpacing.md),

          // Name + address + status column.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        data.addressLine,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (data.openingStatus != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DittoSpacing.sm,
                        ),
                        child: Text(
                          '·',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        data.openingStatus!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: data.isOpen == true
                              ? colorScheme.primary
                              : colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Action buttons — right side.
          const SizedBox(width: DittoSpacing.md),
          FilledButton.icon(
            // TODO: Wire to booking flow
            onPressed: null,
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Bestill time'),
          ),
          const SizedBox(width: DittoSpacing.sm),
          OutlinedButton.icon(
            // TODO: Wire to favorites flow
            onPressed: null,
            icon: const Icon(Icons.favorite_border_rounded),
            label: const Text('Lagre'),
          ),
        ],
      ),
    );
  }

  /// Builds the logo circle avatar with fallback icon.
  Widget _buildAvatar(ColorScheme colorScheme, {required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.secondaryContainer,
      backgroundImage: data.logoUrl != null
          ? NetworkImage(data.logoUrl!)
          : null,
      child: data.logoUrl == null
          ? Icon(
              data.businessType.icon,
              size: radius * 0.9,
              color: colorScheme.onSecondaryContainer,
            )
          : null,
    );
  }
}
