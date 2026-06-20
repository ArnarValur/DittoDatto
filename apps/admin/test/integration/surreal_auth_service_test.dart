@Tags(['integration'])
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:ditto_admin/core/surreal_auth_service.dart';

import 'helpers/mock_secure_storage.dart';

/// Integration tests for [SurrealAuthService] against a real SurrealDB instance.
///
/// The Admin Panel uses namespace-level auth (ADR-0007):
///   1. Extract username from email prefix
///   2. Signin as NS user on both `companies` and `users` namespaces
///   3. Store JWT tokens for session persistence
///
/// Prerequisites:
///   ./scripts/test-db-up.sh   (starts + seeds ephemeral SurrealDB)
///
/// Run:
///   cd apps/admin
///   flutter test --tags integration
void main() {
  late Map<String, String> mockStorage;

  const testUrl = 'ws://localhost:18000/rpc';

  late SurrealAuthService authService;

  SurrealAuthService makeService() => SurrealAuthService(
    wsUrl: testUrl,
    storage: const FlutterSecureStorage(),
  );

  setUp(() {
    mockStorage = setUpMockSecureStorage();
    authService = makeService();
  });

  tearDown(() {
    authService.connection?.close();
    mockStorage.clear();
  });

  group('SurrealAuthService.login() — NS-level auth', () {
    test('valid admin credentials → Authenticated', () async {
      // testadmin is created by test-db-seed.sh as NS OWNER on both namespaces.
      final result = await authService.login(
        'testadmin@dittodatto.no',
        'testadmin-pass',
      );

      expect(result, isA<Authenticated>());
      final auth = result as Authenticated;
      expect(auth.email, 'testadmin@dittodatto.no');
      expect(auth.accessToken, isNotEmpty);

      // Connection should be established with both namespace clients.
      expect(authService.connection, isNotNull);
    });

    test('wrong password → Unauthenticated', () async {
      final result = await authService.login(
        'testadmin@dittodatto.no',
        'wrong-password',
      );

      expect(result, isA<Unauthenticated>());
      expect(authService.connection, isNull);
    });

    test('non-existent user → Unauthenticated', () async {
      final result = await authService.login(
        'nobody@dittodatto.no',
        'any-password',
      );

      expect(result, isA<Unauthenticated>());
    });
  });

  group('SurrealAuthService.logout()', () {
    test('clears connection and returns Unauthenticated', () async {
      final loginResult = await authService.login(
        'testadmin@dittodatto.no',
        'testadmin-pass',
      );
      expect(loginResult, isA<Authenticated>(),
        reason: 'Login must succeed before we can test logout');
      expect(authService.connection, isNotNull);

      final result = await authService.logout();
      expect(result, isA<Unauthenticated>());
      expect(authService.connection, isNull);

      // Storage should be cleared.
      expect(mockStorage, isEmpty);
    });
  });

  group('SurrealAuthService.tryRestore()', () {
    test('restores session after login (tokens persisted)', () async {
      final loginResult = await authService.login(
        'testadmin@dittodatto.no',
        'testadmin-pass',
      );
      expect(loginResult, isA<Authenticated>(),
        reason: 'Login must succeed to persist tokens');

      expect(mockStorage, isNotEmpty,
        reason: 'Tokens should be persisted after login');

      // Close the current connection to simulate app restart.
      authService.connection?.close();

      // Create a new service instance (simulating cold start)
      // but with the same mock storage (tokens are persisted).
      final freshService = makeService();

      final restoreResult = await freshService.tryRestore();

      expect(restoreResult, isA<Authenticated>());
      final auth = restoreResult as Authenticated;
      expect(auth.email, 'testadmin@dittodatto.no');

      expect(freshService.connection, isNotNull);

      freshService.connection?.close();
    });

    test('returns Unauthenticated when no stored tokens', () async {
      final result = await authService.tryRestore();
      expect(result, isA<Unauthenticated>());
    });
  });
}
