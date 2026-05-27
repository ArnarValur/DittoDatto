import 'package:ditto_design/ditto_design.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DittoWindowClass.of', () {
    test('returns compact for widths < 600', () {
      expect(DittoWindowClass.of(0), DittoWindowClass.compact);
      expect(DittoWindowClass.of(320), DittoWindowClass.compact);
      expect(DittoWindowClass.of(599), DittoWindowClass.compact);
    });

    test('returns medium for widths 600–839', () {
      expect(DittoWindowClass.of(600), DittoWindowClass.medium);
      expect(DittoWindowClass.of(700), DittoWindowClass.medium);
      expect(DittoWindowClass.of(839), DittoWindowClass.medium);
    });

    test('returns expanded for widths 840–1199', () {
      expect(DittoWindowClass.of(840), DittoWindowClass.expanded);
      expect(DittoWindowClass.of(1024), DittoWindowClass.expanded);
      expect(DittoWindowClass.of(1199), DittoWindowClass.expanded);
    });

    test('returns large for widths >= 1200', () {
      expect(DittoWindowClass.of(1200), DittoWindowClass.large);
      expect(DittoWindowClass.of(1920), DittoWindowClass.large);
      expect(DittoWindowClass.of(3840), DittoWindowClass.large);
    });
  });

  group('DittoWindowClass.showPermanentSidebar', () {
    test('compact does not show permanent sidebar', () {
      expect(DittoWindowClass.compact.showPermanentSidebar, isFalse);
    });

    test('medium and above show permanent sidebar', () {
      expect(DittoWindowClass.medium.showPermanentSidebar, isTrue);
      expect(DittoWindowClass.expanded.showPermanentSidebar, isTrue);
      expect(DittoWindowClass.large.showPermanentSidebar, isTrue);
    });
  });
}
