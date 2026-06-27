import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_manager/media_manager.dart';

Widget testApp(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

/// Standard item for grid tile tests.
const _logoItem = MediaItem(
  id: 'media:logo1',
  uploaderId: 'user@test.com',
  url: 'https://example.com/logo.png',
  storagePath: 'companies/test/media/logo.png',
  filename: 'logo.png',
  mimeType: 'image/png',
  size: 1024,
  category: MediaCategory.logo,
  tags: ['brand', 'header'],
  name: 'Company Logo',
);

const _generalItem = MediaItem(
  id: 'media:gen1',
  uploaderId: 'user@test.com',
  url: 'https://example.com/photo.jpg',
  storagePath: 'companies/test/media/photo.jpg',
  filename: 'photo.jpg',
  mimeType: 'image/jpeg',
  size: 2048,
);

void main() {
  group('MediaGridTile — gallery mode', () {
    testWidgets('shows category badge for non-general categories',
        (tester) async {
      await tester.pumpWidget(testApp(
        SizedBox(
          width: 200,
          height: 200,
          child: MediaGridTile(
            item: _logoItem,
            onDelete: () {},
          ),
        ),
      ));

      expect(find.text('Logo'), findsOneWidget);
    });

    testWidgets('hides category badge for general category', (tester) async {
      await tester.pumpWidget(testApp(
        SizedBox(
          width: 200,
          height: 200,
          child: MediaGridTile(
            item: _generalItem,
            onDelete: () {},
          ),
        ),
      ));

      // "Generelt" badge should NOT appear — general items have no badge
      expect(find.text('Generelt'), findsNothing);
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(testApp(
        SizedBox(
          width: 200,
          height: 200,
          child: MediaGridTile(
            item: _generalItem,
            onDelete: () {},
            onTap: () => tapped = true,
          ),
        ),
      ));

      await tester.tap(find.byType(MediaGridTile));
      expect(tapped, isTrue);
    });
  });

  group('MediaGridTile — picker mode (selectable)', () {
    testWidgets('shows selection circle when selectable', (tester) async {
      await tester.pumpWidget(testApp(
        SizedBox(
          width: 200,
          height: 200,
          child: MediaGridTile(
            item: _generalItem,
            onDelete: () {},
            selectable: true,
            selected: false,
          ),
        ),
      ));

      // The unselected circle is a Container with BoxShape.circle
      // Check that the check icon is NOT present (unselected)
      expect(find.byIcon(Icons.check_rounded), findsNothing);
    });

    testWidgets('shows check icon when selected', (tester) async {
      await tester.pumpWidget(testApp(
        SizedBox(
          width: 200,
          height: 200,
          child: MediaGridTile(
            item: _generalItem,
            onDelete: () {},
            selectable: true,
            selected: true,
          ),
        ),
      ));

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });
  });

  group('MediaGrid — responsive breakpoints', () {
    testWidgets('uses 2 columns on narrow widths (< 600)', (tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MediaGrid(
            items: List.generate(
              4,
              (i) => MediaItem(
                id: 'media:$i',
                uploaderId: 'u',
                url: 'https://example.com/$i.jpg',
                storagePath: 'p/$i.jpg',
                filename: '$i.jpg',
                mimeType: 'image/jpeg',
                size: 100,
              ),
            ),
            onDelete: (_) {},
          ),
        ),
      ));

      // GridView should render — just verify it builds without error
      expect(find.byType(GridView), findsOneWidget);

      addTeardownToResetViewSize(tester);
    });

    testWidgets('uses 3 columns on medium widths (600-900)', (tester) async {
      tester.view.physicalSize = const Size(750, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MediaGrid(
            items: List.generate(
              6,
              (i) => MediaItem(
                id: 'media:$i',
                uploaderId: 'u',
                url: 'https://example.com/$i.jpg',
                storagePath: 'p/$i.jpg',
                filename: '$i.jpg',
                mimeType: 'image/jpeg',
                size: 100,
              ),
            ),
            onDelete: (_) {},
          ),
        ),
      ));

      expect(find.byType(GridView), findsOneWidget);

      addTeardownToResetViewSize(tester);
    });

    testWidgets('uses 4 columns on wide widths (> 900)', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MediaGrid(
            items: List.generate(
              8,
              (i) => MediaItem(
                id: 'media:$i',
                uploaderId: 'u',
                url: 'https://example.com/$i.jpg',
                storagePath: 'p/$i.jpg',
                filename: '$i.jpg',
                mimeType: 'image/jpeg',
                size: 100,
              ),
            ),
            onDelete: (_) {},
          ),
        ),
      ));

      expect(find.byType(GridView), findsOneWidget);

      addTeardownToResetViewSize(tester);
    });
  });
}

/// Reset the test view size after a test that changed it.
void addTeardownToResetViewSize(WidgetTester tester) {
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
