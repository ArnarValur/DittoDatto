import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DittoColors', () {
    test('moodyBlue has correct hex value', () {
      expect(DittoColors.moodyBlue, const Color(0xFF6F71CC));
    });

    test('dark surface grades are ordered from darkest to lightest', () {
      // Extract luminance as a proxy for "lightness"
      final surfaces = [
        DittoColors.surfaceDark,
        DittoColors.sidebarBg,
        DittoColors.surfaceContainer,
        DittoColors.surfaceContainerHigh,
      ];

      for (var i = 0; i < surfaces.length - 1; i++) {
        expect(
          surfaces[i].computeLuminance(),
          lessThan(surfaces[i + 1].computeLuminance()),
          reason:
              'Surface grade $i should be darker than grade ${i + 1}',
        );
      }
    });

    test('status colors are non-null and opaque', () {
      for (final color in [
        DittoColors.success,
        DittoColors.error,
        DittoColors.warning,
      ]) {
        expect(color.a, 1.0, reason: '$color should be fully opaque');
      }
    });

    test('badge colors are non-null and opaque', () {
      for (final color in [
        DittoColors.premiumBadge,
        DittoColors.freeBadge,
      ]) {
        expect(color.a, 1.0, reason: '$color should be fully opaque');
      }
    });
  });
}
