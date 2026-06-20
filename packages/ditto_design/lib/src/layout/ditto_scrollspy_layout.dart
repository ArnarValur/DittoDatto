import 'package:flutter/material.dart';
import '../tokens/ditto_border_radius.dart';
import '../tokens/ditto_spacing.dart';
import 'ditto_window_class.dart';

/// A section configuration for [DittoScrollspyLayout].
class DittoScrollspySection {
  const DittoScrollspySection({
    required this.key,
    required this.label,
    required this.icon,
    required this.content,
  });

  /// The global key attached to the container of this section's card.
  final GlobalKey key;

  /// Display label shown in navigation links.
  final String label;

  /// Icon displayed next to the label.
  final IconData icon;

  /// Content/fields inside the section card.
  final Widget content;
}

/// A responsive scrollspy layout widget.
///
/// On wide viewports (≥600px): renders a vertical sidebar navigation link panel on the left,
/// a vertical divider, and a scrollable pane on the right containing section card widgets.
/// On compact viewports (<600px): renders a sticky top bar of ChoiceChip section navigation links
/// and a scrollable pane below it.
///
/// Tapping a section link smooth-scrolls the view to that section's card.
/// Scrolling the pane updates the active highlighted link.
class DittoScrollspyLayout extends StatefulWidget {
  const DittoScrollspyLayout({
    super.key,
    required this.sections,
    required this.scrollController,
  });

  /// List of sections to render.
  final List<DittoScrollspySection> sections;

  /// The scroll controller attached to the scroll view.
  final ScrollController scrollController;

  @override
  State<DittoScrollspyLayout> createState() => _DittoScrollspyLayoutState();
}

class _DittoScrollspyLayoutState extends State<DittoScrollspyLayout> {
  int _activeIndex = 0;
  bool _isProgrammaticScroll = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_isProgrammaticScroll) return;

    int newActiveIndex = _activeIndex;

    for (int i = 0; i < widget.sections.length; i++) {
      final key = widget.sections[i].key;
      final context = key.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox?;
      if (box == null) continue;

      // Get the position of the section relative to the screen.
      final position = box.localToGlobal(Offset.zero);
      final top = position.dy;

      // Active section = the one whose top has scrolled past the scroll view's
      // own top edge (+ a small comfort zone for the "snap" threshold).
      final scrollBox = widget.scrollController.position.context.storageContext
          .findRenderObject() as RenderBox?;
      final scrollTop = scrollBox?.localToGlobal(Offset.zero).dy ?? 0;
      if (top <= scrollTop + 48) {
        newActiveIndex = i;
      }
    }

    if (newActiveIndex != _activeIndex) {
      setState(() {
        _activeIndex = newActiveIndex;
      });
    }
  }

  void _scrollToSection(int index) async {
    final key = widget.sections[index].key;
    final context = key.currentContext;
    if (context == null) return;

    setState(() {
      _activeIndex = index;
      _isProgrammaticScroll = true;
    });

    // Smooth scroll to the section
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.0, // align top
    );

    // Brief delay to allow scroll physics to settle
    await Future.delayed(const Duration(milliseconds: 100));

    setState(() {
      _isProgrammaticScroll = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final windowClass = DittoWindowClass.of(constraints.maxWidth);
        final isDesktop = windowClass.showPermanentSidebar;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Desktop Scrollspy Sidebar
              SizedBox(
                width: 220,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    vertical: DittoSpacing.md,
                    horizontal: DittoSpacing.sm,
                  ),
                  itemCount: widget.sections.length,
                  itemBuilder: (context, index) {
                    final section = widget.sections[index];
                    final isActive = index == _activeIndex;
                    final primaryColor = Theme.of(context).colorScheme.primary;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Material(
                        color: isActive
                            ? primaryColor.withValues(alpha: 0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(DittoSpacing.sm),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(DittoSpacing.sm),
                          onTap: () => _scrollToSection(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DittoSpacing.md,
                              vertical: DittoSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  section.icon,
                                  size: 18,
                                  color: isActive
                                      ? primaryColor
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: DittoSpacing.md),
                                Expanded(
                                  child: Text(
                                    section.label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isActive
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isActive
                                          ? primaryColor
                                          : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              Expanded(
                child: _buildScrollView(),
              ),
            ],
          );
        }

        // Mobile Layout: Sticky horizontal chips + Scroll view
        return Column(
          children: [
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: DittoSpacing.sm,
                  vertical: DittoSpacing.xs,
                ),
                itemCount: widget.sections.length,
                itemBuilder: (context, index) {
                  final section = widget.sections[index];
                  final isActive = index == _activeIndex;
                  final primaryColor = Theme.of(context).colorScheme.primary;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(section.label),
                      selected: isActive,
                      onSelected: (_) => _scrollToSection(index),
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? primaryColor : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: _buildScrollView(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScrollView() {
    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(DittoSpacing.lg),
      itemCount: widget.sections.length,
      itemBuilder: (context, index) {
        final section = widget.sections[index];
        return Container(
          key: section.key,
          margin: const EdgeInsets.only(bottom: DittoSpacing.lg),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: DittoBorderRadius.mediumAll,
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(DittoSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        section.icon,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: DittoSpacing.sm),
                      Text(
                        section.label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const Divider(height: DittoSpacing.lg),
                  section.content,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
