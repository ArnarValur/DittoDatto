@Tags(['integration'])
library;

import 'package:ditto_auth/ditto_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace/features/favorites/favorite_repository.dart';

import 'helpers/mock_secure_storage.dart';

const testUrl = String.fromEnvironment(
  'SURREAL_TEST_URL',
  defaultValue: 'ws://localhost:18000/rpc',
);

var _emailCounter = 0;
final _runId = DateTime.now().microsecondsSinceEpoch;
String uniqueEmail() => 'fav-$_runId-${++_emailCounter}@integration.test';

/// Create a consumer-authenticated DittoAuth and return the repository.
Future<FavoriteRepository> makeAuthenticatedRepo() async {
  setUpMockSecureStorage();
  final auth = DittoAuth(
    backend: SurrealAuthBackend(
      wsUrl: testUrl,
      serviceUser: '',
      servicePass: '',
    ),
  );

  final email = uniqueEmail();
  await auth.consumerSignup(
    name: 'Fav Test User',
    email: email,
    password: 'testpass123',
  );

  final db = auth.consumerDb;
  expect(db, isNotNull, reason: 'consumerDb should be set after signup');
  return FavoriteRepository(db!);
}

void main() {
  group('FavoriteRepository', () {
    test('addFavorite creates a record and returns it', () async {
      final repo = await makeAuthenticatedRepo();

      final fav = await repo.addFavorite('estbl_test_add_123');

      expect(fav.targetId, 'estbl_test_add_123');
      expect(fav.targetType, 'store');
      expect(fav.id, isNotNull);
      expect(fav.addedAt, isNotNull);
    });

    test('isFavorited returns true after adding', () async {
      final repo = await makeAuthenticatedRepo();

      await repo.addFavorite('estbl_check_456');
      final result = await repo.isFavorited('estbl_check_456');

      expect(result, isTrue);
    });

    test('isFavorited returns false when not favorited', () async {
      final repo = await makeAuthenticatedRepo();

      final result = await repo.isFavorited('estbl_nonexistent');

      expect(result, isFalse);
    });

    test('removeFavorite deletes the record', () async {
      final repo = await makeAuthenticatedRepo();

      await repo.addFavorite('estbl_remove_789');
      await repo.removeFavorite('estbl_remove_789');
      final result = await repo.isFavorited('estbl_remove_789');

      expect(result, isFalse);
    });

    test('removeFavorite is idempotent (no error if not found)', () async {
      final repo = await makeAuthenticatedRepo();

      // Should not throw.
      await repo.removeFavorite('estbl_never_existed');
    });

    test('addFavorite rejects duplicate (unique index)', () async {
      final repo = await makeAuthenticatedRepo();

      await repo.addFavorite('estbl_dup_abc');

      expect(
        () => repo.addFavorite('estbl_dup_abc'),
        throwsA(isA<Exception>()),
      );
    });

    test('listFavorites returns all store favorites', () async {
      final repo = await makeAuthenticatedRepo();

      await repo.addFavorite('estbl_list_a');
      await repo.addFavorite('estbl_list_b');

      final favorites = await repo.listFavorites();

      expect(favorites.length, greaterThanOrEqualTo(2));
      expect(
        favorites.map((f) => f.targetId),
        containsAll(['estbl_list_a', 'estbl_list_b']),
      );
    });

    test('listFavorites returns empty when none exist', () async {
      final repo = await makeAuthenticatedRepo();

      final favorites = await repo.listFavorites();

      expect(favorites, isEmpty);
    });

    test('different target_type creates separate records', () async {
      final repo = await makeAuthenticatedRepo();

      await repo.addFavorite('dual_target_xyz', targetType: 'store');
      await repo.addFavorite('dual_target_xyz', targetType: 'person');

      final stores = await repo.listFavorites(targetType: 'store');
      final people = await repo.listFavorites(targetType: 'person');

      expect(stores.length, 1);
      expect(people.length, 1);
    });
  });
}
