import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_manager/media_manager.dart';

Widget testApp(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('MediaFilterBar', () {
    late TextEditingController searchController;
    MediaCategory? lastCategory;
    String? lastTag;
    var searchChangedCount = 0;

    setUp(() {
      searchController = TextEditingController();
      lastCategory = null;
      lastTag = null;
      searchChangedCount = 0;
    });

    tearDown(() => searchController.dispose());

    Widget buildFilterBar({List<String> tags = const ['exterior', 'interior']}) {
      return testApp(
        MediaFilterBar(
          searchController: searchController,
          tags: tags,
          selectedTag: null,
          selectedCategory: null,
          onTagSelected: (tag) => lastTag = tag,
          onCategorySelected: (cat) => lastCategory = cat,
          onSearchChanged: () => searchChangedCount++,
        ),
      );
    }

    testWidgets('renders search field with hint text', (tester) async {
      await tester.pumpWidget(buildFilterBar());
      expect(find.text('Søk etter filnavn...'), findsOneWidget);
    });

    testWidgets('renders category chips for all categories', (tester) async {
      await tester.pumpWidget(buildFilterBar());

      // At minimum, first few categories should be visible
      expect(find.text('Generelt'), findsOneWidget);
      expect(find.text('Logo'), findsOneWidget);
    });

    testWidgets('tapping category chip fires onCategorySelected',
        (tester) async {
      await tester.pumpWidget(buildFilterBar());

      await tester.tap(find.text('Logo'));
      expect(lastCategory, MediaCategory.logo);
    });

    testWidgets('typing in search fires onSearchChanged', (tester) async {
      await tester.pumpWidget(buildFilterBar());

      await tester.enterText(find.byType(TextField), 'test');
      expect(searchChangedCount, 1); // enterText fires onChanged once
    });

    testWidgets('renders tag chips when tags are provided', (tester) async {
      await tester.pumpWidget(buildFilterBar());

      expect(find.text('exterior'), findsOneWidget);
      expect(find.text('interior'), findsOneWidget);
    });

    testWidgets('hides tag chips when tags list is empty', (tester) async {
      await tester.pumpWidget(buildFilterBar(tags: []));

      expect(find.text('exterior'), findsNothing);
    });

    testWidgets('tapping tag chip fires onTagSelected', (tester) async {
      await tester.pumpWidget(buildFilterBar());

      await tester.tap(find.text('exterior'));
      expect(lastTag, 'exterior');
    });

    testWidgets('clear button clears search and fires callback',
        (tester) async {
      searchController.text = 'something';
      await tester.pumpWidget(buildFilterBar());
      await tester.pump(); // rebuild with text

      // Find and tap the clear icon
      final clearButton = find.byIcon(Icons.clear_rounded);
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);

      expect(searchController.text, isEmpty);
      expect(searchChangedCount, greaterThan(0));
    });
  });
}
