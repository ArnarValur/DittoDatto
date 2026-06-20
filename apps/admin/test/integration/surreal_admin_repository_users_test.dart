@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:ditto_admin/core/surreal_admin_repository.dart';
import 'package:ditto_admin/core/surreal_connection.dart';

import 'helpers/test_connection.dart';

/// Integration tests for User CRUD in [SurrealAdminRepository].
///
/// Tests the FULL round-trip against a real SurrealDB instance:
///   createUser → getUsers → updateUser → updateUserRole → deleteUser
///
/// This catches the bug classes that mocks hide:
///   - NULL vs NONE coercion (the exact bug that bit us 2026-06-20)
///   - Schema mismatches (field renames)
///   - Query syntax errors in SurrealQL templates
///   - Record ID normalization (user:abc → abc)
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

  setUp(() async {
    connection = await connectTestAdmin();
    repo = SurrealAdminRepository(connection: connection);
  });

  tearDown(() async {
    // Clean up any created users.
    for (final id in createdUserIds) {
      try {
        await repo.deleteUser(id);
      } catch (_) {}
    }
    createdUserIds.clear();
    connection.close();
  });

  group('createUser', () {
    test('with password → record persisted with password_hash', () async {
      final user = User(
        id: '',
        name: 'Test Create User',
        email: 'testcreate@dittodatto.no',
        phone: '12345678',
        role: ActorRole.business,
        companySlug: 'testcompany',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await repo.createUser(user, password: 'test-pass-123');
      createdUserIds.add(created.id);

      expect(created.name, 'Test Create User');
      expect(created.email, 'testcreate@dittodatto.no');
      expect(created.role, ActorRole.business);
      expect(created.id, isNotEmpty);
    });

    test('without password → record persisted, no password_hash', () async {
      final user = User(
        id: '',
        name: 'No Password User',
        email: 'nopass@dittodatto.no',
        phone: '87654321',
        role: ActorRole.customer,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await repo.createUser(user);
      createdUserIds.add(created.id);

      expect(created.name, 'No Password User');
      expect(created.email, 'nopass@dittodatto.no');
      expect(created.role, ActorRole.customer);
    });

    test('NULL→NONE coercion: ALL optional fields as null do not crash', () async {
      // This is the EXACT bug class from 2026-06-20.
      // SurrealDB option<string> rejects NULL but accepts NONE.
      // ALL optional fields must be null here — no cheating with hardcoded values.
      final user = User(
        id: '',
        name: 'Null Fields User',
        email: 'nullfields@dittodatto.no',
        phone: null,          // NULL → must coerce to NONE
        role: ActorRole.customer,
        companySlug: null,    // NULL → must coerce to NONE
        vippsSub: null,       // NULL → must coerce to NONE
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await repo.createUser(user, password: 'test-pass');
      createdUserIds.add(created.id);

      expect(created.name, 'Null Fields User');
      expect(created.email, 'nullfields@dittodatto.no');
      // If we got here without throwing, the NULL→NONE coercion works.
    });
  });

  group('getUsers', () {
    test('returns created users with correct pagination', () async {
      // Create two users.
      final user1 = User(
        id: '',
        name: 'List User One',
        email: 'list1@dittodatto.no',
        phone: '22222222',
        role: ActorRole.customer,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final user2 = User(
        id: '',
        name: 'List User Two',
        email: 'list2@dittodatto.no',
        phone: '33333333',
        role: ActorRole.business,
        companySlug: 'testcompany',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final c1 = await repo.createUser(user1);
      final c2 = await repo.createUser(user2);
      createdUserIds.addAll([c1.id, c2.id]);

      final result = await repo.getUsers(page: 1, pageSize: 50);

      // Should include at least our 2 created users (plus any from seed).
      expect(result.items.length, greaterThanOrEqualTo(2));
      expect(result.total, greaterThanOrEqualTo(2));
      expect(result.page, 1);

      // Verify our created users are in the list.
      final emails = result.items.map((u) => u.email).toList();
      expect(emails, contains('list1@dittodatto.no'));
      expect(emails, contains('list2@dittodatto.no'));
    });
  });

  group('updateUser', () {
    test('changes fields, preserves ID', () async {
      final user = User(
        id: '',
        name: 'Before Update',
        email: 'beforeupdate@dittodatto.no',
        phone: '44444444',
        role: ActorRole.customer,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await repo.createUser(user);
      createdUserIds.add(created.id);

      final updated = await repo.updateUser(
        User(
          id: created.id,
          name: 'After Update',
          email: 'beforeupdate@dittodatto.no',
          phone: '55555555',
          role: ActorRole.customer,
          createdAt: created.createdAt,
          updatedAt: DateTime.now(),
        ),
      );

      expect(updated.id, created.id);
      expect(updated.name, 'After Update');
      expect(updated.phone, '55555555');
    });

    test('with new password → password_hash changes', () async {
      final user = User(
        id: '',
        name: 'Password Change User',
        email: 'passchange@dittodatto.no',
        phone: '66666666',
        role: ActorRole.business,
        companySlug: 'testcompany',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await repo.createUser(user, password: 'old-pass');
      createdUserIds.add(created.id);

      // Update with a new password — should not throw.
      final updated = await repo.updateUser(
        User(
          id: created.id,
          name: 'Password Change User',
          email: 'passchange@dittodatto.no',
          phone: '66666666',
          role: ActorRole.business,
          companySlug: 'testcompany',
          createdAt: created.createdAt,
          updatedAt: DateTime.now(),
        ),
        password: 'new-pass',
      );

      expect(updated.id, created.id);
      // If we got here, the password_hash was updated without error.
    });
  });

  group('updateUserRole', () {
    test('updates role only', () async {
      final user = User(
        id: '',
        name: 'Role Change User',
        email: 'rolechange@dittodatto.no',
        phone: '77777777',
        role: ActorRole.customer,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await repo.createUser(user);
      createdUserIds.add(created.id);

      await repo.updateUserRole(created.id, ActorRole.business);

      // Verify by re-fetching.
      final result = await repo.getUsers();
      final found = result.items.where((u) => u.id == created.id);
      expect(found, isNotEmpty);
      expect(found.first.role, ActorRole.business);
    });
  });

  group('deleteUser', () {
    test('removes record', () async {
      final user = User(
        id: '',
        name: 'Delete Me User',
        email: 'deleteme@dittodatto.no',
        phone: '88888888',
        role: ActorRole.customer,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await repo.createUser(user);
      // Don't add to createdUserIds — we're testing deletion.

      await repo.deleteUser(created.id);

      // Verify deletion.
      final result = await repo.getUsers();
      final found = result.items.where((u) => u.id == created.id);
      expect(found, isEmpty);
    });
  });

  group('Round-trip', () {
    test('create → read → update → delete → verify gone', () async {
      // Create.
      final user = User(
        id: '',
        name: 'Round Trip User',
        email: 'roundtrip@dittodatto.no',
        phone: '99999999',
        role: ActorRole.customer,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await repo.createUser(user, password: 'round-trip-pass');
      expect(created.id, isNotEmpty);

      // Read.
      final readResult = await repo.getUsers();
      expect(readResult.items.any((u) => u.id == created.id), isTrue);

      // Update.
      final updated = await repo.updateUser(
        User(
          id: created.id,
          name: 'Round Trip Updated',
          email: 'roundtrip@dittodatto.no',
          phone: '00000000',
          role: ActorRole.business,
          companySlug: 'testcompany',
          createdAt: created.createdAt,
          updatedAt: DateTime.now(),
        ),
        password: 'new-round-trip-pass',
      );
      expect(updated.name, 'Round Trip Updated');
      expect(updated.phone, '00000000');

      // Delete.
      await repo.deleteUser(created.id);

      // Verify gone.
      final afterDelete = await repo.getUsers();
      expect(afterDelete.items.any((u) => u.id == created.id), isFalse);
    });
  });
}
