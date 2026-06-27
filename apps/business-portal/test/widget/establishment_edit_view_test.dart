import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_manager/media_manager.dart';

import 'package:business_portal/features/establishments/establishment_model.dart';
import 'package:business_portal/features/establishments/establishment_providers.dart';
import 'package:business_portal/features/establishments/establishment_edit_view.dart';
import 'package:business_portal/features/media/media_providers.dart';

final _testEstablishment = Establishment.fromJson({
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
});

class _MockEstablishmentsNotifier extends AsyncNotifier<List<Establishment>>
    implements EstablishmentsNotifier {
  Establishment? lastUpdated;

  @override
  Future<List<Establishment>> build() async => [_testEstablishment];

  @override
  Future<void> create(Establishment establishment) async {}

  @override
  Future<void> updateEstablishment(Establishment establishment) async {
    lastUpdated = establishment;
  }

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> refresh() async {}
}

class _MockMediaNotifier extends AsyncNotifier<List<MediaItem>>
    implements MediaNotifier {
  @override
  Future<List<MediaItem>> build() async => [];

  @override
  Future<MediaItem?> uploadMedia({
    required dynamic bytes,
    required String filename,
    required String mimeType,
    required int size,
    MediaCategory category = MediaCategory.general,
    String? establishmentId,
    List<String> tags = const [],
  }) async => null;

  @override
  Future<List<MediaItem>> uploadMultiple({
    required List<dynamic> files,
    MediaCategory category = MediaCategory.general,
    String? establishmentId,
    List<String> tags = const [],
  }) async => [];

  @override
  Future<bool> deleteMedia(MediaItem item) async => false;

  @override
  Future<bool> updateMediaName(String id, String? name) async => false;

  @override
  Future<bool> updateMediaTags(String id, List<String> tags) async => false;

  @override
  Future<void> refresh() async {}
}

Widget _buildEditView({_MockEstablishmentsNotifier? mockNotifier}) {
  final notifier = mockNotifier ?? _MockEstablishmentsNotifier();
  return ProviderScope(
    overrides: [
      establishmentsProvider.overrideWith(() => notifier),
      mediaProvider.overrideWith(() => _MockMediaNotifier()),
      mediaUploadStateProvider.overrideWith(MediaUploadStateNotifier.new),
    ],
    child: MaterialApp(
      theme: DittoTheme.light,
      home: const EstablishmentEditView(
        establishmentId: 'establishment:1',
      ),
    ),
  );
}

void main() {
  group('EstablishmentEditView (Scrollspy)', () {
    testWidgets('renders establishment name and status badge', (tester) async {
      await tester.pumpWidget(_buildEditView());
      await tester.pumpAndSettle();

      expect(find.text('Merkurial Studio'), findsNWidgets(2));
      expect(find.text('Publisert'), findsOneWidget);
    });

    testWidgets('renders all four scrollspy section labels', (tester) async {
      // Use desktop viewport to show the vertical scrollspy sidebar.
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildEditView());
      await tester.pumpAndSettle();

      expect(find.text('Generelt'), findsWidgets);
      expect(find.text('Bilder'), findsWidgets);
      expect(find.text('Lokasjon'), findsWidgets);
      expect(find.text('Kontakt'), findsWidgets);
      expect(find.text('Innstillinger'), findsWidgets);
    });

    testWidgets('renders form fields in cards', (tester) async {
      // Use a tall viewport so all scrollspy sections are built.
      tester.view.physicalSize = const Size(1280, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildEditView());
      await tester.pumpAndSettle();

      // Fields should be populated from _testEstablishment.
      expect(find.widgetWithText(TextFormField, 'Navn'), findsOneWidget);
      expect(find.text('Grønland 42', skipOffstage: false), findsOneWidget);
      expect(find.text('Drammen', skipOffstage: false), findsOneWidget);
      expect(find.text('3045', skipOffstage: false), findsOneWidget);
    });

    testWidgets('clicking Save triggers updateEstablishment', (tester) async {
      final mock = _MockEstablishmentsNotifier();
      await tester.pumpWidget(_buildEditView(mockNotifier: mock));
      await tester.pumpAndSettle();

      // Change the name.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Navn'),
        'New Name',
      );

      // Tap Lagre.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Lagre'));
      await tester.pumpAndSettle();

      expect(mock.lastUpdated, isNotNull);
      expect(mock.lastUpdated!.name, 'New Name');
    });
  });
}
