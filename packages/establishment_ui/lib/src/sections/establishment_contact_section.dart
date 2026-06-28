import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Contact section displaying phone, email, and website.
///
/// Responsive layout:
/// - **Mobile** (compact): Single card with ListTile items.
/// - **Tablet/Desktop** (medium+): Two-column — contact info left,
///   map placeholder right.
///
/// Renders as a [SliverToBoxAdapter] inside a [CustomScrollView].
/// Hidden entirely when all contact fields are null.
class EstablishmentContactSection extends StatelessWidget {
  const EstablishmentContactSection({
    required this.data,
    this.isWide = false,
    super.key,
  });

  final EstablishmentData data;

  /// Whether to use the wide (tablet/desktop) two-column layout.
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    // Show at least the address on desktop even if no phone/email/website.
    if (!data.hasContactInfo && !isWide) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final theme = Theme.of(context);

    if (isWide) {
      return SliverToBoxAdapter(
        child: _buildWideLayout(theme),
      );
    }

    return SliverToBoxAdapter(
      child: _buildMobileLayout(theme),
    );
  }

  /// Mobile: single card with ListTiles.
  Widget _buildMobileLayout(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DittoSpacing.base),
      child: Card.outlined(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            ..._buildContactItems(),
            const SizedBox(height: DittoSpacing.xs),
          ],
        ),
      ),
    );
  }

  /// Desktop: two-column — contact info left, map placeholder right.
  Widget _buildWideLayout(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DittoSpacing.base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column — contact info card.
          Expanded(
            child: Card.outlined(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(theme),
                  // Address (always shown on desktop).
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(data.addressLine),
                    dense: true,
                  ),
                  ..._buildContactItems(),
                  const SizedBox(height: DittoSpacing.xs),
                ],
              ),
            ),
          ),

          const SizedBox(width: DittoSpacing.md),

          // Right column — map placeholder.
          Expanded(
            child: Card.outlined(
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: DittoBorderRadius.mediumAll,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 48,
                        color: colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: DittoSpacing.sm),
                      Text(
                        'Kart kommer snart',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Contact section header with icon and title.
  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DittoSpacing.base,
        DittoSpacing.base,
        DittoSpacing.base,
        DittoSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(
            Icons.contact_mail_outlined,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: DittoSpacing.sm),
          Text(
            'Kontakt',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the list of contact ListTile widgets.
  List<Widget> _buildContactItems() {
    return [
      if (data.phone != null)
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: Text(data.phone!),
          dense: true,
        ),
      if (data.email != null)
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: Text(data.email!),
          dense: true,
        ),
      if (data.website != null)
        ListTile(
          leading: const Icon(Icons.language_outlined),
          title: Text(data.website!),
          dense: true,
        ),
    ];
  }
}
