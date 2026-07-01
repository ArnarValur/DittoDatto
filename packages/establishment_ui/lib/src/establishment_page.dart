
import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/establishment_data.dart';
import 'sections/establishment_about_grid.dart';
import 'sections/establishment_events_section.dart';
import 'sections/establishment_featured_section.dart';
import 'sections/establishment_gallery_section.dart';
import 'sections/establishment_hours_section.dart';
import 'sections/establishment_info_bar.dart';
import 'sections/establishment_map_section.dart';

/// The main establishment storefront page widget.
///
/// Renders a single vertically scrollable page with all establishment
/// sections stacked top-to-bottom. No horizontal tab transitions.
///
/// Responsive layout via [DittoWindowClass]:
/// - **compact** (< 600px): Mobile — single column, full-bleed
/// - **medium+** (≥ 600px): Tablet/Desktop — max-width 1100px, centered,
///   bento gallery, horizontal info bar, two-column contact
///
/// Consumed by:
/// - **Business Portal** — preview mode (set [isPreview] to `true`)
/// - **Public Marketplace** — customer-facing page
///
/// Features:
/// - Collapsing SliverAppBar with transparent → solid scroll transition
/// - Visible system status bar with appropriate icon brightness
/// - Conditional sections controlled by [EstablishmentData] visibility flags
/// - Back-to-top FAB after scrolling 300px
class EstablishmentPage extends StatefulWidget {
  const EstablishmentPage({
    required this.data,
    this.isPreview = false,
    this.onBack,
    this.onProfile,
    this.onRefresh,
    this.onThemeToggle,
    this.isDarkMode = false,
    this.onFavoriteTapped,
    this.isFavorited = false,
    this.onBookTapped,
    super.key,
  });

  /// The establishment data to render.
  final EstablishmentData data;

  /// Whether this is being shown in preview mode (Business Portal).
  /// When true, hides action buttons and shows a draft indicator
  /// for unpublished establishments.
  final bool isPreview;

  /// Called when the back button is tapped.
  final VoidCallback? onBack;

  /// Called when the profile/avatar icon is tapped.
  final VoidCallback? onProfile;

  /// Called when the refresh action is triggered (debug only).
  final VoidCallback? onRefresh;

  /// Called when the theme toggle button is tapped.
  /// When `null`, the toggle button is hidden.
  final VoidCallback? onThemeToggle;

  /// Whether the current theme is dark mode.
  /// Controls which icon the toggle button shows.
  final bool isDarkMode;

  /// Called when the user taps the Lagre (favorite) button.
  final VoidCallback? onFavoriteTapped;

  /// Whether the establishment is currently favorited by the user.
  final bool isFavorited;

  /// Called when the user taps the "Bestill time" (Book) button.
  final VoidCallback? onBookTapped;

  @override
  State<EstablishmentPage> createState() => _EstablishmentPageState();
}

class _EstablishmentPageState extends State<EstablishmentPage> {
  final _scrollController = ScrollController();

  EstablishmentData get data => widget.data;
  bool get isPreview => widget.isPreview;

  /// Maximum content width for tablet/desktop viewports.
  static const _maxContentWidth = 1200.0;

  /// Horizontal padding inside constrained area on wide viewports.
  static const _widePaddingH = DittoSpacing.lg;

  /// Height of the mobile cover image.
  static const _coverHeight = 300.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool _showBackToTop = false;

  /// Tracks how far the user has scrolled past the cover image.
  /// 0.0 = at top (cover fully visible), 1.0 = scrolled past cover.
  double _scrollProgress = 0.0;

  void _onScroll() {
    final offset = _scrollController.offset;
    final shouldShow = offset > 300;
    if (shouldShow != _showBackToTop) {
      setState(() => _showBackToTop = shouldShow);
    }

    // Calculate scroll progress for app bar transition.
    final progress = (offset / (_coverHeight - kToolbarHeight)).clamp(0.0, 1.0);
    if ((progress - _scrollProgress).abs() > 0.01) {
      setState(() => _scrollProgress = progress);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine status bar brightness based on scroll position.
    // Over the cover image: light icons. After scrolling: dark icons.
    final statusBarBrightness = _scrollProgress > 0.5
        ? Brightness.dark
        : Brightness.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: statusBarBrightness,
        statusBarBrightness: statusBarBrightness == Brightness.dark
            ? Brightness.light  // iOS: light status bar = dark icons
            : Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: _showBackToTop
            ? FloatingActionButton.small(
                onPressed: _scrollToTop,
                child: const Icon(Icons.keyboard_arrow_up),
              )
            : null,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final windowClass = DittoWindowClass.of(constraints.maxWidth);
            final isWide = windowClass != DittoWindowClass.compact;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // ── Collapsing app bar ─────────────────────────────────
                _buildSliverAppBar(theme, colorScheme, isWide),

                // ── Draft banner ────────────────────────────────────────
                _buildDraftBanner(context),

                // ── Gallery (wide only — mobile uses SliverAppBar) ──────
                if (isWide)
                  EstablishmentGallerySection(data: data, isWide: isWide),

                // ── Spacing between gallery and content on wide ──────────
                if (isWide)
                  const SliverToBoxAdapter(
                    child: SizedBox(height: DittoSpacing.xl),
                  ),

                // ── Info bar + action buttons ──────────────────────────
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: isWide
                          ? const BoxConstraints(maxWidth: _maxContentWidth)
                          : const BoxConstraints(),
                      child: Padding(
                        padding: isWide
                            ? const EdgeInsets.symmetric(
                                horizontal: _widePaddingH)
                            : EdgeInsets.zero,
                        child: EstablishmentInfoBar(
                          data: data,
                          isWide: isWide,
                          isPreview: isPreview,
                          onFavoriteTapped: widget.onFavoriteTapped,
                          isFavorited: widget.isFavorited,
                          onBookTapped: widget.onBookTapped,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Featured services section ──────────────────────────
                if (data.showServices)
                  _buildConstrainedSliver(
                    isWide: isWide,
                    sliver: EstablishmentFeaturedSection(data: data),
                  ),

                // ── Events section ──────────────────────────────────────
                if (data.showEvents)
                  _buildConstrainedSliver(
                    isWide: isWide,
                    sliver: const EstablishmentEventsSection(),
                  ),

                // ── About section ───────────────────────────────────────
                _buildConstrainedSliver(
                  isWide: isWide,
                  sliver: EstablishmentAboutGrid(data: data),
                ),

                // ── Map section ──────────────────────────────────────────
                if (data.hasLocation)
                  _buildConstrainedSliver(
                    isWide: isWide,
                    sliver: EstablishmentMapSection(
                      data: data,
                      isWide: isWide,
                    ),
                  ),

                // ── Opening hours section ────────────────────────────────
                if (data.hasOpeningSchedule)
                  _buildConstrainedSliver(
                    isWide: isWide,
                    sliver: EstablishmentHoursSection(data: data),
                  ),

                // ── Bottom padding (clear the glass bottom nav) ─────
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: DittoSpacing.xl +
                        MediaQuery.paddingOf(context).bottom +
                        48, // nav bar height
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Builds the collapsing SliverAppBar with transparent → solid transition.
  ///
  /// Over the cover: transparent with semi-transparent icon backgrounds.
  /// Scrolled past cover: solid surface with establishment name.
  Widget _buildSliverAppBar(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isWide,
  ) {
    final appBarColor = Color.lerp(
      Colors.transparent,
      colorScheme.surface,
      _scrollProgress,
    )!;

    final iconBgColor = Color.lerp(
      Colors.black38,
      Colors.transparent,
      _scrollProgress,
    )!;

    final titleOpacity = (_scrollProgress * 2 - 1).clamp(0.0, 1.0);

    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: isWide ? 0 : _coverHeight,
      backgroundColor: appBarColor,
      surfaceTintColor: Colors.transparent,
      elevation: _scrollProgress > 0.9 ? 1 : 0,
      leading: _buildAppBarIcon(
        icon: Icons.arrow_back_rounded,
        onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
        iconBgColor: iconBgColor,
        colorScheme: colorScheme,
      ),
      actions: [
        if (widget.onRefresh != null)
          _buildAppBarIcon(
            icon: Icons.refresh_rounded,
            onPressed: widget.onRefresh!,
            iconBgColor: iconBgColor,
            colorScheme: colorScheme,
          ),
        if (widget.onThemeToggle != null)
          _buildAppBarIcon(
            icon: widget.isDarkMode
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            onPressed: widget.onThemeToggle!,
            iconBgColor: iconBgColor,
            colorScheme: colorScheme,
          ),
        _buildAppBarIcon(
          icon: Icons.person_outline_rounded,
          onPressed: widget.onProfile ?? () {},
          iconBgColor: iconBgColor,
          colorScheme: colorScheme,
        ),
        const SizedBox(width: DittoSpacing.xs),
      ],
      title: Opacity(
        opacity: titleOpacity,
        child: Text(
          data.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      flexibleSpace: isWide
          ? null
          : FlexibleSpaceBar(
              background: _buildCoverForAppBar(colorScheme),
            ),
    );
  }

  /// Builds an icon button for the app bar with a semi-transparent
  /// circular background for contrast over cover images.
  Widget _buildAppBarIcon({
    required IconData icon,
    required VoidCallback onPressed,
    required Color iconBgColor,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: iconBgColor,
        ),
        child: IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          color: _scrollProgress > 0.5
              ? colorScheme.onSurface
              : Colors.white,
          iconSize: 22,
        ),
      ),
    );
  }

  /// Builds the cover image for the SliverAppBar's FlexibleSpaceBar.
  /// This replaces the old EstablishmentGallerySection for mobile.
  Widget _buildCoverForAppBar(ColorScheme colorScheme) {
    if (!data.hasMedia) {
      return Container(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        child: Center(
          child: Icon(
            Icons.photo_library_outlined,
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    final coverUrl = data.coverUrl ?? data.galleryUrls.first;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          coverUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        // Gradient overlay for status bar readability.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [Colors.black45, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the draft banner (shown only in preview mode for unpublished).
  Widget _buildDraftBanner(BuildContext context) {
    if (!isPreview || data.isPublished) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: DittoSpacing.base,
          vertical: DittoSpacing.sm,
        ),
        color: colorScheme.tertiaryContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_off_outlined,
              size: 16,
              color: colorScheme.onTertiaryContainer,
            ),
            const SizedBox(width: DittoSpacing.xs),
            Flexible(
              child: Text(
                'Utkast — ikke synlig for kunder',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Wraps a [SliverToBoxAdapter] sliver's child in a max-width constraint.
  /// For slivers that are already SliverToBoxAdapter (about, contact, etc.),
  /// this re-wraps them with centering/constraint logic.
  Widget _buildConstrainedSliver({
    required bool isWide,
    required Widget sliver,
  }) {
    if (!isWide) return sliver;

    // Wrap the sliver content in a center + constrained box.
    // We achieve this by wrapping in SliverConstrainedCrossAxis when
    // available, or using a SliverToBoxAdapter wrapper pattern.
    return _ConstrainedSliverWrapper(
      maxWidth: _maxContentWidth,
      innerPadding: _widePaddingH,
      child: sliver,
    );
  }
}

/// Wraps a child sliver to constrain its cross-axis width and center it.
///
/// Uses [SliverCrossAxisGroup] is not ideal here — instead we wrap the
/// sliver's output by embedding it in a center-constrained layout.
class _ConstrainedSliverWrapper extends StatelessWidget {
  const _ConstrainedSliverWrapper({
    required this.maxWidth,
    required this.child,
    this.innerPadding = 0,
  });

  final double maxWidth;
  final Widget child;

  /// Extra horizontal padding applied inside the max-width constraint.
  final double innerPadding;

  @override
  Widget build(BuildContext context) {
    // SliverCrossAxisExpanded/Group is complex; simpler approach:
    // use SliverLayoutBuilder to detect available width and apply padding.
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final crossAxisExtent = constraints.crossAxisExtent;
        if (crossAxisExtent <= maxWidth) {
          // Still apply inner padding even when not centering.
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: innerPadding),
            sliver: child,
          );
        }

        final outerPadding = (crossAxisExtent - maxWidth) / 2;
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: outerPadding + innerPadding),
          sliver: child,
        );
      },
    );
  }
}
