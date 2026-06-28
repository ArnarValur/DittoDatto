import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import 'models/establishment_data.dart';
import 'sections/establishment_about_grid.dart';
import 'sections/establishment_action_buttons.dart';
import 'sections/establishment_contact_section.dart';
import 'sections/establishment_events_section.dart';
import 'sections/establishment_gallery_section.dart';
import 'sections/establishment_info_bar.dart';
import 'sections/establishment_map_section.dart';

import 'sections/establishment_services_section.dart';

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
/// - Conditional sections controlled by [EstablishmentData] visibility flags
/// - Anchor shortcut chips for quick-scrolling to sections
/// - Back-to-top FAB after scrolling 300px
class EstablishmentPage extends StatefulWidget {
  const EstablishmentPage({
    required this.data,
    this.isPreview = false,
    super.key,
  });

  /// The establishment data to render.
  final EstablishmentData data;

  /// Whether this is being shown in preview mode (Business Portal).
  /// When true, hides action buttons and shows a draft indicator
  /// for unpublished establishments.
  final bool isPreview;

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

  void _onScroll() {
    final shouldShow = _scrollController.offset > 300;
    if (shouldShow != _showBackToTop) {
      setState(() => _showBackToTop = shouldShow);
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
    return Scaffold(
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
              // ── Draft banner ────────────────────────────────────────
              _buildDraftBanner(context),

              // ── Gallery ─────────────────────────────────────────────
              EstablishmentGallerySection(data: data, isWide: isWide),

              // ── Spacing between gallery and content on wide ──────────
              if (isWide)
                const SliverToBoxAdapter(
                  child: SizedBox(height: DittoSpacing.xl),
                ),

              // ── Constrained content area for wide viewports ─────────
              // Everything below the gallery gets a max-width constraint.
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
                      child: Column(
                        children: [
                          // ── Info bar ──────────────────────────────────
                          EstablishmentInfoBar(
                            data: data,
                            isWide: isWide,
                            isPreview: isPreview,
                          ),

                          // ── Action buttons (mobile only) ─────────────
                          // On wide viewports, buttons are inside the info bar.
                          if (!isWide)
                            EstablishmentActionButtons(
                              data: data,
                              isPreview: isPreview,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Services section ────────────────────────────────────
              if (data.showServices)
                _buildConstrainedSliver(
                  isWide: isWide,
                  sliver: const EstablishmentServicesSection(),
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

              // Spacing between sections
              const SliverToBoxAdapter(
                child: SizedBox(height: DittoSpacing.md),
              ),

              // ── Contact section ─────────────────────────────────────
              _buildConstrainedSliver(
                isWide: isWide,
                sliver: EstablishmentContactSection(
                  data: data,
                  isWide: isWide,
                ),
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

              // ── Bottom padding ──────────────────────────────────────
              const SliverToBoxAdapter(
                child: SizedBox(height: DittoSpacing.xl),
              ),
            ],
          );
        },
      ),
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
