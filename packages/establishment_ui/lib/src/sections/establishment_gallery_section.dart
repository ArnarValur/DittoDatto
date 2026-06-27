import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Full-width cover image gallery for the establishment page.
///
/// Mobile-first layout: single cover image filling the width with a
/// "Se bilder" pill button overlaid bottom-right (when gallery has
/// additional photos). Falls back to an inline placeholder when no
/// media is available.
///
/// TODO: Implement responsive bento/showcase layouts for tablet/desktop
/// breakpoints based on [EstablishmentData.coverLayoutMode].
class EstablishmentGallerySection extends StatelessWidget {
  const EstablishmentGallerySection({
    required this.data,
    this.onViewPhotos,
    super.key,
  });

  final EstablishmentData data;

  /// Called when the "Se bilder" button is tapped.
  /// TODO: Wire to full-screen gallery viewer.
  final VoidCallback? onViewPhotos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // No media at all — inline placeholder.
    if (!data.hasMedia) {
      return SliverToBoxAdapter(
        child: Container(
          height: 260,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 48,
                  color:
                      colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                const SizedBox(height: DittoSpacing.sm),
                Text(
                  'Bilder kommer snart',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Cover image with optional "Se bilder" pill overlay.
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          // Cover image — full width, 4:3-ish aspect on mobile.
          if (data.coverUrl != null)
            Image.network(
              data.coverUrl!,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _ImageErrorBox(
                height: 300,
                colorScheme: colorScheme,
              ),
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return _ImageLoadingBox(
                  height: 300,
                  colorScheme: colorScheme,
                );
              },
            )
          else if (data.galleryUrls.isNotEmpty)
            // No cover but gallery exists — use first gallery image.
            Image.network(
              data.galleryUrls.first,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _ImageErrorBox(
                height: 300,
                colorScheme: colorScheme,
              ),
            ),

          // "Se bilder" pill — bottom-right, shown when there are photos.
          if (data.totalPhotoCount > 1)
            Positioned(
              bottom: DittoSpacing.md,
              right: DittoSpacing.md,
              child: Material(
                color: colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: DittoBorderRadius.mediumAll,
                elevation: 2,
                child: InkWell(
                  onTap: onViewPhotos,
                  borderRadius: DittoBorderRadius.mediumAll,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DittoSpacing.md,
                      vertical: DittoSpacing.sm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.grid_view_rounded,
                          size: 16,
                          color: colorScheme.onSurface,
                        ),
                        const SizedBox(width: DittoSpacing.xs),
                        Text(
                          'Se bilder (${data.totalPhotoCount})',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
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
}

/// Error state for failed image loads.
class _ImageErrorBox extends StatelessWidget {
  const _ImageErrorBox({
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
