import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Full-width cover image gallery for the establishment page.
///
/// Responsive layout:
/// - **Mobile** (compact): Single cover image filling the width with a
///   "Se bilder" pill button overlaid bottom-right.
/// - **Tablet/Desktop** (medium+): Bento grid — hero cover (2/3 width)
///   + 2 stacked gallery thumbnails (1/3 width) with gap.
///
/// Falls back to an inline placeholder when no media is available.
class EstablishmentGallerySection extends StatelessWidget {
  const EstablishmentGallerySection({
    required this.data,
    this.isWide = false,
    this.onViewPhotos,
    super.key,
  });

  final EstablishmentData data;

  /// Whether to use the wide (tablet/desktop) layout.
  final bool isWide;

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
          height: isWide ? 350 : 260,
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

    // Wide layout — bento grid.
    if (isWide) {
      return SliverToBoxAdapter(child: _buildBentoGrid(theme, colorScheme));
    }

    // Mobile layout — single cover with pill overlay.
    return SliverToBoxAdapter(
      child: _buildMobileCover(theme, colorScheme),
    );
  }

  /// Builds the mobile cover: full-width image + "Se bilder" pill.
  Widget _buildMobileCover(ThemeData theme, ColorScheme colorScheme) {
    return Stack(
      children: [
        _buildCoverImage(300, colorScheme),

        // "Se bilder" pill — bottom-right, shown when there are photos.
        if (data.totalPhotoCount > 1)
          Positioned(
            bottom: DittoSpacing.md,
            right: DittoSpacing.md,
            child: _ViewPhotosPill(
              count: data.totalPhotoCount,
              onTap: onViewPhotos,
              colorScheme: colorScheme,
              textStyle: theme.textTheme.labelMedium,
            ),
          ),
      ],
    );
  }

  /// Builds the bento grid: hero (flex 2) + 2 stacked thumbnails (flex 1).
  Widget _buildBentoGrid(ThemeData theme, ColorScheme colorScheme) {
    const gridHeight = 380.0;
    const gap = 4.0;

    return SizedBox(
      height: gridHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero cover — takes 2/3 of width.
          Expanded(
            flex: 2,
            child: _buildCoverImage(gridHeight, colorScheme),
          ),

          const SizedBox(width: gap),

          // Thumbnail column — takes 1/3 of width.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thumbnail 1
                Expanded(
                  child: data.galleryUrls.isNotEmpty
                      ? _buildThumbnailImage(
                          data.galleryUrls[0],
                          colorScheme,
                        )
                      : _buildThumbnailPlaceholder(colorScheme),
                ),

                const SizedBox(height: gap),

                // Thumbnail 2 — with "Se bilder" overlay if more photos.
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      data.galleryUrls.length > 1
                          ? _buildThumbnailImage(
                              data.galleryUrls[1],
                              colorScheme,
                            )
                          : _buildThumbnailPlaceholder(colorScheme),

                      // "Se bilder" overlay on last thumbnail.
                      if (data.totalPhotoCount > 3)
                        Positioned(
                          bottom: DittoSpacing.sm,
                          right: DittoSpacing.sm,
                          child: _ViewPhotosPill(
                            count: data.totalPhotoCount,
                            onTap: onViewPhotos,
                            colorScheme: colorScheme,
                            textStyle: theme.textTheme.labelMedium,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the primary cover image (used in both mobile and bento layouts).
  Widget _buildCoverImage(double height, ColorScheme colorScheme) {
    final url = data.coverUrl ?? (data.galleryUrls.isNotEmpty ? data.galleryUrls.first : null);
    if (url == null) {
      return _ImageErrorBox(height: height, colorScheme: colorScheme);
    }

    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _ImageErrorBox(
        height: height,
        colorScheme: colorScheme,
      ),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return _ImageLoadingBox(
          height: height,
          colorScheme: colorScheme,
        );
      },
    );
  }

  /// Builds a gallery thumbnail image with clipped corners.
  Widget _buildThumbnailImage(String url, ColorScheme colorScheme) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: 24,
          ),
        ),
      ),
    );
  }

  /// Builds a placeholder for missing thumbnail slots.
  Widget _buildThumbnailPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          size: 32,
        ),
      ),
    );
  }
}

/// "Se bilder (N)" pill button overlaid on the gallery.
class _ViewPhotosPill extends StatelessWidget {
  const _ViewPhotosPill({
    required this.count,
    required this.onTap,
    required this.colorScheme,
    required this.textStyle,
  });

  final int count;
  final VoidCallback? onTap;
  final ColorScheme colorScheme;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.surface.withValues(alpha: 0.9),
      borderRadius: DittoBorderRadius.mediumAll,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
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
                'Se bilder ($count)',
                style: textStyle?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
