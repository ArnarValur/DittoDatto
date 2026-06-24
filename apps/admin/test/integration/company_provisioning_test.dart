@Tags(['integration'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:surrealdb/surrealdb.dart';

import 'package:ditto_admin/core/surreal_admin_repository.dart';
import 'package:ditto_admin/core/surreal_connection.dart';

import 'helpers/test_connection.dart';

/// Integration tests for company database provisioning.
///
/// Verifies the FULL provisioning pipeline:
///   1. `provisionCompanyDatabase` creates the tenant DB
///   2. Blueprint schema is applied (18 tables, 3 relations)
///   3. `bp_portal` service user is created and can authenticate
///   4. `createCompany` + `provisionCompanyDatabase` work together
///   5. `deprovisionCompanyDatabase` cleans up
///   6. BP login succeeds against a provisioned company
///
/// Prerequisites:
///   ./scripts/test-db-up.sh
///
/// Run:
///   cd apps/admin && flutter test --tags integration test/integration/company_provisioning_test.dart
void main() {
  late SurrealConnection connection;
  late SurrealAdminRepository repo;
  late String blueprintSql;

  final createdUserIds = <String>[];
  final createdCompanyIds = <String>[];
  final provisionedSlugs = <String>[];

  // Load the blueprint SQL once for all tests.
  final blueprintFile = File('${Directory.current.parent.parent.path}/schemas/company-blueprint.surql');

  const bpPortalPassword = 'test-portal-pass';

  setUpAll(() async {
    // Verify the blueprint file exists.
    if (!blueprintFile.existsSync()) {
      fail(
        'Blueprint file not found at ${blueprintFile.path}. '
        'Run tests from the project root or apps/admin/ directory.',
      );
    }
    blueprintSql = blueprintFile.readAsStringSync();
  });

  setUp(() async {
    connection = await connectTestAdmin();
    repo = SurrealAdminRepository(connection: connection);
  });

  tearDown(() async {
    // Clean up provisioned databases first.
    for (final slug in provisionedSlugs.reversed) {
      try {
        await repo.deprovisionCompanyDatabase(slug);
      } catch (_) {}
    }
    provisionedSlugs.clear();

    // Clean up companies (registry records).
    for (final id in createdCompanyIds.reversed) {
      try {
        await repo.deleteCompany(id);
      } catch (_) {}
    }
    createdCompanyIds.clear();

    // Clean up users.
    for (final id in createdUserIds) {
      try {
        await repo.deleteUser(id);
      } catch (_) {}
    }
    createdUserIds.clear();

    connection.close();
  });

  /// Unwrap SurrealDB WebSocket SDK query response.
  ///
  /// The SDK returns `[{status: 'OK', result: [...], ...}]`.
  /// This helper drills into the result list.
  List<Map<String, dynamic>> unwrapQueryResult(Object? raw) {
    if (raw is! List || raw.isEmpty) return [];
    final outer = raw.first;
    if (outer is Map && outer.containsKey('result')) {
      final inner = outer['result'];
      if (inner is List) {
        return inner.whereType<Map<String, dynamic>>().toList();
      }
    }
    // Some queries return flat lists without the envelope.
    return raw.whereType<Map<String, dynamic>>().toList();
  }

  /// Helper: create a user that can own companies.
  Future<User> createOwnerUser(String name, String email) async {
    final user = User(
      id: '',
      name: name,
      email: email,
      phone: '12345678',
      role: ActorRole.customer,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final created = await repo.createUser(user, password: 'test-pass');
    createdUserIds.add(created.id);
    return created;
  }

  /// Helper: build a Company.
  Company makeCompany({
    required String name,
    required String slug,
    required String ownerId,
    String email = 'info@test.no',
  }) {
    return Company(
      id: '',
      name: name,
      slug: slug,
      email: email,
      ownerId: ownerId,
      dbSlug: 'company_$slug',
      tier: CompanyTier.free,
      onboardingStatus: OnboardingStatus.notStarted,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  group('provisionCompanyDatabase', () {
    test('creates company database and applies blueprint schema', () async {
      const slug = 'provisionalphatest';

      // First create a registry record (needed for the provisioned flag update).
      final owner = await createOwnerUser('Provision Owner', 'provision-owner@dittodatto.no');
      final company = await repo.createCompany(
        makeCompany(name: 'Provision Alpha', slug: slug, ownerId: owner.id),
      );
      createdCompanyIds.add(company.id);

      // Provision the database.
      await repo.provisionCompanyDatabase(
        slug: slug,
        blueprintSql: blueprintSql,
        bpPortalPassword: bpPortalPassword,
      );
      provisionedSlugs.add(slug);

      // Verify the database exists by querying tables.
      await connection.companies.use('companies', 'company_$slug');

      // Verify core tables exist by trying to SELECT from them.
      final estResult = await connection.companies.query('SELECT * FROM establishment;');
      expect(estResult, isA<List>());

      final svcResult = await connection.companies.query('SELECT * FROM service;');
      expect(svcResult, isA<List>());

      final bookingResult = await connection.companies.query('SELECT * FROM booking;');
      expect(bookingResult, isA<List>());

      final staffResult = await connection.companies.query('SELECT * FROM staff;');
      expect(staffResult, isA<List>());

      final customerResult = await connection.companies.query('SELECT * FROM customer;');
      expect(customerResult, isA<List>());

      // Verify graph edges.
      final offersResult = await connection.companies.query('SELECT * FROM offers;');
      expect(offersResult, isA<List>());

      final worksAtResult = await connection.companies.query('SELECT * FROM works_at;');
      expect(worksAtResult, isA<List>());

      final assignedToResult = await connection.companies.query('SELECT * FROM assigned_to;');
      expect(assignedToResult, isA<List>());
    });

    test('sets provisioned flag to true in registry', () async {
      const slug = 'provisionflagtest';

      final owner = await createOwnerUser('Flag Owner', 'flag-owner@dittodatto.no');
      final company = await repo.createCompany(
        makeCompany(name: 'Flag Test Co', slug: slug, ownerId: owner.id),
      );
      createdCompanyIds.add(company.id);

      await repo.provisionCompanyDatabase(
        slug: slug,
        blueprintSql: blueprintSql,
        bpPortalPassword: bpPortalPassword,
      );
      provisionedSlugs.add(slug);

      // Check registry record.
      await connection.companies.use('companies', 'registry');
      final result = await connection.companies.query(
        r'SELECT provisioned FROM company WHERE slug = $slug',
        {'slug': slug},
      );

      final records = unwrapQueryResult(result);
      expect(records, isNotEmpty, reason: 'Should find the company in registry');
      expect(records.first['provisioned'], isTrue);
    });

    test('bp_portal service user can authenticate', () async {
      const slug = 'bpauthtest';

      final owner = await createOwnerUser('BP Auth Owner', 'bpauth-owner@dittodatto.no');
      final company = await repo.createCompany(
        makeCompany(name: 'BP Auth Co', slug: slug, ownerId: owner.id),
      );
      createdCompanyIds.add(company.id);

      await repo.provisionCompanyDatabase(
        slug: slug,
        blueprintSql: blueprintSql,
        bpPortalPassword: bpPortalPassword,
      );
      provisionedSlugs.add(slug);

      // Try to authenticate as bp_portal on the company database.
      final bpDb = SurrealDB('ws://localhost:18000/rpc');
      bpDb.connect();
      await bpDb.wait();

      try {
        final token = await bpDb.signin(
          user: 'bp_portal',
          pass: bpPortalPassword,
          namespace: 'companies',
          database: 'company_$slug',
        );
        expect(token, isNotEmpty, reason: 'bp_portal should get a valid token');

        // Verify we can query the company database as bp_portal.
        await bpDb.use('companies', 'company_$slug');
        final result = await bpDb.query('SELECT * FROM establishment;');
        expect(result, isA<List>());
      } finally {
        bpDb.close();
      }
    });

    test('is idempotent — double provision does not error', () async {
      const slug = 'idempotenttest';

      final owner = await createOwnerUser('Idempotent Owner', 'idempotent@dittodatto.no');
      final company = await repo.createCompany(
        makeCompany(name: 'Idempotent Co', slug: slug, ownerId: owner.id),
      );
      createdCompanyIds.add(company.id);

      // First provision.
      await repo.provisionCompanyDatabase(
        slug: slug,
        blueprintSql: blueprintSql,
        bpPortalPassword: bpPortalPassword,
      );
      provisionedSlugs.add(slug);

      // Second provision — should not throw.
      await expectLater(
        repo.provisionCompanyDatabase(
          slug: slug,
          blueprintSql: blueprintSql,
          bpPortalPassword: bpPortalPassword,
        ),
        completes,
      );
    });
  });

  group('isCompanyProvisioned', () {
    test('returns false for non-existent database', () async {
      final result = await repo.isCompanyProvisioned('nonexistentslugxyz');
      expect(result, isFalse);
    });

    test('returns true after provisioning', () async {
      const slug = 'checkprovisiontest';

      final owner = await createOwnerUser('Check Owner', 'check-owner@dittodatto.no');
      final company = await repo.createCompany(
        makeCompany(name: 'Check Co', slug: slug, ownerId: owner.id),
      );
      createdCompanyIds.add(company.id);

      await repo.provisionCompanyDatabase(
        slug: slug,
        blueprintSql: blueprintSql,
        bpPortalPassword: bpPortalPassword,
      );
      provisionedSlugs.add(slug);

      final result = await repo.isCompanyProvisioned(slug);
      expect(result, isTrue);
    });
  });

  group('deprovisionCompanyDatabase', () {
    test('removes company database', () async {
      const slug = 'deprovisiontest';

      final owner = await createOwnerUser('Deprovision Owner', 'deprovision@dittodatto.no');
      final company = await repo.createCompany(
        makeCompany(name: 'Deprovision Co', slug: slug, ownerId: owner.id),
      );
      createdCompanyIds.add(company.id);

      // Provision first.
      await repo.provisionCompanyDatabase(
        slug: slug,
        blueprintSql: blueprintSql,
        bpPortalPassword: bpPortalPassword,
      );

      // Verify it exists.
      var exists = await repo.isCompanyProvisioned(slug);
      expect(exists, isTrue);

      // Deprovision.
      await repo.deprovisionCompanyDatabase(slug);

      // Verify it's gone.
      exists = await repo.isCompanyProvisioned(slug);
      expect(exists, isFalse);
    });

    test('sets provisioned flag to false in registry', () async {
      const slug = 'deprovisionflagtest';

      final owner = await createOwnerUser('Deprovision Flag Owner', 'deprov-flag@dittodatto.no');
      final company = await repo.createCompany(
        makeCompany(name: 'Deprovision Flag Co', slug: slug, ownerId: owner.id),
      );
      createdCompanyIds.add(company.id);

      await repo.provisionCompanyDatabase(
        slug: slug,
        blueprintSql: blueprintSql,
        bpPortalPassword: bpPortalPassword,
      );

      // Deprovision.
      await repo.deprovisionCompanyDatabase(slug);

      // Check registry.
      await connection.companies.use('companies', 'registry');
      final result = await connection.companies.query(
        r'SELECT provisioned FROM company WHERE slug = $slug',
        {'slug': slug},
      );

      final records = unwrapQueryResult(result);
      expect(records, isNotEmpty, reason: 'Company should still exist in registry');
      expect(records.first['provisioned'], isFalse);
    });
  });

  group('E2E: createCompany + provision + BP login', () {
    test('full pipeline — create company, provision, then BP can authenticate', () async {
      const slug = 'e2efulltest';

      // 1. Create owner user.
      final owner = await createOwnerUser('E2E Owner', 'e2e-owner@dittodatto.no');

      // 2. Create company (registry record).
      final company = await repo.createCompany(
        makeCompany(name: 'E2E Full Test Co', slug: slug, ownerId: owner.id),
      );
      createdCompanyIds.add(company.id);

      // 3. Provision the company database.
      await repo.provisionCompanyDatabase(
        slug: slug,
        blueprintSql: blueprintSql,
        bpPortalPassword: bpPortalPassword,
      );
      provisionedSlugs.add(slug);

      // 4. Verify BP service user can authenticate.
      final bpDb = SurrealDB('ws://localhost:18000/rpc');
      bpDb.connect();
      await bpDb.wait();

      try {
        final token = await bpDb.signin(
          user: 'bp_portal',
          pass: bpPortalPassword,
          namespace: 'companies',
          database: 'company_$slug',
        );
        expect(token, isNotEmpty);

        // 5. Use the authenticated connection to create test data.
        await bpDb.use('companies', 'company_$slug');

        // Create an establishment (the core entity of a company).
        final estResult = await bpDb.query('''
          CREATE establishment SET
            name = 'E2E Test Salon',
            slug = 'e2e-test-salon',
            address = 'Grønland 1',
            city = 'Drammen',
            zip = '3045',
            country = 'NO',
            is_published = false,
            is_active = true;
        ''');

        expect(estResult, isA<List>());
        // Unwrap the SDK response to check the created record.
        final records = unwrapQueryResult(estResult);
        expect(records, isNotEmpty, reason: 'Should have created an establishment');
        expect(records.first['name'], 'E2E Test Salon');
        expect(records.first['city'], 'Drammen');

        // 6. Verify we can also read it back.
        final readResult = await bpDb.query('SELECT * FROM establishment;');
        final readRecords = unwrapQueryResult(readResult);
        expect(readRecords, isNotEmpty);
        expect(readRecords.first['name'], 'E2E Test Salon');
      } finally {
        bpDb.close();
      }
    });
  });

  group('createCompany auto-provisioning', () {
    test('createCompany auto-provisions when blueprint is configured', () async {
      const slug = 'autoprovisiontest';

      // Create a repo WITH blueprint wired in.
      final autoRepo = SurrealAdminRepository(
        connection: connection,
        blueprintSql: blueprintSql,
        bpPortalPassword: bpPortalPassword,
      );

      final owner = await createOwnerUser('Auto Owner', 'auto-owner@dittodatto.no');
      final company = await autoRepo.createCompany(
        makeCompany(name: 'Auto Provision Co', slug: slug, ownerId: owner.id),
      );
      createdCompanyIds.add(company.id);
      provisionedSlugs.add(slug);

      // The tenant DB should now exist because createCompany called provision.
      final isProvisioned = await autoRepo.isCompanyProvisioned(slug);
      expect(isProvisioned, isTrue, reason: 'createCompany should auto-provision');

      // BP portal should also be able to authenticate.
      final bpDb = SurrealDB('ws://localhost:18000/rpc');
      bpDb.connect();
      await bpDb.wait();

      try {
        final token = await bpDb.signin(
          user: 'bp_portal',
          pass: bpPortalPassword,
          namespace: 'companies',
          database: 'company_$slug',
        );
        expect(token, isNotEmpty, reason: 'bp_portal should authenticate on auto-provisioned DB');
      } finally {
        bpDb.close();
      }
    });
  });

  group('deleteCompany auto-deprovisioning', () {
    test('deleteCompany removes the tenant database', () async {
      const slug = 'autodeprovisiontest';

      // Create a repo WITH blueprint wired in.
      final autoRepo = SurrealAdminRepository(
        connection: connection,
        blueprintSql: blueprintSql,
        bpPortalPassword: bpPortalPassword,
      );

      final owner = await createOwnerUser('AutoDel Owner', 'autodel-owner@dittodatto.no');
      final company = await autoRepo.createCompany(
        makeCompany(name: 'Auto Deprovision Co', slug: slug, ownerId: owner.id),
      );

      // Verify it was provisioned.
      var isProvisioned = await autoRepo.isCompanyProvisioned(slug);
      expect(isProvisioned, isTrue);

      // Delete the company — should also deprovision.
      await autoRepo.deleteCompany(company.id);
      // Don't add to createdCompanyIds — it's already deleted.

      // Verify the tenant DB is gone.
      isProvisioned = await autoRepo.isCompanyProvisioned(slug);
      expect(isProvisioned, isFalse, reason: 'deleteCompany should auto-deprovision');
    });
  });
}
