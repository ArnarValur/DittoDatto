import 'package:discovery_service/discovery_service.dart';
import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

/// Compact card for displaying an [EstablishmentListing] on the Home screen.
///
/// Shows cover image (with logo/placeholder fallback), name, category chip,
/// rating stars, and city subtitle. Tapping invokes [onTap].
class EstablishmentListingCard extends StatelessWidget {
  const EstablishmentListingCard({
    required this.listing,
    required this.onTap,
    super.key,
  });

  final EstablishmentListing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: DittoBorderRadius.largeAll,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cover image ──
            _CoverImage(listing: listing),
            // ── Details ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DittoSpacing.md,
                DittoSpacing.compact,
                DittoSpacing.md,
                DittoSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    listing.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: DittoSpacing.xs),
                  // Category + Rating row
                  Row(
                    children: [
                      if (listing.category != null) ...[
                        _CategoryChip(category: listing.category!),
                        const SizedBox(width: DittoSpacing.sm),
                      ],
                      if (listing.aggregateRating != null)
                        _RatingBadge(rating: listing.aggregateRating!),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: DittoSpacing.xs),
                  // City / address
                  Text(
                    listing.city.isNotEmpty
                        ? '${listing.address}, ${listing.city}'
                        : listing.address,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.listing});

  final EstablishmentListing listing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Cover or placeholder
          if (listing.cover != null)
            Image.network(
              listing.cover!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _Placeholder(colorScheme: colorScheme),
            )
          else
            _Placeholder(colorScheme: colorScheme),
          // Logo overlay (bottom-left)
          if (listing.logo != null)
            Positioned(
              left: DittoSpacing.compact,
              bottom: DittoSpacing.compact,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(listing.logo!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.storefront_outlined,
          size: 48,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
        borderRadius: DittoBorderRadius.smallAll,
      ),
      child: Text(
        category,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final AggregateRating rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          size: 14,
          color: Colors.amber.shade700,
        ),
        const SizedBox(width: 2),
        Text(
          rating.average.toStringAsFixed(1),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          '(${rating.count})',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
