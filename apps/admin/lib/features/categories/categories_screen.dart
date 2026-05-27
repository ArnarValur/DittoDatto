import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../dashboard/dashboard_screen.dart';
import '../shared/format_date.dart';
import '../shared/slug_utils.dart';

/// Provider for paginated categories list.
final categoriesProvider = AsyncNotifierProvider.autoDispose<
    CategoriesNotifier, PaginatedResponse<Category>>(CategoriesNotifier.new);

class CategoriesNotifier
    extends AsyncNotifier<PaginatedResponse<Category>> {
  @override
  Future<PaginatedResponse<Category>> build() {
    final repo = ref.watch(adminRepositoryProvider);
    return repo.getCategories();
  }

  Future<void> createCategory(Category category) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.createCategory(category);
    ref.invalidateSelf();
  }

  Future<void> updateCategory(Category category) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.updateCategory(category);
    ref.invalidateSelf();
  }

  Future<void> deleteCategory(String id) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.deleteCategory(id);
    ref.invalidateSelf();
  }
}

/// Categories management screen with full CRUD.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => DittoErrorView(
        message: 'Failed to load categories',
        onRetry: () => ref.invalidate(categoriesProvider),
      ),
      data: (response) => _CategoriesTable(response: response),
    );
  }
}

class _CategoriesTable extends ConsumerWidget {
  const _CategoriesTable({required this.response});
  final PaginatedResponse<Category> response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Categories', style: theme.textTheme.headlineMedium),
            FilledButton.icon(
              onPressed: () => _showCategoryDialog(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Category'),
            ),
          ],
        ),
        const SizedBox(height: DittoSpacing.base),
        Card(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Icon')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Slug')),
              DataColumn(label: Text('Count'), numeric: true),
              DataColumn(label: Text('Created')),
              DataColumn(label: Text('Actions')),
            ],
            rows: response.items.map((cat) {
              return DataRow(
                cells: [
                  DataCell(Text(cat.icon ?? '📁', style: const TextStyle(fontSize: 20))),
                  DataCell(
                    Text(cat.name),
                    onTap: () => _showCategoryDialog(context, ref, category: cat),
                  ),
                  DataCell(Text(cat.slug)),
                  DataCell(Text(cat.count.toString())),
                  DataCell(Text(formatDate(cat.createdAt))),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        tooltip: 'Edit',
                        onPressed: () => _showCategoryDialog(context, ref, category: cat),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_rounded, size: 18, color: DittoColors.error),
                        tooltip: 'Delete',
                        onPressed: () async {
                          final confirmed = await showDittoConfirmDialog(
                            context: context,
                            title: 'Delete Category',
                            message: 'Are you sure you want to delete "${cat.name}"? This action cannot be undone.',
                            confirmLabel: 'Delete',
                            confirmColor: DittoColors.error,
                          );
                          if (confirmed && context.mounted) {
                            ref.read(categoriesProvider.notifier).deleteCategory(cat.id);
                          }
                        },
                      ),
                    ],
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref, {Category? category}) {
    final isEdit = category != null;
    final nameCtrl = TextEditingController(text: category?.name ?? '');
    final slugCtrl = TextEditingController(text: category?.slug ?? '');
    final descCtrl = TextEditingController(text: category?.description ?? '');
    final iconCtrl = TextEditingController(text: category?.icon ?? '');
    var slugManuallyEdited = isEdit;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Category' : 'New Category'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (v) {
                  if (!slugManuallyEdited) {
                    slugCtrl.text = generateSlug(v);
                  }
                },
              ),
              const SizedBox(height: DittoSpacing.sm),
              TextField(
                controller: slugCtrl,
                decoration: const InputDecoration(labelText: 'Slug'),
                onChanged: (_) => slugManuallyEdited = true,
              ),
              const SizedBox(height: DittoSpacing.sm),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: DittoSpacing.sm),
              TextField(
                controller: iconCtrl,
                decoration: const InputDecoration(labelText: 'Icon (emoji)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final now = DateTime.now();
              final result = Category(
                id: category?.id ?? 'cat${now.millisecondsSinceEpoch}',
                name: nameCtrl.text,
                slug: slugCtrl.text,
                description: descCtrl.text.isNotEmpty ? descCtrl.text : null,
                icon: iconCtrl.text.isNotEmpty ? iconCtrl.text : null,
                count: category?.count ?? 0,
                createdAt: category?.createdAt ?? now,
                updatedAt: now,
              );
              if (isEdit) {
                ref.read(categoriesProvider.notifier).updateCategory(result);
              } else {
                ref.read(categoriesProvider.notifier).createCategory(result);
              }
              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Save' : 'Create'),
          ),
        ],
      ),
    );
  }
}
