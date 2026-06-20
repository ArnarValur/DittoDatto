import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:ditto_admin/core/providers.dart';
import 'package:ditto_admin/features/companies/companies_screen.dart';

class FakeAdminRepository implements AdminRepository {
  final List<User> users = [
    User(
      id: 'arnarvalur',
      vippsSub: 'vipps_arnarvalur',
      name: 'Arnar Valur',
      email: 'arnarvalur@avj.info',
      phone: '92913093',
      role: ActorRole.business,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<Company> companies = [];

  @override
  Future<AdminStats> getStats() async {
    return const AdminStats(userCount: 1, companyCount: 0, categoryCount: 0, engineHealthy: true);
  }

  @override
  Future<PaginatedResponse<User>> getUsers({int page = 1, int pageSize = 50}) async {
    return PaginatedResponse(items: users, total: users.length, page: page, pageSize: pageSize);
  }

  @override
  Future<void> updateUserRole(String userId, ActorRole newRole) async {}

  @override
  Future<User> createUser(User user, {String? password}) async => user;

  @override
  Future<User> updateUser(User user, {String? password}) async => user;

  @override
  Future<void> deleteUser(String id) async {}

  @override
  Future<PaginatedResponse<Company>> getCompanies({int page = 1, int pageSize = 50}) async {
    return PaginatedResponse(items: companies, total: companies.length, page: page, pageSize: pageSize);
  }

  @override
  Future<Company> createCompany(Company company) async {
    companies.add(company);
    return company;
  }

  @override
  Future<Company> updateCompany(Company company) async {
    final idx = companies.indexWhere((c) => c.id == company.id);
    if (idx != -1) {
      companies[idx] = company;
    }
    return company;
  }

  @override
  Future<void> deleteCompany(String id) async {
    companies.removeWhere((c) => c.id == id);
  }

  @override
  Future<PaginatedResponse<Category>> getCategories({int page = 1, int pageSize = 50}) async {
    return PaginatedResponse(items: [], total: 0, page: page, pageSize: pageSize);
  }

  @override
  Future<Category> createCategory(Category category) async => category;

  @override
  Future<Category> updateCategory(Category category) async => category;

  @override
  Future<void> deleteCategory(String id) async {}
}

void main() {
  group('CompanyDialog Form Validation Tests', () {
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
            body: CompaniesScreen(),
          ),
        ),
      );
    }

    testWidgets('Opens Company Dialog and verifies required fields validation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Click Add Company to open dialog
      await tester.tap(find.text('Add Company'));
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

      await tester.tap(find.text('Add Company'));
      await tester.pumpAndSettle();

      // Enter name
      await tester.enterText(find.widgetWithText(TextField, 'Name *'), 'Merkurial Studio');
      // Enter invalid slug
      await tester.enterText(find.widgetWithText(TextField, 'Slug *'), 'invalid_slug_here');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify validation error for slug
      expect(find.text('Slug must only contain lowercase letters, numbers, and hyphens'), findsOneWidget);
    });

    testWidgets('Email format validation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Company'));
      await tester.pumpAndSettle();

      // Enter name
      await tester.enterText(find.widgetWithText(TextField, 'Name *'), 'Merkurial Studio');
      // Enter valid slug
      await tester.enterText(find.widgetWithText(TextField, 'Slug *'), 'merkurial-studio');
      // Select Owner (FutureBuilder should be resolved)
      await tester.tap(find.text('Owner / User *'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Arnar Valur (arnarvalur@avj.info)').last);
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.widgetWithText(TextField, 'Email *'), 'invalid-email');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify validation error for email format
      expect(find.text('Invalid email address format'), findsOneWidget);
    });

    testWidgets('Successful company creation form submit', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Company'));
      await tester.pumpAndSettle();

      // Enter name
      await tester.enterText(find.widgetWithText(TextField, 'Name *'), 'Merkurial Studio');
      // Enter valid slug
      await tester.enterText(find.widgetWithText(TextField, 'Slug *'), 'merkurial-studio');
      // Select Owner
      await tester.tap(find.text('Owner / User *'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Arnar Valur (arnarvalur@avj.info)').last);
      await tester.pumpAndSettle();

      // Enter valid email
      await tester.enterText(find.widgetWithText(TextField, 'Email *'), 'arnarvalur@merkurial-studio.com');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify dialog is dismissed and company was added to repository
      expect(find.text('New Company'), findsNothing);
      expect(fakeRepo.companies.length, 1);
      expect(fakeRepo.companies.first.name, 'Merkurial Studio');
      expect(fakeRepo.companies.first.slug, 'merkurial-studio');
    });
  });
}
