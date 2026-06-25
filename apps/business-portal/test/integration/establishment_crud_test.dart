@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:surrealdb/surrealdb.dart';

import 'package:business_portal/features/establishments/establishment_model.dart';

/// Integration tests for Establishment CRUD against real SurrealDB.
///
/// Validates that the [Establishment] model correctly serializes/deserializes
/// with the SCHEMAFULL `establishment` table in `company-blueprint.surql`.
///
/// Key regression: NULL→NONE fix — `option<string>` fields must NOT be sent
/// as JSON `null`; they must be omitted (NONE in SurrealDB).
///
/// Prerequisites:
///   ./scripts/test-db-up.sh   (starts + seeds ephemeral SurrealDB)
///
/// Run:
///   cd apps/business-portal
///   flutter test --tags integration
void main() {
  const testUrl = String.fromEnvironment(
    'SURREAL_TEST_URL',
    defaultValue: 'ws://localhost:18000/rpc',
  );

  // Service credentials for company DB (matches test-db-seed.sh).
  const serviceUser = 'bp_portal';
  const servicePass = 'test-portal-pass';

  late SurrealDB db;

  /// Connect as bp_portal to company_testcompany.
  Future<void> connectDb() async {
    db = SurrealDB(testUrl);
    db.connect();
    await db.wait();
    await db.signin(
      user: serviceUser,
      pass: servicePass,
      namespace: 'companies',
      database: 'company_testcompany',
    );
  }

  /// Helper: extract rows from SurrealDB query result.
  List<Map<String, dynamic>> extractRows(dynamic result) {
    if (result is List && result.isNotEmpty) {
      final first = result.first;
      if (first is Map && first.containsKey('result')) {
        final inner = first['result'];
        if (inner is List) {
          return inner.cast<Map<String, dynamic>>();
        }
      }
      if (first is Map<String, dynamic>) {
        return result.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  setUp(() async {
    await connectDb();
    // Clean slate — delete any leftover establishments from previous runs.
    await db.query('DELETE establishment');
  });

  tearDown(() {
    db.close();
  });

  group('Establishment CREATE', () {
    test('creates a store establishment with required fields only', () async {
      final est = Establishment(
        id: '',
        name: 'Test Butikk',
        slug: 'test-butikk',
        businessType: BusinessType.store,
        address: 'Storgata 1',
        city: 'Drammen',
        zip: '3045',
      );

      final json = est.toJson()..remove('id');
      final result = await db.create('establishment', json);

      expect(result, isNotNull);
      // Verify it can be read back.
      final rows = extractRows(
        await db.query('SELECT * FROM establishment WHERE slug = "test-butikk"'),
      );
      expect(rows, hasLength(1));
      expect(rows.first['name'], 'Test Butikk');
      expect(rows.first['store_type'], 'store');
      expect(rows.first['city'], 'Drammen');
      expect(rows.first['is_published'], false);
      expect(rows.first['is_active'], true);
    });

    test('creates a restaurant establishment', () async {
      final est = Establishment(
        id: '',
        name: 'Test Restaurant',
        slug: 'test-restaurant',
        businessType: BusinessType.restaurant,
        address: 'Bragernes Torg 5',
        city: 'Drammen',
        zip: '3017',
      );

      final json = est.toJson()..remove('id');
      await db.create('establishment', json);

      final rows = extractRows(
        await db.query(
            'SELECT * FROM establishment WHERE slug = "test-restaurant"'),
      );
      expect(rows, hasLength(1));
      expect(rows.first['store_type'], 'restaurant');
    });

    test('creates a venue establishment', () async {
      final est = Establishment(
        id: '',
        name: 'Test Spillested',
        slug: 'test-spillested',
        businessType: BusinessType.venue,
        address: 'Elvegata 10',
        city: 'Drammen',
        zip: '3045',
      );

      final json = est.toJson()..remove('id');
      await db.create('establishment', json);

      final rows = extractRows(
        await db.query(
            'SELECT * FROM establishment WHERE slug = "test-spillested"'),
      );
      expect(rows, hasLength(1));
      expect(rows.first['store_type'], 'venue');
    });

    test('creates establishment with all optional fields populated', () async {
      final est = Establishment(
        id: '',
        name: 'Full Butikk',
        slug: 'full-butikk',
        businessType: BusinessType.store,
        address: 'Kongens Gate 12',
        city: 'Drammen',
        zip: '3045',
        category: 'Beauty',
        phone: '+4712345678',
        email: 'test@butikk.no',
        website: 'https://butikk.no',
        about: 'En testbutikk med alle felter.',
      );

      final json = est.toJson()..remove('id');
      await db.create('establishment', json);

      final rows = extractRows(
        await db.query(
            'SELECT * FROM establishment WHERE slug = "full-butikk"'),
      );
      expect(rows, hasLength(1));
      expect(rows.first['category'], 'Beauty');
      expect(rows.first['phone'], '+4712345678');
      expect(rows.first['email'], 'test@butikk.no');
      expect(rows.first['website'], 'https://butikk.no');
      expect(rows.first['about'], 'En testbutikk med alle felter.');
    });

    test('NULL→NONE regression: optional fields absent → no error', () async {
      // This is the exact scenario that caused the console error.
      // All optional fields are null (the default for a new create dialog).
      final est = Establishment(
        id: '',
        name: 'Minimal Store',
        slug: 'minimal-store',
        businessType: BusinessType.store,
        address: 'Testgata 1',
        city: 'Drammen',
        zip: '3045',
      );

      final json = est.toJson()..remove('id');

      // These keys must NOT be present (null fields are stripped).
      expect(json.containsKey('category'), false,
          reason: 'null category must not be serialized');
      expect(json.containsKey('phone'), false,
          reason: 'null phone must not be serialized');
      expect(json.containsKey('email'), false,
          reason: 'null email must not be serialized');
      expect(json.containsKey('website'), false,
          reason: 'null website must not be serialized');
      expect(json.containsKey('about'), false,
          reason: 'null about must not be serialized');

      // Must NOT throw — this is the bug we're fixing.
      await db.create('establishment', json);

      final rows = extractRows(
        await db.query(
            'SELECT * FROM establishment WHERE slug = "minimal-store"'),
      );
      expect(rows, hasLength(1));
      expect(rows.first['name'], 'Minimal Store');
    });
  });

  group('Establishment READ', () {
    test('SELECT returns all establishments', () async {
      for (final name in ['Alpha', 'Beta', 'Gamma']) {
        final slug = name.toLowerCase();
        await db.create('establishment', {
          'name': name,
          'slug': slug,
          'store_type': 'store',
          'address': 'Gata $name',
          'city': 'Drammen',
          'zip': '3045',
          'country': 'NO',
          'is_published': false,
          'is_active': true,
          'resources_enabled': false,
        });
      }

      final rows = extractRows(
        await db.query('SELECT * FROM establishment'),
      );
      expect(rows.length, 3);
    });

    test('fromJson round-trip preserves all fields', () async {
      await db.create('establishment', {
        'name': 'Round Trip',
        'slug': 'round-trip',
        'store_type': 'restaurant',
        'address': 'Rundgata 1',
        'city': 'Oslo',
        'zip': '0150',
        'country': 'NO',
        'category': 'Restaurant',
        'phone': '+4787654321',
        'email': 'round@trip.no',
        'website': 'https://roundtrip.no',
        'about': 'Test description',
        'is_published': true,
        'is_active': true,
        'resources_enabled': true,
      });

      final rows = extractRows(
        await db.query(
            'SELECT * FROM establishment WHERE slug = "round-trip"'),
      );
      expect(rows, hasLength(1));

      final parsed = Establishment.fromJson(rows.first);
      expect(parsed.name, 'Round Trip');
      expect(parsed.businessType, BusinessType.restaurant);
      expect(parsed.city, 'Oslo');
      expect(parsed.category, 'Restaurant');
      expect(parsed.phone, '+4787654321');
      expect(parsed.isPublished, true);
      expect(parsed.resourcesEnabled, true);
    });
  });

  group('Establishment UPDATE', () {
    test('MERGE updates specific fields without clobbering others', () async {
      await db.create('establishment', {
        'name': 'Before Update',
        'slug': 'update-test',
        'store_type': 'store',
        'address': 'Old Street 1',
        'city': 'Drammen',
        'zip': '3045',
        'country': 'NO',
        'is_published': false,
        'is_active': true,
        'resources_enabled': false,
      });

      // Get the ID.
      final rows = extractRows(
        await db.query(
            'SELECT * FROM establishment WHERE slug = "update-test"'),
      );
      expect(rows, hasLength(1));
      final id = rows.first['id'] as String;

      // Build the updated model.
      final updated = Establishment.fromJson(rows.first).copyWith(
        name: 'After Update',
        address: 'New Street 99',
        phone: '+4799999999',
      );

      final json = updated.toJson();
      json.remove('id');
      json.removeWhere((_, v) => v == null);

      await db.query(
        r'UPDATE type::record("establishment", $id) MERGE $data',
        {'id': id, 'data': json},
      );

      final updatedRows = extractRows(
        await db.query(
            'SELECT * FROM establishment WHERE slug = "update-test"'),
      );
      expect(updatedRows.first['name'], 'After Update');
      expect(updatedRows.first['address'], 'New Street 99');
      expect(updatedRows.first['phone'], '+4799999999');
      // Verify untouched fields are preserved.
      expect(updatedRows.first['city'], 'Drammen');
      expect(updatedRows.first['store_type'], 'store');
    });
  });

  group('Establishment DELETE', () {
    test('DELETE removes the establishment', () async {
      await db.create('establishment', {
        'name': 'To Delete',
        'slug': 'delete-me',
        'store_type': 'store',
        'address': 'Gone Street',
        'city': 'Drammen',
        'zip': '3045',
        'country': 'NO',
        'is_published': false,
        'is_active': true,
        'resources_enabled': false,
      });

      final rows = extractRows(
        await db.query(
            'SELECT * FROM establishment WHERE slug = "delete-me"'),
      );
      expect(rows, hasLength(1));
      final id = rows.first['id'] as String;

      await db.query(
        r'DELETE type::record("establishment", $id)',
        {'id': id},
      );

      final after = extractRows(
        await db.query(
            'SELECT * FROM establishment WHERE slug = "delete-me"'),
      );
      expect(after, isEmpty);
    });
  });

  group('Schema validation', () {
    test('invalid store_type is rejected by ASSERT', () async {
      expect(
        () => db.create('establishment', {
          'name': 'Bad Type',
          'slug': 'bad-type',
          'store_type': 'invalid_type',
          'address': 'Nowhere',
          'city': 'Drammen',
          'zip': '3045',
          'country': 'NO',
          'is_published': false,
          'is_active': true,
          'resources_enabled': false,
        }),
        throwsA(anything),
      );
    });

    test('slug UNIQUE index prevents duplicates', () async {
      final json = {
        'name': 'Unique Test',
        'slug': 'unique-slug',
        'store_type': 'store',
        'address': 'Singular Street',
        'city': 'Drammen',
        'zip': '3045',
        'country': 'NO',
        'is_published': false,
        'is_active': true,
        'resources_enabled': false,
      };

      await db.create('establishment', json);

      // Second create with same slug should fail.
      expect(
        () => db.create('establishment', json),
        throwsA(anything),
      );
    });
  });
}
