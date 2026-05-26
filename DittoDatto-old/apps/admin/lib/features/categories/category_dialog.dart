import 'package:flutter/material.dart';
import 'package:mercury_client/mercury_client.dart';

/// Dialog for creating or editing a platform category.
///
/// Returns a [Category] on save, or null on cancel.
/// If [category] is provided, pre-fills the form for editing.
class CategoryDialog extends StatefulWidget {
  const CategoryDialog({super.key, this.category});

  /// If non-null, we're editing this category.
  final Category? category;

  bool get isEditing => category != null;

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtl;
  late final TextEditingController _slugCtl;
  late final TextEditingController _descCtl;
  late final TextEditingController _iconCtl;

  /// Whether the user has manually edited the slug field.
  bool _slugManuallyEdited = false;

  @override
  void initState() {
    super.initState();
    _nameCtl = TextEditingController(text: widget.category?.name ?? '');
    _slugCtl = TextEditingController(text: widget.category?.slug ?? '');
    _descCtl = TextEditingController(text: widget.category?.description ?? '');
    _iconCtl = TextEditingController(text: widget.category?.icon ?? '');

    // If editing, slug was already set so mark as manually edited.
    if (widget.isEditing) _slugManuallyEdited = true;

    _nameCtl.addListener(_onNameChanged);
    _slugCtl.addListener(_onSlugEdited);
  }

  void _onNameChanged() {
    if (!_slugManuallyEdited) {
      _slugCtl.removeListener(_onSlugEdited);
      _slugCtl.text = _slugify(_nameCtl.text);
      _slugCtl.addListener(_onSlugEdited);
    }
  }

  void _onSlugEdited() {
    _slugManuallyEdited = true;
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _slugCtl.dispose();
    _descCtl.dispose();
    _iconCtl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final category = Category(
      id: widget.category?.id,
      name: _nameCtl.text.trim(),
      slug: _slugCtl.text.trim(),
      description:
          _descCtl.text.trim().isEmpty ? null : _descCtl.text.trim(),
      icon: _iconCtl.text.trim().isEmpty ? null : _iconCtl.text.trim(),
    );
    Navigator.of(context).pop(category);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEditing ? 'Edit Category' : 'Create Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameCtl,
                  decoration: const InputDecoration(labelText: 'Name'),
                  autofocus: true,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _slugCtl,
                  decoration: const InputDecoration(
                    labelText: 'Slug',
                    helperText: 'Auto-generated from name',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Slug is required';
                    if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(v.trim())) {
                      return 'Lowercase letters, numbers, and hyphens only';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descCtl,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _iconCtl,
                  decoration: const InputDecoration(
                    labelText: 'Icon',
                    helperText: 'Emoji or icon identifier',
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(widget.isEditing ? 'Save' : 'Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Converts a name into a URL-safe slug.
String _slugify(String text) {
  return text
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp(r'-{2,}'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}
