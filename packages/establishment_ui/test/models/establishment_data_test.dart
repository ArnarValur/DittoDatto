import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EstablishmentType', () {
    test('has correct Norwegian labels', () {
      expect(EstablishmentType.shop.label, 'Butikk');
      expect(EstablishmentType.restaurant.label, 'Restaurant');
      expect(EstablishmentType.venue.label, 'Spillested');
    });

    test('fromString parses valid values', () {
      expect(EstablishmentType.fromString('store'), EstablishmentType.shop);
      expect(
        EstablishmentType.fromString('restaurant'),
        EstablishmentType.restaurant,
      );
      expect(EstablishmentType.fromString('venue'), EstablishmentType.venue);
    });

    test('fromString defaults to store for unknown values', () {
      expect(EstablishmentType.fromString('unknown'), EstablishmentType.shop);
      expect(EstablishmentType.fromString(''), EstablishmentType.shop);
    });
  });

  group('EstablishmentData', () {
    late EstablishmentData minimal;
    late EstablishmentData full;

    setUp(() {
      minimal = const EstablishmentData(
        name: 'DittoDatto AS',
        establishmentType: EstablishmentType.venue,
        address: 'Skolegata 9',
        city: 'Drammen',
        zip: '3046',
      );

      full = const EstablishmentData(
        name: 'House of the North',
        establishmentType: EstablishmentType.venue,
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
      expect(minimal.establishmentType, EstablishmentType.venue);
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
      expect(updated.establishmentType, EstablishmentType.venue);
    });

    test('equality works for identical data', () {
      const a = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.shop,
        address: 'Addr',
        city: 'City',
        zip: '0000',
      );
      const b = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.shop,
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
        establishmentType: EstablishmentType.shop,
        address: 'Addr',
        city: 'City',
        zip: '0000',
      );
      const b = EstablishmentData(
        name: 'Test B',
        establishmentType: EstablishmentType.shop,
        address: 'Addr',
        city: 'City',
        zip: '0000',
      );

      expect(a, isNot(equals(b)));
    });

    test('media fields default correctly', () {
      expect(minimal.logoUrl, isNull);
      expect(minimal.coverUrl, isNull);
      expect(minimal.galleryUrls, isEmpty);
      expect(minimal.coverLayoutMode, CoverLayoutMode.bento);
    });

    test('hasMedia returns false when no media set', () {
      expect(minimal.hasMedia, false);
    });

    test('hasMedia returns true when coverUrl is set', () {
      final withCover = minimal.copyWith(coverUrl: 'https://img/cover.jpg');
      expect(withCover.hasMedia, true);
    });

    test('hasMedia returns true when galleryUrls is non-empty', () {
      final withGallery = minimal.copyWith(
        galleryUrls: ['https://img/1.jpg', 'https://img/2.jpg'],
      );
      expect(withGallery.hasMedia, true);
    });

    test('copyWith overrides media fields', () {
      final updated = minimal.copyWith(
        logoUrl: 'https://img/logo.png',
        coverUrl: 'https://img/cover.jpg',
        galleryUrls: ['https://img/g1.jpg'],
        coverLayoutMode: CoverLayoutMode.spotlight,
      );

      expect(updated.logoUrl, 'https://img/logo.png');
      expect(updated.coverUrl, 'https://img/cover.jpg');
      expect(updated.galleryUrls, ['https://img/g1.jpg']);
      expect(updated.coverLayoutMode, CoverLayoutMode.spotlight);
      // Unchanged fields preserved
      expect(updated.name, 'DittoDatto AS');
    });

    test('equality includes media fields', () {
      final a = minimal.copyWith(
        coverUrl: 'https://img/cover.jpg',
        galleryUrls: ['https://img/1.jpg'],
        coverLayoutMode: CoverLayoutMode.showcase,
      );
      final b = minimal.copyWith(
        coverUrl: 'https://img/cover.jpg',
        galleryUrls: ['https://img/1.jpg'],
        coverLayoutMode: CoverLayoutMode.showcase,
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality fails when gallery contents differ', () {
      final a = minimal.copyWith(
        galleryUrls: ['https://img/1.jpg'],
      );
      final b = minimal.copyWith(
        galleryUrls: ['https://img/2.jpg'],
      );
      expect(a, isNot(equals(b)));
    });

    test('equality fails when coverLayoutMode differs', () {
      final a = minimal.copyWith(coverLayoutMode: CoverLayoutMode.bento);
      final b = minimal.copyWith(coverLayoutMode: CoverLayoutMode.spotlight);
      expect(a, isNot(equals(b)));
    });
  });

  group('CoverLayoutMode', () {
    test('fromString parses valid values', () {
      expect(CoverLayoutMode.fromString('bento'), CoverLayoutMode.bento);
      expect(CoverLayoutMode.fromString('showcase'), CoverLayoutMode.showcase);
      expect(
        CoverLayoutMode.fromString('spotlight'),
        CoverLayoutMode.spotlight,
      );
    });

    test('fromString defaults to bento for unknown values', () {
      expect(CoverLayoutMode.fromString('unknown'), CoverLayoutMode.bento);
      expect(CoverLayoutMode.fromString(''), CoverLayoutMode.bento);
    });
  });
}
