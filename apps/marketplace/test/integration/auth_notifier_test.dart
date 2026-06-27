@Tags(['integration'])
library;

import 'package:ditto_auth/ditto_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace/core/auth_provider.dart';
import 'package:mercury_client/mercury_client.dart';

import 'helpers/mock_secure_storage.dart';

const testUrl = String.fromEnvironment(
  'SURREAL_TEST_URL',
  defaultValue: 'ws://localhost:18000/rpc',
);

var _emailCounter = 0;
String uniqueEmail() => 'mkt-test-${++_emailCounter}@integration.test';

DittoAuth makeTestAuth() => DittoAuth(
      backend: SurrealAuthBackend(
        wsUrl: testUrl,
        serviceUser: '',
        servicePass: '',
      ),
    );

void main() {
  late Map<String, String> mockStorage;

  setUp(() {
    mockStorage = setUpMockSecureStorage();
  });

  group('AuthNotifier.signup()', () {
    test('valid signup → Authenticated with name and email', () async {
      final email = uniqueEmail();
      final testAuth = makeTestAuth();
      final container = ProviderContainer(
        overrides: [
          dittoAuthProvider.overrideWithValue(testAuth),
        ],
      );
      addTearDown(() {
        testAuth.consumerDb?.close();
        container.dispose();
      });

      // Wait for initial build.
      await container.read(authProvider.future);

      await container.read(authProvider.notifier).signup(
            'Test User',
            email,
            'strong-password-123',
          );

      final state = container.read(authProvider).value;
      expect(state, isA<Authenticated>());
      final auth = state as Authenticated;
      expect(auth.email, email);
      expect(auth.name, 'Test User');
    });

    test('duplicate email → AuthError', () async {
      final email = uniqueEmail();
      final testAuth = makeTestAuth();
      final container = ProviderContainer(
        overrides: [
          dittoAuthProvider.overrideWithValue(testAuth),
        ],
      );
      addTearDown(() {
        testAuth.consumerDb?.close();
        container.dispose();
      });

      await container.read(authProvider.future);

      // First signup succeeds.
      await container.read(authProvider.notifier).signup(
            'First User',
            email,
            'password-123',
          );
      expect(container.read(authProvider).value, isA<Authenticated>());

      // Second signup with same email → AuthError.
      await container.read(authProvider.notifier).signup(
            'Second User',
            email,
            'password-456',
          );
      final state = container.read(authProvider).value;
      expect(state, isA<AuthError>());
    });
  });

  group('AuthNotifier.login()', () {
    test('seeded customer → Authenticated', () async {
      final testAuth = makeTestAuth();
      final container = ProviderContainer(
        overrides: [
          dittoAuthProvider.overrideWithValue(testAuth),
        ],
      );
      addTearDown(() {
        testAuth.consumerDb?.close();
        container.dispose();
      });

      await container.read(authProvider.future);

      await container.read(authProvider.notifier).login(
            'testcustomer@dittodatto.no',
            'testcustomer-pass',
          );

      final state = container.read(authProvider).value;
      expect(state, isA<Authenticated>());
      final auth = state as Authenticated;
      expect(auth.email, 'testcustomer@dittodatto.no');
    });

    test('wrong password → Unauthenticated', () async {
      final testAuth = makeTestAuth();
      final container = ProviderContainer(
        overrides: [
          dittoAuthProvider.overrideWithValue(testAuth),
        ],
      );
      addTearDown(() {
        testAuth.consumerDb?.close();
        container.dispose();
      });

      await container.read(authProvider.future);

      await container.read(authProvider.notifier).login(
            'testcustomer@dittodatto.no',
            'totally-wrong-password',
          );

      final state = container.read(authProvider).value;
      expect(state, isA<Unauthenticated>());
    });
  });

  group('AuthNotifier.logout()', () {
    test('clears auth state', () async {
      final testAuth = makeTestAuth();
      final container = ProviderContainer(
        overrides: [
          dittoAuthProvider.overrideWithValue(testAuth),
        ],
      );
      addTearDown(() {
        testAuth.consumerDb?.close();
        container.dispose();
      });

      await container.read(authProvider.future);

      // Login first.
      await container.read(authProvider.notifier).login(
            'testcustomer@dittodatto.no',
            'testcustomer-pass',
          );
      expect(container.read(authProvider).value, isA<Authenticated>());

      // Logout.
      await container.read(authProvider.notifier).logout();

      final state = container.read(authProvider).value;
      expect(state, isA<Unauthenticated>());
    });
  });

  group('Session restore', () {
    test('restores session after signup', () async {
      final testAuth = makeTestAuth();
      final email = uniqueEmail();

      // First container: signup.
      final container1 = ProviderContainer(
        overrides: [
          dittoAuthProvider.overrideWithValue(testAuth),
        ],
      );
      addTearDown(() => container1.dispose());

      await container1.read(authProvider.future);
      await container1.read(authProvider.notifier).signup(
            'Restore User',
            email,
            'restore-pass-123',
          );
      expect(container1.read(authProvider).value, isA<Authenticated>());

      // Second container: same DittoAuth, session should restore.
      final container2 = ProviderContainer(
        overrides: [
          dittoAuthProvider.overrideWithValue(testAuth),
        ],
      );
      addTearDown(() {
        testAuth.consumerDb?.close();
        container2.dispose();
      });

      final restored = await container2.read(authProvider.future);
      expect(restored, isA<Authenticated>());
      final auth = restored as Authenticated;
      expect(auth.email, email);
    });

    test('no stored session → Unauthenticated', () async {
      final testAuth = makeTestAuth();
      final container = ProviderContainer(
        overrides: [
          dittoAuthProvider.overrideWithValue(testAuth),
        ],
      );
      addTearDown(() {
        testAuth.consumerDb?.close();
        container.dispose();
      });

      mockStorage.clear();

      final state = await container.read(authProvider.future);
      expect(state, isA<Unauthenticated>());
    });
  });
}
