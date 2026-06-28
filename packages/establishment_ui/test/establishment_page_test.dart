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

    testWidgets('shows section shortcuts', (tester) async {
      await tester.pumpWidget(_wrapPage(_fullText));
      expect(find.text('Om oss'), findsAtLeast(1));
      expect(find.text('Kontakt'), findsAtLeast(1));
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
}
