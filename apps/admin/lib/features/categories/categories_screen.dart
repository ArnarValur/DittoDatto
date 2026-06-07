import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/providers.dart';
import '../shared/format_date.dart';
import '../shared/slug_utils.dart';

/// Registry of curated business icons mapping keys to Material Icons.
class CategoryIcons {
  static const Map<String, IconData> registry = {
    'smart_toy': Icons.smart_toy_rounded,
    'pets': Icons.pets_rounded,
    'palette': Icons.palette_rounded,
    'directions_car': Icons.directions_car_rounded,
    'bakery_dining': Icons.bakery_dining_rounded,
    'content_cut': Icons.content_cut_rounded,
    'local_bar': Icons.local_bar_rounded,
    'restaurant': Icons.restaurant_rounded,
    'healing': Icons.healing_rounded,
    'cleaning_services': Icons.cleaning_services_rounded,
    'school': Icons.school_rounded,
    'favorite': Icons.favorite_rounded,
    'directions_bike': Icons.directions_bike_rounded,
    'directions_run': Icons.directions_run_rounded,
    'medical_services': Icons.medical_services_rounded,
    'electric_bolt': Icons.electric_bolt_rounded,
    'theater_comedy': Icons.theater_comedy_rounded,
    'fitness_center': Icons.fitness_center_rounded,
    'yard': Icons.yard_rounded,
    'sports_golf': Icons.sports_golf_rounded,
    'account_balance': Icons.account_balance_rounded,
    'chair': Icons.chair_rounded,
    'computer': Icons.computer_rounded,
    'child_care': Icons.child_care_rounded,
    'gavel': Icons.gavel_rounded,
    'spa': Icons.spa_rounded,
    'local_shipping': Icons.local_shipping_rounded,
    'music_note': Icons.music_note_rounded,
    'brush': Icons.brush_rounded,
    'nightlife': Icons.nightlife_rounded,
    'visibility': Icons.visibility_rounded,
  };

  static IconData getIcon(String? key) {
    if (key == null) return Icons.folder_open_rounded;
    return registry[key] ?? Icons.folder_open_rounded;
  }
}

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
                  DataCell(Icon(
                    CategoryIcons.getIcon(cat.icon),
                    size: 20,
                    color: theme.colorScheme.primary,
                  )),
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
    final nameCtrl = TextEditingController(text: category?.name ?? '');
    final slugCtrl = TextEditingController(text: category?.slug ?? '');
    final descCtrl = TextEditingController(text: category?.description ?? '');
    var selectedIconKey = category?.icon;
    var slugManuallyEdited = isEdit;
    var isSubmitting = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(isEdit ? 'Edit Category' : 'New Category'),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Name *'),
                      enabled: !isSubmitting,
                      onChanged: (v) {
                        if (!slugManuallyEdited) {
                          slugCtrl.text = generateSlug(v);
                        }
                      },
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    TextField(
                      controller: slugCtrl,
                      decoration: const InputDecoration(labelText: 'Slug *'),
                      enabled: !isSubmitting,
                      onChanged: (_) => slugManuallyEdited = true,
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    TextField(
                      controller: descCtrl,
                      decoration: const InputDecoration(labelText: 'Description (Optional)'),
                      maxLines: 2,
                      enabled: !isSubmitting,
                    ),
                    const SizedBox(height: DittoSpacing.base),
                    Text(
                      'Select Icon',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: DittoSpacing.xs),
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(DittoBorderRadius.sm),
                      ),
                      padding: const EdgeInsets.all(DittoSpacing.xs),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          crossAxisSpacing: DittoSpacing.xs,
                          mainAxisSpacing: DittoSpacing.xs,
                        ),
                        itemCount: CategoryIcons.registry.length,
                        itemBuilder: (context, index) {
                          final key = CategoryIcons.registry.keys.elementAt(index);
                          final icon = CategoryIcons.registry[key]!;
                          final isSelected = selectedIconKey == key;
                          return InkWell(
                            onTap: isSubmitting
                                ? null
                                : () {
                                    setState(() {
                                      selectedIconKey = key;
                                    });
                                  },
                            borderRadius: BorderRadius.circular(DittoBorderRadius.sm),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.colorScheme.primary.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(DittoBorderRadius.sm),
                              ),
                              child: Icon(
                                icon,
                                size: 20,
                                color: isSelected ? theme.colorScheme.primary : Colors.white70,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        if (nameCtrl.text.trim().isEmpty) {
                          setState(() {
                            errorMessage = 'Name is required';
                          });
                          return;
                        }
                        if (slugCtrl.text.trim().isEmpty) {
                          setState(() {
                            errorMessage = 'Slug is required';
                          });
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
                            description: descCtrl.text.trim().isNotEmpty
                                ? descCtrl.text.trim()
                                : null,
                            icon: selectedIconKey,
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
                          if (context.mounted) {
                            setState(() {
                              isSubmitting = false;
                              errorMessage = e.toString().replaceAll('Exception: ', '');
                            });
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(isEdit ? 'Save' : 'Create'),
              ),
            ],
          ),
        );
      },
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
