import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_manager/media_manager.dart';

/// Helper to wrap a widget in MaterialApp for testing.
Widget testApp(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

/// Sample MediaItems for testing.
final sampleItems = [
  const MediaItem(
    id: 'media:1',
    uploaderId: 'user@test.com',
    url: 'https://example.com/logo.png',
    storagePath: 'companies/test/media/logo.png',
    filename: 'logo.png',
    mimeType: 'image/png',
    size: 1024,
    category: MediaCategory.logo,
  ),
  const MediaItem(
    id: 'media:2',
    uploaderId: 'user@test.com',
    url: 'https://example.com/cover.jpg',
    storagePath: 'companies/test/media/cover.jpg',
    filename: 'cover.jpg',
    mimeType: 'image/jpeg',
    size: 2048,
    category: MediaCategory.cover,
  ),
  const MediaItem(
    id: 'media:3',
    uploaderId: 'user@test.com',
    url: 'https://example.com/gallery1.jpg',
    storagePath: 'companies/test/media/gallery1.jpg',
    filename: 'gallery1.jpg',
    mimeType: 'image/jpeg',
    size: 4096,
    category: MediaCategory.gallery,
    tags: ['exterior'],
  ),
];

/// Dummy onUpload callback for tests.
Future<void> noOpUpload({
  required MediaCategory category,
  required List<({Uint8List bytes, String filename, String mimeType, int size})>
      files,
}) async {}

void main() {
  group('MediaPickerWidget', () {
    testWidgets('shows "Velg bilde" when no selection', (tester) async {
      await tester.pumpWidget(testApp(
        MediaPickerWidget(
          items: sampleItems,
          isLoading: false,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          onChanged: (_) {},
        ),
      ));

      expect(find.text('Velg bilde'), findsOneWidget);
    });

    testWidgets('shows custom hint when provided', (tester) async {
      await tester.pumpWidget(testApp(
        MediaPickerWidget(
          items: sampleItems,
          isLoading: false,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          onChanged: (_) {},
          hint: 'Velg logo',
        ),
      ));

      expect(find.text('Velg logo'), findsOneWidget);
    });

    testWidgets('shows "Endre" when items are selected', (tester) async {
      await tester.pumpWidget(testApp(
        MediaPickerWidget(
          items: sampleItems,
          isLoading: false,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          onChanged: (_) {},
          selectedItems: [sampleItems[0]],
        ),
      ));

      expect(find.text('Endre'), findsOneWidget);
      expect(find.text('Velg bilde'), findsNothing);
    });

    testWidgets('shows label when provided', (tester) async {
      await tester.pumpWidget(testApp(
        MediaPickerWidget(
          items: sampleItems,
          isLoading: false,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          onChanged: (_) {},
          label: 'Logo',
        ),
      ));

      expect(find.text('Logo'), findsOneWidget);
    });

    testWidgets('remove button calls onChanged without removed item',
        (tester) async {
      List<MediaItem>? result;

      await tester.pumpWidget(testApp(
        MediaPickerWidget(
          items: sampleItems,
          isLoading: false,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          onChanged: (items) => result = items,
          selectedItems: [sampleItems[0], sampleItems[1]],
        ),
      ));

      // Find and tap the first remove button (close icon)
      final closeIcons = find.byIcon(Icons.close_rounded);
      expect(closeIcons, findsNWidgets(2));
      await tester.tap(closeIcons.first);

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result!.first.id, 'media:2');
    });

    testWidgets('opens modal on button tap', (tester) async {
      await tester.pumpWidget(testApp(
        MediaPickerWidget(
          items: sampleItems,
          isLoading: false,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          onChanged: (_) {},
        ),
      ));

      await tester.tap(find.text('Velg bilde'));
      await tester.pumpAndSettle();

      // Modal should show "Velg bilde" in the dialog title
      expect(find.text('Velg bilder'), findsOneWidget);
      expect(find.text('Avbryt'), findsOneWidget);
    });
  });

  group('MediaPickerModal', () {
    testWidgets('shows title for single select', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaPickerModal(
          items: sampleItems,
          isLoading: false,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          maxSelection: 1,
        ),
      ));

      expect(find.text('Velg bilde'), findsOneWidget);
    });

    testWidgets('shows title for multi select', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaPickerModal(
          items: sampleItems,
          isLoading: false,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
        ),
      ));

      expect(find.text('Velg bilder'), findsOneWidget);
    });

    testWidgets('shows "Alle" chip and category chips', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaPickerModal(
          items: sampleItems,
          isLoading: false,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
        ),
      ));

      expect(find.text('Alle'), findsOneWidget);
      // First few categories visible; later ones scrolled off-screen
      expect(find.text('Generelt'), findsAtLeast(1));
      expect(find.text('Logo'), findsAtLeast(1));
    });

    testWidgets('shows loading skeleton when isLoading', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaPickerModal(
          items: const [],
          isLoading: true,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
        ),
      ));

      // Should show the loading skeleton grid
      expect(find.byType(MediaLoadingSkeleton), findsOneWidget);
    });

    testWidgets('Velg button disabled when nothing selected',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaPickerModal(
          items: sampleItems,
          isLoading: false,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
        ),
      ));

      // The "Velg" button should be present but disabled
      final button = find.widgetWithText(FilledButton, 'Velg');
      expect(button, findsOneWidget);

      final filledButton = tester.widget<FilledButton>(button);
      expect(filledButton.onPressed, isNull);
    });

    testWidgets('shows upload progress bar during upload',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaPickerModal(
          items: sampleItems,
          isLoading: false,
          uploadState: const MediaUploadState(
            isUploading: true,
            progress: 0.5,
            currentFileName: 'test.jpg',
          ),
          onUpload: noOpUpload,
        ),
      ));

      expect(find.byType(MediaUploadProgressBar), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });
  });

  group('MediaGalleryPage', () {
    testWidgets('shows empty state when no items', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaGalleryPage(
          items: const [],
          isLoading: false,
          error: null,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          onDelete: (_) async => true,
          onRefresh: () {},
          onDismissError: () {},
        ),
      ));

      expect(find.text('Ingen medier ennå'), findsOneWidget);
    });

    testWidgets('shows loading skeleton when loading', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaGalleryPage(
          items: const [],
          isLoading: true,
          error: null,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          onDelete: (_) async => true,
          onRefresh: () {},
          onDismissError: () {},
        ),
      ));

      expect(find.byType(MediaLoadingSkeleton), findsOneWidget);
    });

    testWidgets('shows error state with retry', (tester) async {
      var refreshCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: MediaGalleryPage(
          items: const [],
          isLoading: false,
          error: 'Nettverksfeil',
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          onDelete: (_) async => true,
          onRefresh: () => refreshCalled = true,
          onDismissError: () {},
        ),
      ));

      expect(find.textContaining('Nettverksfeil'), findsOneWidget);
      expect(find.text('Prøv igjen'), findsOneWidget);

      await tester.tap(find.text('Prøv igjen'));
      expect(refreshCalled, isTrue);
    });

    testWidgets('shows upload progress bar during upload', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaGalleryPage(
          items: sampleItems,
          isLoading: false,
          error: null,
          uploadState: const MediaUploadState(
            isUploading: true,
            progress: 0.7,
            currentFileName: 'photo.jpg',
            currentIndex: 1,
            totalFiles: 3,
          ),
          onUpload: noOpUpload,
          onDelete: (_) async => true,
          onRefresh: () {},
          onDismissError: () {},
        ),
      ));

      expect(find.byType(MediaUploadProgressBar), findsOneWidget);
      expect(find.text('70%'), findsOneWidget);
    });

    testWidgets('shows appbar with Last opp button', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaGalleryPage(
          items: sampleItems,
          isLoading: false,
          error: null,
          uploadState: MediaUploadState.idle,
          onUpload: noOpUpload,
          onDelete: (_) async => true,
          onRefresh: () {},
          onDismissError: () {},
        ),
      ));

      expect(find.text('Media'), findsOneWidget);
      expect(find.text('Last opp'), findsOneWidget);
    });
  });
}
