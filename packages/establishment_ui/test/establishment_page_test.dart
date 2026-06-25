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

/// Full test data — all fields populated.
const _full = EstablishmentData(
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
  group('EstablishmentPage', () {
    testWidgets('renders without crashing with minimal data', (tester) async {
      await tester.pumpWidget(_wrapPage(_minimal));
      expect(find.text('DittoDatto AS'), findsOneWidget);
    });

    testWidgets('renders all sections with full data', (tester) async {
      await tester.pumpWidget(_wrapPage(_full));

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
        _wrapSliver(const EstablishmentInfoBar(data: _full)),
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
        expect(find.byIcon(type.icon), findsOneWidget);
      }
    });
  });

  group('EstablishmentAboutGrid', () {
    testWidgets('shows about text when present', (tester) async {
      await tester.pumpWidget(
        _wrapSliver(const EstablishmentAboutGrid(data: _full)),
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
        _wrapSliver(const EstablishmentContactSection(data: _full)),
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
