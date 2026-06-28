import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps an [EstablishmentPage] in a test scaffold at the given [width].
Widget _wrapPage(
  EstablishmentData data, {
  bool isPreview = false,
  double width = 400,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: width,
        child: EstablishmentPage(data: data, isPreview: isPreview),
      ),
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


void main() {
  group('EstablishmentPage — Mobile (compact)', () {
    testWidgets('renders without crashing with minimal data', (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal));
      expect(find.text('DittoDatto AS'), findsOneWidget);
    });

    testWidgets('renders all sections with full data', (tester) async {
      await tester.pumpWidget(_wrapPage(_fullText));

      // InfoBar
      expect(find.text('House of the North'), findsOneWidget);
      expect(find.text('Skolegata 9, Drammen 3046'), findsOneWidget);

      // Scroll down to reveal about and contact sections.
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // AboutGrid
      expect(find.text('Om oss'), findsAtLeast(1));
      expect(
        find.text('Et fantastisk spillested i hjertet av Drammen.'),
        findsOneWidget,
      );

      // ContactSection — "Kontakt" appears in shortcuts and section header.
      expect(find.text('Kontakt'), findsAtLeast(1));
      expect(find.text('92913093'), findsOneWidget);
      expect(find.text('post@houseofthenorth.no'), findsOneWidget);
      expect(find.text('https://houseofthenorth.no'), findsOneWidget);
    });

    testWidgets('shows draft indicator when preview + unpublished',
        (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal, isPreview: true));
      await tester.pumpAndSettle();
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
    });

    testWidgets('shows action buttons on mobile', (tester) async {
      await tester.pumpWidget(_wrapPage(_fullText));
      expect(find.text('Bestill time'), findsOneWidget);
      expect(find.text('Lagre'), findsOneWidget);
    });

    testWidgets('shows action buttons in preview mode too', (tester) async {
      await tester.pumpWidget(_wrapPage(_fullText, isPreview: true));
      expect(find.text('Bestill time'), findsOneWidget);
      expect(find.text('Lagre'), findsOneWidget);
    });


  });

  group('EstablishmentPage — Wide (tablet/desktop)', () {
    testWidgets('renders with horizontal info bar at wide width',
        (tester) async {
      await tester.pumpWidget(_wrapPage(_fullText, width: 900));
      // Name still visible
      expect(find.text('House of the North'), findsOneWidget);
      // Action buttons should be in the info bar on wide layout
      expect(find.text('Bestill time'), findsOneWidget);
      expect(find.text('Lagre'), findsOneWidget);
    });

    testWidgets('shows action buttons in preview mode at wide width',
        (tester) async {
      await tester.pumpWidget(
        _wrapPage(_fullText, isPreview: true, width: 900),
      );
      expect(find.text('Bestill time'), findsOneWidget);
      expect(find.text('Lagre'), findsOneWidget);
    });

    testWidgets('shows map placeholder in contact section at wide width',
        (tester) async {
      await tester.pumpWidget(_wrapPage(_fullText, width: 900));
      // Scroll to find the map placeholder
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      expect(find.text('Kart kommer snart'), findsOneWidget);
    });

    testWidgets('shows address in contact section at wide width',
        (tester) async {
      await tester.pumpWidget(_wrapPage(_fullText, width: 900));
      // Scroll down
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      // Address line should appear in the contact section on wide
      expect(find.text('Skolegata 9, Drammen 3046'), findsAtLeast(1));
    });

    testWidgets('shows gallery placeholder at wide height', (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal, width: 900));
      expect(find.text('Bilder kommer snart'), findsOneWidget);
    });
  });

  group('EstablishmentInfoBar', () {
    testWidgets('shows name and address in mobile layout', (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal));
      expect(find.text('DittoDatto AS'), findsOneWidget);
      expect(find.text('Skolegata 9, Drammen 3046'), findsOneWidget);
    });

    testWidgets('shows CircleAvatar with fallback icon when no logo',
        (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal));
      expect(find.byType(CircleAvatar), findsOneWidget);
      // Fallback icon is the business type icon (venue = stadium)
      expect(find.byIcon(Icons.stadium_rounded), findsAtLeast(1));
    });

    testWidgets('CircleAvatar has backgroundImage when logoUrl is set',
        (tester) async {
      final withLogo =
          _minimal.copyWith(logoUrl: 'https://example.com/logo.png');
      await tester.pumpWidget(_wrapPage(withLogo));
      // Let the async image load error propagate
      await tester.pump();

      expect(find.byType(CircleAvatar), findsOneWidget);

      // Verify the CircleAvatar has a backgroundImage (logo wiring)
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundImage, isNotNull);

      // Consume the expected NetworkImageLoadException from the image service
      final exception = tester.takeException();
      expect(exception, isA<NetworkImageLoadException>());
    });
  });

  group('EstablishmentAboutGrid', () {
    testWidgets('shows about text when present', (tester) async {
      await tester.pumpWidget(_wrapPage(_fullText));
      // Scroll down to reach the about section.
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      expect(find.text('Om oss'), findsAtLeast(1));
      expect(
        find.text('Et fantastisk spillested i hjertet av Drammen.'),
        findsOneWidget,
      );
    });

    testWidgets('hidden when about is null', (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal));
      // "Om oss" appears in shortcuts but not as a section header
      // since there's no about text
      expect(
        find.text('Et fantastisk spillested i hjertet av Drammen.'),
        findsNothing,
      );
    });
  });

  group('EstablishmentContactSection', () {
    testWidgets('shows all contact fields when present', (tester) async {
      await tester.pumpWidget(_wrapPage(_fullText));
      // Scroll down to find contact section
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // "Kontakt" appears in shortcuts chip and section header.
      expect(find.text('Kontakt'), findsAtLeast(1));
      expect(find.text('92913093'), findsOneWidget);
      expect(find.text('post@houseofthenorth.no'), findsOneWidget);
      expect(find.text('https://houseofthenorth.no'), findsOneWidget);
    });

    testWidgets('hidden when all contact fields are null on mobile',
        (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal));
      // Scroll to bottom
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Contact section card is hidden, but "Kontakt" chip is in shortcuts.
      // Verify phone/email/website icons are absent (contact section hidden)
      expect(find.byIcon(Icons.phone_outlined), findsNothing);
      expect(find.byIcon(Icons.email_outlined), findsNothing);
    });
  });

  group('EstablishmentGallerySection — Layout Modes', () {
    // Gallery URLs for testing. These won't load in tests (no HTTP),
    // but they exercise the layout structure and widget tree.
    const galleryUrls = [
      'https://example.com/1.jpg',
      'https://example.com/2.jpg',
      'https://example.com/3.jpg',
      'https://example.com/4.jpg',
      'https://example.com/5.jpg',
    ];

    final bentoData = _fullText.copyWith(
      coverUrl: 'https://example.com/cover.jpg',
      galleryUrls: galleryUrls,
      coverLayoutMode: CoverLayoutMode.bento,
    );

    final showcaseData = _fullText.copyWith(
      coverUrl: 'https://example.com/cover.jpg',
      galleryUrls: galleryUrls,
      coverLayoutMode: CoverLayoutMode.showcase,
    );

    final spotlightData = _fullText.copyWith(
      coverUrl: 'https://example.com/cover.jpg',
      galleryUrls: galleryUrls,
      coverLayoutMode: CoverLayoutMode.spotlight,
    );

    // ── Bento Grid ────────────────────────────────────────────────────

    testWidgets('Bento Grid: renders 2×2 thumbnail grid at wide width',
        (tester) async {
      await tester.pumpWidget(_wrapPage(bentoData, width: 900));
      await tester.pump();

      // Bento grid has a Row with 2 Expanded children (hero + thumbnail grid).
      // The gallery section renders Image.network widgets for cover + thumbnails.
      // At wide width with bento mode, we should NOT find SingleChildScrollView
      // (that's the Showcase scroll strip).
      expect(find.byType(SingleChildScrollView), findsNothing);

      // Should find Image.network widgets for cover + up to 4 thumbnails.
      expect(find.byType(Image), findsAtLeast(1));
    });

    testWidgets('Bento Grid: shows placeholder when no media at wide width',
        (tester) async {
      final noMedia = _minimal.copyWith(coverLayoutMode: CoverLayoutMode.bento);
      await tester.pumpWidget(_wrapPage(noMedia, width: 900));
      expect(find.text('Bilder kommer snart'), findsOneWidget);
    });

    // ── Showcase ──────────────────────────────────────────────────────

    testWidgets(
        'Showcase: renders auto-scrolling strip at wide width',
        (tester) async {
      await tester.pumpWidget(_wrapPage(showcaseData, width: 900));
      await tester.pump();

      // Showcase layout has a SingleChildScrollView for the auto-scroll strip.
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Auto-scroll uses NeverScrollableScrollPhysics (no manual scroll).
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.physics, isA<NeverScrollableScrollPhysics>());

      // Should find Image.network widgets for the gallery thumbnails.
      expect(find.byType(Image), findsAtLeast(1));
    });

    testWidgets('Showcase: shows placeholder when no gallery images',
        (tester) async {
      final coverOnly = _fullText.copyWith(
        coverUrl: 'https://example.com/cover.jpg',
        galleryUrls: const [],
        coverLayoutMode: CoverLayoutMode.showcase,
      );
      await tester.pumpWidget(_wrapPage(coverOnly, width: 900));
      await tester.pump();

      // With no gallery images, the strip should show a placeholder
      // (no SingleChildScrollView because no images to scroll).
      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    testWidgets('Showcase: shows placeholder when no media at all',
        (tester) async {
      final noMedia =
          _minimal.copyWith(coverLayoutMode: CoverLayoutMode.showcase);
      await tester.pumpWidget(_wrapPage(noMedia, width: 900));
      expect(find.text('Bilder kommer snart'), findsOneWidget);
    });

    // ── Spotlight ─────────────────────────────────────────────────────

    testWidgets('Spotlight: renders full-width cover at wide width',
        (tester) async {
      await tester.pumpWidget(_wrapPage(spotlightData, width: 900));
      await tester.pump();

      // Spotlight has NO thumbnail grid or scroll strip.
      expect(find.byType(SingleChildScrollView), findsNothing);

      // Should find exactly 1 Image.network for the cover.
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Spotlight: shows Se bilder pill when gallery has images',
        (tester) async {
      await tester.pumpWidget(_wrapPage(spotlightData, width: 900));
      await tester.pump();

      // totalPhotoCount = 1 (cover) + 5 (gallery) = 6
      expect(find.textContaining('Se bilder'), findsOneWidget);
    });

    testWidgets('Spotlight: shows placeholder when no media at all',
        (tester) async {
      final noMedia =
          _minimal.copyWith(coverLayoutMode: CoverLayoutMode.spotlight);
      await tester.pumpWidget(_wrapPage(noMedia, width: 900));
      expect(find.text('Bilder kommer snart'), findsOneWidget);
    });

    // ── Mobile stays same across modes ────────────────────────────────

    testWidgets('Mobile layout is identical regardless of layout mode',
        (tester) async {
      // All 3 modes at compact width should render the same mobile layout
      // (single cover, no grid, no scroll strip).
      for (final mode in CoverLayoutMode.values) {
        final data = _fullText.copyWith(
          coverUrl: 'https://example.com/cover.jpg',
          galleryUrls: galleryUrls,
          coverLayoutMode: mode,
        );
        await tester.pumpWidget(_wrapPage(data, width: 400));
        await tester.pump();

        // No thumbnail grid or scroll strip on mobile.
        expect(
          find.byType(SingleChildScrollView),
          findsNothing,
          reason: 'Mode $mode should not show scroll strip on mobile',
        );
      }
    });
  });
}
