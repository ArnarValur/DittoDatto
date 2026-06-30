import 'package:discovery_service/discovery_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace/features/home/establishment_listing_card.dart';

void main() {
  const listing = EstablishmentListing(
    id: 'establishment_listing:test_1',
    companySlug: 'test-company',
    sourceId: 'establishment:abc',
    name: 'House of the North',
    slug: 'house-of-the-north',
    about: 'A cozy salon in Drammen',
    address: 'Grønland 52',
    city: 'Drammen',
    zip: '3045',
    category: 'Skjønnhet',
    categoryRef: 'category:beauty',
    aggregateRating: AggregateRating(average: 4.5, count: 12),
    cover: null,
    logo: null,
  );

  const listingNoCategoryNoRating = EstablishmentListing(
    companySlug: 'test-co',
    sourceId: 'establishment:xyz',
    name: 'Simple Barbershop',
    slug: 'simple-barbershop',
    address: 'Konnerud 1',
    city: 'Drammen',
    zip: '3040',
  );

  Widget buildCard(EstablishmentListing l, {VoidCallback? onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: EstablishmentListingCard(
            listing: l,
            onTap: onTap ?? () {},
          ),
        ),
      ),
    );
  }

  group('EstablishmentListingCard', () {
    testWidgets('renders name, category, rating, and address', (tester) async {
      await tester.pumpWidget(buildCard(listing));

      expect(find.text('House of the North'), findsOneWidget);
      expect(find.text('Skjønnhet'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(12)'), findsOneWidget);
      expect(find.text('Grønland 52, Drammen'), findsOneWidget);
    });

    testWidgets('renders placeholder when no cover image', (tester) async {
      await tester.pumpWidget(buildCard(listing));

      // Should show storefront icon as placeholder
      expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
    });

    testWidgets('omits category chip when category is null', (tester) async {
      await tester.pumpWidget(buildCard(listingNoCategoryNoRating));

      expect(find.text('Simple Barbershop'), findsOneWidget);
      // No category chip
      expect(find.text('Skjønnhet'), findsNothing);
    });

    testWidgets('omits rating when aggregateRating is null', (tester) async {
      await tester.pumpWidget(buildCard(listingNoCategoryNoRating));

      // No star icon
      expect(find.byIcon(Icons.star_rounded), findsNothing);
    });

    testWidgets('calls onTap when card is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildCard(listing, onTap: () => tapped = true),
      );

      await tester.tap(find.text('House of the North'));
      expect(tapped, isTrue);
    });

    testWidgets('renders address-only when city is empty', (tester) async {
      const noCityListing = EstablishmentListing(
        companySlug: 'co',
        sourceId: 'est:1',
        name: 'Test',
        slug: 'test',
        address: 'Some Street 1',
        city: '',
        zip: '0000',
      );
      await tester.pumpWidget(buildCard(noCityListing));

      expect(find.text('Some Street 1'), findsOneWidget);
    });
  });
}
