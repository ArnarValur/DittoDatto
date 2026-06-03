import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/providers.dart';
import '../shared/format_date.dart';
import '../shared/slug_utils.dart';

/// Provider for paginated categories list.
final categoriesProvider = AsyncNotifierProvider.autoDispose<
    CategoriesNotifier, PaginatedResponse<Category>>(CategoriesNotifier.new);

class CategoriesNotifier
    extends AsyncNotifier<PaginatedResponse<Category>> {
  int _page = 1;
  static const _pageSize = 50;

  @override
  Future<PaginatedResponse<Category>> build() {
    final repo = ref.watch(adminRepositoryProvider);
    return repo.getCategories(page: _page, pageSize: _pageSize);
  }

  Future<void> _reload() async {
    final repo = ref.read(adminRepositoryProvider);
    try {
      final response = await repo.getCategories(page: _page, pageSize: _pageSize);
      state = AsyncData(response);
    } catch (err, stack) {
      state = AsyncError(err, stack);
      rethrow;
    }
  }

  Future<void> goToPage(int page) async {
    _page = page;
    await _reload();
  }

  Future<void> createCategory(Category category) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.createCategory(category);
    await _reload();
  }

  Future<void> updateCategory(Category category) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.updateCategory(category);
    await _reload();
  }

  Future<void> deleteCategory(String id) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.deleteCategory(id);
    await _reload();
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('Categories', style: theme.textTheme.headlineMedium),
                const SizedBox(width: DittoSpacing.sm),
                Text(
                  '${response.total} total',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
                ),
              ],
            ),
            FilledButton.icon(
              onPressed: () => _showCategoryDialog(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Category'),
            ),
          ],
        ),
        const SizedBox(height: DittoSpacing.base),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Icon')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Slug')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Count'), numeric: true),
                DataColumn(label: Text('Created')),
                DataColumn(label: Text('Actions')),
              ],
              rows: response.items.map((cat) {
                return DataRow(
                  cells: [
                    DataCell(Text(
                      cat.id.length > 8 ? '${cat.id.substring(0, 8)}...' : cat.id,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        color: Colors.white38,
                      ),
                    )),
                    DataCell(Text(cat.icon ?? '📁', style: const TextStyle(fontSize: 20))),
                    DataCell(
                      Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () => _showCategoryDialog(context, ref, category: cat),
                    ),
                    DataCell(Text(cat.slug)),
                    DataCell(SizedBox(
                      width: 200,
                      child: Text(
                        cat.description ?? '—',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
                      ),
                    )),
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
                              try {
                                await ref.read(categoriesProvider.notifier).deleteCategory(cat.id);
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to delete category: $e'),
                                      backgroundColor: DittoColors.error,
                                    ),
                                  );
                                }
                              }
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
        ),
        const SizedBox(height: DittoSpacing.base),
        _PaginationBar(
          currentPage: response.page,
          totalPages: response.totalPages,
          onPageChanged: (page) {
            ref.read(categoriesProvider.notifier).goToPage(page);
          },
        ),
      ],
    );
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref, {Category? category}) {
    final isEdit = category != null;
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: category?.name ?? '');
    final slugCtrl = TextEditingController(text: category?.slug ?? '');
    final descCtrl = TextEditingController(text: category?.description ?? '');
    final iconCtrl = TextEditingController(text: category?.icon ?? '');
    var slugManuallyEdited = isEdit;

    bool isSubmitting = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEdit ? 'Edit Category' : 'New Category'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(DittoSpacing.sm),
                        decoration: BoxDecoration(
                          color: DittoColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: DittoColors.error.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: DittoColors.error, size: 18),
                            const SizedBox(width: DittoSpacing.xs),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(color: DittoColors.error, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: DittoSpacing.sm),
                    ],
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Name *'),
                      enabled: !isSubmitting,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                      onChanged: (v) {
                        if (!slugManuallyEdited) {
                          slugCtrl.text = generateSlug(v);
                        }
                      },
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    TextFormField(
                      controller: slugCtrl,
                      decoration: const InputDecoration(labelText: 'Slug *'),
                      enabled: !isSubmitting,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Slug is required';
                        }
                        final slugRegex = RegExp(r'^[a-z0-9-]+$');
                        if (!slugRegex.hasMatch(v.trim())) {
                          return 'Slug must only contain lowercase letters, numbers, and hyphens';
                        }
                        return null;
                      },
                      onChanged: (_) => slugManuallyEdited = true,
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                      enabled: !isSubmitting,
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    TextFormField(
                      controller: iconCtrl,
                      decoration: const InputDecoration(labelText: 'Icon (emoji)'),
                      enabled: !isSubmitting,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            if (!isEdit)
              TextButton(
                onPressed: isSubmitting
                    ? null
                    : () {
                        setState(() {
                          nameCtrl.text = 'Frisør';
                          slugCtrl.text = 'frisoer';
                          descCtrl.text = 'Hårklipp, farge og styling';
                          iconCtrl.text = '✂️';
                          slugManuallyEdited = true;
                        });
                      },
                child: const Text('Fill Mock Data'),
              ),
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      setState(() {
                        isSubmitting = true;
                        errorMessage = null;
                      });

                      try {
                        final now = DateTime.now();
                        final result = Category(
                          id: category?.id ?? 'cat${now.millisecondsSinceEpoch}',
                          name: nameCtrl.text.trim(),
                          slug: slugCtrl.text.trim(),
                          description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
                          icon: iconCtrl.text.trim().isNotEmpty ? iconCtrl.text.trim() : null,
                          count: category?.count ?? 0,
                          createdAt: category?.createdAt ?? now,
                          updatedAt: now,
                        );

                        if (isEdit) {
                          await ref.read(categoriesProvider.notifier).updateCategory(result);
                        } else {
                          await ref.read(categoriesProvider.notifier).createCategory(result);
                        }

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        setState(() {
                          isSubmitting = false;
                          errorMessage = e.toString().replaceAll('Exception: ', '');
                        });
                      }
                    },
              child: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEdit ? 'Save' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable pagination bar for data tables.
class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
        Text(
          'Page $currentPage of $totalPages',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}
