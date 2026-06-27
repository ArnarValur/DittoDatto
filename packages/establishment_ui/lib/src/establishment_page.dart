import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import 'models/establishment_data.dart';
import 'sections/establishment_about_grid.dart';
import 'sections/establishment_action_buttons.dart';
import 'sections/establishment_contact_section.dart';
import 'sections/establishment_events_section.dart';
import 'sections/establishment_gallery_section.dart';
import 'sections/establishment_info_bar.dart';
import 'sections/establishment_section_shortcuts.dart';
import 'sections/establishment_services_section.dart';

/// The main establishment storefront page widget.
///
/// Renders a single vertically scrollable page with all establishment
/// sections stacked top-to-bottom. No horizontal tab transitions.
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
  bool _showBackToTop = false;

  // Section keys for anchor scrolling.
  final _servicesKey = GlobalKey();
  final _eventsKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _contactKey = GlobalKey();

  EstablishmentData get data => widget.data;
  bool get isPreview => widget.isPreview;

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

  void _onScroll() {
    final shouldShow = _scrollController.offset > 300;
    if (shouldShow != _showBackToTop) {
      setState(() => _showBackToTop = shouldShow);
    }
  }

  /// Builds the list of visible section entries for the shortcut chips.
  List<({String label, GlobalKey key})> _buildVisibleSections() {
    return [
      if (data.showServices) (label: 'Tilbud', key: _servicesKey),
      if (data.showEvents) (label: 'Arrangementer', key: _eventsKey),
      // Staff section — future, not wired yet.
      (label: 'Om oss', key: _aboutKey),
      (label: 'Kontakt', key: _contactKey),
    ];
  }

  /// Smoothly scrolls so that [key]'s widget is visible.
  void _scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
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

    return Scaffold(
      floatingActionButton: _showBackToTop
          ? FloatingActionButton.small(
              onPressed: _scrollToTop,
              child: const Icon(Icons.keyboard_arrow_up),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ── Draft banner ──────────────────────────────────────────
          if (isPreview && !data.isPublished)
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: DittoSpacing.base,
                  vertical: DittoSpacing.sm,
                ),
                color: colorScheme.tertiaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.visibility_off_outlined,
                      size: 16,
                      color: colorScheme.onTertiaryContainer,
                    ),
                    const SizedBox(width: DittoSpacing.xs),
                    Text(
                      'Utkast — ikke synlig for kunder',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Gallery ───────────────────────────────────────────────
          EstablishmentGallerySection(data: data),

          // ── Info bar ──────────────────────────────────────────────
          EstablishmentInfoBar(data: data),

          // ── Action buttons (hidden in preview) ────────────────────
          EstablishmentActionButtons(data: data, isPreview: isPreview),

          // ── Section shortcuts ─────────────────────────────────────
          EstablishmentSectionShortcuts(
            sections: _buildVisibleSections(),
            onTap: _scrollToSection,
          ),

          // ── Services section ──────────────────────────────────────
          if (data.showServices)
            SliverToBoxAdapter(
              key: _servicesKey,
              child: const _SectionAnchor(),
            ),
          if (data.showServices)
            const EstablishmentServicesSection(),

          // ── Events section ────────────────────────────────────────
          if (data.showEvents)
            SliverToBoxAdapter(
              key: _eventsKey,
              child: const _SectionAnchor(),
            ),
          if (data.showEvents)
            const EstablishmentEventsSection(),

          // ── About section ─────────────────────────────────────────
          SliverToBoxAdapter(
            key: _aboutKey,
            child: const _SectionAnchor(),
          ),
          EstablishmentAboutGrid(data: data),

          // Spacing between cards
          if (data.about != null && data.about!.trim().isNotEmpty)
            const SliverToBoxAdapter(
              child: SizedBox(height: DittoSpacing.sm),
            ),

          // ── Contact section ───────────────────────────────────────
          SliverToBoxAdapter(
            key: _contactKey,
            child: const _SectionAnchor(),
          ),
          EstablishmentContactSection(data: data),

          // ── Bottom padding ────────────────────────────────────────
          const SliverToBoxAdapter(
            child: SizedBox(height: DittoSpacing.xl),
          ),
        ],
      ),
    );
  }
}

/// Zero-height anchor widget used as a scroll target for section shortcuts.
class _SectionAnchor extends StatelessWidget {
  const _SectionAnchor();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
