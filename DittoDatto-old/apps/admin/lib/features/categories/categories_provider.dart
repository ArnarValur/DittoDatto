import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../auth/auth_provider.dart';

/// Categories state — platform-wide service taxonomy.
///
/// Manages CRUD operations against AdminApi.listCategories/create/update/delete.
/// Uses invalidateSelf() after mutations for automatic re-fetch.
final categoriesProvider = AsyncNotifierProvider.autoDispose<
    CategoriesNotifier, List<Category>>(CategoriesNotifier.new);

class CategoriesNotifier extends AutoDisposeAsyncNotifier<List<Category>> {
  AdminApi get _adminApi => ref.read(adminApiProvider);

  @override
  Future<List<Category>> build() async {
    final adminApi = ref.watch(adminApiProvider);
    return adminApi.listCategories();
  }

  /// Create a new category and refresh the list.
  Future<void> createCategory(Category category) async {
    await _adminApi.createCategory(category);
    ref.invalidateSelf();
  }

  /// Update an existing category and refresh the list.
  Future<void> updateCategory(String id, Category category) async {
    await _adminApi.updateCategory(id, category);
    ref.invalidateSelf();
  }

  /// Delete a category by ID and refresh the list.
  Future<void> deleteCategory(String id) async {
    await _adminApi.deleteCategory(id);
    ref.invalidateSelf();
  }
}
