@Tags(['integration'])
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ditto_auth/ditto_auth.dart';

import 'helpers/mock_secure_storage.dart';

/// Integration tests for [DittoAuth] consumer auth against a real SurrealDB.
///
/// Tests the consumer auth flow via RECORD ACCESS `consumer_auth` on users/users:
///   - SIGNUP: creates user with role='customer', argon2 hashed password
///   - SIGNIN: authenticates existing customer-role users
///   - Session restore: token-based session persistence
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

  DittoAuth? auth;

  // Counter for unique signup emails per test.
  var signupCounter = 0;

  DittoAuth makeAuth() => DittoAuth(
    backend: SurrealAuthBackend(
      wsUrl: testUrl,
      // Consumer auth doesn't need service credentials.
      serviceUser: '',
      servicePass: '',
    ),
    tokenStore: TokenStore(storage: const FlutterSecureStorage()),
  );

  String uniqueEmail() => 'consumer-test-${++signupCounter}@example.com';

  setUp(() {
    mockStorage = setUpMockSecureStorage();
    auth = makeAuth();
  });

  tearDown(() {
    auth?.consumerDb?.close();
    auth = null;
    mockStorage.clear();
  });

  // ── Signup ──

  group('DittoAuth.consumerSignup()', () {
    test('valid signup → ConsumerAuthResult with name, email, userId',
        () async {
      final email = uniqueEmail();
      final result = await auth!.consumerSignup(
        name: 'Test Consumer',
        email: email,
        password: 'password123',
      );

      expect(result.email, email);
      expect(result.name, 'Test Consumer');
      expect(result.userId, isNotEmpty);
    });

    test('duplicate email → throws exception', () async {
      final email = uniqueEmail();

      // First signup succeeds.
      await auth!.consumerSignup(
        name: 'First',
        email: email,
        password: 'password123',
      );

      // Close and recreate auth to avoid connection reuse issues.
      auth?.consumerDb?.close();
      auth = makeAuth();

      // Second signup with same email should fail.
      expect(
        () => auth!.consumerSignup(
          name: 'Second',
          email: email,
          password: 'different-pass',
        ),
        throwsA(isA<DittoAuthException>()),
      );
    });

    test('signup user can query \$auth profile', () async {
      final email = uniqueEmail();
      await auth!.consumerSignup(
        name: 'Profile Test',
        email: email,
        password: 'password123',
      );

      expect(auth!.consumerDb, isNotNull);

      final profileResult = await auth!.consumerDb!.query(
        r'SELECT name, email FROM $auth',
      );
      expect(profileResult, isNotNull);
    });
  });

  // ── Signin ──

  group('DittoAuth.consumerSignin()', () {
    test('seeded customer user → ConsumerAuthResult', () async {
      final result = await auth!.consumerSignin(
        email: 'testcustomer@dittodatto.no',
        password: 'testcustomer-pass',
      );

      expect(result.email, 'testcustomer@dittodatto.no');
      expect(result.name, isNotNull);
    });

    test('wrong password → InvalidCredentials', () async {
      expect(
        () => auth!.consumerSignin(
          email: 'testcustomer@dittodatto.no',
          password: 'wrong-password',
        ),
        throwsA(isA<InvalidCredentials>()),
      );
    });

    test('nonexistent user → InvalidCredentials', () async {
      expect(
        () => auth!.consumerSignin(
          email: 'nobody@example.com',
          password: 'any-password',
        ),
        throwsA(isA<InvalidCredentials>()),
      );
    });

    test('business-role user → rejected by consumer_auth role gate', () async {
      expect(
        () => auth!.consumerSignin(
          email: 'testbiz@dittodatto.no',
          password: 'testbiz-pass',
        ),
        throwsA(isA<InvalidCredentials>()),
      );
    });

    test('email is case-insensitive and trimmed', () async {
      final result = await auth!.consumerSignin(
        email: '  TestCustomer@DittoDatto.No  ',
        password: 'testcustomer-pass',
      );

      expect(result.email, 'testcustomer@dittodatto.no');
    });
  });

  // ── Session Restore ──

  group('DittoAuth.tryRestoreConsumer()', () {
    test('restores session after signin (tokens persisted)', () async {
      final loginResult = await auth!.consumerSignin(
        email: 'testcustomer@dittodatto.no',
        password: 'testcustomer-pass',
      );
      expect(loginResult.email, 'testcustomer@dittodatto.no');
      expect(
        mockStorage,
        isNotEmpty,
        reason: 'Tokens should be persisted after signin',
      );

      // Close connection to simulate app restart.
      auth!.consumerDb?.close();

      // Create fresh DittoAuth with same mock storage.
      final freshAuth = makeAuth();

      final restored = await freshAuth.tryRestoreConsumer();

      expect(restored, isNotNull);
      expect(restored!.email, 'testcustomer@dittodatto.no');

      freshAuth.consumerDb?.close();
    });

    test('returns null when no stored tokens', () async {
      final result = await auth!.tryRestoreConsumer();
      expect(result, isNull);
    });
  });

  // ── Signout ──

  group('DittoAuth.signOut() — consumer', () {
    test('clears connection and tokens', () async {
      await auth!.consumerSignin(
        email: 'testcustomer@dittodatto.no',
        password: 'testcustomer-pass',
      );
      expect(auth!.consumerDb, isNotNull);
      expect(mockStorage, isNotEmpty);

      await auth!.signOut();

      expect(auth!.consumerDb, isNull);
      expect(mockStorage, isEmpty);
    });
  });

  // ── Role Isolation ──

  group('Role isolation', () {
    test('customer user → rejected by bp_auth', () async {
      // Use a separate auth with service creds for business signin.
      final bizAuth = DittoAuth(
        backend: SurrealAuthBackend(
          wsUrl: testUrl,
          serviceUser: 'bp_portal',
          servicePass: 'test-portal-pass',
        ),
        tokenStore: TokenStore(storage: const FlutterSecureStorage()),
      );

      expect(
        () => bizAuth.businessSignin(
          email: 'testcustomer@dittodatto.no',
          password: 'testcustomer-pass',
        ),
        throwsA(isA<InvalidCredentials>()),
      );
    });

    test('business user → rejected by consumer_auth', () async {
      expect(
        () => auth!.consumerSignin(
          email: 'testbiz@dittodatto.no',
          password: 'testbiz-pass',
        ),
        throwsA(isA<InvalidCredentials>()),
      );
    });
  });
}
