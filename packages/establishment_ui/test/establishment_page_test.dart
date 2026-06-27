import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a sliver widget in the minimal scaffold needed for testing.
Widget _wrapSliver(Widget sliver) {
  return MaterialApp(
    home: Scaffold(
      body: CustomScrollView(
        slivers: [sliver],
      ),
    ),
  );
}

/// Wraps an [EstablishmentPage] in a test scaffold.
Widget _wrapPage(EstablishmentData data, {bool isPreview = false}) {
  return MaterialApp(
    home: Scaffold(
      body: EstablishmentPage(data: data, isPreview: isPreview),
    ),
  );
}

/// Minimal test data — only required fields.
const _minimal = EstablishmentData(
  name: 'DittoDatto AS',
  businessType: EstablishmentType.venue,
  address: 'Skolegata 9',
  city: 'Drammen',
  zip: '3046',
);

/// Full test data — all text fields populated, NO media URLs.
/// Used for most tests to avoid NetworkImage timer issues.
const _fullText = EstablishmentData(
  name: 'House of the North',
  businessType: EstablishmentType.venue,
  address: 'Skolegata 9',
  city: 'Drammen',
  zip: '3046',
  category: 'Underholdning',
  about: 'Et fantastisk spillested i hjertet av Drammen.',
  phone: '92913093',
  email: 'post@houseofthenorth.no',
  website: 'https://houseofthenorth.no',
  isPublished: true,
);

/// Test data with media URLs (cover + gallery, no logo).
/// Only used in tests that verify widget type presence.
const _withMedia = EstablishmentData(
  name: 'Media Test',
  businessType: EstablishmentType.store,
  address: 'Testgate 1',
  city: 'Oslo',
  zip: '0001',
  coverUrl: 'https://example.com/cover.jpg',
  galleryUrls: ['https://example.com/g1.jpg', 'https://example.com/g2.jpg'],
  coverLayoutMode: CoverLayoutMode.bento,
);

void main() {
  group('EstablishmentPage', () {
    testWidgets('renders without crashing with minimal data', (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal));
      expect(find.text('DittoDatto AS'), findsOneWidget);
    });

    testWidgets('renders all sections with full data', (tester) async {
      await tester.pumpWidget(_wrapPage(_fullText));

      // InfoBar
      expect(find.text('House of the North'), findsOneWidget);
      expect(find.text('Spillested'), findsOneWidget);
      expect(find.text('Skolegata 9, Drammen 3046'), findsOneWidget);
      expect(find.text('Underholdning'), findsOneWidget);

      // AboutGrid
      expect(find.text('Om oss'), findsOneWidget);
      expect(
        find.text('Et fantastisk spillested i hjertet av Drammen.'),
        findsOneWidget,
      );

      // ContactSection
      expect(find.text('Kontakt'), findsOneWidget);
      expect(find.text('92913093'), findsOneWidget);
      expect(find.text('post@houseofthenorth.no'), findsOneWidget);
      expect(find.text('https://houseofthenorth.no'), findsOneWidget);
    });

    testWidgets('shows draft indicator when preview + unpublished',
        (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal, isPreview: true));
      expect(find.text('Utkast — ikke synlig for kunder'), findsOneWidget);
    });

    testWidgets('hides draft indicator when published', (tester) async {
      await tester.pumpWidget(
        _wrapPage(_minimal.copyWith(isPublished: true), isPreview: true),
      );
      expect(find.text('Utkast — ikke synlig for kunder'), findsNothing);
    });

    testWidgets('hides draft indicator when not in preview mode',
        (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal, isPreview: false));
      expect(find.text('Utkast — ikke synlig for kunder'), findsNothing);
    });

    testWidgets('shows gallery placeholder when no media', (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal));
      expect(find.text('Bilder kommer snart'), findsOneWidget);
      expect(find.byType(EstablishmentGalleryPlaceholder), findsOneWidget);
      expect(find.byType(EstablishmentGallerySection), findsNothing);
    });

    testWidgets('shows gallery section when media is present',
        (tester) async {
      // Use runAsync to allow NetworkImage HTTP client to settle
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrapPage(_withMedia));
      });
      expect(find.byType(EstablishmentGallerySection), findsOneWidget);
      expect(find.byType(EstablishmentGalleryPlaceholder), findsNothing);
    });
  });

  group('EstablishmentGalleryPlaceholder', () {
    testWidgets('renders placeholder text', (tester) async {
      await tester.pumpWidget(
        _wrapSliver(const EstablishmentGalleryPlaceholder()),
      );
      expect(find.text('Bilder kommer snart'), findsOneWidget);
      expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
    });
  });

  group('EstablishmentGallerySection', () {
    testWidgets('renders cover image widget when coverUrl is set',
        (tester) async {
      final data = _minimal.copyWith(coverUrl: 'https://example.com/cover.jpg');
      await tester.runAsync(() async {
        await tester.pumpWidget(
          _wrapSliver(EstablishmentGallerySection(data: data)),
        );
      });
      // Image.network creates an Image widget
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders gallery thumbnails when galleryUrls is set',
        (tester) async {
      final data = _minimal.copyWith(
        galleryUrls: [
          'https://example.com/g1.jpg',
          'https://example.com/g2.jpg',
        ],
      );
      await tester.runAsync(() async {
        await tester.pumpWidget(
          _wrapSliver(EstablishmentGallerySection(data: data)),
        );
      });
      // 2 gallery images in the ListView
      expect(find.byType(Image), findsNWidgets(2));
    });

    testWidgets('renders cover + gallery together', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          _wrapSliver(EstablishmentGallerySection(data: _withMedia)),
        );
      });
      // 1 cover + 2 gallery = 3 Image widgets
      expect(find.byType(Image), findsNWidgets(3));
    });
  });

  group('EstablishmentInfoBar', () {
    testWidgets('shows name, type badge, and address', (tester) async {
      await tester.pumpWidget(
        _wrapSliver(const EstablishmentInfoBar(data: _minimal)),
      );

      expect(find.text('DittoDatto AS'), findsOneWidget);
      expect(find.text('Spillested'), findsOneWidget);
      expect(find.text('Skolegata 9, Drammen 3046'), findsOneWidget);
    });

    testWidgets('shows category when present', (tester) async {
      await tester.pumpWidget(
        _wrapSliver(const EstablishmentInfoBar(data: _fullText)),
      );
      expect(find.text('Underholdning'), findsOneWidget);
    });

    testWidgets('hides category when null', (tester) async {
      await tester.pumpWidget(
        _wrapSliver(const EstablishmentInfoBar(data: _minimal)),
      );
      // Only name, badge, and address should appear — no category row
      expect(find.byIcon(Icons.category_outlined), findsNothing);
    });

    testWidgets('shows correct badge for each type', (tester) async {
      for (final type in EstablishmentType.values) {
        await tester.pumpWidget(
          _wrapSliver(
            EstablishmentInfoBar(
              data: _minimal.copyWith(businessType: type),
            ),
          ),
        );
        expect(find.text(type.label), findsOneWidget);
        // Type icon appears twice: avatar fallback + badge
        expect(find.byIcon(type.icon), findsNWidgets(2));
      }
    });

    testWidgets('shows CircleAvatar with fallback icon when no logo',
        (tester) async {
      await tester.pumpWidget(
        _wrapSliver(const EstablishmentInfoBar(data: _minimal)),
      );
      expect(find.byType(CircleAvatar), findsOneWidget);
      // Fallback icon is the business type icon (venue = stadium)
      // The icon appears twice: once in avatar fallback, once in badge
      expect(find.byIcon(Icons.stadium_rounded), findsNWidgets(2));
    });

    testWidgets('CircleAvatar has backgroundImage when logoUrl is set',
        (tester) async {
      final withLogo =
          _minimal.copyWith(logoUrl: 'https://example.com/logo.png');
      await tester.pumpWidget(
        _wrapSliver(EstablishmentInfoBar(data: withLogo)),
      );
      // Let the async image load error propagate
      await tester.pump();

      expect(find.byType(CircleAvatar), findsOneWidget);

      // Verify the CircleAvatar has a backgroundImage (logo wiring)
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundImage, isNotNull);

      // With logo set, the fallback icon child is null,
      // so the business type icon only appears once (in the badge).
      expect(find.byIcon(Icons.stadium_rounded), findsOneWidget);

      // Consume the expected NetworkImageLoadException from the image service
      // (TestWidgetsFlutterBinding returns 400 for all HTTP requests)
      final exception = tester.takeException();
      expect(exception, isA<NetworkImageLoadException>());
    });
  });

  group('EstablishmentAboutGrid', () {
    testWidgets('shows about text when present', (tester) async {
      await tester.pumpWidget(
        _wrapSliver(const EstablishmentAboutGrid(data: _fullText)),
      );
      expect(find.text('Om oss'), findsOneWidget);
      expect(
        find.text('Et fantastisk spillested i hjertet av Drammen.'),
        findsOneWidget,
      );
    });

    testWidgets('hidden when about is null', (tester) async {
      await tester.pumpWidget(
        _wrapSliver(const EstablishmentAboutGrid(data: _minimal)),
      );
      expect(find.text('Om oss'), findsNothing);
    });

    testWidgets('hidden when about is empty string', (tester) async {
      await tester.pumpWidget(
        _wrapSliver(
          EstablishmentAboutGrid(data: _minimal.copyWith(about: '   ')),
        ),
      );
      expect(find.text('Om oss'), findsNothing);
    });
  });

  group('EstablishmentContactSection', () {
    testWidgets('shows all contact fields when present', (tester) async {
      await tester.pumpWidget(
        _wrapSliver(const EstablishmentContactSection(data: _fullText)),
      );
      expect(find.text('Kontakt'), findsOneWidget);
      expect(find.text('92913093'), findsOneWidget);
      expect(find.text('post@houseofthenorth.no'), findsOneWidget);
      expect(find.text('https://houseofthenorth.no'), findsOneWidget);
    });

    testWidgets('hidden when all contact fields are null', (tester) async {
      await tester.pumpWidget(
        _wrapSliver(const EstablishmentContactSection(data: _minimal)),
      );
      expect(find.text('Kontakt'), findsNothing);
    });

    testWidgets('shows only populated contact fields', (tester) async {
      final phoneOnly = _minimal.copyWith(phone: '12345678');
      await tester.pumpWidget(
        _wrapSliver(EstablishmentContactSection(data: phoneOnly)),
      );
      expect(find.text('Kontakt'), findsOneWidget);
      expect(find.text('12345678'), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsNothing);
      expect(find.byIcon(Icons.language_outlined), findsNothing);
    });
  });
}
