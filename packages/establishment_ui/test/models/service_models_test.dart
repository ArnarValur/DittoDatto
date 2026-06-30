import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServiceGroup', () {
    test('fromJson parses minimal fields', () {
      final json = {
        'id': 'service_group:abc123',
        'name': 'Hårklipp',
        'establishment': 'establishment:xyz',
        'sort_order': 0,
        'show_on_booking_panel': true,
        'multi_select': false,
      };

      final group = ServiceGroup.fromJson(json);

      expect(group.id, 'service_group:abc123');
      expect(group.name, 'Hårklipp');
      expect(group.description, isNull);
      expect(group.sortOrder, 0);
      expect(group.showOnBookingPanel, true);
      expect(group.multiSelect, false);
    });

    test('fromJson parses all optional fields', () {
      final json = {
        'id': 'service_group:abc123',
        'name': 'Behandlinger',
        'description': 'Alle behandlinger vi tilbyr',
        'establishment': 'establishment:xyz',
        'sort_order': 2,
        'show_on_booking_panel': false,
        'multi_select': true,
      };

      final group = ServiceGroup.fromJson(json);

      expect(group.description, 'Alle behandlinger vi tilbyr');
      expect(group.sortOrder, 2);
      expect(group.showOnBookingPanel, false);
      expect(group.multiSelect, true);
    });

    test('toJson round-trips correctly', () {
      final original = ServiceGroup.fromJson({
        'id': 'service_group:abc123',
        'name': 'Hårklipp',
        'description': 'Diverse klipp',
        'establishment': 'establishment:xyz',
        'sort_order': 1,
        'show_on_booking_panel': true,
        'multi_select': false,
      });

      final json = original.toJson();
      final roundTripped = ServiceGroup.fromJson(json);

      expect(roundTripped.id, original.id);
      expect(roundTripped.name, original.name);
      expect(roundTripped.description, original.description);
      expect(roundTripped.sortOrder, original.sortOrder);
      expect(roundTripped.showOnBookingPanel, original.showOnBookingPanel);
      expect(roundTripped.multiSelect, original.multiSelect);
    });

    test('fromJson uses defaults for missing optional fields', () {
      final json = {
        'id': 'service_group:abc123',
        'name': 'Test',
        'establishment': 'establishment:xyz',
      };

      final group = ServiceGroup.fromJson(json);

      expect(group.sortOrder, 0);
      expect(group.showOnBookingPanel, true);
      expect(group.multiSelect, false);
      expect(group.description, isNull);
    });

    test('equality works for identical groups', () {
      final a = ServiceGroup.fromJson({
        'id': 'service_group:abc',
        'name': 'Test',
        'establishment': 'establishment:xyz',
        'sort_order': 0,
        'show_on_booking_panel': true,
        'multi_select': false,
      });
      final b = ServiceGroup.fromJson({
        'id': 'service_group:abc',
        'name': 'Test',
        'establishment': 'establishment:xyz',
        'sort_order': 0,
        'show_on_booking_panel': true,
        'multi_select': false,
      });

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
  });

  group('Service', () {
    test('fromJson parses all fields for standard booking mode', () {
      final json = {
        'id': 'service:svc1',
        'title': 'Herreklipp',
        'description': 'Klassisk herreklipp med styling',
        'establishment': 'establishment:xyz',
        'group': 'service_group:abc123',
        'duration': 30,
        'price': 450.0,
        'currency': 'NOK',
        'booking_mode': 'standard',
        'is_active': true,
        'cover_image': 'https://example.com/photo.jpg',
      };

      final service = Service.fromJson(json);

      expect(service.id, 'service:svc1');
      expect(service.title, 'Herreklipp');
      expect(service.description, 'Klassisk herreklipp med styling');
      expect(service.groupId, 'service_group:abc123');
      expect(service.duration, 30);
      expect(service.price, 450.0);
      expect(service.currency, 'NOK');
      expect(service.bookingMode, 'standard');
      expect(service.isActive, true);
      expect(service.coverImage, 'https://example.com/photo.jpg');
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'service:svc2',
        'title': 'Skjeggklipp',
        'establishment': 'establishment:xyz',
        'duration': 15,
        'price': 200,
      };

      final service = Service.fromJson(json);

      expect(service.description, isNull);
      expect(service.groupId, isNull);
      expect(service.currency, 'NOK');
      expect(service.bookingMode, 'standard');
      expect(service.isActive, true);
      expect(service.coverImage, isNull);
    });

    test('fromJson handles tableReservation booking mode', () {
      final json = {
        'id': 'service:svc3',
        'title': 'Bord for 4',
        'establishment': 'establishment:xyz',
        'duration': 120,
        'price': 0,
        'booking_mode': 'tableReservation',
      };

      final service = Service.fromJson(json);

      expect(service.bookingMode, 'tableReservation');
      expect(service.price, 0);
    });

    test('fromJson handles ticketSystem booking mode', () {
      final json = {
        'id': 'service:svc4',
        'title': 'VIP-billett',
        'establishment': 'establishment:xyz',
        'duration': 180,
        'price': 899.0,
        'booking_mode': 'ticketSystem',
      };

      final service = Service.fromJson(json);

      expect(service.bookingMode, 'ticketSystem');
    });

    test('toJson round-trips correctly', () {
      final original = Service.fromJson({
        'id': 'service:svc1',
        'title': 'Herreklipp',
        'description': 'Klassisk herreklipp',
        'establishment': 'establishment:xyz',
        'group': 'service_group:abc123',
        'duration': 30,
        'price': 450.0,
        'currency': 'NOK',
        'booking_mode': 'standard',
        'is_active': true,
        'cover_image': 'https://example.com/photo.jpg',
      });

      final json = original.toJson();
      final roundTripped = Service.fromJson(json);

      expect(roundTripped.id, original.id);
      expect(roundTripped.title, original.title);
      expect(roundTripped.description, original.description);
      expect(roundTripped.groupId, original.groupId);
      expect(roundTripped.duration, original.duration);
      expect(roundTripped.price, original.price);
      expect(roundTripped.currency, original.currency);
      expect(roundTripped.bookingMode, original.bookingMode);
      expect(roundTripped.isActive, original.isActive);
      expect(roundTripped.coverImage, original.coverImage);
    });

    test('price parses int as double', () {
      final json = {
        'id': 'service:svc5',
        'title': 'Test',
        'establishment': 'establishment:xyz',
        'duration': 15,
        'price': 300, // int, not double
      };

      final service = Service.fromJson(json);

      expect(service.price, 300.0);
      expect(service.price, isA<double>());
    });

    test('equality works for identical services', () {
      final json = {
        'id': 'service:svc1',
        'title': 'Test',
        'establishment': 'establishment:xyz',
        'duration': 30,
        'price': 450.0,
        'booking_mode': 'standard',
        'is_active': true,
      };

      final a = Service.fromJson(json);
      final b = Service.fromJson(json);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
  });

  group('Format helpers', () {
    group('formatPrice', () {
      test('formats Norwegian krone', () {
        expect(formatPrice(450, 'NOK'), 'kr 450');
      });

      test('formats zero price as Gratis', () {
        expect(formatPrice(0, 'NOK'), 'Gratis');
      });

      test('formats fractional price with decimals', () {
        expect(formatPrice(199.50, 'NOK'), 'kr 199,50');
      });

      test('strips trailing .00 for whole numbers', () {
        expect(formatPrice(300.00, 'NOK'), 'kr 300');
      });

      test('handles non-NOK currency', () {
        expect(formatPrice(100, 'SEK'), 'kr 100');
      });
    });

    group('formatDuration', () {
      test('formats minutes under 60', () {
        expect(formatDuration(30), '30 min');
        expect(formatDuration(45), '45 min');
      });

      test('formats exactly 60 minutes', () {
        expect(formatDuration(60), '1 t');
      });

      test('formats hours and minutes', () {
        expect(formatDuration(90), '1 t 30 min');
        expect(formatDuration(150), '2 t 30 min');
      });

      test('formats exact hours', () {
        expect(formatDuration(120), '2 t');
        expect(formatDuration(180), '3 t');
      });

      test('formats zero duration', () {
        expect(formatDuration(0), '0 min');
      });
    });
  });
}
