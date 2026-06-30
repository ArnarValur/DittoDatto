import 'package:flutter_test/flutter_test.dart';
import 'package:discovery_service/discovery_service.dart';

void main() {
  group('DiscoveryCategory', () {
    test('fromJson parses all fields', () {
      final json = <String, dynamic>{
        'id': 'category:skjonnhet',
        'name': 'Skjønnhet',
        'slug': 'skjonnhet',
        'description': 'Beauty and wellness services',
        'icon': 'content_cut',
        'count': 12,
      };

      final cat = DiscoveryCategory.fromJson(json);

      expect(cat.id, 'category:skjonnhet');
      expect(cat.name, 'Skjønnhet');
      expect(cat.slug, 'skjonnhet');
      expect(cat.description, 'Beauty and wellness services');
      expect(cat.icon, 'content_cut');
      expect(cat.count, 12);
    });

    test('fromJson handles missing optional fields', () {
      final cat = DiscoveryCategory.fromJson({
        'name': 'Test',
        'slug': 'test',
      });

      expect(cat.id, isNull);
      expect(cat.description, isNull);
      expect(cat.icon, isNull);
      expect(cat.count, 0);
    });

    test('toJson omits null optional fields', () {
      final json = DiscoveryCategory(name: 'Test', slug: 'test').toJson();

      expect(json['name'], 'Test');
      expect(json['slug'], 'test');
      expect(json.containsKey('description'), false);
      expect(json.containsKey('icon'), false);
    });

    test('equality based on slug and name', () {
      final a = DiscoveryCategory(name: 'A', slug: 'a');
      final b = DiscoveryCategory(name: 'A', slug: 'a', count: 5);
      expect(a, equals(b));
    });
  });

  group('DiscoveryArea', () {
    test('fromJson parses all fields', () {
      final json = <String, dynamic>{
        'id': 'area:drammen',
        'name': 'Drammen',
        'slug': 'drammen',
        'parent': 'area:viken',
        'center': {
          'type': 'Point',
          'coordinates': [10.2045, 59.7441],
        },
      };

      final area = DiscoveryArea.fromJson(json);

      expect(area.id, 'area:drammen');
      expect(area.name, 'Drammen');
      expect(area.slug, 'drammen');
      expect(area.parentId, 'area:viken');
      expect(area.centerLatitude, closeTo(59.7441, 0.001));
      expect(area.centerLongitude, closeTo(10.2045, 0.001));
    });

    test('fromJson handles missing optional fields', () {
      final area = DiscoveryArea.fromJson({
        'name': 'Viken',
        'slug': 'viken',
      });

      expect(area.id, isNull);
      expect(area.parentId, isNull);
      expect(area.centerLatitude, isNull);
      expect(area.centerLongitude, isNull);
    });

    test('toJson includes parent when present', () {
      final json = DiscoveryArea(
        name: 'Drammen',
        slug: 'drammen',
        parentId: 'area:viken',
      ).toJson();

      expect(json['parent'], 'area:viken');
    });

    test('toJson includes center when coordinates present', () {
      final json = DiscoveryArea(
        name: 'Drammen',
        slug: 'drammen',
        centerLatitude: 59.74,
        centerLongitude: 10.20,
      ).toJson();

      expect(json['center'], {
        'type': 'Point',
        'coordinates': [10.20, 59.74],
      });
    });

    test('toJson omits center when coordinates null', () {
      final json = DiscoveryArea(name: 'X', slug: 'x').toJson();
      expect(json.containsKey('center'), false);
    });

    test('equality based on slug', () {
      final a = DiscoveryArea(name: 'A', slug: 'a');
      final b = DiscoveryArea(name: 'A', slug: 'a', parentId: 'area:x');
      expect(a, equals(b));
    });
  });
}
