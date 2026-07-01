import 'dart:typed_data';

import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/media_category.dart';
import '../models/media_item.dart';
import '../upload/media_upload_state.dart';
import 'media_picker_modal.dart';

/// Inline media picker widget for use in forms.
///
/// Shows current selection as thumbnails with a "Velg bilde" / "Endre" button
/// that opens [MediaPickerModal].
///
/// ## Usage
///
/// ```dart
/// MediaPickerWidget(
///   items: allMediaItems,          // company's full library
///   isLoading: false,
///   uploadState: MediaUploadState.idle,
///   onUpload: handleUpload,
///   maxSelection: 1,               // Logo field: single select
///   defaultCategory: MediaCategory.logo,
///   selectedItems: [currentLogo],
///   onChanged: (selected) {
///     setState(() => currentLogo = selected.firstOrNull);
///   },
/// )
/// ```
class MediaPickerWidget extends StatelessWidget {
  const MediaPickerWidget({
    super.key,
    required this.items,
    required this.isLoading,
    required this.uploadState,
    required this.onUpload,
    required this.onChanged,
    this.maxSelection,
    this.defaultCategory,
    this.selectedItems = const [],
    this.label,
    this.hint,
  });

  /// All media items for the current company (passed to the modal).
  final List<MediaItem> items;

  /// Whether media is currently loading.
  final bool isLoading;

  /// Current upload state.
  final MediaUploadState uploadState;

  /// Called when files are uploaded from within the modal.
  /// Must return the newly created [MediaItem]s.
  final Future<List<MediaItem>> Function({
    required MediaCategory category,
    required List<({Uint8List bytes, String filename, String mimeType, int size})>
        files,
  }) onUpload;

  /// Called when selection changes.
  final ValueChanged<List<MediaItem>> onChanged;

  /// Maximum number of items that can be selected.
  /// 1 = single-select (Logo, Cover). Null = unlimited (Gallery).
  final int? maxSelection;

  /// Default category filter when the modal opens.
  final MediaCategory? defaultCategory;

  /// Currently selected media items.
  final List<MediaItem> selectedItems;

  /// Optional label above the picker (e.g. "Logo", "Omslagsbilde").
  final String? label;

  /// Optional hint text when nothing is selected.
  final String? hint;

  Future<void> _openPicker(BuildContext context) async {
    final result = await MediaPickerModal.show(
      context: context,
      items: items,
      isLoading: isLoading,
      uploadState: uploadState,
      onUpload: onUpload,
      maxSelection: maxSelection,
      defaultCategory: defaultCategory,
      initialSelection: selectedItems,
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelection = selectedItems.isNotEmpty;
    final isSingle = maxSelection == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: DittoSpacing.xs),
        ],

        // Thumbnail display
        if (hasSelection)
          Wrap(
            spacing: DittoSpacing.sm,
            runSpacing: DittoSpacing.sm,
            children: selectedItems.map((item) {
              return ClipRRect(
                borderRadius: DittoBorderRadius.mediumAll,
                child: Stack(
                  children: [
                    Image.network(
                      item.url,
                      width: isSingle ? 120 : 80,
                      height: isSingle ? 120 : 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: isSingle ? 120 : 80,
                        height: isSingle ? 120 : 80,
                        color:
                            theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.broken_image_rounded),
                      ),
                    ),
                    // Remove button
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () {
                          final updated = selectedItems
                              .where((m) => m.id != item.id)
                              .toList();
                          onChanged(updated);
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

        const SizedBox(height: DittoSpacing.sm),

        // Action button
        OutlinedButton.icon(
          onPressed: () => _openPicker(context),
          icon: Icon(
            hasSelection
                ? Icons.swap_horiz_rounded
                : Icons.add_photo_alternate_rounded,
            size: 18,
          ),
          label: Text(
            hasSelection
                ? 'Endre'
                : hint ?? 'Velg bilde',
          ),
        ),
      ],
    );
  }
}
