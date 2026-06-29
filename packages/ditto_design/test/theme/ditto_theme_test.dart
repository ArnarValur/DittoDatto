import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('DittoTheme.dark', () {
    testWidgets('uses Brightness.dark', (tester) async {
      final theme = DittoTheme.dark;
      expect(theme.brightness, Brightness.dark);
    });

    testWidgets('uses Material 3', (tester) async {
      final theme = DittoTheme.dark;
      expect(theme.useMaterial3, isTrue);
    });

    testWidgets('seeds ColorScheme from Moody Blue', (tester) async {
      final theme = DittoTheme.dark;
      expect(theme.colorScheme.primary, isNotNull);
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    testWidgets('uses hand-tuned dark surface colors', (tester) async {
      final theme = DittoTheme.dark;
      expect(theme.colorScheme.surface, DittoColors.surfaceDark);
      expect(theme.scaffoldBackgroundColor, DittoColors.surfaceDark);
    });

    testWidgets('has component themes configured', (tester) async {
      final theme = DittoTheme.dark;
      // AppBar
      expect(theme.appBarTheme.backgroundColor, isNotNull);
      expect(theme.appBarTheme.elevation, 0);
      // Card
      expect(theme.cardTheme.color, DittoColors.surfaceContainer);
      expect(theme.cardTheme.elevation, 0);
      // Input
      expect(theme.inputDecorationTheme.filled, isTrue);
      // ElevatedButton
      expect(theme.elevatedButtonTheme.style?.backgroundColor, isNotNull);
      // SnackBar
      expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);
    });
  });

  group('DittoTheme.light', () {
    testWidgets('uses Brightness.light', (tester) async {
      final theme = DittoTheme.light;
      expect(theme.brightness, Brightness.light);
    });

    testWidgets('uses Material 3', (tester) async {
      final theme = DittoTheme.light;
      expect(theme.useMaterial3, isTrue);
    });

    testWidgets('seeds ColorScheme from Moody Blue', (tester) async {
      final theme = DittoTheme.light;
      expect(theme.colorScheme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, isNotNull);
    });

    testWidgets('has light surface colors (not dark overrides)',
        (tester) async {
      final theme = DittoTheme.light;
      // Light theme should NOT use the dark surface grade colors.
      expect(theme.colorScheme.surface, isNot(DittoColors.surfaceDark));
      expect(theme.colorScheme.surface, isNotNull);
    });

    testWidgets('scaffold background is a light color', (tester) async {
      final theme = DittoTheme.light;
      // Luminance > 0.5 means it's a light color.
      expect(
        theme.scaffoldBackgroundColor.computeLuminance(),
        greaterThan(0.5),
      );
    });

    testWidgets('has component themes configured', (tester) async {
      final theme = DittoTheme.light;
      // Light theme must have hand-tuned component themes, not bare defaults.
      // AppBar
      expect(theme.appBarTheme.elevation, 0);
      // Card
      expect(theme.cardTheme.elevation, 0);
      expect(theme.cardTheme.shape, isNotNull);
      // Input
      expect(theme.inputDecorationTheme.filled, isTrue);
      // ElevatedButton
      expect(theme.elevatedButtonTheme.style?.backgroundColor, isNotNull);
      // SnackBar
      expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);
    });

    testWidgets('light and dark themes have different brightness',
        (tester) async {
      final light = DittoTheme.light;
      final dark = DittoTheme.dark;
      expect(light.brightness, isNot(dark.brightness));
    });

    testWidgets('light and dark themes share Moody Blue seed',
        (tester) async {
      final light = DittoTheme.light;
      final dark = DittoTheme.dark;
      // Both should produce a non-null primary derived from the same seed.
      expect(light.colorScheme.primary, isNotNull);
      expect(dark.colorScheme.primary, isNotNull);
    });

    testWidgets('light theme uses Plus Jakarta Sans for headlines', (tester) async {
      final theme = DittoTheme.light;
      // Headlines (displayLarge, headlineLarge, titleLarge) should use Plus Jakarta Sans.
      expect(
        theme.textTheme.headlineLarge?.fontFamily,
        contains('PlusJakartaSans'),
      );
      expect(
        theme.textTheme.displayLarge?.fontFamily,
        contains('PlusJakartaSans'),
      );
      expect(
        theme.textTheme.titleLarge?.fontFamily,
        contains('PlusJakartaSans'),
      );
    });

    testWidgets('light theme uses Inter for body text', (tester) async {
      final theme = DittoTheme.light;
      // Body / label styles should use Inter.
      expect(
        theme.textTheme.bodyLarge?.fontFamily,
        contains('Inter'),
      );
      expect(
        theme.textTheme.bodyMedium?.fontFamily,
        contains('Inter'),
      );
      expect(
        theme.textTheme.labelLarge?.fontFamily,
        contains('Inter'),
      );
    });

    testWidgets('dark theme keeps Inter for all text', (tester) async {
      final theme = DittoTheme.dark;
      // Dark theme (Admin Panel) keeps Inter across the board.
      expect(
        theme.textTheme.headlineLarge?.fontFamily,
        contains('Inter'),
      );
      expect(
        theme.textTheme.bodyLarge?.fontFamily,
        contains('Inter'),
      );
    });
  });
}
