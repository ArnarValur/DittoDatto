import 'dart:typed_data';

import 'package:ditto_design/ditto_design.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/media_category.dart';
import '../models/media_item.dart';
import '../upload/media_upload_state.dart';
import 'media_support_widgets.dart';

/// Modal dialog for browsing and selecting from the company's media library.
///
/// Opens as a dialog overlay. Shows a grid of existing media items with
/// category filtering, search, and upload-from-within capability.
///
/// [onUpload] must return the newly created [MediaItem]s so the modal can
/// display them immediately (the dialog is a separate route and won't
/// receive Riverpod state updates from the parent widget tree).
///
/// Returns the list of selected [MediaItem]s when confirmed.
class MediaPickerModal extends StatefulWidget {
  const MediaPickerModal({
    super.key,
    required this.items,
    required this.isLoading,
    required this.uploadState,
    required this.onUpload,
    this.maxSelection,
    this.defaultCategory,
    this.initialSelection = const [],
  });

  /// All media items for the current company.
  final List<MediaItem> items;

  /// Whether media is currently loading.
  final bool isLoading;

  /// Current upload state for progress bar.
  final MediaUploadState uploadState;

  /// Called when the user uploads files from within the modal.
  ///
  /// Must return the newly created [MediaItem]s so the modal can add them
  /// to its local items list for immediate display.
  final Future<List<MediaItem>> Function({
    required MediaCategory category,
    required List<({Uint8List bytes, String filename, String mimeType, int size})>
        files,
  }) onUpload;

  /// Maximum number of items that can be selected.
  /// Null = unlimited.
  final int? maxSelection;

  /// Default category filter when the modal opens.
  final MediaCategory? defaultCategory;

  /// Items already selected (for pre-populating in edit scenarios).
  final List<MediaItem> initialSelection;

  /// Show the modal and return selected items (or null if cancelled).
  static Future<List<MediaItem>?> show({
    required BuildContext context,
    required List<MediaItem> items,
    required bool isLoading,
    required MediaUploadState uploadState,
    required Future<List<MediaItem>> Function({
      required MediaCategory category,
      required List<({Uint8List bytes, String filename, String mimeType, int size})>
          files,
    }) onUpload,
    int? maxSelection,
    MediaCategory? defaultCategory,
    List<MediaItem> initialSelection = const [],
  }) {
    return showDialog<List<MediaItem>>(
      context: context,
      builder: (context) => MediaPickerModal(
        items: items,
        isLoading: isLoading,
        uploadState: uploadState,
        onUpload: onUpload,
        maxSelection: maxSelection,
        defaultCategory: defaultCategory,
        initialSelection: initialSelection,
      ),
    );
  }

  @override
  State<MediaPickerModal> createState() => _MediaPickerModalState();
}

class _MediaPickerModalState extends State<MediaPickerModal> {
  final _searchController = TextEditingController();
  late MediaCategory? _selectedCategory;
  late Set<String> _selectedIds;

  /// Local copy of items that includes any newly uploaded ones.
  /// The dialog is a separate route and won't receive Riverpod rebuilds.
  late List<MediaItem> _localItems;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.defaultCategory;
    _selectedIds = widget.initialSelection.map((m) => m.id).toSet();
    _localItems = List.of(widget.items);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MediaItem> get _filteredItems {
    var items = _localItems;

    if (_selectedCategory != null) {
      items = items.where((m) => m.category == _selectedCategory).toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      items = items.where((m) {
        return m.filename.toLowerCase().contains(query) ||
            (m.name?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return items;
  }

  List<MediaItem> get _selectedItems {
    return _localItems.where((m) => _selectedIds.contains(m.id)).toList();
  }

  bool get _canSelectMore {
    return widget.maxSelection == null ||
        _selectedIds.length < widget.maxSelection!;
  }

  void _toggleSelection(MediaItem item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
      } else if (_canSelectMore) {
        _selectedIds.add(item.id);
      }
    });
  }

  String mimeForExtension(String ext) {
    return switch (ext.toLowerCase()) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'svg' => 'image/svg+xml',
      _ => 'image/jpeg',
    };
  }

  Future<void> _uploadFromModal() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'svg'],
      allowMultiple: widget.maxSelection != 1,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

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

    final category = _selectedCategory ?? MediaCategory.general;
    final newItems = await widget.onUpload(category: category, files: files);

    // Merge newly uploaded items into local list so they appear immediately.
    if (newItems.isNotEmpty) {
      setState(() {
        _localItems = [...newItems, ..._localItems];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredItems;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DittoSpacing.lg,
                DittoSpacing.lg,
                DittoSpacing.base,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.maxSelection == 1
                          ? 'Velg bilde'
                          : 'Velg bilder',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  if (_selectedIds.isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.only(right: DittoSpacing.sm),
                      child: Text(
                        widget.maxSelection != null
                            ? '${_selectedIds.length}/${widget.maxSelection} valgt'
                            : '${_selectedIds.length} valgt',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),

            // Search + category filter
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DittoSpacing.lg,
                vertical: DittoSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Søk...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: DittoBorderRadius.mediumAll,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: DittoSpacing.sm),
                  OutlinedButton.icon(
                    onPressed:
                        widget.uploadState.isUploading ? null : _uploadFromModal,
                    icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                    label: const Text('Last opp'),
                  ),
                ],
              ),
            ),

            // Category chips
            SizedBox(
              height: 36,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DittoSpacing.lg),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MediaCategory.values.length + 1,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: DittoSpacing.xs),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return FilterChip(
                        label: const Text('Alle'),
                        selected: _selectedCategory == null,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = null),
                      );
                    }
                    final cat = MediaCategory.values[index - 1];
                    return FilterChip(
                      label: Text(cat.label),
                      selected: _selectedCategory == cat,
                      onSelected: (_) => setState(() {
                        _selectedCategory =
                            _selectedCategory == cat ? null : cat;
                      }),
                    );
                  },
                ),
              ),
            ),

            // Upload progress
            if (widget.uploadState.isUploading)
              Padding(
                padding: const EdgeInsets.only(top: DittoSpacing.sm),
                child: MediaUploadProgressBar(state: widget.uploadState),
              ),

            const SizedBox(height: DittoSpacing.sm),

            // Grid
            Expanded(
              child: widget.isLoading
                  ? const MediaLoadingSkeleton()
                  : filtered.isEmpty
                      ? const MediaEmptyFilterState()
                      : MediaGrid(
                          items: filtered,
                          onDelete: (_) {},
                          onTap: _toggleSelection,
                          selectedIds: _selectedIds,
                          selectable: true,
                        ),
            ),

            // Action bar
            Padding(
              padding: const EdgeInsets.all(DittoSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Avbryt'),
                  ),
                  const SizedBox(width: DittoSpacing.sm),
                  FilledButton(
                    onPressed: _selectedIds.isEmpty
                        ? null
                        : () =>
                            Navigator.of(context).pop(_selectedItems),
                    child: Text(
                      _selectedIds.isEmpty
                          ? 'Velg'
                          : 'Velg (${_selectedIds.length})',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
