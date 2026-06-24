@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_portal/core/surreal_connection.dart';

/// Integration tests for [SurrealConnection] against a real SurrealDB instance.
///
/// Security model (ADR-0016):
/// - User auth: RECORD ACCESS (bp_auth) on users/users — validates password_hash
/// - Company DB: DB-level service user (bp_portal) — deployment credential
///
/// Prerequisites:
///   ./scripts/test-db-up.sh   (starts + seeds ephemeral SurrealDB)
///
/// Run:
///   cd apps/business-portal
///   dart test --tags integration
void main() {
  const testUrl = String.fromEnvironment(
    'SURREAL_TEST_URL',
    defaultValue: 'ws://localhost:18000/rpc',
  );

  // Service credentials for company DB (matches test-db-seed.sh).
  const serviceUser = 'bp_portal';
  const servicePass = 'test-portal-pass';

  group('SurrealConnection.authenticateUser() — RECORD ACCESS', () {
    test('valid business user authenticates via password_hash', () async {
      final result = await SurrealConnection.authenticateUser(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
        url: testUrl,
      );

      expect(result.usersToken, isNotEmpty);
      expect(result.usersToken.split('.').length, 3,
          reason: 'Should be a JWT (3 dot-separated parts)');
      expect(result.profile, isNotNull);
      expect(result.profile['role'], 'business');
      expect(result.profile['company_slug'], 'testcompany');

      result.usersDb.close();
    });

    test('wrong password → throws (argon2 mismatch)', () async {
      expect(
        () => SurrealConnection.authenticateUser(
          email: 'testbiz@dittodatto.no',
          password: 'wrong-password',
          url: testUrl,
        ),
        throwsA(anything),
      );
    });

    test('nonexistent user → throws', () async {
      expect(
        () => SurrealConnection.authenticateUser(
          email: 'nobody@invalid.com',
          password: 'any-password',
          url: testUrl,
        ),
        throwsA(anything),
      );
    });

    test('customer user rejected by bp_auth role gate', () async {
      // With the role gate in bp_auth SIGNIN clause, customer-role users
      // are rejected at the database level — the SIGNIN query returns nothing.
      expect(
        () => SurrealConnection.authenticateUser(
          email: 'testcustomer@dittodatto.no',
          password: 'testcustomer-pass',
          url: testUrl,
        ),
        throwsA(anything),
      );
    });
  });

  group('SurrealConnection.connectTenant() — DB-level service user', () {
    test('connects to tenant DB with service credentials', () async {
      // Phase 1: authenticate user.
      final auth = await SurrealConnection.authenticateUser(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
        url: testUrl,
      );

      // Phase 2: connect to tenant DB.
      final tenant = await SurrealConnection.connectTenant(
        usersDb: auth.usersDb,
        usersToken: auth.usersToken,
        slug: 'testcompany',
        serviceUser: serviceUser,
        servicePass: servicePass,
        url: testUrl,
      );

      expect(tenant.companiesToken, isNotEmpty);
      expect(tenant.companiesToken.split('.').length, 3);
      expect(tenant.connection.slug, 'testcompany');

      // Verify we can query the tenant DB.
      final info = await tenant.connection.companies.query('INFO FOR DB');
      expect(info, isNotNull);

      tenant.connection.close();
    });

    test('wrong service password → throws', () async {
      final auth = await SurrealConnection.authenticateUser(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
        url: testUrl,
      );

      expect(
        () => SurrealConnection.connectTenant(
          usersDb: auth.usersDb,
          usersToken: auth.usersToken,
          slug: 'testcompany',
          serviceUser: serviceUser,
          servicePass: 'wrong-service-pass',
          url: testUrl,
        ),
        throwsA(anything),
      );

      auth.usersDb.close();
    });

    test('nonexistent tenant DB → throws or empty', () async {
      final auth = await SurrealConnection.authenticateUser(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
        url: testUrl,
      );

      // bp_portal user only exists on company_testcompany.
      // Trying to auth on a nonexistent DB should fail.
      expect(
        () => SurrealConnection.connectTenant(
          usersDb: auth.usersDb,
          usersToken: auth.usersToken,
          slug: 'does_not_exist',
          serviceUser: serviceUser,
          servicePass: servicePass,
          url: testUrl,
        ),
        throwsA(anything),
      );

      auth.usersDb.close();
    });
  });

  group('SurrealConnection.connectWithTokens() — session restore', () {
    test('reconnects with valid tokens from a previous session', () async {
      // Full login flow.
      final auth = await SurrealConnection.authenticateUser(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
        url: testUrl,
      );
      final tenant = await SurrealConnection.connectTenant(
        usersDb: auth.usersDb,
        usersToken: auth.usersToken,
        slug: 'testcompany',
        serviceUser: serviceUser,
        servicePass: servicePass,
        url: testUrl,
      );

      final companiesToken = tenant.companiesToken;
      final usersToken = tenant.usersToken;
      tenant.connection.close();

      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Session restore with saved tokens.
      final restored = await SurrealConnection.connectWithTokens(
        companiesToken: companiesToken,
        usersToken: usersToken,
        slug: 'testcompany',
        url: testUrl,
      );

      expect(restored.slug, 'testcompany');

      // Verify restored connection can query.
      final info = await restored.companies.query('INFO FOR DB');
      expect(info, isNotNull);

      restored.close();
    });

    test('garbage tokens → throws', () async {
      expect(
        () => SurrealConnection.connectWithTokens(
          companiesToken: 'garbage.token.value',
          usersToken: 'garbage.token.value',
          url: testUrl,
        ),
        throwsA(anything),
      );
    });

    test('respects 5-second timeout', () async {
      final stopwatch = Stopwatch()..start();

      try {
        await SurrealConnection.connectWithTokens(
          companiesToken: 'invalid',
          usersToken: 'invalid',
          url: testUrl,
        );
      } catch (_) {
        // Expected.
      }

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(10000));
    });
  });

  group('SurrealConnection.close()', () {
    test('closes without error', () async {
      final auth = await SurrealConnection.authenticateUser(
        email: 'testbiz@dittodatto.no',
        password: 'testbiz-pass',
        url: testUrl,
      );
      final tenant = await SurrealConnection.connectTenant(
        usersDb: auth.usersDb,
        usersToken: auth.usersToken,
        slug: 'testcompany',
        serviceUser: serviceUser,
        servicePass: servicePass,
        url: testUrl,
      );

      // Should not throw.
      tenant.connection.close();
    });
  });
}
