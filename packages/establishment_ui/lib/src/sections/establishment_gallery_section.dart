import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/establishment_data.dart';

/// Full-width cover image gallery for the establishment page.
///
/// Responsive layout controlled by [EstablishmentData.coverLayoutMode]:
/// - **Mobile** (compact): Single cover image filling the width with a
///   "Se bilder" pill button overlaid bottom-right. Identical across all
///   layout modes.
/// - **Tablet/Desktop** (medium+): Layout depends on [CoverLayoutMode]:
///   - [CoverLayoutMode.bento]: Hero cover (1/2 width) + 2×2 gallery
///     thumbnails (1/2 width) with rounded corners and gaps.
///   - [CoverLayoutMode.showcase]: Hero cover (3/4 width) + vertically
///     scrollable gallery strip (1/4 width) — the "Nuxt favorite".
///   - [CoverLayoutMode.spotlight]: Full-width single cover image.
///
/// Falls back to an inline placeholder when no media is available.
class EstablishmentGallerySection extends StatelessWidget {
  const EstablishmentGallerySection({
    required this.data,
    this.isWide = false,
    super.key,
  });

  final EstablishmentData data;

  /// Whether to use the wide (tablet/desktop) layout.
  final bool isWide;

  /// All image URLs (cover first, then gallery) for the viewer.
  List<String> get _allImageUrls => [
        if (data.coverUrl != null) data.coverUrl!,
        ...data.galleryUrls,
      ];

  /// Opens a full-screen gallery viewer dialog.
  void _openGalleryViewer(BuildContext context, {int initialPage = 0}) {
    final urls = _allImageUrls;
    if (urls.isEmpty) return;
    showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (_) => _GalleryViewerDialog(
        imageUrls: urls,
        initialPage: initialPage,
      ),
    );
  }

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

    // Wide layout — dispatch by cover layout mode.
    if (isWide) {
      final wideChild = switch (data.coverLayoutMode) {
        CoverLayoutMode.showcase => _buildShowcase(theme, colorScheme),
        CoverLayoutMode.spotlight => _buildSpotlight(theme, colorScheme),
        CoverLayoutMode.bento => _buildBentoGrid(theme, colorScheme),
      };
      return SliverToBoxAdapter(
        child: _buildConstrainedWrapper(child: wideChild),
      );
    }

    // Mobile layout — single cover with pill overlay (full-bleed).
    return SliverToBoxAdapter(
      child: _buildMobileCover(context, theme, colorScheme),
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
  Widget _buildMobileCover(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
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
              onTap: () => _openGalleryViewer(context),
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
                                  child: Builder(
                                    builder: (context) => _ViewPhotosPill(
                                      count: data.totalPhotoCount,
                                      onTap: () => _openGalleryViewer(context),
                                      colorScheme: colorScheme,
                                      textStyle: theme.textTheme.labelMedium,
                                    ),
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

  /// Builds the showcase layout: hero (3/4 width) + vertically scrollable
  /// gallery strip (1/4 width).
  ///
  /// The user's favorite layout from the Nuxt reference — the gallery
  /// thumbnails scroll vertically next to the large cover image, creating
  /// a beautiful "peek and scroll" experience.
  Widget _buildShowcase(ThemeData theme, ColorScheme colorScheme) {
    const gridHeight = 400.0;
    // Height for each thumbnail in the vertical strip.
    const thumbnailHeight = 120.0;

    final gallery = data.galleryUrls;

    return SizedBox(
      height: gridHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero cover — takes 3/4 of width.
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: _imageRadius,
                bottomLeft: _imageRadius,
              ),
              child: _buildCoverImage(gridHeight, colorScheme),
            ),
          ),

          const SizedBox(width: _gridGap),

          // Vertical scrollable gallery strip — takes 1/4 of width.
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: _imageRadius,
                bottomRight: _imageRadius,
              ),
              child: gallery.isEmpty
                  ? _buildThumbnailPlaceholder(colorScheme)
                  : _ShowcaseStrip(
                      gallery: gallery,
                      thumbnailHeight: thumbnailHeight,
                      gridGap: _gridGap,
                      colorScheme: colorScheme,
                      buildThumbnailImage: _buildThumbnailImage,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the spotlight layout: full-width single cover image.
  ///
  /// The simplest layout — no thumbnails, just the hero cover.
  /// "Se bilder" pill appears if gallery images exist (opens gallery viewer).
  Widget _buildSpotlight(ThemeData theme, ColorScheme colorScheme) {
    const gridHeight = 400.0;

    return ClipRRect(
      borderRadius: const BorderRadius.all(_imageRadius),
      child: Stack(
        children: [
          _buildCoverImage(gridHeight, colorScheme),

          // "Se bilder" pill — shown when gallery has extra images.
          if (data.totalPhotoCount > 1)
            Positioned(
              bottom: DittoSpacing.md,
              right: DittoSpacing.md,
              child: Builder(
                builder: (context) => _ViewPhotosPill(
                  count: data.totalPhotoCount,
                  onTap: () => _openGalleryViewer(context),
                  colorScheme: colorScheme,
                  textStyle: theme.textTheme.labelMedium,
                ),
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

/// Auto-scrolling vertical thumbnail strip for the Showcase layout.
///
/// Gallery images scroll continuously in a seamless vertical loop next to
/// the hero cover image — no manual interaction needed, no "Se bilder" pill.
/// The content is duplicated to create the infinite loop illusion.
///
/// Pauses on hover (desktop) or tap (mobile) so users can inspect an image.
class _ShowcaseStrip extends StatefulWidget {
  const _ShowcaseStrip({
    required this.gallery,
    required this.thumbnailHeight,
    required this.gridGap,
    required this.colorScheme,
    required this.buildThumbnailImage,
  });

  final List<String> gallery;
  final double thumbnailHeight;
  final double gridGap;
  final ColorScheme colorScheme;
  final Widget Function(String url, ColorScheme scheme) buildThumbnailImage;

  @override
  State<_ShowcaseStrip> createState() => _ShowcaseStripState();
}

class _ShowcaseStripState extends State<_ShowcaseStrip>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animController;
  bool _paused = false;

  /// Pixels per second scroll speed — slow and elegant.
  static const _scrollSpeed = 30.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animController = AnimationController(
      vsync: this,
      // Duration is a placeholder — we drive by frame ticks, not total duration.
      duration: const Duration(seconds: 1),
    );
    // Start scrolling after the first frame so layout is resolved.
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    if (!mounted) return;
    _animController.addListener(_onTick);
    _animController.repeat();
  }

  DateTime? _lastTick;

  void _onTick() {
    if (_paused || !_scrollController.hasClients) {
      _lastTick = null;
      return;
    }

    final now = DateTime.now();
    if (_lastTick != null) {
      final dt = now.difference(_lastTick!).inMilliseconds / 1000.0;
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll <= 0) return;

      var newOffset = _scrollController.offset + _scrollSpeed * dt;
      // When we reach halfway (the duplicated content boundary), jump back.
      final halfScroll = maxScroll / 2;
      if (newOffset >= halfScroll) {
        newOffset -= halfScroll;
      }
      _scrollController.jumpTo(newOffset);
    }
    _lastTick = now;
  }

  @override
  Widget build(BuildContext context) {
    // Duplicate the gallery list for seamless looping.
    final loopedGallery = [...widget.gallery, ...widget.gallery];

    return MouseRegion(
      onEnter: (_) => setState(() => _paused = true),
      onExit: (_) => setState(() {
        _paused = false;
        _lastTick = null;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _paused = true),
        onTapUp: (_) => setState(() {
          _paused = false;
          _lastTick = null;
        }),
        onTapCancel: () => setState(() {
          _paused = false;
          _lastTick = null;
        }),
        child: ScrollConfiguration(
          // Hide scrollbar — auto-scroll doesn't need one.
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                for (var i = 0; i < loopedGallery.length; i++) ...[
                  if (i > 0) SizedBox(height: widget.gridGap),
                  SizedBox(
                    height: widget.thumbnailHeight,
                    width: double.infinity,
                    child: widget.buildThumbnailImage(
                      loopedGallery[i],
                      widget.colorScheme,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-screen gallery viewer dialog with swipeable images.
///
/// Opened by the "Se bilder" pill. Shows all images in a [PageView]
/// with arrow navigation, keyboard support (←/→/Esc), and a counter.
class _GalleryViewerDialog extends StatefulWidget {
  const _GalleryViewerDialog({
    required this.imageUrls,
    this.initialPage = 0,
  });

  final List<String> imageUrls;
  final int initialPage;

  @override
  State<_GalleryViewerDialog> createState() => _GalleryViewerDialogState();
}

class _GalleryViewerDialogState extends State<_GalleryViewerDialog> {
  late final PageController _pageController;
  late int _currentPage;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    if (page < 0 || page >= widget.imageUrls.length) return;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    // Only handle key-down (not key-up) to avoid double-firing.
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      _goTo(_currentPage - 1);
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _goTo(_currentPage + 1);
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final total = widget.imageUrls.length;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            // ── Image PageView ─────────────────────────────────────
            PageView.builder(
              controller: _pageController,
              itemCount: total,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => InteractiveViewer(
                minScale: 1,
                maxScale: 3,
                child: Center(
                  child: Image.network(
                    widget.imageUrls[i],
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.broken_image_outlined,
                      size: 64,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── Close button ───────────────────────────────────────
            Positioned(
              top: DittoSpacing.md,
              right: DittoSpacing.md,
              child: IconButton.filled(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.close),
              ),
            ),

            // ── Counter ────────────────────────────────────────────
            Positioned(
              top: DittoSpacing.md,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DittoSpacing.md,
                    vertical: DittoSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: DittoBorderRadius.mediumAll,
                  ),
                  child: Text(
                    '${_currentPage + 1} / $total',
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // ── Left arrow ─────────────────────────────────────────
            if (_currentPage > 0)
              Positioned(
                left: DittoSpacing.md,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton.filled(
                    onPressed: () => _goTo(_currentPage - 1),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.chevron_left),
                  ),
                ),
              ),

            // ── Right arrow ────────────────────────────────────────
            if (_currentPage < total - 1)
              Positioned(
                right: DittoSpacing.md,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton.filled(
                    onPressed: () => _goTo(_currentPage + 1),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
