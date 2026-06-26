import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';


import '../models/media_item.dart';
import '../upload/media_upload_state.dart';
import 'media_grid_tile.dart';

/// Upload progress bar showing current file name and progress.
class MediaUploadProgressBar extends StatelessWidget {
  const MediaUploadProgressBar({super.key, required this.state});

  final MediaUploadState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.lg,
        vertical: DittoSpacing.sm,
      ),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: DittoSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.totalFiles > 1
                      ? 'Laster opp ${state.currentIndex}/${state.totalFiles}: ${state.currentFileName ?? ""}'
                      : 'Laster opp: ${state.currentFileName ?? ""}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: state.progress),
              ],
            ),
          ),
          const SizedBox(width: DittoSpacing.base),
          Text(
            '${(state.progress * 100).toInt()}%',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error banner for media upload failures.
class MediaErrorBanner extends StatelessWidget {
  const MediaErrorBanner({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      content: Text(message),
      backgroundColor: Colors.red.withValues(alpha: 0.1),
      leading: const Icon(Icons.error_outline_rounded, color: Colors.red),
      actions: [
        TextButton(onPressed: onDismiss, child: const Text('Lukk')),
      ],
    );
  }
}

/// Empty state shown when no media items exist.
class MediaEmptyState extends StatelessWidget {
  const MediaEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: DittoSpacing.base),
          Text(
            'Ingen medier ennå',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DittoSpacing.sm),
          Text(
            'Last opp bilder for å komme i gang',
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state shown when filters match nothing.
class MediaEmptyFilterState extends StatelessWidget {
  const MediaEmptyFilterState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: DittoSpacing.base),
          Text(
            'Ingen treff',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading skeleton grid for the gallery.
class MediaLoadingSkeleton extends StatelessWidget {
  const MediaLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: DittoSpacing.base,
        crossAxisSpacing: DittoSpacing.base,
      ),
      itemCount: 9,
      itemBuilder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.4),
            borderRadius: DittoBorderRadius.mediumAll,
          ),
        );
      },
    );
  }
}

/// Responsive media grid displaying [MediaItem] tiles.
class MediaGrid extends StatelessWidget {
  const MediaGrid({
    super.key,
    required this.items,
    required this.onDelete,
    this.onTap,
    this.selectedIds = const {},
    this.selectable = false,
  });

  final List<MediaItem> items;
  final ValueChanged<MediaItem> onDelete;

  /// Called when a tile is tapped (picker mode).
  final ValueChanged<MediaItem>? onTap;

  /// IDs of currently selected items (picker mode).
  final Set<String> selectedIds;

  /// Whether selection UI should be shown (picker mode).
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
                ? 3
                : 2;

        return GridView.builder(
          padding: const EdgeInsets.all(DittoSpacing.lg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: DittoSpacing.base,
            crossAxisSpacing: DittoSpacing.base,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return MediaGridTile(
              item: item,
              onDelete: () => onDelete(item),
              onTap: onTap != null ? () => onTap!(item) : null,
              selected: selectedIds.contains(item.id),
              selectable: selectable,
            );
          },
        );
      },
    );
  }
}
