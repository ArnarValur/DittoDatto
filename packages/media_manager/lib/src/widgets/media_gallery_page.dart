import 'dart:typed_data';

import 'package:ditto_design/ditto_design.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/media_category.dart';
import '../models/media_item.dart';
import '../upload/media_upload_state.dart';
import 'media_filter_bar.dart';
import 'media_support_widgets.dart';

/// Standalone Media Gallery page widget.
///
/// Displays a company's full media library with search, category/tag filters,
/// multi-file upload, and delete. Designed to be used as a routable page
/// in any consuming app (Business Portal, Admin Panel).
///
/// The gallery does NOT own state management — it receives data and callbacks
/// from the consuming app's providers. This keeps the package Riverpod-free
/// at the widget level.
class MediaGalleryPage extends StatefulWidget {
  const MediaGalleryPage({
    super.key,
    required this.items,
    required this.isLoading,
    required this.error,
    required this.uploadState,
    required this.onUpload,
    required this.onDelete,
    required this.onRefresh,
    required this.onDismissError,
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
  /// Receives the selected category and list of file data.
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

  @override
  State<MediaGalleryPage> createState() => _MediaGalleryPageState();
}

class _MediaGalleryPageState extends State<MediaGalleryPage> {
  final _searchController = TextEditingController();
  String? _selectedTag;
  MediaCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MediaItem> _filterItems(List<MediaItem> items) {
    var filtered = items;

    if (_selectedCategory != null) {
      filtered =
          filtered.where((m) => m.category == _selectedCategory).toList();
    }

    if (_selectedTag != null) {
      filtered =
          filtered.where((m) => m.tags.contains(_selectedTag)).toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((m) {
        return m.filename.toLowerCase().contains(query) ||
            (m.name?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }

  List<String> _extractTags(List<MediaItem> items) {
    final tags = <String>{};
    for (final item in items) {
      tags.addAll(item.tags);
    }
    return tags.toList()..sort();
  }

  Future<void> _pickAndUpload() async {
    final category = await _showCategoryPicker();
    if (category == null) return;

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
      final success = await widget.onDelete(item);
      if (mounted && !success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kunne ikke slette mediet')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = widget.items;
    final filtered = _filterItems(items);
    final tags = _extractTags(items);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: DittoSpacing.base),
            child: FilledButton.icon(
              onPressed:
                  widget.uploadState.isUploading ? null : _pickAndUpload,
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

          // Search + category + tag filters
          if (!widget.isLoading && widget.error == null && items.isNotEmpty)
            MediaFilterBar(
              searchController: _searchController,
              tags: tags,
              selectedTag: _selectedTag,
              selectedCategory: _selectedCategory,
              onTagSelected: (tag) => setState(() {
                _selectedTag = _selectedTag == tag ? null : tag;
              }),
              onCategorySelected: (cat) => setState(() {
                _selectedCategory =
                    _selectedCategory == cat ? null : cat;
              }),
              onSearchChanged: () => setState(() {}),
            ),

          // Gallery content
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
                    : items.isEmpty
                        ? const MediaEmptyState()
                        : filtered.isEmpty
                            ? const MediaEmptyFilterState()
                            : MediaGrid(
                                items: filtered,
                                onDelete: _confirmDelete,
                              ),
          ),
        ],
      ),
    );
  }
}
