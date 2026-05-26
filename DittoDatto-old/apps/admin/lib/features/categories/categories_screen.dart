import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../theme/app_colors.dart';
import '../shared/confirm_dialog.dart';
import 'categories_provider.dart';
import 'category_dialog.dart';

/// Categories screen — platform-wide service taxonomy CRUD.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.category_rounded,
              size: 20,
              color: AppColors.moodyBlue,
            ),
            const SizedBox(width: 10),
            const Text('Categories'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: () => _createCategory(context, ref),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Create'),
            ),
          ),
        ],
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(categoriesProvider),
        ),
        data: (categories) => categories.isEmpty
            ? _EmptyView(onCreate: () => _createCategory(context, ref))
            : _CategoriesTable(categories: categories),
      ),
    );
  }

  Future<void> _createCategory(BuildContext context, WidgetRef ref) async {
    final category = await showDialog<Category>(
      context: context,
      builder: (_) => const CategoryDialog(),
    );
    if (category == null || !context.mounted) return;

    try {
      await ref.read(categoriesProvider.notifier).createCategory(category);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category "${category.name}" created')),
        );
      }
    } on MercuryApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${e.message}')),
        );
      }
    }
  }
}

class _CategoriesTable extends ConsumerWidget {
  const _CategoriesTable({required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              Colors.white.withValues(alpha: 0.03),
            ),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Slug')),
              DataColumn(label: Text('Icon')),
              DataColumn(label: Text('Count'), numeric: true),
              DataColumn(label: Text('Actions')),
            ],
            rows: categories.map((cat) {
              return DataRow(
                cells: [
                  DataCell(Text(
                    cat.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  )),
                  DataCell(Text(
                    cat.slug,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  )),
                  DataCell(Text(cat.icon ?? '—')),
                  DataCell(Text(cat.count.toString())),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        tooltip: 'Edit',
                        color: Colors.white38,
                        onPressed: () => _editCategory(context, ref, cat),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_rounded, size: 18),
                        tooltip: 'Delete',
                        color: AppColors.error.withValues(alpha: 0.7),
                        onPressed: () => _deleteCategory(context, ref, cat),
                      ),
                    ],
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _editCategory(
    BuildContext context,
    WidgetRef ref,
    Category existing,
  ) async {
    final updated = await showDialog<Category>(
      context: context,
      builder: (_) => CategoryDialog(category: existing),
    );
    if (updated == null || existing.id == null || !context.mounted) return;

    try {
      await ref
          .read(categoriesProvider.notifier)
          .updateCategory(existing.id!, updated);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category "${updated.name}" updated')),
        );
      }
    } on MercuryApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${e.message}')),
        );
      }
    }
  }

  Future<void> _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Category',
      message:
          'Are you sure you want to delete "${category.name}"? This action cannot be undone.',
    );
    if (!confirmed || category.id == null || !context.mounted) return;

    try {
      await ref
          .read(categoriesProvider.notifier)
          .deleteCategory(category.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category "${category.name}" deleted')),
        );
      }
    } on MercuryApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${e.message}')),
        );
      }
    }
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.category_rounded,
            size: 48,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            'No categories yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white54,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first service category to get started',
            style: TextStyle(fontSize: 13, color: Colors.white30),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Create Category'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            'Failed to load categories',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white54,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 12, color: Colors.white30),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
