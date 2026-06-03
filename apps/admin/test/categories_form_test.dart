import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:ditto_admin/core/providers.dart';
import 'package:ditto_admin/features/categories/categories_screen.dart';

class FakeAdminRepository implements AdminRepository {
  final List<Category> categories = [];

  @override
  Future<AdminStats> getStats() async {
    return const AdminStats(userCount: 0, companyCount: 0, categoryCount: 0, engineHealthy: true);
  }

  @override
  Future<PaginatedResponse<User>> getUsers({int page = 1, int pageSize = 50}) async {
    return PaginatedResponse(items: [], total: 0, page: page, pageSize: pageSize);
  }

  @override
  Future<void> updateUserRole(String userId, ActorRole newRole) async {}

  @override
  Future<User> createUser(User user) async => user;

  @override
  Future<User> updateUser(User user) async => user;

  @override
  Future<void> deleteUser(String id) async {}

  @override
  Future<PaginatedResponse<Company>> getCompanies({int page = 1, int pageSize = 50}) async {
    return PaginatedResponse(items: [], total: 0, page: page, pageSize: pageSize);
  }

  @override
  Future<Company> createCompany(Company company) async => company;

  @override
  Future<Company> updateCompany(Company company) async => company;

  @override
  Future<void> deleteCompany(String id) async {}

  @override
  Future<PaginatedResponse<Category>> getCategories({int page = 1, int pageSize = 50}) async {
    return PaginatedResponse(items: categories, total: categories.length, page: page, pageSize: pageSize);
  }

  @override
  Future<Category> createCategory(Category category) async {
    // Simulate unique constraint on slug
    if (categories.any((c) => c.slug == category.slug)) {
      throw Exception('Category slug already exists');
    }
    categories.add(category);
    return category;
  }

  @override
  Future<Category> updateCategory(Category category) async {
    final idx = categories.indexWhere((c) => c.id == category.id);
    if (idx != -1) {
      if (categories.any((c) => c.slug == category.slug && c.id != category.id)) {
        throw Exception('Category slug already exists');
      }
      categories[idx] = category;
    }
    return category;
  }

  @override
  Future<void> deleteCategory(String id) async {
    categories.removeWhere((c) => c.id == id);
  }
}

void main() {
  group('CategoryDialog Form Validation Tests', () {
    late FakeAdminRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeAdminRepository();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          adminRepositoryProvider.overrideWithValue(fakeRepo),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CategoriesScreen(),
          ),
        ),
      );
    }

    testWidgets('Opens Category Dialog and verifies required fields validation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Click Add Category to open dialog
      await tester.tap(find.text('Add Category'));
      await tester.pumpAndSettle();

      // Click Create button to trigger validation
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('Slug format validation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Category'));
      await tester.pumpAndSettle();

      // Enter name
      await tester.enterText(find.widgetWithText(TextField, 'Name *'), 'Frisør');
      // Enter invalid slug
      await tester.enterText(find.widgetWithText(TextField, 'Slug *'), 'invalid_slug_here');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify validation error for slug
      expect(find.text('Slug must only contain lowercase letters, numbers, and hyphens'), findsOneWidget);
    });

    testWidgets('Shows error banner when database throws exception (duplicate slug)', (tester) async {
      // Add an existing category with conflicting slug
      fakeRepo.categories.add(Category(
        id: 'cat1',
        name: 'Hårklipp',
        slug: 'frisoer',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Category'));
      await tester.pumpAndSettle();

      // Enter details that conflict
      await tester.enterText(find.widgetWithText(TextField, 'Name *'), 'Annen Frisør');
      await tester.enterText(find.widgetWithText(TextField, 'Slug *'), 'frisoer');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify error banner is shown with exception message
      expect(find.text('Category slug already exists'), findsOneWidget);
      expect(find.text('New Category'), findsOneWidget); // Dialog should stay open
    });

    testWidgets('Successful category creation form submit', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Category'));
      await tester.pumpAndSettle();

      // Enter details
      await tester.enterText(find.widgetWithText(TextField, 'Name *'), 'Frisør');
      await tester.enterText(find.widgetWithText(TextField, 'Slug *'), 'frisoer');
      await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Hårklipp og styling');
      await tester.enterText(find.widgetWithText(TextField, 'Icon (emoji)'), '✂️');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify dialog is dismissed and category was added to repository
      expect(find.text('New Category'), findsNothing);
      expect(fakeRepo.categories.length, 1);
      expect(fakeRepo.categories.first.name, 'Frisør');
      expect(fakeRepo.categories.first.slug, 'frisoer');
      expect(fakeRepo.categories.first.description, 'Hårklipp og styling');
      expect(fakeRepo.categories.first.icon, '✂️');
    });
  });
}
