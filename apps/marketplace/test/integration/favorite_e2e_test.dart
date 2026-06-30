@Tags(['integration'])
library;

import 'package:ditto_auth/ditto_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace/features/favorites/favorite_repository.dart';

import 'helpers/mock_secure_storage.dart';

/// Full E2E test: consumer signup → create favorite → read → delete → verify.
/// This simulates exactly what happens on the phone.
void main() {
  const testUrl = String.fromEnvironment(
    'SURREAL_TEST_URL',
    defaultValue: 'ws://localhost:18000/rpc',
  );

  test('E2E: consumer signup → favorite toggle → verify', () async {
    setUpMockSecureStorage();

    // 1. Create consumer auth (same as app does)
    final auth = DittoAuth(
      backend: SurrealAuthBackend(
        wsUrl: testUrl,
        serviceUser: '',
        servicePass: '',
      ),
    );

    final runId = DateTime.now().microsecondsSinceEpoch;
    final email = 'e2e-fav-$runId@test.test';

    print('1. Signing up consumer: $email');
    final result = await auth.consumerSignup(
      name: 'E2E Test User',
      email: email,
      password: 'testpass123',
    );
    print('   userId: ${result.userId}');

    // 2. Get consumer DB (same as favoriteRepositoryProvider does)
    final db = auth.consumerDb;
    expect(db, isNotNull, reason: 'consumerDb must be set after signup');
    print('2. Got consumerDb');

    // 3. Create repository (same as app does)
    final repo = FavoriteRepository(db!);

    // 4. Create favorite with slug (same as EstablishmentTestScreen._targetId)
    const targetId = 'house-of-the-north';
    print('3. Creating favorite for targetId=$targetId');
    final fav = await repo.addFavorite(targetId);
    print('   Created: id=${fav.id}, targetId=${fav.targetId}, user=${fav.user}');

    expect(fav.targetId, targetId);
    expect(fav.id, isNotNull);

    // 5. Check isFavorited
    print('4. Checking isFavorited...');
    final isFav = await repo.isFavorited(targetId);
    print('   isFavorited=$isFav');
    expect(isFav, isTrue);

    // 6. List favorites
    print('5. Listing favorites...');
    final list = await repo.listFavorites();
    print('   count=${list.length}');
    expect(list.length, 1);
    expect(list.first.targetId, targetId);

    // 7. Remove favorite
    print('6. Removing favorite...');
    await repo.removeFavorite(targetId);
    final isStillFav = await repo.isFavorited(targetId);
    print('   isFavorited after remove=$isStillFav');
    expect(isStillFav, isFalse);

    // 8. Verify list is empty
    final listAfter = await repo.listFavorites();
    print('   count after remove=${listAfter.length}');
    expect(listAfter.length, 0);

    print('✅ E2E test passed!');
  });
}
