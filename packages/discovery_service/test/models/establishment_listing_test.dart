import 'package:flutter_test/flutter_test.dart';
import 'package:discovery_service/discovery_service.dart';

void main() {
  group('EstablishmentListing', () {
    test('fromJson parses all fields correctly', () {
      final json = <String, dynamic>{
        'id': 'establishment_listing:abc123',
        'company_slug': 'dittodatto-as',
        'source_id': 'establishment:house-of-the-north',
        'name': 'House of the North',
        'slug': 'house-of-the-north',
        'about': 'Premium barbershop in Drammen',
        'address': 'Nedre Storgate 23',
        'city': 'Drammen',
        'zip': '3015',
        'country': 'NO',
        'location': {
          'type': 'Point',
          'coordinates': [10.2045, 59.7441],
        },
        'logo': 'https://storage.example.com/logo.png',
        'cover': 'https://storage.example.com/cover.jpg',
        'establishment_type': 'shop',
        'category': 'skjonnhet',
        'category_ref': 'category:skjonnhet',
        'aggregate_rating': {'average': 4.8, 'count': 42},
        'favorites_count': 15,
        'is_active': true,
        'keywords': ['barbershop', 'frisør', 'skjegg'],
      };

      final listing = EstablishmentListing.fromJson(json);

      expect(listing.id, 'establishment_listing:abc123');
      expect(listing.companySlug, 'dittodatto-as');
      expect(listing.sourceId, 'establishment:house-of-the-north');
      expect(listing.name, 'House of the North');
      expect(listing.slug, 'house-of-the-north');
      expect(listing.about, 'Premium barbershop in Drammen');
      expect(listing.address, 'Nedre Storgate 23');
      expect(listing.city, 'Drammen');
      expect(listing.zip, '3015');
      expect(listing.country, 'NO');
      expect(listing.latitude, closeTo(59.7441, 0.001));
      expect(listing.longitude, closeTo(10.2045, 0.001));
      expect(listing.logo, 'https://storage.example.com/logo.png');
      expect(listing.cover, 'https://storage.example.com/cover.jpg');
      expect(listing.establishmentType, 'shop');
      expect(listing.category, 'skjonnhet');
      expect(listing.categoryRef, 'category:skjonnhet');
      expect(listing.aggregateRating!.average, 4.8);
      expect(listing.aggregateRating!.count, 42);
      expect(listing.favoritesCount, 15);
      expect(listing.isActive, true);
      expect(listing.keywords, ['barbershop', 'frisør', 'skjegg']);
    });

    test('fromJson handles missing optional fields', () {
      final json = <String, dynamic>{
        'company_slug': 'test-co',
        'source_id': 'establishment:test',
        'name': 'Test Place',
        'slug': 'test-place',
        'address': 'Test Street 1',
        'city': 'Oslo',
        'zip': '0001',
      };

      final listing = EstablishmentListing.fromJson(json);

      expect(listing.id, isNull);
      expect(listing.about, isNull);
      expect(listing.latitude, isNull);
      expect(listing.longitude, isNull);
      expect(listing.logo, isNull);
      expect(listing.cover, isNull);
      expect(listing.category, isNull);
      expect(listing.aggregateRating, isNull);
      expect(listing.favoritesCount, 0);
      expect(listing.isActive, true);
      expect(listing.keywords, isEmpty);
      expect(listing.country, 'NO');
      expect(listing.establishmentType, 'shop');
    });

    test('toJson produces valid SurrealDB payload', () {
      final listing = EstablishmentListing(
        companySlug: 'dittodatto-as',
        sourceId: 'establishment:hotn',
        name: 'House of the North',
        slug: 'house-of-the-north',
        about: 'A barbershop',
        address: 'Nedre Storgate 23',
        city: 'Drammen',
        zip: '3015',
        latitude: 59.7441,
        longitude: 10.2045,
        logo: 'logo.png',
        cover: 'cover.jpg',
        category: 'skjonnhet',
      );

      final json = listing.toJson();

      expect(json['company_slug'], 'dittodatto-as');
      expect(json['name'], 'House of the North');
      expect(json['about'], 'A barbershop');
      expect(json['logo'], 'logo.png');
      expect(json['cover'], 'cover.jpg');
      expect(json['category'], 'skjonnhet');
      expect(json['location'], {
        'type': 'Point',
        'coordinates': [10.2045, 59.7441],
      });
      // Null optional fields should be absent (not null).
      expect(json.containsKey('category_ref'), false);
      expect(json.containsKey('aggregate_rating'), false);
    });

    test('toJson omits location when coordinates are null', () {
      final listing = EstablishmentListing(
        companySlug: 'test',
        sourceId: 'est:1',
        name: 'No Geo',
        slug: 'no-geo',
        address: 'Street',
        city: 'City',
        zip: '0000',
      );

      final json = listing.toJson();
      expect(json.containsKey('location'), false);
    });

    test('equality based on id, companySlug, sourceId, name, slug', () {
      final a = EstablishmentListing(
        id: 'listing:1',
        companySlug: 'co',
        sourceId: 'est:1',
        name: 'Place',
        slug: 'place',
        address: 'A',
        city: 'B',
        zip: 'C',
      );
      final b = EstablishmentListing(
        id: 'listing:1',
        companySlug: 'co',
        sourceId: 'est:1',
        name: 'Place',
        slug: 'place',
        address: 'Different',
        city: 'Different',
        zip: 'Different',
      );
      expect(a, equals(b));
    });

    test('roundtrip: fromJson(toJson) preserves data', () {
      final original = EstablishmentListing(
        companySlug: 'co',
        sourceId: 'est:1',
        name: 'Roundtrip',
        slug: 'roundtrip',
        about: 'Test about',
        address: 'Street',
        city: 'Drammen',
        zip: '3015',
        latitude: 59.74,
        longitude: 10.20,
        logo: 'logo.png',
        establishmentType: 'restaurant',
        category: 'restaurant',
        keywords: ['mat', 'pizza'],
      );

      final roundtripped = EstablishmentListing.fromJson(original.toJson());

      expect(roundtripped.companySlug, original.companySlug);
      expect(roundtripped.name, original.name);
      expect(roundtripped.about, original.about);
      expect(roundtripped.establishmentType, original.establishmentType);
      expect(roundtripped.category, original.category);
      expect(roundtripped.latitude, closeTo(original.latitude!, 0.001));
      expect(roundtripped.longitude, closeTo(original.longitude!, 0.001));
      expect(roundtripped.keywords, original.keywords);
    });
  });

  group('AggregateRating', () {
    test('fromJson parses correctly', () {
      final rating = AggregateRating.fromJson({'average': 4.5, 'count': 100});
      expect(rating.average, 4.5);
      expect(rating.count, 100);
    });

    test('toJson serializes correctly', () {
      final json = AggregateRating(average: 3.7, count: 25).toJson();
      expect(json, {'average': 3.7, 'count': 25});
    });

    test('equality works', () {
      final a = AggregateRating(average: 4.0, count: 10);
      final b = AggregateRating(average: 4.0, count: 10);
      expect(a, equals(b));
    });
  });
}
