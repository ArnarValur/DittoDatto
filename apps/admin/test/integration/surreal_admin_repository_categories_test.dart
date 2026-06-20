@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:ditto_admin/core/surreal_admin_repository.dart';
import 'package:ditto_admin/core/surreal_connection.dart';

import 'helpers/test_connection.dart';

/// Integration tests for Category CRUD in [SurrealAdminRepository].
///
/// Categories live in `companies/discovery` — separate DB from users and registry.
/// Tests the full round-trip against real SurrealDB.
///
/// Prerequisites:
///   ./scripts/test-db-up.sh
///
/// Run:
///   cd apps/admin && flutter test --tags integration
void main() {
  late SurrealConnection connection;
  late SurrealAdminRepository repo;
  final createdCategoryIds = <String>[];

  setUp(() async {
    connection = await connectTestAdmin();
    repo = SurrealAdminRepository(connection: connection);
  });

  tearDown(() async {
    for (final id in createdCategoryIds) {
      try {
        await repo.deleteCategory(id);
      } catch (_) {}
    }
    createdCategoryIds.clear();
    connection.close();
  });

  group('createCategory', () {
    test('record persisted in discovery DB', () async {
      final category = Category(
        id: '',
        name: 'Beauty',
        slug: 'beauty',
        description: 'Hair, nails, and spa services',
        icon: 'spa',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await repo.createCategory(category);
      createdCategoryIds.add(created.id);

      expect(created.name, 'Beauty');
      expect(created.slug, 'beauty');
      expect(created.id, isNotEmpty);
    });
  });

  group('getCategories', () {
    test('returns created categories with pagination', () async {
      final c1 = await repo.createCategory(Category(
        id: '',
        name: 'Fitness',
        slug: 'fitness',
        description: 'Gym and training',
        icon: 'fitness_center',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      createdCategoryIds.add(c1.id);

      final c2 = await repo.createCategory(Category(
        id: '',
        name: 'Restaurant',
        slug: 'restaurant',
        description: 'Dining and food',
        icon: 'restaurant',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      createdCategoryIds.add(c2.id);

      final result = await repo.getCategories(page: 1, pageSize: 50);

      expect(result.items.length, greaterThanOrEqualTo(2));
      expect(result.total, greaterThanOrEqualTo(2));

      final names = result.items.map((c) => c.name).toList();
      expect(names, contains('Fitness'));
      expect(names, contains('Restaurant'));
    });
  });

  group('updateCategory', () {
    test('modifies fields, preserves ID', () async {
      final created = await repo.createCategory(Category(
        id: '',
        name: 'Before Update',
        slug: 'before-update-cat',
        description: 'Original description',
        icon: 'help',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      createdCategoryIds.add(created.id);

      final updated = await repo.updateCategory(Category(
        id: created.id,
        name: 'After Update',
        slug: 'before-update-cat',
        description: 'Updated description',
        icon: 'check',
        createdAt: created.createdAt,
        updatedAt: DateTime.now(),
      ));

      expect(updated.id, created.id);
      expect(updated.name, 'After Update');
      expect(updated.description, 'Updated description');
    });
  });

  group('deleteCategory', () {
    test('removes record', () async {
      final created = await repo.createCategory(Category(
        id: '',
        name: 'Delete Me Category',
        slug: 'delete-me-cat',
        description: 'To be deleted',
        icon: 'delete',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      // Don't add to cleanup — we're testing deletion.

      await repo.deleteCategory(created.id);

      // Verify deletion.
      final result = await repo.getCategories();
      expect(result.items.any((c) => c.id == created.id), isFalse);
    });
  });

  group('Round-trip', () {
    test('create → read → update → delete → verify gone', () async {
      // Create.
      final created = await repo.createCategory(Category(
        id: '',
        name: 'Round Trip Category',
        slug: 'roundtrip-cat',
        description: 'Testing full lifecycle',
        icon: 'loop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      expect(created.id, isNotEmpty);

      // Read.
      final readResult = await repo.getCategories();
      expect(readResult.items.any((c) => c.id == created.id), isTrue);

      // Update.
      final updated = await repo.updateCategory(Category(
        id: created.id,
        name: 'Round Trip Updated',
        slug: 'roundtrip-cat',
        description: 'Updated lifecycle',
        icon: 'done',
        createdAt: created.createdAt,
        updatedAt: DateTime.now(),
      ));
      expect(updated.name, 'Round Trip Updated');

      // Delete.
      await repo.deleteCategory(created.id);

      // Verify gone.
      final afterDelete = await repo.getCategories();
      expect(afterDelete.items.any((c) => c.id == created.id), isFalse);
    });
  });
}
