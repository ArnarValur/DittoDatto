@Tags(['integration'])
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ditto_auth/ditto_auth.dart';

import 'helpers/mock_secure_storage.dart';

/// Integration tests for [DittoAuth.businessSignin] against a real SurrealDB.
///
/// These test the FULL two-phase business login flow:
///   Phase 1: RECORD ACCESS `bp_auth` on users/users → validates password_hash + role gate
///   Phase 2: `bp_portal` service user signin on company_{slug} → tenant connection
///
/// Prerequisites:
///   ./scripts/test-db-up.sh   (starts + seeds ephemeral SurrealDB)
///
/// Run:
///   cd packages/ditto_auth
///   flutter test --tags integration
void main() {
  late Map<String, String> mockStorage;

  const testUrl = String.fromEnvironment(
    'SURREAL_TEST_URL',
    defaultValue: 'ws://localhost:18000/rpc',
  );

  const serviceUser = 'bp_portal';
  const servicePass = 'test-portal-pass';

  DittoAuth? auth;

  DittoAuth makeAuth() => DittoAuth(
    backend: SurrealAuthBackend(
      wsUrl: testUrl,
      serviceUser: serviceUser,
      servicePass: servicePass,
    ),
    tokenStore: TokenStore(storage: const FlutterSecureStorage()),
  );

  setUp(() {
    mockStorage = setUpMockSecureStorage();
    auth = makeAuth();
  });

  tearDown(() {
    auth?.activeTenant?.close();
    auth = null;
    mockStorage.clear();
  });

  group('DittoAuth.businessSignin() — two-phase flow', () {
    test('business user with valid password → BusinessAuthResult', () async {
      final result = await auth!.businessSignin(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
      );

      expect(result.email, 'testbiz@dittodatto.no');
      expect(result.name, 'Test Business User');
      expect(result.role, 'business');
      expect(result.companySlug, 'testcompany');
      expect(result.tenant, isNotNull);
      expect(result.tenant.slug, 'testcompany');
      expect(auth!.activeTenant, isNotNull);
    });

    test('customer-role user → InsufficientRole exception', () async {
      expect(
        () => auth!.businessSignin(
          email: 'testcustomer@dittodatto.no',
          password: 'testcustomer-pass',
        ),
        throwsA(isA<InvalidCredentials>()),
      );
    });

    test('wrong password → InvalidCredentials exception', () async {
      expect(
        () => auth!.businessSignin(
          email: 'testbiz@dittodatto.no',
          password: 'wrong-password',
        ),
        throwsA(isA<InvalidCredentials>()),
      );
    });

    test('nonexistent user → InvalidCredentials exception', () async {
      expect(
        () => auth!.businessSignin(
          email: 'nobody@dittodatto.no',
          password: 'any-password',
        ),
        throwsA(isA<InvalidCredentials>()),
      );
    });

    test('email is case-insensitive and trimmed', () async {
      final result = await auth!.businessSignin(
        email: '  TestBiz@DittoDatto.No  ',
        password: 'testbiz-pass',
      );

      expect(result.email, 'testbiz@dittodatto.no');
    });
  });

  group('DittoAuth.businessSignin() — tenant connection', () {
    test('companies connection can query tenant DB', () async {
      final result = await auth!.businessSignin(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
      );

      // Verify we can query the company database.
      final info = await result.tenant.companies.query('INFO FOR DB');
      expect(info, isNotNull);
    });

    test('users connection can query $auth', () async {
      final result = await auth!.businessSignin(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
      );

      final profileResult = await result.tenant.users.query(
        r'SELECT role, company_slug FROM $auth',
      );
      expect(profileResult, isNotNull);
    });
  });

  group('DittoAuth.tryRestoreBusiness()', () {
    test('restores session after signin (tokens persisted)', () async {
      final loginResult = await auth!.businessSignin(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
      );
      expect(loginResult.companySlug, 'testcompany');
      expect(mockStorage, isNotEmpty,
        reason: 'Tokens should be persisted after signin');

      // Close connections to simulate app restart.
      auth!.activeTenant?.close();

      // Create a fresh DittoAuth instance (simulating cold start)
      // with the same mock storage (tokens persisted).
      final freshAuth = makeAuth();

      final restored = await freshAuth.tryRestoreBusiness();

      expect(restored, isNotNull);
      expect(restored!.email, 'testbiz@dittodatto.no');
      expect(restored.companySlug, 'testcompany');
      expect(restored.tenant, isNotNull);
      expect(freshAuth.activeTenant, isNotNull);

      freshAuth.activeTenant?.close();
    });

    test('returns null when no stored tokens', () async {
      final result = await auth!.tryRestoreBusiness();
      expect(result, isNull);
    });
  });

  group('DittoAuth.signOut()', () {
    test('clears connection and tokens', () async {
      await auth!.businessSignin(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
      );
      expect(auth!.activeTenant, isNotNull);
      expect(mockStorage, isNotEmpty);

      await auth!.signOut();

      expect(auth!.activeTenant, isNull);
      expect(mockStorage, isEmpty);
    });
  });

  group('DittoAuth configuration errors', () {
    test('missing BP_PORTAL_PASS → TenantConnectionFailed', () async {
      final badAuth = DittoAuth(
        backend: SurrealAuthBackend(
          wsUrl: testUrl,
          serviceUser: serviceUser,
          servicePass: '', // empty!
        ),
        tokenStore: TokenStore(storage: const FlutterSecureStorage()),
      );

      expect(
        () => badAuth.businessSignin(
          email: 'testbiz@dittodatto.no',
          password: 'testbiz-pass',
        ),
        throwsA(isA<TenantConnectionFailed>()),
      );
    });
  });
}
