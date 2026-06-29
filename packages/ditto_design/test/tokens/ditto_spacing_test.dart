import 'package:ditto_design/ditto_design.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DittoSpacing', () {
    test('spacing values are correct', () {
      expect(DittoSpacing.xs, 4);
      expect(DittoSpacing.sm, 8);
      expect(DittoSpacing.compact, 12);
      expect(DittoSpacing.md, 16);
      expect(DittoSpacing.base, 16);
      expect(DittoSpacing.lg, 24);
      expect(DittoSpacing.xl, 32);
    });

    test('spacing values are strictly ascending', () {
      final values = [
        DittoSpacing.xs,
        DittoSpacing.sm,
        DittoSpacing.compact,
        DittoSpacing.md,
        DittoSpacing.lg,
        DittoSpacing.xl,
      ];

      for (var i = 0; i < values.length - 1; i++) {
        expect(
          values[i],
          lessThan(values[i + 1]),
          reason: 'Spacing step $i should be smaller than step ${i + 1}',
        );
      }
    });
  });
}
