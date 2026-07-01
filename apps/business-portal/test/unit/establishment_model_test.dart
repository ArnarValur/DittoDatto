import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_portal/features/establishments/establishment_model.dart';

void main() {
  group('EstablishmentType', () {
    test('has three values', () {
      expect(EstablishmentType.values.length, 3);
    });

    test('has shop, restaurant, and venue', () {
      expect(EstablishmentType.values, contains(EstablishmentType.shop));
      expect(EstablishmentType.values, contains(EstablishmentType.restaurant));
      expect(EstablishmentType.values, contains(EstablishmentType.venue));
    });

    test('label returns Norwegian display name', () {
      expect(EstablishmentType.shop.label, 'Butikk');
      expect(EstablishmentType.restaurant.label, 'Restaurant');
      expect(EstablishmentType.venue.label, 'Spillested');
    });

    test('icon returns distinct icons', () {
      final icons = EstablishmentType.values.map((e) => e.icon).toSet();
      expect(icons.length, 3);
    });
  });

  group('Establishment', () {
    final sampleJson = {
      'id': 'establishment:abc123',
      'name': 'Merkurial Studio',
      'slug': 'merkurial-studio',
      'establishment_type': 'shop',
      'category': 'Teknologi',
      'address': 'Grønland 42',
      'city': 'Drammen',
      'zip': '3045',
      'country': 'NO',
      'phone': '+4712345678',
      'email': 'hei@merkurial.no',
      'website': 'https://merkurial.no',
      'about': 'Et teknologistudio.',
      'is_published': true,
      'is_active': true,
      'resources_enabled': false,
    };

    test('fromJson parses all fields', () {
      final est = Establishment.fromJson(sampleJson);

      expect(est.id, 'establishment:abc123');
      expect(est.name, 'Merkurial Studio');
      expect(est.slug, 'merkurial-studio');
      expect(est.establishmentType, EstablishmentType.shop);
      expect(est.category, 'Teknologi');
      expect(est.address, 'Grønland 42');
      expect(est.city, 'Drammen');
      expect(est.zip, '3045');
      expect(est.phone, '+4712345678');
      expect(est.email, 'hei@merkurial.no');
      expect(est.website, 'https://merkurial.no');
      expect(est.about, 'Et teknologistudio.');
      expect(est.isPublished, isTrue);
      expect(est.resourcesEnabled, isFalse);
    });

    test('fromJson handles optional null fields', () {
      final minimalJson = {
        'id': 'establishment:min1',
        'name': 'Minimal',
        'slug': 'minimal',
        'establishment_type': 'restaurant',
        'address': 'Gate 1',
        'city': 'Oslo',
        'zip': '0001',
        'country': 'NO',
        'is_published': false,
        'is_active': true,
        'resources_enabled': false,
      };

      final est = Establishment.fromJson(minimalJson);

      expect(est.id, 'establishment:min1');
      expect(est.establishmentType, EstablishmentType.restaurant);
      expect(est.category, isNull);
      expect(est.phone, isNull);
      expect(est.email, isNull);
      expect(est.website, isNull);
      expect(est.about, isNull);
      expect(est.isPublished, isFalse);
    });

    test('toJson round-trips correctly', () {
      final est = Establishment.fromJson(sampleJson);
      final json = est.toJson();

      expect(json['name'], 'Merkurial Studio');
      expect(json['establishment_type'], 'shop');
      expect(json['city'], 'Drammen');
      expect(json['is_published'], isTrue);

      // Round-trip: fromJson → toJson → fromJson should be identical.
      final roundTripped = Establishment.fromJson(json);
      expect(roundTripped.name, est.name);
      expect(roundTripped.establishmentType, est.establishmentType);
      expect(roundTripped.city, est.city);
    });

    test('establishmentType maps establishment_type string correctly', () {
      expect(
        Establishment.fromJson({...sampleJson, 'establishment_type': 'shop'})
            .establishmentType,
        EstablishmentType.shop,
      );
      expect(
        Establishment.fromJson({...sampleJson, 'establishment_type': 'restaurant'})
            .establishmentType,
        EstablishmentType.restaurant,
      );
      expect(
        Establishment.fromJson({...sampleJson, 'establishment_type': 'venue'})
            .establishmentType,
        EstablishmentType.venue,
      );
    });
  });
}
