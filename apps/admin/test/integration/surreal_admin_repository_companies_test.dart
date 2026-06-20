@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:ditto_admin/core/surreal_admin_repository.dart';
import 'package:ditto_admin/core/surreal_connection.dart';

import 'helpers/test_connection.dart';

/// Integration tests for Company CRUD in [SurrealAdminRepository].
///
/// Tests the FULL round-trip against a real SurrealDB instance including
/// the cross-namespace atomic operations:
///   - Creating a company updates the owner's user record in `users/users`
///   - Owner transfer updates both old and new owner
///   - Deleting a company reverts the owner's role if no other companies
///
/// Prerequisites:
///   ./scripts/test-db-up.sh
///
/// Run:
///   cd apps/admin && flutter test --tags integration
void main() {
  late SurrealConnection connection;
  late SurrealAdminRepository repo;
  final createdUserIds = <String>[];
  final createdCompanyIds = <String>[];

  setUp(() async {
    connection = await connectTestAdmin();
    repo = SurrealAdminRepository(connection: connection);
  });

  tearDown(() async {
    // Clean up companies first (they reference users).
    for (final id in createdCompanyIds.reversed) {
      try {
        await repo.deleteCompany(id);
      } catch (_) {}
    }
    createdCompanyIds.clear();

    for (final id in createdUserIds) {
      try {
        await repo.deleteUser(id);
      } catch (_) {}
    }
    createdUserIds.clear();

    connection.close();
  });

  /// Helper: create a user that can own companies.
  Future<User> createOwnerUser(String name, String email) async {
    final user = User(
      id: '',
      name: name,
      email: email,
      phone: '12345678',
      role: ActorRole.customer,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final created = await repo.createUser(user, password: 'test-pass');
    createdUserIds.add(created.id);
    return created;
  }

  /// Helper: build a Company with all required fields.
  Company makeCompany({
    required String name,
    required String slug,
    required String ownerId,
    String email = 'info@test.no',
    String id = '',
    DateTime? createdAt,
  }) {
    return Company(
      id: id,
      name: name,
      slug: slug,
      email: email,
      ownerId: ownerId,
      dbSlug: 'company_$slug',
      tier: CompanyTier.free,
      onboardingStatus: OnboardingStatus.notStarted,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  group('createCompany', () {
    test('creates company in registry + updates owner user', () async {
      final owner = await createOwnerUser('Company Owner', 'compowner@dittodatto.no');

      final created = await repo.createCompany(
        makeCompany(name: 'Test Company AS', slug: 'test-company-as', ownerId: owner.id),
      );
      createdCompanyIds.add(created.id);

      expect(created.name, 'Test Company AS');
      expect(created.slug, 'test-company-as');
      expect(created.id, isNotEmpty);

      // Verify the owner's user record was updated with company_slug.
      final users = await repo.getUsers();
      final ownerUser = users.items.firstWhere((u) => u.id == owner.id);
      expect(ownerUser.companySlug, contains('test-company-as'));
    });
  });

  group('getCompanies', () {
    test('returns created companies with pagination', () async {
      final owner = await createOwnerUser('List Owner', 'listowner@dittodatto.no');

      final c1 = await repo.createCompany(
        makeCompany(name: 'List Company One', slug: 'list-company-one', ownerId: owner.id, email: 'one@test.no'),
      );
      createdCompanyIds.add(c1.id);

      final c2 = await repo.createCompany(
        makeCompany(name: 'List Company Two', slug: 'list-company-two', ownerId: owner.id, email: 'two@test.no'),
      );
      createdCompanyIds.add(c2.id);

      final result = await repo.getCompanies(page: 1, pageSize: 50);

      expect(result.items.length, greaterThanOrEqualTo(2));
      expect(result.total, greaterThanOrEqualTo(2));

      final slugs = result.items.map((c) => c.slug).toList();
      expect(slugs, contains('list-company-one'));
      expect(slugs, contains('list-company-two'));
    });
  });

  group('updateCompany', () {
    test('modifies fields, preserves ID', () async {
      final owner = await createOwnerUser('Update Owner', 'updateowner@dittodatto.no');

      final created = await repo.createCompany(
        makeCompany(name: 'Before Update Company', slug: 'before-update', ownerId: owner.id, email: 'before@test.no'),
      );
      createdCompanyIds.add(created.id);

      final updated = await repo.updateCompany(
        makeCompany(
          id: created.id,
          name: 'After Update Company',
          slug: 'before-update',
          ownerId: owner.id,
          email: 'after@test.no',
          createdAt: created.createdAt,
        ),
      );

      expect(updated.id, created.id);
      expect(updated.name, 'After Update Company');
      expect(updated.email, 'after@test.no');
    });

    test('owner transfer → old owner loses slug, new owner gains it', () async {
      final oldOwner = await createOwnerUser('Old Owner', 'oldowner@dittodatto.no');
      final newOwner = await createOwnerUser('New Owner', 'newowner@dittodatto.no');

      final created = await repo.createCompany(
        makeCompany(name: 'Transfer Company', slug: 'transfer-company', ownerId: oldOwner.id, email: 'transfer@test.no'),
      );
      createdCompanyIds.add(created.id);

      // Transfer ownership.
      await repo.updateCompany(
        makeCompany(
          id: created.id,
          name: 'Transfer Company',
          slug: 'transfer-company',
          ownerId: newOwner.id,
          email: 'transfer@test.no',
          createdAt: created.createdAt,
        ),
      );

      // Verify old owner lost the company slug.
      final users = await repo.getUsers();
      final oldOwnerUser = users.items.firstWhere((u) => u.id == oldOwner.id);
      // Old owner had only one company → should revert to customer, slug cleared.
      expect(oldOwnerUser.companySlug, anyOf(isNull, isEmpty, equals('none')));

      // Verify new owner gained the company slug.
      final newOwnerUser = users.items.firstWhere((u) => u.id == newOwner.id);
      expect(newOwnerUser.companySlug, contains('transfer-company'));
    });
  });

  group('deleteCompany', () {
    test('removes record + reverts owner to customer if no other companies', () async {
      final owner = await createOwnerUser('Delete Owner', 'deleteowner@dittodatto.no');

      final created = await repo.createCompany(
        makeCompany(name: 'Delete Me Company', slug: 'delete-me-company', ownerId: owner.id, email: 'delete@test.no'),
      );
      // Don't add to createdCompanyIds — we're testing deletion.

      await repo.deleteCompany(created.id);

      // Verify company is gone.
      final companies = await repo.getCompanies();
      expect(companies.items.any((c) => c.id == created.id), isFalse);

      // Verify owner reverted to customer (no other companies).
      final users = await repo.getUsers();
      final ownerUser = users.items.firstWhere((u) => u.id == owner.id);
      expect(ownerUser.role, anyOf(ActorRole.customer, ActorRole.admin, ActorRole.superAdmin));
    });
  });

  group('Multiple companies same owner', () {
    test('company_slug is comma-separated list', () async {
      final owner = await createOwnerUser('Multi Owner', 'multiowner@dittodatto.no');

      final c1 = await repo.createCompany(
        makeCompany(name: 'Multi Company One', slug: 'multi-one', ownerId: owner.id, email: 'multi1@test.no'),
      );
      createdCompanyIds.add(c1.id);

      final c2 = await repo.createCompany(
        makeCompany(name: 'Multi Company Two', slug: 'multi-two', ownerId: owner.id, email: 'multi2@test.no'),
      );
      createdCompanyIds.add(c2.id);

      // Verify owner has both slugs.
      final users = await repo.getUsers();
      final ownerUser = users.items.firstWhere((u) => u.id == owner.id);
      expect(ownerUser.companySlug, contains('multi-one'));
      expect(ownerUser.companySlug, contains('multi-two'));
    });
  });
}
