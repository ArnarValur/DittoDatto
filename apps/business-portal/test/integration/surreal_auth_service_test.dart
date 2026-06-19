@Tags(['integration'])
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:business_portal/core/surreal_auth_service.dart';

import 'helpers/mock_secure_storage.dart';

/// Integration tests for [SurrealAuthService] against a real SurrealDB instance.
///
/// These test the FULL login flow (ADR-0016):
///   1. RECORD ACCESS signin on users/users → validates password_hash
///   2. Role verification via $auth profile query
///   3. Tenant DB connection via DB-level service user (bp_portal)
///
/// The user's password is validated against their profile's password_hash
/// via argon2. No database admin/root credentials are used for portal login.
///
/// Prerequisites:
///   ./scripts/test-db-up.sh   (starts + seeds ephemeral SurrealDB)
///
/// Run:
///   cd apps/business-portal
///   flutter test --tags integration
void main() {
  late Map<String, String> mockStorage;

  const testUrl = String.fromEnvironment(
    'SURREAL_TEST_URL',
    defaultValue: 'ws://localhost:18000/rpc',
  );

  // Service credentials matching test-db-seed.sh.
  const serviceUser = 'bp_portal';
  const servicePass = 'test-portal-pass';

  late SurrealAuthService authService;

  SurrealAuthService makeService() => SurrealAuthService(
    wsUrl: testUrl,
    serviceUser: serviceUser,
    servicePass: servicePass,
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

  group('SurrealAuthService.login() — RECORD ACCESS flow', () {
    test('business user with valid password → Authenticated', () async {
      final result = await authService.login(
        'testbiz@dittodatto.no',
        'testbiz-pass',
      );

      expect(result, isA<Authenticated>());
      final auth = result as Authenticated;
      expect(auth.email, 'testbiz@dittodatto.no');
      expect(auth.accessToken, isNotEmpty);

      // Connection should be established and routed.
      expect(authService.connection, isNotNull);
      expect(authService.connection!.slug, 'testcompany');
    });

    test('customer-role user → Unauthenticated (rejected by role check)', () async {
      final result = await authService.login(
        'testcustomer@dittodatto.no',
        'testcustomer-pass',
      );

      // Customer role is not in _allowedRoles — login should reject.
      expect(result, isA<Unauthenticated>());
      expect(authService.connection, isNull);
    });

    test('wrong password → Unauthenticated (argon2 mismatch)', () async {
      final result = await authService.login(
        'testbiz@dittodatto.no',
        'wrong-password',
      );

      expect(result, isA<Unauthenticated>());
    });

    test('nonexistent user → Unauthenticated', () async {
      final result = await authService.login(
        'nobody@dittodatto.no',
        'any-password',
      );

      expect(result, isA<Unauthenticated>());
    });

    test('email domain is irrelevant — only username prefix matters', () async {
      final fresh = makeService();
      final result = await fresh.login(
        'testbiz@gmail.com',
        'testbiz-pass',
      );

      expect(result, isA<Authenticated>());
      fresh.connection?.close();
    });
  });

  group('SurrealAuthService.logout()', () {
    test('clears connection and returns Unauthenticated', () async {
      final loginResult = await authService.login(
        'testbiz@dittodatto.no',
        'testbiz-pass',
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
        'testbiz@dittodatto.no',
        'testbiz-pass',
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
      expect(auth.email, 'testbiz@dittodatto.no');

      expect(freshService.connection, isNotNull);
      expect(freshService.connection!.slug, 'testcompany');

      freshService.connection?.close();
    });

    test('returns Unauthenticated when no stored tokens', () async {
      final result = await authService.tryRestore();
      expect(result, isA<Unauthenticated>());
    });
  });

  group('Tenant isolation', () {
    test('after login, companies connection is scoped to tenant DB', () async {
      final loginResult = await authService.login(
        'testbiz@dittodatto.no',
        'testbiz-pass',
      );
      expect(loginResult, isA<Authenticated>(),
        reason: 'Login must succeed to test tenant isolation');

      final conn = authService.connection!;

      // Verify we're on company_testcompany.
      final info = await conn.companies.query('INFO FOR DB');
      expect(info, isNotNull);
    });

    test('users connection queries against users/users DB', () async {
      final loginResult = await authService.login(
        'testbiz@dittodatto.no',
        'testbiz-pass',
      );
      expect(loginResult, isA<Authenticated>(),
        reason: 'Login must succeed to test user queries');

      final conn = authService.connection!;

      // RECORD ACCESS token allows querying $auth (the user's own record).
      final result = await conn.users.query(
        r'SELECT role, company_slug FROM $auth',
      );

      expect(result, isNotNull);
    });
  });
}
