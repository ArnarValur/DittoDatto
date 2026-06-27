import 'dart:typed_data';

import 'package:ditto_design/ditto_design.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/media_category.dart';
import '../models/media_item.dart';
import '../upload/media_upload_state.dart';
import 'media_category_row.dart';
import 'media_detail_modal.dart';
import 'media_support_widgets.dart';

/// V2 Media Gallery page with category rows layout.
///
/// Replaces the V1 filter-chip + flat-grid layout with a scrollable page
/// of horizontal category rows (Netflix-style). Each category gets its own
/// section header + horizontal scroll. Tapping a tile opens [MediaDetailModal].
///
/// Constructor API is intentionally similar to [MediaGalleryPage] for easy
/// feature-flag toggling. New callbacks: [onUpdateName], [onUpdateTags].
class MediaGalleryV2Page extends StatefulWidget {
  const MediaGalleryV2Page({
    super.key,
    required this.items,
    required this.isLoading,
    required this.error,
    required this.uploadState,
    required this.onUpload,
    required this.onDelete,
    required this.onRefresh,
    required this.onDismissError,
    required this.onUpdateName,
    required this.onUpdateTags,
  });

  /// All media items for the current company.
  final List<MediaItem> items;

  /// Whether the gallery is currently loading.
  final bool isLoading;

  /// Error message, if any.
  final String? error;

  /// Current upload state for progress bars.
  final MediaUploadState uploadState;

  /// Called when the user picks files to upload.
  final Future<void> Function({
    required MediaCategory category,
    required List<({Uint8List bytes, String filename, String mimeType, int size})>
        files,
  }) onUpload;

  /// Called when the user confirms deletion of an item.
  final Future<bool> Function(MediaItem item) onDelete;

  /// Called to refresh the media list.
  final VoidCallback onRefresh;

  /// Called to dismiss an upload error.
  final VoidCallback onDismissError;

  /// Called when the user updates the display name of an item.
  final Future<bool> Function(String id, String? name) onUpdateName;

  /// Called when the user updates the tags of an item.
  final Future<bool> Function(String id, List<String> tags) onUpdateTags;

  @override
  State<MediaGalleryV2Page> createState() => _MediaGalleryV2PageState();
}

class _MediaGalleryV2PageState extends State<MediaGalleryV2Page> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MediaItem> _filterBySearch(List<MediaItem> items) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return items;

    return items.where((m) {
      return m.filename.toLowerCase().contains(query) ||
          (m.name?.toLowerCase().contains(query) ?? false) ||
          m.tags.any((t) => t.toLowerCase().contains(query));
    }).toList();
  }

  Map<MediaCategory, List<MediaItem>> _groupByCategory(
      List<MediaItem> items) {
    final map = <MediaCategory, List<MediaItem>>{};
    for (final cat in MediaCategory.values) {
      map[cat] = items.where((m) => m.category == cat).toList();
    }
    return map;
  }

  Future<void> _pickAndUploadForCategory(MediaCategory category) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'svg'],
      allowMultiple: true,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

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

    await widget.onUpload(category: category, files: files);
  }

  Future<void> _pickAndUploadGlobal() async {
    final category = await _showCategoryPicker();
    if (category == null) return;
    await _pickAndUploadForCategory(category);
  }

  Future<MediaCategory?> _showCategoryPicker() async {
    return showDialog<MediaCategory>(
      context: context,
      builder: (context) {
        var selected = MediaCategory.general;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Velg kategori'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Hvilken type bilde laster du opp?'),
                  const SizedBox(height: DittoSpacing.base),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: MediaCategory.values.map((cat) {
                      final isSelected = selected == cat;
                      return ChoiceChip(
                        label: Text(cat.label),
                        selected: isSelected,
                        onSelected: (_) {
                          setDialogState(() => selected = cat);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Avbryt'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(selected),
                  child: const Text('Velg filer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openDetail(MediaItem item) {
    MediaDetailModal.show(
      context: context,
      item: item,
      onUpdateName: (name) => widget.onUpdateName(item.id, name),
      onUpdateTags: (tags) => widget.onUpdateTags(item.id, tags),
      onDelete: () => widget.onDelete(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = widget.items;
    final filtered = _filterBySearch(items);
    final grouped = _groupByCategory(filtered);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: DittoSpacing.base),
            child: FilledButton.icon(
              onPressed:
                  widget.uploadState.isUploading ? null : _pickAndUploadGlobal,
              icon: const Icon(Icons.cloud_upload_rounded),
              label: const Text('Last opp'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Upload progress bar
          if (widget.uploadState.isUploading)
            MediaUploadProgressBar(state: widget.uploadState),

          // Upload error
          if (widget.uploadState.error != null)
            MediaErrorBanner(
              message: widget.uploadState.error!,
              onDismiss: widget.onDismissError,
            ),

          // Search bar (always visible when there are items)
          if (!widget.isLoading && widget.error == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DittoSpacing.lg,
                DittoSpacing.base,
                DittoSpacing.lg,
                0,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Søk etter filnavn, navn eller tagg...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: DittoBorderRadius.mediumAll,
                  ),
                ),
              ),
            ),

          // Category rows
          Expanded(
            child: widget.isLoading
                ? const MediaLoadingSkeleton()
                : widget.error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline_rounded,
                                size: 48,
                                color: theme.colorScheme.error),
                            const SizedBox(height: DittoSpacing.base),
                            Text('Feil: ${widget.error}'),
                            const SizedBox(height: DittoSpacing.base),
                            OutlinedButton(
                              onPressed: widget.onRefresh,
                              child: const Text('Prøv igjen'),
                            ),
                          ],
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Adaptive tile height based on screen width
                          final tileHeight = constraints.maxWidth > 1200
                              ? 160.0
                              : constraints.maxWidth > 800
                                  ? 140.0
                                  : constraints.maxWidth > 600
                                      ? 120.0
                                      : 100.0;

                          // Check if search matches nothing
                          final hasAnyItems =
                              grouped.values.any((list) => list.isNotEmpty);

                          if (_searchController.text.isNotEmpty &&
                              !hasAnyItems) {
                            return const MediaEmptyFilterState();
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.only(
                              bottom: DittoSpacing.xl,
                            ),
                            itemCount: MediaCategory.values.length,
                            itemBuilder: (context, index) {
                              final cat = MediaCategory.values[index];
                              final catItems = grouped[cat] ?? [];

                              // When searching, hide empty categories
                              if (_searchController.text.isNotEmpty &&
                                  catItems.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return MediaCategoryRow(
                                category: cat,
                                items: catItems,
                                tileHeight: tileHeight,
                                onTap: _openDetail,
                                onDelete: (item) async {
                                  final confirmed =
                                      await _showDeleteConfirm(item);
                                  if (confirmed) await widget.onDelete(item);
                                },
                                onUpload: () =>
                                    _pickAndUploadForCategory(cat),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirm(MediaItem item) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Slett media?'),
            content: Text(
              'Er du sikker på at du vil slette '
              '"${item.name ?? item.filename}"? '
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
        ) ??
        false;
  }
}
