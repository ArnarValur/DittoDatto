import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// Primary action buttons for an establishment page (mobile layout).
///
/// Renders a **Book** and **Favorite** button side-by-side.
/// Hidden entirely when [isPreview] is true.
///
/// On wide viewports, the parent [EstablishmentPage] does not render
/// this widget — action buttons are merged into [EstablishmentInfoBar]
/// instead.
class EstablishmentActionButtons extends StatelessWidget {
  const EstablishmentActionButtons({
    required this.data,
    required this.isPreview,
    this.onFavoriteTapped,
    this.isFavorited = false,
    super.key,
  });

  final EstablishmentData data;
  final bool isPreview;

  /// Called when the user taps the Lagre (favorite) button.
  final VoidCallback? onFavoriteTapped;

  /// Whether the establishment is currently favorited.
  final bool isFavorited;

  @override
  Widget build(BuildContext context) {
    // Note: buttons are shown even in preview so the business owner
    // can see the full customer-facing layout.

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
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
            onPressed: isPreview ? null : onFavoriteTapped,
            icon: Icon(
              isFavorited
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorited
                  ? Theme.of(context).colorScheme.error
                  : null,
            ),
            label: const Text('Lagre'),
          ),
        ],
      ),
    );
  }
}
