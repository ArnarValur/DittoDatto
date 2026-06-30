import 'package:flutter_test/flutter_test.dart';
import 'package:discovery_service/discovery_service.dart';

void main() {
  group('ListingSyncService.projectToListing', () {
    test('projects establishment data to listing correctly', () {
      final data = <String, dynamic>{
        'id': 'establishment:house-of-the-north',
        'name': 'House of the North',
        'slug': 'house-of-the-north',
        'about': 'Premium barbershop',
        'address': 'Nedre Storgate 23',
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
          'logo': 'https://storage.example.com/logo.png',
          'cover': 'https://storage.example.com/cover.jpg',
          'gallery': ['img1.jpg', 'img2.jpg'],
        },
        'is_published': true,
        'is_active': true,
      };

      final listing = ListingSyncService.projectToListing(
        data: data,
        companySlug: 'dittodatto-as',
      );

      expect(listing.companySlug, 'dittodatto-as');
      expect(listing.sourceId, 'establishment:house-of-the-north');
      expect(listing.name, 'House of the North');
      expect(listing.slug, 'house-of-the-north');
      expect(listing.about, 'Premium barbershop');
      expect(listing.address, 'Nedre Storgate 23');
      expect(listing.city, 'Drammen');
      expect(listing.zip, '3015');
      expect(listing.country, 'NO');
      expect(listing.storeType, 'store');
      expect(listing.category, 'skjonnhet');
      expect(listing.latitude, closeTo(59.7441, 0.001));
      expect(listing.longitude, closeTo(10.2045, 0.001));
      expect(listing.logo, 'https://storage.example.com/logo.png');
      expect(listing.cover, 'https://storage.example.com/cover.jpg');
      expect(listing.isActive, true);
    });

    test('handles missing optional fields gracefully', () {
      final data = <String, dynamic>{
        'id': 'establishment:minimal',
        'name': 'Minimal Place',
        'slug': 'minimal-place',
        'address': 'Street 1',
        'city': 'Oslo',
        'zip': '0001',
        'store_type': 'restaurant',
      };

      final listing = ListingSyncService.projectToListing(
        data: data,
        companySlug: 'test-co',
      );

      expect(listing.about, isNull);
      expect(listing.latitude, isNull);
      expect(listing.longitude, isNull);
      expect(listing.logo, isNull);
      expect(listing.cover, isNull);
      expect(listing.category, isNull);
      expect(listing.storeType, 'restaurant');
    });

    test('handles null images object', () {
      final data = <String, dynamic>{
        'id': 'establishment:no-media',
        'name': 'No Media',
        'slug': 'no-media',
        'address': 'A',
        'city': 'B',
        'zip': 'C',
      };

      final listing = ListingSyncService.projectToListing(
        data: data,
        companySlug: 'co',
      );

      expect(listing.logo, isNull);
      expect(listing.cover, isNull);
    });

    test('handles empty/null fields with defaults', () {
      final data = <String, dynamic>{};

      final listing = ListingSyncService.projectToListing(
        data: data,
        companySlug: 'co',
      );

      expect(listing.name, '');
      expect(listing.slug, '');
      expect(listing.sourceId, '');
      expect(listing.address, '');
      expect(listing.city, '');
      expect(listing.zip, '');
      expect(listing.country, 'NO');
      expect(listing.storeType, 'store');
    });

    test('projected listing toJson is valid for SurrealDB upsert', () {
      final data = <String, dynamic>{
        'id': 'establishment:test',
        'name': 'Test',
        'slug': 'test',
        'about': 'About text',
        'address': 'Street',
        'city': 'Drammen',
        'zip': '3015',
        'store_type': 'venue',
        'category': 'underholdning',
        'location': {
          'type': 'Point',
          'coordinates': [10.2, 59.7],
        },
        'images': {
          'logo': 'logo.png',
          'cover': 'cover.jpg',
        },
      };

      final listing = ListingSyncService.projectToListing(
        data: data,
        companySlug: 'test-co',
      );
      final json = listing.toJson();

      // Required fields present.
      expect(json['company_slug'], 'test-co');
      expect(json['source_id'], 'establishment:test');
      expect(json['name'], 'Test');
      expect(json['slug'], 'test');
      expect(json['store_type'], 'venue');

      // Optional fields present.
      expect(json['about'], 'About text');
      expect(json['category'], 'underholdning');
      expect(json['logo'], 'logo.png');
      expect(json['location'], isA<Map>());

      // Null fields absent (SurrealDB SCHEMAFULL compat).
      expect(json.containsKey('category_ref'), false);
      expect(json.containsKey('aggregate_rating'), false);
    });
  });
}
