import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Primary action buttons for an establishment page.
///
/// Renders as a [SliverToBoxAdapter] with a **Book** and **Favorite** button
/// side-by-side. Hidden entirely when [isPreview] is true.
class EstablishmentActionButtons extends StatelessWidget {
  const EstablishmentActionButtons({
    required this.data,
    required this.isPreview,
    super.key,
  });

  final EstablishmentData data;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    if (isPreview) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: DittoSpacing.base,
          right: DittoSpacing.base,
          top: DittoSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                // TODO: Wire to booking/favorites flow
                onPressed: null,
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text('Bestill time'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: DittoSpacing.sm),
            OutlinedButton.icon(
              // TODO: Wire to booking/favorites flow
              onPressed: null,
              icon: const Icon(Icons.favorite_border_rounded),
              label: const Text('Lagre'),
            ),
          ],
        ),
      ),
    );
  }
}
