import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_portal/features/establishments/establishment_model.dart';
import 'package:business_portal/features/establishments/establishment_providers.dart';
import 'package:business_portal/features/establishments/establishments_screen.dart';

/// Sample establishment data for tests.
final _sampleEstablishments = [
  Establishment.fromJson({
    'id': 'establishment:1',
    'name': 'Merkurial Studio',
    'slug': 'merkurial-studio',
    'store_type': 'store',
    'category': 'Teknologi',
    'address': 'Grønland 42',
    'city': 'Drammen',
    'zip': '3045',
    'country': 'NO',
    'is_published': true,
    'is_active': true,
    'resources_enabled': false,
  }),
  Establishment.fromJson({
    'id': 'establishment:2',
    'name': 'Pizzeria Roma',
    'slug': 'pizzeria-roma',
    'store_type': 'restaurant',
    'address': 'Karl Johan 10',
    'city': 'Oslo',
    'zip': '0154',
    'country': 'NO',
    'is_published': false,
    'is_active': true,
    'resources_enabled': false,
  }),
  Establishment.fromJson({
    'id': 'establishment:3',
    'name': 'Rockefeller',
    'slug': 'rockefeller',
    'store_type': 'venue',
    'address': 'Torggata 16',
    'city': 'Oslo',
    'zip': '0181',
    'country': 'NO',
    'is_published': true,
    'is_active': true,
    'resources_enabled': true,
  }),
];

/// Mock establishments notifier that returns preset data.
class _MockEstablishmentsNotifier extends AsyncNotifier<List<Establishment>>
    implements EstablishmentsNotifier {
  _MockEstablishmentsNotifier(this._data);

  final List<Establishment> _data;

  @override
  Future<List<Establishment>> build() async => _data;

  @override
  Future<void> create(Establishment establishment) async {}

  @override
  Future<void> updateEstablishment(Establishment establishment) async {}

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> refresh() async {}
}

Widget _buildEstablishmentsScreen({List<Establishment>? data}) {
  return ProviderScope(
    overrides: [
      establishmentsProvider.overrideWith(
        () => _MockEstablishmentsNotifier(data ?? _sampleEstablishments),
      ),
    ],
    child: MaterialApp(
      theme: DittoTheme.light,
      home: const EstablishmentsScreen(),
    ),
  );
}

void main() {
  group('EstablishmentsScreen', () {
    // ── Layout ──

    testWidgets('shows "+ Legg til virksomhet" button', (tester) async {
      await tester.pumpWidget(_buildEstablishmentsScreen());
      await tester.pumpAndSettle();

      expect(find.text('Legg til virksomhet'), findsOneWidget);
    });

    testWidgets('shows heading "Virksomheter"', (tester) async {
      await tester.pumpWidget(_buildEstablishmentsScreen());
      await tester.pumpAndSettle();

      expect(find.text('Virksomheter'), findsOneWidget);
    });

    // ── Tab filters ──

    testWidgets('shows type filter tabs', (tester) async {
      await tester.pumpWidget(_buildEstablishmentsScreen());
      await tester.pumpAndSettle();

      // Each tab text appears at least once (may also appear on cards).
      expect(find.text('Alle'), findsOneWidget);
      expect(find.text('Butikk'), findsAtLeast(1));
      expect(find.text('Restaurant'), findsAtLeast(1));
      expect(find.text('Spillested'), findsAtLeast(1));
    });

    // ── Card content ──

    testWidgets('renders establishment names in cards', (tester) async {
      await tester.pumpWidget(_buildEstablishmentsScreen());
      await tester.pumpAndSettle();

      expect(find.text('Merkurial Studio'), findsOneWidget);
      expect(find.text('Pizzeria Roma'), findsOneWidget);
      expect(find.text('Rockefeller'), findsOneWidget);
    });

    testWidgets('shows address with city on cards', (tester) async {
      await tester.pumpWidget(_buildEstablishmentsScreen());
      await tester.pumpAndSettle();

      // City appears combined with address in card text.
      expect(find.textContaining('Drammen'), findsOneWidget);
    });

    testWidgets('shows status badges', (tester) async {
      await tester.pumpWidget(_buildEstablishmentsScreen());
      await tester.pumpAndSettle();

      // "Merkurial Studio" is published → Live badge
      // "Pizzeria Roma" is not published → Utkast badge
      expect(find.text('Live'), findsWidgets);
      expect(find.text('Utkast'), findsWidgets);
    });

    // ── Empty state ──

    testWidgets('shows empty state when no establishments', (tester) async {
      await tester.pumpWidget(_buildEstablishmentsScreen(data: []));
      await tester.pumpAndSettle();

      expect(find.text('Ingen virksomheter ennå'), findsOneWidget);
    });
  });
}
