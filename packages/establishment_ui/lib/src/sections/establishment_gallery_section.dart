import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Full-width cover image gallery for the establishment page.
///
/// Responsive layout:
/// - **Mobile** (compact): Single cover image filling the width with a
///   "Se bilder" pill button overlaid bottom-right.
/// - **Tablet/Desktop** (medium+): Bento grid — hero cover (1/2 width)
///   + 2×2 gallery thumbnails (1/2 width) with rounded corners and gaps.
///   Respects the page's max-width constraint (not full-bleed).
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

  /// Maximum content width — matches EstablishmentPage._maxContentWidth.
  static const _maxContentWidth = 1200.0;

  /// Horizontal padding inside the constrained area on wide viewports.
  static const _widePaddingH = DittoSpacing.lg;

  /// Border radius for gallery images on desktop.
  static const _imageRadius = Radius.circular(12);

  /// Gap between gallery grid images.
  static const _gridGap = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // No media at all — inline placeholder.
    if (!data.hasMedia) {
      return SliverToBoxAdapter(
        child: _buildConstrainedWrapper(
          child: Container(
            height: isWide ? 350 : 260,
            decoration: BoxDecoration(
              color:
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius:
                  isWide ? const BorderRadius.all(_imageRadius) : null,
            ),
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
        ),
      );
    }

    // Wide layout — bento grid with margins and rounded corners.
    if (isWide) {
      return SliverToBoxAdapter(
        child: _buildConstrainedWrapper(
          child: _buildBentoGrid(theme, colorScheme),
        ),
      );
    }

    // Mobile layout — single cover with pill overlay (full-bleed).
    return SliverToBoxAdapter(
      child: _buildMobileCover(theme, colorScheme),
    );
  }

  /// Wraps content in a centered, max-width constrained container
  /// with horizontal padding — matching the page content area.
  Widget _buildConstrainedWrapper({required Widget child}) {
    if (!isWide) return child;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _widePaddingH),
          child: child,
        ),
      ),
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

  /// Builds the bento grid: hero (1/2) + 2×2 thumbnails (1/2).
  ///
  /// Matches the Nuxt reference layout with rounded corners and gaps.
  Widget _buildBentoGrid(ThemeData theme, ColorScheme colorScheme) {
    const gridHeight = 400.0;
    const thumbnailHeight = (gridHeight - _gridGap) / 2;

    final gallery = data.galleryUrls;

    return SizedBox(
      height: gridHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero cover — takes 1/2 of width.
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: _imageRadius,
                bottomLeft: _imageRadius,
              ),
              child: _buildCoverImage(gridHeight, colorScheme),
            ),
          ),

          const SizedBox(width: _gridGap),

          // 2×2 thumbnail grid — takes 1/2 of width.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top row — 2 thumbnails side by side.
                SizedBox(
                  height: thumbnailHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.zero,
                          ),
                          child: gallery.isNotEmpty
                              ? _buildThumbnailImage(
                                  gallery[0], colorScheme)
                              : _buildThumbnailPlaceholder(colorScheme),
                        ),
                      ),
                      const SizedBox(width: _gridGap),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: _imageRadius,
                          ),
                          child: gallery.length > 1
                              ? _buildThumbnailImage(
                                  gallery[1], colorScheme)
                              : _buildThumbnailPlaceholder(colorScheme),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: _gridGap),

                // Bottom row — 2 thumbnails, last one has "Se bilder".
                SizedBox(
                  height: thumbnailHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.zero,
                          ),
                          child: gallery.length > 2
                              ? _buildThumbnailImage(
                                  gallery[2], colorScheme)
                              : _buildThumbnailPlaceholder(colorScheme),
                        ),
                      ),
                      const SizedBox(width: _gridGap),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: _imageRadius,
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              gallery.length > 3
                                  ? _buildThumbnailImage(
                                      gallery[3], colorScheme)
                                  : _buildThumbnailPlaceholder(colorScheme),

                              // "Se bilder" pill on last thumbnail.
                              if (data.totalPhotoCount > 4)
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
    final url = data.coverUrl ??
        (data.galleryUrls.isNotEmpty ? data.galleryUrls.first : null);
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

  /// Builds a gallery thumbnail image.
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
