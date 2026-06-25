import 'package:ditto_design/ditto_design.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'media_model.dart';
import 'media_providers.dart';

/// Standalone Media Gallery page for the Business Portal.
///
/// Features: responsive grid, upload (multi-file), delete, search, tag filter.
class MediaGalleryScreen extends ConsumerStatefulWidget {
  const MediaGalleryScreen({super.key});

  @override
  ConsumerState<MediaGalleryScreen> createState() => _MediaGalleryScreenState();
}

class _MediaGalleryScreenState extends ConsumerState<MediaGalleryScreen> {
  final _searchController = TextEditingController();
  String? _selectedTag;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtered media items based on search + tag.
  List<MediaItem> _filterItems(List<MediaItem> items) {
    var filtered = items;

    // Filter by tag
    if (_selectedTag != null) {
      filtered = filtered.where((m) => m.tags.contains(_selectedTag)).toList();
    }

    // Filter by search query
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((m) {
        return m.filename.toLowerCase().contains(query) ||
            (m.name?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }

  /// Extract all unique tags from media items.
  List<String> _extractTags(List<MediaItem> items) {
    final tags = <String>{};
    for (final item in items) {
      tags.addAll(item.tags);
    }
    return tags.toList()..sort();
  }

  /// Open file picker and upload selected files.
  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'svg'],
      allowMultiple: true,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    // Map MIME types from extensions
    String mimeForExtension(String ext) {
      return switch (ext.toLowerCase()) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'webp' => 'image/webp',
        'svg' => 'image/svg+xml',
        _ => 'image/jpeg',
      };
    }

    final files = result.files
        .where((f) => f.bytes != null && f.size > 0)
        .map((f) => (
              bytes: f.bytes!,
              filename: f.name,
              mimeType: mimeForExtension(f.extension ?? 'jpg'),
              size: f.size,
            ))
        .toList();

    if (files.isEmpty) return;

    if (files.length == 1) {
      final f = files.first;
      await ref.read(mediaProvider.notifier).uploadMedia(
            bytes: f.bytes,
            filename: f.filename,
            mimeType: f.mimeType,
            size: f.size,
          );
    } else {
      await ref.read(mediaProvider.notifier).uploadMultiple(files: files);
    }
  }

  /// Confirm and delete a media item.
  Future<void> _confirmDelete(MediaItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Slett media?'),
        content: Text(
          'Er du sikker på at du vil slette "${item.name ?? item.filename}"? '
          'Denne handlingen kan ikke angres.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Avbryt'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Slett'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success =
          await ref.read(mediaProvider.notifier).deleteMedia(item);
      if (mounted && !success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kunne ikke slette mediet')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncMedia = ref.watch(mediaProvider);
    final uploadState = ref.watch(mediaUploadStateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media'),
        actions: [
          // Upload button
          Padding(
            padding: const EdgeInsets.only(right: DittoSpacing.base),
            child: FilledButton.icon(
              onPressed: uploadState.isUploading ? null : _pickAndUpload,
              icon: const Icon(Icons.cloud_upload_rounded),
              label: const Text('Last opp'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Upload progress bar
          if (uploadState.isUploading) _UploadProgressBar(state: uploadState),

          // Upload error
          if (uploadState.error != null)
            _ErrorBanner(
              message: uploadState.error!,
              onDismiss: () {
                ref.read(mediaUploadStateProvider.notifier).reset();
              },
            ),

          // Search + tag filters
          asyncMedia.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (items) {
              final tags = _extractTags(items);
              if (items.isEmpty) return const SizedBox.shrink();

              return _FilterBar(
                searchController: _searchController,
                tags: tags,
                selectedTag: _selectedTag,
                onTagSelected: (tag) => setState(() {
                  _selectedTag = _selectedTag == tag ? null : tag;
                }),
                onSearchChanged: () => setState(() {}),
              );
            },
          ),

          // Gallery content
          Expanded(
            child: asyncMedia.when(
              loading: () => const _LoadingSkeleton(),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: DittoSpacing.base),
                    Text('Feil: $e'),
                    const SizedBox(height: DittoSpacing.base),
                    OutlinedButton(
                      onPressed: () =>
                          ref.read(mediaProvider.notifier).refresh(),
                      child: const Text('Prøv igjen'),
                    ),
                  ],
                ),
              ),
              data: (items) {
                final filtered = _filterItems(items);

                if (items.isEmpty) {
                  return const _EmptyState();
                }

                if (filtered.isEmpty) {
                  return const _EmptyFilterState();
                }

                return _MediaGrid(
                  items: filtered,
                  onDelete: _confirmDelete,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Upload Progress Bar ──────────────────────────────────────────────────────

class _UploadProgressBar extends StatelessWidget {
  const _UploadProgressBar({required this.state});

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

// ── Error Banner ─────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onDismiss});

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

// ── Filter Bar ───────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.searchController,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
    required this.onSearchChanged,
  });

  final TextEditingController searchController;
  final List<String> tags;
  final String? selectedTag;
  final ValueChanged<String> onTagSelected;
  final VoidCallback onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DittoSpacing.lg,
        DittoSpacing.base,
        DittoSpacing.lg,
        DittoSpacing.sm,
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: searchController,
            onChanged: (_) => onSearchChanged(),
            decoration: InputDecoration(
              hintText: 'Søk etter filnavn...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged();
                      },
                    )
                  : null,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: DittoBorderRadius.mediumAll,
              ),
            ),
          ),

          // Tag chips
          if (tags.isNotEmpty) ...[
            const SizedBox(height: DittoSpacing.sm),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: DittoSpacing.xs),
                itemBuilder: (context, index) {
                  final tag = tags[index];
                  final isSelected = selectedTag == tag;
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) => onTagSelected(tag),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Media Grid ───────────────────────────────────────────────────────────────

class _MediaGrid extends StatelessWidget {
  const _MediaGrid({required this.items, required this.onDelete});

  final List<MediaItem> items;
  final ValueChanged<MediaItem> onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive columns: 2 on mobile, 3 on tablet, 4 on desktop
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
            return _MediaGridTile(
              item: items[index],
              onDelete: () => onDelete(items[index]),
            );
          },
        );
      },
    );
  }
}

// ── Grid Tile ────────────────────────────────────────────────────────────────

class _MediaGridTile extends StatefulWidget {
  const _MediaGridTile({required this.item, required this.onDelete});

  final MediaItem item;
  final VoidCallback onDelete;

  @override
  State<_MediaGridTile> createState() => _MediaGridTileState();
}

class _MediaGridTileState extends State<_MediaGridTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: ClipRRect(
        borderRadius: DittoBorderRadius.mediumAll,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.network(
              widget.item.url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    size: 40,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),

            // Hover overlay
            if (_hovering) ...[
              // Gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),

              // Delete button
              Positioned(
                top: 8,
                right: 8,
                child: IconButton.filled(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  onPressed: widget.onDelete,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withValues(alpha: 0.9),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(32, 32),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              // File info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name ?? widget.item.filename,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.item.formattedSize,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tag chips at top-left
              if (widget.item.tags.isNotEmpty)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Wrap(
                    spacing: 4,
                    children: widget.item.tags.take(2).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Empty States ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFilterState extends StatelessWidget {
  const _EmptyFilterState();

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

// ── Loading Skeleton ─────────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

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
