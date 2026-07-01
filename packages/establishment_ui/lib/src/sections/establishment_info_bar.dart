import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Identity bar showing the establishment's logo, name, address,
/// category, opening status, and action buttons.
///
/// Responsive layout:
/// - **Mobile** (compact): Inline row with logo left + text column right,
///   category/status pills, and full-width action buttons below.
///   ```
///   [Logo 48px]  Establishment Name
///                Category 🏷  ● Åpen
///                Skolegata 9, Drammen
///
///   [ 📅 Bestill time     ] [ ♡ Lagre ]
///   ```
/// - **Tablet/Desktop** (medium+): Horizontal row with action buttons right.
///   ```
///   [Logo]  House of the North          [🗓 Book] [♡ Fav]
///           Restaurant · Åpen til 18:00
///   ```
class EstablishmentInfoBar extends StatelessWidget {
  const EstablishmentInfoBar({
    required this.data,
    this.isWide = false,
    this.isPreview = false,
    this.onFavoriteTapped,
    this.isFavorited = false,
    this.onBookTapped,
    super.key,
  });

  final EstablishmentData data;

  /// Whether to use the wide (tablet/desktop) horizontal layout.
  final bool isWide;

  /// Whether this is preview mode (hides action buttons).
  final bool isPreview;

  /// Called when the user taps the Lagre (favorite) button.
  /// Null in preview mode — button is disabled.
  final VoidCallback? onFavoriteTapped;

  /// Whether the establishment is currently favorited by the user.
  /// Controls filled vs outline heart icon.
  final bool isFavorited;

  /// Called when the user taps the "Bestill time" (Book) button.
  final VoidCallback? onBookTapped;

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return _buildWideLayout(context);
    }
    return _buildMobileLayout(context);
  }

  /// Mobile: inline row (logo + text) + pills + buttons below.
  Widget _buildMobileLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.base,
        vertical: DittoSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo + Name row ────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo avatar (or type icon fallback).
              _buildAvatar(colorScheme, radius: 28),
              const SizedBox(width: DittoSpacing.sm + 4),

              // Name + pills + address column.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Establishment name.
                    Text(
                      data.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: DittoSpacing.xs),

                    // Category pill + open/closed pill.
                    _buildPillsRow(theme, colorScheme),
                    const SizedBox(height: DittoSpacing.xs),

                    // Address line.
                    Text(
                      data.addressLine,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: DittoSpacing.md),

          // ── Action buttons ─────────────────────────────────
          _buildActionButtons(colorScheme),
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
        vertical: 20,
      ),
      child: Row(
        children: [
          // Logo avatar.
          _buildAvatar(colorScheme, radius: 32),
          const SizedBox(width: DittoSpacing.base),

          // Name + category · address · status column.
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
                    // Category + address.
                    if (data.category != null) ...[
                      Text(
                        data.category!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
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
                    ],
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
            onPressed: isPreview ? null : onBookTapped,
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Bestill time'),
          ),
          const SizedBox(width: DittoSpacing.sm),
          OutlinedButton.icon(
            onPressed: isPreview ? null : onFavoriteTapped,
            icon: Icon(
              isFavorited
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorited ? colorScheme.error : null,
            ),
            label: const Text('Lagre'),
          ),
        ],
      ),
    );
  }

  /// Builds the category + open/closed pills row.
  Widget _buildPillsRow(ThemeData theme, ColorScheme colorScheme) {
    return Wrap(
      spacing: DittoSpacing.xs,
      runSpacing: DittoSpacing.xs,
      children: [
        // Category pill.
        if (data.category != null)
          _buildPill(
            label: data.category!,
            icon: data.establishmentType.icon,
            backgroundColor: colorScheme.secondaryContainer,
            foregroundColor: colorScheme.onSecondaryContainer,
            theme: theme,
          ),

        // Open/closed status pill.
        if (data.openingStatus != null)
          _buildStatusPill(
            label: data.openingStatus!,
            isOpen: data.isOpen == true,
            colorScheme: colorScheme,
            theme: theme,
          ),
      ],
    );
  }

  /// Builds a category pill chip.
  Widget _buildPill({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the open/closed status pill.
  Widget _buildStatusPill({
    required String label,
    required bool isOpen,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    final dotColor = isOpen ? colorScheme.primary : colorScheme.error;
    final textColor = colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Action buttons row — Bestill time (filled) + Lagre (outlined with heart).
  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: isPreview ? null : onBookTapped,
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Bestill time'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: DittoSpacing.sm),
        OutlinedButton.icon(
          onPressed: isPreview ? null : onFavoriteTapped,
          icon: Icon(
            isFavorited
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: isFavorited ? colorScheme.error : null,
          ),
          label: const Text('Lagre'),
        ),
      ],
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
              data.establishmentType.icon,
              size: radius * 0.9,
              color: colorScheme.onSecondaryContainer,
            )
          : null,
    );
  }
}
