@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:discovery_service/discovery_service.dart';

/// Integration tests for ListingSyncService + DiscoveryRepository against
/// a real SurrealDB instance.
///
/// Requires: `./scripts/test-db-up.sh` to be running on localhost:18000.
void main() {
  const wsUrl = 'ws://localhost:18000/rpc';
  const user = 'bp_portal';
  const pass = 'test-portal-pass';

  late SurrealDB db;

  setUp(() async {
    db = SurrealDB(wsUrl);
    db.connect();
    await db.wait();
    await db.signin(
      user: user,
      pass: pass,
      namespace: 'companies',
      database: 'discovery',
    );
  });

  tearDown(() async {
    // Clean up test data.
    try {
      await db.query(
          'DELETE establishment_listing WHERE company_slug = "test-sync-co"');
      await db.query(
          'DELETE categorized_as WHERE in.company_slug = "test-sync-co"');
    } catch (_) {}
    db.close();
  });

  group('ListingSyncService.syncListing', () {
    test('creates a new establishment_listing record', () async {
      final syncService = ListingSyncService(db);

      final estData = <String, dynamic>{
        'id': 'establishment:test-barber',
        'name': 'Test Barbershop',
        'slug': 'test-barbershop',
        'about': 'The best barbershop in town',
        'address': 'Testgata 1',
        'city': 'Drammen',
        'zip': '3015',
        'country': 'NO',
        'store_type': 'store',
        'category': 'skjonnhet',
        'location': {
          'type': 'Point',
          'coordinates': [10.2045, 59.7441],
        },
        'images': {
          'logo': 'https://example.com/logo.png',
          'cover': 'https://example.com/cover.jpg',
          'gallery': <String>[],
        },
        'is_published': true,
        'is_active': true,
      };

      await syncService.syncListing(
        data: estData,
        companySlug: 'test-sync-co',
      );

      // Verify the record exists in the DB.
      final result = await db.query(
        r'SELECT * FROM establishment_listing WHERE company_slug = $slug',
        {'slug': 'test-sync-co'},
      );

      final rows = _parseRows(result);
      expect(rows, hasLength(1));

      final listing = rows.first;
      expect(listing['name'], 'Test Barbershop');
      expect(listing['slug'], 'test-barbershop');
      expect(listing['about'], 'The best barbershop in town');
      expect(listing['city'], 'Drammen');
      expect(listing['store_type'], 'store');
      expect(listing['is_active'], true);
      expect(listing['logo'], 'https://example.com/logo.png');
      expect(listing['cover'], 'https://example.com/cover.jpg');
    });

    test('upsert updates an existing record on re-sync', () async {
      final syncService = ListingSyncService(db);

      final estData = <String, dynamic>{
        'id': 'establishment:test-barber',
        'name': 'Test Barbershop',
        'slug': 'test-barbershop',
        'address': 'Testgata 1',
        'city': 'Drammen',
        'zip': '3015',
        'store_type': 'store',
      };

      // First sync.
      await syncService.syncListing(
          data: estData, companySlug: 'test-sync-co');

      // Update name and re-sync.
      estData['name'] = 'Test Barbershop V2';
      estData['about'] = 'Now with new management';
      await syncService.syncListing(
          data: estData, companySlug: 'test-sync-co');

      // Verify only one record, with updated data.
      final result = await db.query(
        r'SELECT * FROM establishment_listing WHERE company_slug = $slug',
        {'slug': 'test-sync-co'},
      );

      final rows = _parseRows(result);
      expect(rows, hasLength(1));
      expect(rows.first['name'], 'Test Barbershop V2');
      expect(rows.first['about'], 'Now with new management');
    });

    test('deactivateListing sets is_active to false', () async {
      final syncService = ListingSyncService(db);

      // Create first.
      await syncService.syncListing(
        data: <String, dynamic>{
          'id': 'establishment:test-deactivate',
          'name': 'Deactivate Me',
          'slug': 'deactivate-me',
          'address': 'X',
          'city': 'Y',
          'zip': '0000',
          'store_type': 'store',
        },
        companySlug: 'test-sync-co',
      );

      // Verify active.
      var result = await db.query(
        r'SELECT is_active FROM establishment_listing WHERE company_slug = $slug AND slug = $est_slug',
        {'slug': 'test-sync-co', 'est_slug': 'deactivate-me'},
      );
      expect(_parseRows(result).first['is_active'], true);

      // Deactivate.
      await syncService.deactivateListing(
        companySlug: 'test-sync-co',
        establishmentSlug: 'deactivate-me',
      );

      // Verify deactivated.
      result = await db.query(
        r'SELECT is_active FROM establishment_listing WHERE company_slug = $slug AND slug = $est_slug',
        {'slug': 'test-sync-co', 'est_slug': 'deactivate-me'},
      );
      expect(_parseRows(result).first['is_active'], false);
    });
  });

  group('DiscoveryRepository', () {
    test('fetchListings returns synced listings', () async {
      final syncService = ListingSyncService(db);
      final repo = DiscoveryRepository(db);

      // Sync a listing.
      await syncService.syncListing(
        data: <String, dynamic>{
          'id': 'establishment:fetch-test',
          'name': 'Fetch Test Place',
          'slug': 'fetch-test-place',
          'address': 'Street 1',
          'city': 'Drammen',
          'zip': '3015',
          'store_type': 'restaurant',
        },
        companySlug: 'test-sync-co',
      );

      // Fetch and verify.
      final listings = await repo.fetchListings();
      final match = listings.where((l) => l.companySlug == 'test-sync-co');
      expect(match, isNotEmpty);
      expect(match.first.name, 'Fetch Test Place');
      expect(match.first.storeType, 'restaurant');
    });

    test('fetchCategories returns admin-managed categories', () async {
      final repo = DiscoveryRepository(db);
      final categories = await repo.fetchCategories();
      // Categories are seeded by the admin panel — may be empty in test DB.
      // Just verify the call doesn't throw.
      expect(categories, isA<List<DiscoveryCategory>>());
    });
  });
}

/// Parse SurrealDB query response into rows.
List<Map<String, dynamic>> _parseRows(dynamic result) {
  if (result is List && result.isNotEmpty) {
    final first = result.first;
    if (first is Map && first.containsKey('result')) {
      return (first['result'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          [];
    }
    return result.whereType<Map<String, dynamic>>().toList();
  }
  return [];
}
