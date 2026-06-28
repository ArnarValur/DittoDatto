import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

/// Horizontal shortcut bar for quick-scrolling to page sections.
///
/// Renders a scrollable row of [ActionChip] widgets. Each chip corresponds
/// to a visible section on the page. Returns [SizedBox.shrink] when
/// [sections] is empty.
///
/// Note: This is a regular (non-sliver) widget. The parent
/// [EstablishmentPage] wraps it in a [SliverToBoxAdapter].
class EstablishmentSectionShortcuts extends StatelessWidget {
  const EstablishmentSectionShortcuts({
    required this.sections,
    required this.onTap,
    super.key,
  });

  /// List of (label, key) pairs for visible sections.
  final List<({String label, GlobalKey key})> sections;

  /// Callback when a shortcut chip is tapped.
  final void Function(GlobalKey key) onTap;

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DittoSpacing.base),
        child: Row(
          children: [
            for (final section in sections) ...[
              if (section != sections.first)
                const SizedBox(width: DittoSpacing.sm),
              ActionChip(
                label: Text(section.label),
                onPressed: () => onTap(section.key),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
