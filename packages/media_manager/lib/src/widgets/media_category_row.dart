import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/media_category.dart';
import '../models/media_item.dart';
import 'media_grid_tile.dart';

/// A horizontal-scroll row for a single media category.
///
/// Shows a section header (category label + count + add button),
/// then a horizontal list of [MediaGridTile] items. When the category
/// is empty, displays a dashed upload placeholder.
class MediaCategoryRow extends StatelessWidget {
  const MediaCategoryRow({
    super.key,
    required this.category,
    required this.items,
    required this.onTap,
    required this.onDelete,
    required this.onUpload,
    required this.tileHeight,
  });

  /// The category this row represents.
  final MediaCategory category;

  /// Items in this category (pre-filtered by caller).
  final List<MediaItem> items;

  /// Called when a tile is tapped (opens detail modal).
  final ValueChanged<MediaItem> onTap;

  /// Called when delete is triggered on a tile.
  final ValueChanged<MediaItem> onDelete;

  /// Called when the user wants to upload to this specific category.
  final VoidCallback onUpload;

  /// Height of each tile (adaptive, set by parent based on screen width).
  final double tileHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(
            DittoSpacing.lg,
            DittoSpacing.base,
            DittoSpacing.lg,
            DittoSpacing.sm,
          ),
          child: Row(
            children: [
              Text(
                category.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (items.isNotEmpty) ...[
                const SizedBox(width: DittoSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${items.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add_photo_alternate_outlined),
                tooltip: 'Last opp ${category.label.toLowerCase()}',
                onPressed: onUpload,
                style: IconButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        // Horizontal scroll of items or empty placeholder
        SizedBox(
          height: tileHeight,
          child: items.isEmpty
              ? _EmptyRowPlaceholder(
                  category: category,
                  onUpload: onUpload,
                  height: tileHeight,
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DittoSpacing.lg,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: DittoSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return SizedBox(
                      width: tileHeight, // square tiles
                      child: MediaGridTile(
                        item: item,
                        onDelete: () => onDelete(item),
                        onTap: () => onTap(item),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Dashed-border placeholder for empty category rows.
class _EmptyRowPlaceholder extends StatelessWidget {
  const _EmptyRowPlaceholder({
    required this.category,
    required this.onUpload,
    required this.height,
  });

  final MediaCategory category;
  final VoidCallback onUpload;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DittoSpacing.lg),
      child: InkWell(
        borderRadius: DittoBorderRadius.mediumAll,
        onTap: onUpload,
        child: Container(
          width: height * 2,
          height: height,
          decoration: BoxDecoration(
            borderRadius: DittoBorderRadius.mediumAll,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1.5,
              // Flutter doesn't support dashed borders natively,
              // so we use a lighter outline color to suggest "placeholder".
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 32,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: DittoSpacing.xs),
              Text(
                'Last opp ${category.label.toLowerCase()}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
