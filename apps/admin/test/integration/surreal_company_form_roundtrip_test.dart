@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:ditto_admin/core/surreal_admin_repository.dart';
import 'package:ditto_admin/core/surreal_connection.dart';

import 'helpers/test_connection.dart';

/// Integration test that mirrors EXACTLY what the company form sends to SurrealDB.
///
/// Every Company object built here replicates companies_screen.dart lines 436-457.
/// Every field matches what the schema (schemas/platform.surql) accepts.
/// No mock data, no happy-path shortcuts — full payload, all enum values,
/// all optional fields, create + read + update + delete.
///
/// Prerequisites:
///   ./scripts/test-db-up.sh
void main() {
  late SurrealConnection connection;
  late SurrealAdminRepository repo;
  final createdUserIds = <String>[];
  final createdCompanyIds = <String>[];

  setUp(() async {
    connection = await connectTestAdmin();
    repo = SurrealAdminRepository(connection: connection);
  });

  tearDown(() async {
    for (final id in createdCompanyIds.reversed) {
      try {
        await repo.deleteCompany(id);
      } catch (_) {}
    }
    createdCompanyIds.clear();

    for (final id in createdUserIds) {
      try {
        await repo.deleteUser(id);
      } catch (_) {}
    }
    createdUserIds.clear();

    connection.close();
  });

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

  /// Builds a Company EXACTLY like the form does.
  /// See companies_screen.dart lines 436-457.
  Company buildFormCompany({
    required String name,
    required String slug,
    required String ownerId,
    String? ownerEmail,
    String email = 'test@test.no',
    String? phone = '92913093',
    String? address = 'Skolegata 9',
    String? city = 'Drammen',
    String? postalCode = '3046',
    CompanyTier tier = CompanyTier.free,
    OnboardingStatus onboardingStatus = OnboardingStatus.notStarted,
    Company? existing,
  }) {
    final now = DateTime.now();
    return Company(
      id: existing?.id ?? 'c${now.millisecondsSinceEpoch}',
      name: name,
      slug: slug,
      email: email,
      phone: phone,
      address: address,
      city: city,
      postalCode: postalCode,
      country: existing?.country ?? 'NO',
      tier: tier,
      onboardingStatus: onboardingStatus,
      ownerId: ownerId,
      ownerEmail: ownerEmail,
      // Form: 'company_${slugCtrl.text.trim()}'
      dbSlug: 'company_$slug',
      description: existing?.description,
      socialLinks: existing?.socialLinks ?? const CompanySocialLinks(),
      storePolicy: existing?.storePolicy ?? const StorePolicy(),
      enabledFeatures: existing?.enabledFeatures ?? const EnabledFeatures(),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
  }

  // ---------------------------------------------------------------------------
  // CREATE — full form payload
  // ---------------------------------------------------------------------------
  group('create: full form payload', () {
    test('all fields persist and round-trip from SurrealDB', () async {
      final owner = await createOwnerUser('Arnar Valur', 'arnarvalur@avj.info');

      final company = buildFormCompany(
        name: 'DittoDatto AS',
        slug: 'dittodatto-as',
        ownerId: owner.id,
        ownerEmail: owner.email,
        email: 'arnarvalur@avj.info',
        tier: CompanyTier.premium,
        onboardingStatus: OnboardingStatus.complete,
      );

      final created = await repo.createCompany(company);
      createdCompanyIds.add(created.id);

      // Verify what came back from CREATE matches
      expect(created.name, 'DittoDatto AS');
      expect(created.slug, 'dittodatto-as');
      expect(created.email, 'arnarvalur@avj.info');
      expect(created.phone, '92913093');
      expect(created.address, 'Skolegata 9');
      expect(created.city, 'Drammen');
      expect(created.postalCode, '3046');
      expect(created.country, 'NO');
      expect(created.tier, CompanyTier.premium);
      expect(created.onboardingStatus, OnboardingStatus.complete);
      expect(created.dbSlug, 'company_dittodatto-as');

      // Now READ it back via getCompanies and verify nothing was lost
      final companies = await repo.getCompanies(page: 1, pageSize: 50);
      final fetched = companies.items.firstWhere((c) => c.id == created.id);

      expect(fetched.name, 'DittoDatto AS');
      expect(fetched.slug, 'dittodatto-as');
      expect(fetched.email, 'arnarvalur@avj.info');
      expect(fetched.phone, '92913093');
      expect(fetched.address, 'Skolegata 9');
      expect(fetched.city, 'Drammen');
      expect(fetched.postalCode, '3046');
      expect(fetched.tier, CompanyTier.premium);
      expect(fetched.onboardingStatus, OnboardingStatus.complete);
      expect(fetched.dbSlug, 'company_dittodatto-as');
    });

    test('optional fields as null do not crash SCHEMAFULL table', () async {
      final owner = await createOwnerUser('Null Owner', 'nullowner@dittodatto.no');

      final company = buildFormCompany(
        name: 'Null Fields Co',
        slug: 'null-fields-co',
        ownerId: owner.id,
        ownerEmail: null,
        email: 'null@test.no',
        phone: null,
        address: null,
        city: null,
        postalCode: null,
      );

      final created = await repo.createCompany(company);
      createdCompanyIds.add(created.id);

      expect(created.name, 'Null Fields Co');
      expect(created.phone, isNull);
      expect(created.address, isNull);
      expect(created.city, isNull);
      expect(created.postalCode, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // ENUM EXHAUSTIVE — every value the dropdown can select must be accepted by DB
  // ---------------------------------------------------------------------------
  group('create: every dropdown value accepted by SurrealDB', () {
    test('all OnboardingStatus values', () async {
      final owner = await createOwnerUser('Status Enum Owner', 'statusenum@dittodatto.no');

      for (final status in OnboardingStatus.values) {
        final company = buildFormCompany(
          name: 'Onboard ${status.value}',
          slug: 'onboard-${status.value}',
          ownerId: owner.id,
          email: '${status.value}@test.no',
          onboardingStatus: status,
        );

        final created = await repo.createCompany(company);
        createdCompanyIds.add(created.id);
        expect(created.onboardingStatus, status,
            reason: '${status.name} must round-trip');
      }
    });

    test('all CompanyTier values', () async {
      final owner = await createOwnerUser('Tier Enum Owner', 'tierenum@dittodatto.no');

      for (final tier in CompanyTier.values) {
        final company = buildFormCompany(
          name: 'Tier ${tier.value}',
          slug: 'tier-${tier.value}',
          ownerId: owner.id,
          email: '${tier.value}@test.no',
          tier: tier,
        );

        final created = await repo.createCompany(company);
        createdCompanyIds.add(created.id);
        expect(created.tier, tier,
            reason: '${tier.name} must round-trip');
      }
    });
  });

  // ---------------------------------------------------------------------------
  // UPDATE — full form payload (edit dialog)
  // ---------------------------------------------------------------------------
  group('update: full form payload', () {
    test('change every mutable field and verify persistence', () async {
      final owner = await createOwnerUser('Update Owner', 'updateowner@dittodatto.no');

      // Create
      final created = await repo.createCompany(buildFormCompany(
        name: 'Before Update',
        slug: 'before-update',
        ownerId: owner.id,
        ownerEmail: owner.email,
        email: 'before@test.no',
        tier: CompanyTier.free,
        onboardingStatus: OnboardingStatus.notStarted,
      ));
      createdCompanyIds.add(created.id);

      // Update with different values for every field the form exposes
      final updated = await repo.updateCompany(buildFormCompany(
        name: 'After Update AS',
        slug: 'before-update', // slug doesn't change on edit
        ownerId: owner.id,
        ownerEmail: owner.email,
        email: 'after@test.no',
        phone: '99887766',
        address: 'Grønland 1',
        city: 'Oslo',
        postalCode: '0188',
        tier: CompanyTier.premium,
        onboardingStatus: OnboardingStatus.verified,
        existing: created,
      ));

      expect(updated.name, 'After Update AS');
      expect(updated.email, 'after@test.no');
      expect(updated.phone, '99887766');
      expect(updated.address, 'Grønland 1');
      expect(updated.city, 'Oslo');
      expect(updated.postalCode, '0188');
      expect(updated.tier, CompanyTier.premium);
      expect(updated.onboardingStatus, OnboardingStatus.verified);

      // Read back and verify persistence
      final companies = await repo.getCompanies(page: 1, pageSize: 50);
      final fetched = companies.items.firstWhere((c) => c.id == created.id);
      expect(fetched.name, 'After Update AS');
      expect(fetched.tier, CompanyTier.premium);
      expect(fetched.onboardingStatus, OnboardingStatus.verified);
      expect(fetched.city, 'Oslo');
    });

    test('cycle through every OnboardingStatus via update', () async {
      final owner = await createOwnerUser('Cycle Owner', 'cycleowner@dittodatto.no');

      final created = await repo.createCompany(buildFormCompany(
        name: 'Cycle Company',
        slug: 'cycle-company',
        ownerId: owner.id,
        email: 'cycle@test.no',
        onboardingStatus: OnboardingStatus.notStarted,
      ));
      createdCompanyIds.add(created.id);

      // Walk through every status via update, as an admin would
      for (final status in OnboardingStatus.values) {
        final updated = await repo.updateCompany(buildFormCompany(
          name: 'Cycle Company',
          slug: 'cycle-company',
          ownerId: owner.id,
          email: 'cycle@test.no',
          onboardingStatus: status,
          existing: created,
        ));
        expect(updated.onboardingStatus, status,
            reason: 'Update to ${status.name} must persist');
      }
    });
  });

  // ---------------------------------------------------------------------------
  // DELETE — verify cleanup
  // ---------------------------------------------------------------------------
  group('delete: full lifecycle', () {
    test('create → read → delete → verify gone', () async {
      final owner = await createOwnerUser('Delete Owner', 'deleteowner@dittodatto.no');

      final created = await repo.createCompany(buildFormCompany(
        name: 'Delete Me Co',
        slug: 'delete-me-co',
        ownerId: owner.id,
        email: 'delete@test.no',
        tier: CompanyTier.premium,
        onboardingStatus: OnboardingStatus.complete,
      ));
      // Don't add to createdCompanyIds — we're deleting it ourselves

      // Verify it exists
      final before = await repo.getCompanies(page: 1, pageSize: 50);
      expect(before.items.any((c) => c.id == created.id), isTrue);

      // Delete
      await repo.deleteCompany(created.id);

      // Verify it's gone
      final after = await repo.getCompanies(page: 1, pageSize: 50);
      expect(after.items.any((c) => c.id == created.id), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // SOCIAL LINKS — verify non-null social links don't crash SCHEMAFULL
  // ---------------------------------------------------------------------------
  group('social_links: schema compliance', () {
    test('company with populated social_links round-trips', () async {
      final owner = await createOwnerUser('Social Owner', 'socialowner@dittodatto.no');

      final now = DateTime.now();
      final company = Company(
        id: 'c${now.millisecondsSinceEpoch}',
        name: 'Social Links Co',
        slug: 'social-links-co',
        email: 'social@test.no',
        ownerId: owner.id,
        ownerEmail: owner.email,
        dbSlug: 'company_social-links-co',
        tier: CompanyTier.free,
        onboardingStatus: OnboardingStatus.notStarted,
        socialLinks: const CompanySocialLinks(
          fb: 'https://facebook.com/test',
          ig: 'https://instagram.com/test',
          x: 'https://x.com/test',
        ),
        storePolicy: const StorePolicy(),
        enabledFeatures: const EnabledFeatures(),
        createdAt: now,
        updatedAt: now,
      );

      final created = await repo.createCompany(company);
      createdCompanyIds.add(created.id);

      expect(created.socialLinks.fb, 'https://facebook.com/test');
      expect(created.socialLinks.ig, 'https://instagram.com/test');
      expect(created.socialLinks.x, 'https://x.com/test');

      // Read back
      final companies = await repo.getCompanies(page: 1, pageSize: 50);
      final fetched = companies.items.firstWhere((c) => c.id == created.id);
      expect(fetched.socialLinks.fb, 'https://facebook.com/test');
      expect(fetched.socialLinks.ig, 'https://instagram.com/test');
      expect(fetched.socialLinks.x, 'https://x.com/test');
    });
  });
}
