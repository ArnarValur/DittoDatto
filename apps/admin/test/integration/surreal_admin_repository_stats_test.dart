@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:ditto_admin/core/surreal_admin_repository.dart';
import 'package:ditto_admin/core/surreal_connection.dart';

import 'helpers/test_connection.dart';

/// Integration tests for [AdminStats] aggregation in [SurrealAdminRepository].
///
/// Verifies that getStats() returns correct counts after creating and
/// deleting records across all three databases (users, registry, discovery).
///
/// Prerequisites:
///   ./scripts/test-db-up.sh
///
/// Run:
///   cd apps/admin && flutter test --tags integration
void main() {
  late SurrealConnection connection;
  late SurrealAdminRepository repo;

  setUp(() async {
    connection = await connectTestAdmin();
    repo = SurrealAdminRepository(connection: connection);
  });

  tearDown(() async {
    connection.close();
  });

  group('getStats', () {
    test('returns correct counts after creating users/companies/categories', () async {
      // Get baseline counts (seed data may exist).
      final baseline = await repo.getStats();

      // Create a user.
      final user = await repo.createUser(
        User(
          id: '',
          name: 'Stats Test User',
          email: 'statsuser@dittodatto.no',
          phone: '11112222',
          role: ActorRole.customer,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Create a company.
      final company = await repo.createCompany(Company(
        id: '',
        name: 'Stats Test Company',
        slug: 'stats-test-company',
        email: 'stats@test.no',
        ownerId: user.id,
        dbSlug: 'company_stats-test-company',
        tier: CompanyTier.free,
        onboardingStatus: OnboardingStatus.notStarted,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Create a category.
      final category = await repo.createCategory(Category(
        id: '',
        name: 'Stats Test Category',
        slug: 'stats-test-cat',
        description: 'For stats testing',
        icon: 'bar_chart',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Verify counts increased.
      final afterCreate = await repo.getStats();
      expect(afterCreate.userCount, baseline.userCount + 1);
      expect(afterCreate.companyCount, baseline.companyCount + 1);
      expect(afterCreate.categoryCount, baseline.categoryCount + 1);

      // Clean up: delete in reverse dependency order.
      await repo.deleteCategory(category.id);
      await repo.deleteCompany(company.id);
      await repo.deleteUser(user.id);

      // Verify counts back to baseline.
      final afterDelete = await repo.getStats();
      expect(afterDelete.userCount, baseline.userCount);
      expect(afterDelete.companyCount, baseline.companyCount);
      expect(afterDelete.categoryCount, baseline.categoryCount);
    });

    test('engineHealthy is true (no engine deployed yet)', () async {
      final stats = await repo.getStats();
      expect(stats.engineHealthy, isTrue);
    });
  });
}
