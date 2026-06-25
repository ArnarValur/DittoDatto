import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

/// Placeholder for the establishment image gallery.
///
/// Displays a styled empty state until image management is available.
/// Will be replaced with a real gallery (bento/showcase/spotlight layouts)
/// when the media manager feature lands.
class EstablishmentGalleryPlaceholder extends StatelessWidget {
  const EstablishmentGalleryPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Container(
        height: 220,
        margin: const EdgeInsets.all(DittoSpacing.base),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: DittoBorderRadius.mediumAll,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 48,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: DittoSpacing.sm),
              Text(
                'Bilder kommer snart',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
