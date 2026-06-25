import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EstablishmentType', () {
    test('has correct Norwegian labels', () {
      expect(EstablishmentType.store.label, 'Butikk');
      expect(EstablishmentType.restaurant.label, 'Restaurant');
      expect(EstablishmentType.venue.label, 'Spillested');
    });

    test('fromString parses valid values', () {
      expect(EstablishmentType.fromString('store'), EstablishmentType.store);
      expect(
        EstablishmentType.fromString('restaurant'),
        EstablishmentType.restaurant,
      );
      expect(EstablishmentType.fromString('venue'), EstablishmentType.venue);
    });

    test('fromString defaults to store for unknown values', () {
      expect(EstablishmentType.fromString('unknown'), EstablishmentType.store);
      expect(EstablishmentType.fromString(''), EstablishmentType.store);
    });
  });

  group('EstablishmentData', () {
    late EstablishmentData minimal;
    late EstablishmentData full;

    setUp(() {
      minimal = const EstablishmentData(
        name: 'DittoDatto AS',
        businessType: EstablishmentType.venue,
        address: 'Skolegata 9',
        city: 'Drammen',
        zip: '3046',
      );

      full = const EstablishmentData(
        name: 'House of the North',
        businessType: EstablishmentType.venue,
        address: 'Skolegata 9',
        city: 'Drammen',
        zip: '3046',
        country: 'NO',
        category: 'Underholdning',
        about: 'Et fantastisk spillested i Drammen.',
        phone: '92913093',
        email: 'post@houseofthenorth.no',
        website: 'https://houseofthenorth.no',
        isPublished: true,
      );
    });

    test('constructs with required fields and defaults', () {
      expect(minimal.name, 'DittoDatto AS');
      expect(minimal.businessType, EstablishmentType.venue);
      expect(minimal.address, 'Skolegata 9');
      expect(minimal.city, 'Drammen');
      expect(minimal.zip, '3046');
      expect(minimal.country, 'NO');
      expect(minimal.category, isNull);
      expect(minimal.about, isNull);
      expect(minimal.phone, isNull);
      expect(minimal.email, isNull);
      expect(minimal.website, isNull);
      expect(minimal.isPublished, false);
    });

    test('constructs with all fields populated', () {
      expect(full.name, 'House of the North');
      expect(full.category, 'Underholdning');
      expect(full.about, 'Et fantastisk spillested i Drammen.');
      expect(full.phone, '92913093');
      expect(full.email, 'post@houseofthenorth.no');
      expect(full.website, 'https://houseofthenorth.no');
      expect(full.isPublished, true);
    });

    test('addressLine formats correctly', () {
      expect(minimal.addressLine, 'Skolegata 9, Drammen 3046');
    });

    test('hasContactInfo returns false when all contact fields are null', () {
      expect(minimal.hasContactInfo, false);
    });

    test('hasContactInfo returns true when any contact field is set', () {
      expect(
        minimal.copyWith(phone: '12345678').hasContactInfo,
        true,
      );
      expect(
        minimal.copyWith(email: 'test@test.no').hasContactInfo,
        true,
      );
      expect(
        minimal.copyWith(website: 'https://test.no').hasContactInfo,
        true,
      );
    });

    test('copyWith creates new instance with overrides', () {
      final updated = minimal.copyWith(
        name: 'Updated Name',
        isPublished: true,
        about: 'New description',
      );

      expect(updated.name, 'Updated Name');
      expect(updated.isPublished, true);
      expect(updated.about, 'New description');
      // Unchanged fields preserved
      expect(updated.address, 'Skolegata 9');
      expect(updated.city, 'Drammen');
      expect(updated.businessType, EstablishmentType.venue);
    });

    test('equality works for identical data', () {
      const a = EstablishmentData(
        name: 'Test',
        businessType: EstablishmentType.store,
        address: 'Addr',
        city: 'City',
        zip: '0000',
      );
      const b = EstablishmentData(
        name: 'Test',
        businessType: EstablishmentType.store,
        address: 'Addr',
        city: 'City',
        zip: '0000',
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality fails for different data', () {
      const a = EstablishmentData(
        name: 'Test A',
        businessType: EstablishmentType.store,
        address: 'Addr',
        city: 'City',
        zip: '0000',
      );
      const b = EstablishmentData(
        name: 'Test B',
        businessType: EstablishmentType.store,
        address: 'Addr',
        city: 'City',
        zip: '0000',
      );

      expect(a, isNot(equals(b)));
    });
  });
}
