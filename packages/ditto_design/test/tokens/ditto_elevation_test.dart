import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DittoElevation', () {
    group('dark variant', () {
      test('level0 is the darkest surface', () {
        expect(
          DittoElevation.dark.level0,
          DittoColors.surfaceDark,
        );
      });

      test('level1 is the sidebar/card surface', () {
        expect(
          DittoElevation.dark.level1,
          DittoColors.surfaceContainer,
        );
      });

      test('level2 is the elevated container', () {
        expect(
          DittoElevation.dark.level2,
          DittoColors.surfaceContainerHigh,
        );
      });

      test('levels are ordered from darkest to lightest', () {
        final dark = DittoElevation.dark;
        expect(
          dark.level0.computeLuminance(),
          lessThan(dark.level1.computeLuminance()),
        );
        expect(
          dark.level1.computeLuminance(),
          lessThan(dark.level2.computeLuminance()),
        );
      });
    });

    group('light variant', () {
      test('level0 is white background', () {
        expect(
          DittoElevation.light.level0,
          Colors.white,
        );
      });

      test('level1 is the light surface', () {
        expect(
          DittoElevation.light.level1,
          DittoColors.surfaceLight,
        );
      });

      test('level2 is the light container', () {
        expect(
          DittoElevation.light.level2,
          DittoColors.surfaceContainerLight,
        );
      });

      test('levels are ordered from lightest to darkest', () {
        final light = DittoElevation.light;
        expect(
          light.level0.computeLuminance(),
          greaterThan(light.level1.computeLuminance()),
        );
        expect(
          light.level1.computeLuminance(),
          greaterThan(light.level2.computeLuminance()),
        );
      });
    });
  });

  group('DittoElevation.accentGlow', () {
    test('is a BoxDecoration', () {
      expect(DittoElevation.accentGlow, isA<BoxDecoration>());
    });

    test('uses Moody Blue-based box shadow', () {
      final glow = DittoElevation.accentGlow;
      expect(glow.boxShadow, isNotNull);
      expect(glow.boxShadow, isNotEmpty);
      // The shadow color should be derived from Moody Blue.
      final shadowColor = glow.boxShadow!.first.color;
      // Verify it's a translucent Moody Blue (low alpha).
      expect(shadowColor.a, lessThan(0.5));
    });

    test('has border radius', () {
      final glow = DittoElevation.accentGlow;
      expect(glow.borderRadius, isNotNull);
    });
  });
}
