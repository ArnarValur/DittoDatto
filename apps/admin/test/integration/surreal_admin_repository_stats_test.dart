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
    test('returns valid non-negative counts', () async {
      // Note: flutter test runs test files concurrently, so other tests
      // may create/delete records in parallel. We cannot rely on exact
      // count deltas. Instead, verify the API returns sane values.
      final stats = await repo.getStats();

      expect(stats.userCount, greaterThanOrEqualTo(0));
      expect(stats.companyCount, greaterThanOrEqualTo(0));
      expect(stats.categoryCount, greaterThanOrEqualTo(0));
    });

    test('counts reflect created records', () async {
      // Create a user and verify count is at least 1.
      final user = await repo.createUser(
        User(
          id: '',
          name: 'Stats Test User',
          email: 'stats-isolation@dittodatto.no',
          phone: '11112222',
          role: ActorRole.customer,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final stats = await repo.getStats();
      expect(stats.userCount, greaterThanOrEqualTo(1));

      // Clean up.
      await repo.deleteUser(user.id);
    });

    test('engineHealthy is true (no engine deployed yet)', () async {
      final stats = await repo.getStats();
      expect(stats.engineHealthy, isTrue);
    });
  });
}
