import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/media_category.dart';
import '../models/media_item.dart';

/// Full-screen modal dialog for viewing and editing a media item.
///
/// Shows a large preview, editable name, tag management, file info,
/// and a delete button. All changes are persisted via callbacks.
class MediaDetailModal extends StatefulWidget {
  const MediaDetailModal({
    super.key,
    required this.item,
    required this.onUpdateName,
    required this.onUpdateTags,
    required this.onDelete,
  });

  final MediaItem item;

  /// Called when the user edits the display name.
  final Future<bool> Function(String? name) onUpdateName;

  /// Called when the user adds/removes tags.
  final Future<bool> Function(List<String> tags) onUpdateTags;

  /// Called when the user confirms deletion.
  final Future<bool> Function() onDelete;

  /// Show the detail modal as a dialog.
  static Future<void> show({
    required BuildContext context,
    required MediaItem item,
    required Future<bool> Function(String? name) onUpdateName,
    required Future<bool> Function(List<String> tags) onUpdateTags,
    required Future<bool> Function() onDelete,
  }) {
    return showDialog(
      context: context,
      builder: (_) => MediaDetailModal(
        item: item,
        onUpdateName: onUpdateName,
        onUpdateTags: onUpdateTags,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<MediaDetailModal> createState() => _MediaDetailModalState();
}

class _MediaDetailModalState extends State<MediaDetailModal> {
  late final TextEditingController _nameController;
  late final TextEditingController _tagController;
  late List<String> _tags;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.item.name ?? '');
    _tagController = TextEditingController();
    _tags = List.of(widget.item.tags);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final name =
        _nameController.text.trim().isEmpty ? null : _nameController.text.trim();
    if (name == widget.item.name) return;

    setState(() => _saving = true);
    await widget.onUpdateName(name);
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _addTag() async {
    final tag = _tagController.text.trim().toLowerCase();
    if (tag.isEmpty || _tags.contains(tag)) return;

    setState(() {
      _tags.add(tag);
      _tagController.clear();
    });
    await widget.onUpdateTags(List.of(_tags));
  }

  Future<void> _removeTag(String tag) async {
    setState(() => _tags.remove(tag));
    await widget.onUpdateTags(List.of(_tags));
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Slett media?'),
        content: Text(
          'Er du sikker på at du vil slette '
          '"${widget.item.name ?? widget.item.filename}"? '
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

    if (confirmed == true && mounted) {
      final success = await widget.onDelete();
      if (success && mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 800 ? 640.0 : screenWidth * 0.9;

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: ClipRRect(
          borderRadius: DittoBorderRadius.largeAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image preview
              Flexible(
                child: Stack(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.network(
                          item.url,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => Container(
                            height: 200,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                size: 64,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 200,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Close button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton.filled(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Colors.black.withValues(alpha: 0.5),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                    // Category badge
                    if (item.category != MediaCategory.general)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.category.label,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Metadata editing area
              Padding(
                padding: const EdgeInsets.all(DittoSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name field
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Visningsnavn',
                        hintText: item.filename,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: DittoBorderRadius.mediumAll,
                        ),
                        suffixIcon: _saving
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      onSubmitted: (_) => _saveName(),
                      onTapOutside: (_) => _saveName(),
                    ),

                    const SizedBox(height: DittoSpacing.base),

                    // Tags
                    Text(
                      'Tagger',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: DittoSpacing.xs),

                    Wrap(
                      spacing: DittoSpacing.xs,
                      runSpacing: DittoSpacing.xs,
                      children: [
                        ..._tags.map((tag) => InputChip(
                              label: Text(tag),
                              onDeleted: () => _removeTag(tag),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            )),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _tagController,
                            decoration: const InputDecoration(
                              hintText: 'Ny tagg...',
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8),
                            ),
                            style: theme.textTheme.bodySmall,
                            onSubmitted: (_) => _addTag(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: DittoSpacing.base),

                    // File info
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.filename} · ${item.formattedSize} · ${item.mimeType}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: DittoSpacing.sm),
                        TextButton.icon(
                          onPressed: _confirmDelete,
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 18),
                          label: const Text('Slett'),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
