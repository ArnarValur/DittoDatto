import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_portal/features/establishments/create_establishment_dialog.dart';
import 'package:business_portal/features/establishments/establishment_model.dart';
import 'package:business_portal/features/establishments/establishment_providers.dart';

/// Mock establishments notifier for dialog tests.
class _MockEstablishmentsNotifier extends AsyncNotifier<List<Establishment>>
    implements EstablishmentsNotifier {
  Establishment? lastCreated;

  @override
  Future<List<Establishment>> build() async => [];

  @override
  Future<void> create(Establishment establishment) async {
    lastCreated = establishment;
  }

  @override
  Future<void> updateEstablishment(Establishment establishment) async {}

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> refresh() async {}
}

Widget _buildDialog({_MockEstablishmentsNotifier? mock}) {
  final notifier = mock ?? _MockEstablishmentsNotifier();
  return ProviderScope(
    overrides: [
      establishmentsProvider.overrideWith(() => notifier),
    ],
    child: MaterialApp(
      theme: DittoTheme.light,
      home: const Scaffold(
        body: CreateEstablishmentDialog(),
      ),
    ),
  );
}

void main() {
  group('CreateEstablishmentDialog', () {
    testWidgets('shows "Ny virksomhet" heading', (tester) async {
      await tester.pumpWidget(_buildDialog());
      await tester.pumpAndSettle();

      expect(find.text('Ny virksomhet'), findsOneWidget);
    });

    testWidgets('has business type selector', (tester) async {
      await tester.pumpWidget(_buildDialog());
      await tester.pumpAndSettle();

      expect(find.text('Virksomhetstype'), findsOneWidget);
      expect(find.text('Butikk'), findsOneWidget);
      expect(find.text('Restaurant'), findsOneWidget);
      expect(find.text('Spillested'), findsOneWidget);
    });

    testWidgets('has Norwegian form fields', (tester) async {
      await tester.pumpWidget(_buildDialog());
      await tester.pumpAndSettle();

      expect(find.text('Navn'), findsOneWidget);
      expect(find.text('Adresse'), findsOneWidget);
      expect(find.text('By'), findsOneWidget);
      expect(find.text('Postnummer'), findsOneWidget);
    });

    testWidgets('has Avbryt and Lagre buttons', (tester) async {
      await tester.pumpWidget(_buildDialog());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextButton, 'Avbryt'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Lagre'), findsOneWidget);
    });

    testWidgets('validates required fields', (tester) async {
      await tester.pumpWidget(_buildDialog());
      await tester.pumpAndSettle();

      // Tap Lagre without filling fields.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Lagre'));
      await tester.pumpAndSettle();

      expect(find.text('Påkrevd'), findsWidgets);
    });

    testWidgets('creates establishment on valid submit', (tester) async {
      final mock = _MockEstablishmentsNotifier();
      await tester.pumpWidget(_buildDialog(mock: mock));
      await tester.pumpAndSettle();

      // Fill required fields.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Navn'),
        'Test Butikk',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Adresse'),
        'Testgata 1',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'By'),
        'Oslo',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Postnummer'),
        '0001',
      );

      // Tap Lagre.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Lagre'));
      await tester.pumpAndSettle();

      expect(mock.lastCreated, isNotNull);
      expect(mock.lastCreated!.name, 'Test Butikk');
      expect(mock.lastCreated!.city, 'Oslo');
      expect(mock.lastCreated!.businessType, BusinessType.store);
    });
  });
}
