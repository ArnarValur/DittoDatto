import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Renders the establishment's cover image and gallery photos.
///
/// Shows a cover image at the top, followed by a horizontal scrollable
/// row of gallery thumbnails. Falls back to [_EmptyGallery] when no
/// media is available.
///
/// Layout modes (bento/showcase/spotlight) are stored on
/// [EstablishmentData.coverLayoutMode] but not yet rendered differently —
/// all three currently show a simple cover + gallery row. Distinct layout
/// rendering will be added when the EstablishmentPage is re-grilled.
class EstablishmentGallerySection extends StatelessWidget {
  const EstablishmentGallerySection({required this.data, super.key});

  final EstablishmentData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cover image
          if (data.coverUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(DittoSpacing.base),
                bottomRight: Radius.circular(DittoSpacing.base),
              ),
              child: Image.network(
                data.coverUrl!,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _ImageErrorBox(
                  height: 220,
                  colorScheme: colorScheme,
                ),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return _ImageLoadingBox(
                    height: 220,
                    colorScheme: colorScheme,
                  );
                },
              ),
            ),

          // Gallery thumbnails (horizontal scroll row)
          if (data.galleryUrls.isNotEmpty) ...[
            const SizedBox(height: DittoSpacing.sm),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: DittoSpacing.base,
                ),
                itemCount: data.galleryUrls.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: DittoSpacing.xs),
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: DittoBorderRadius.smallAll,
                  child: Image.network(
                    data.galleryUrls[index],
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _ImageErrorBox(
                      height: 80,
                      width: 100,
                      colorScheme: colorScheme,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error state for failed image loads.
class _ImageErrorBox extends StatelessWidget {
  const _ImageErrorBox({
    required this.height,
    required this.colorScheme,
    this.width,
  });

  final double height;
  final double? width;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          size: 32,
        ),
      ),
    );
  }
}

/// Loading state for images being fetched.
class _ImageLoadingBox extends StatelessWidget {
  const _ImageLoadingBox({
    required this.height,
    required this.colorScheme,
  });

  final double height;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
