import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mercury_client/mercury_client.dart';

void main() {
  // --- Model serialization tests ---

  group('TimeSlot', () {
    test('deserializes from ME response', () {
      final json = {
        'time': '09:00',
        'available': true,
        'staff_id': 'staff:1',
        'staff_name': 'Anna',
        'duration': 60,
      };
      final slot = TimeSlot.fromJson(json);
      expect(slot.time, '09:00');
      expect(slot.available, true);
      expect(slot.staffId, 'staff:1');
      expect(slot.staffName, 'Anna');
      expect(slot.duration, 60);
    });

    test('round-trips through JSON', () {
      const slot = TimeSlot(
        time: '14:30',
        available: false,
        duration: 45,
      );
      final json = slot.toJson();
      final restored = TimeSlot.fromJson(json);
      expect(restored.time, slot.time);
      expect(restored.available, slot.available);
      expect(restored.staffId, isNull);
    });
  });

  group('HoldResponse', () {
    test('deserializes from ME response', () {
      final json = {
        'hold_id': 'hold-abc',
        'expires_at': '2026-07-01T17:00:00Z',
        'final_staff_id': 'staff:2',
        'assigned_resource_id': null,
      };
      final hold = HoldResponse.fromJson(json);
      expect(hold.holdId, 'hold-abc');
      expect(hold.expiresAt, '2026-07-01T17:00:00Z');
      expect(hold.finalStaffId, 'staff:2');
      expect(hold.assignedResourceId, isNull);
    });
  });

  group('BookingConfirmation', () {
    test('deserializes from ME response', () {
      final json = {
        'booking_id': 'bk-123',
        'status': 'confirmed',
        'service_title': 'Haircut',
        'price_at_booking': 499.0,
        'start_time': '2026-07-02T09:00:00Z',
        'end_time': '2026-07-02T10:00:00Z',
      };
      final conf = BookingConfirmation.fromJson(json);
      expect(conf.bookingId, 'bk-123');
      expect(conf.status, 'confirmed');
      expect(conf.serviceTitle, 'Haircut');
      expect(conf.priceAtBooking, 499.0);
    });
  });

  group('BookingListItem', () {
    test('deserializes from ME response', () {
      final json = {
        'booking_id': 'bk-456',
        'status': 'confirmed',
        'establishment': 'bella-salon',
        'service_title': 'Color Treatment',
        'duration': 90,
        'price_at_booking': 1200.0,
        'start_time': '2026-07-03T11:00:00Z',
        'end_time': '2026-07-03T12:30:00Z',
        'staff': 'staff:3',
        'user_id': 'user:xyz',
      };
      final item = BookingListItem.fromJson(json);
      expect(item.bookingId, 'bk-456');
      expect(item.establishment, 'bella-salon');
      expect(item.duration, 90);
      expect(item.cancellationReason, isNull);
      expect(item.rescheduledFrom, isNull);
    });
  });

  group('CancelResponse', () {
    test('deserializes from ME response', () {
      final json = {
        'booking_id': 'bk-789',
        'status': 'cancelled',
        'cancellation_reason': 'Customer request',
      };
      final cancel = CancelResponse.fromJson(json);
      expect(cancel.bookingId, 'bk-789');
      expect(cancel.status, 'cancelled');
      expect(cancel.cancellationReason, 'Customer request');
    });
  });

  // --- BookingRepository HTTP tests ---

  group('BookingRepository', () {
    late MercuryApi api;
    late BookingRepository repo;

    /// Creates a [MercuryApi] backed by a [MockClient] that returns
    /// [responseBody] for the first request matching [expectedPath].
    MercuryApi mockApi(
      String expectedPath,
      Object responseBody, {
      int statusCode = 200,
    }) {
      final client = MockClient((request) async {
        expect(
          request.url.path + '?' + request.url.query,
          contains(expectedPath.split('?').last),
        );
        return http.Response(
          jsonEncode(responseBody),
          statusCode,
          headers: {'content-type': 'application/json'},
        );
      });
      return MercuryApi(
        baseUrl: 'http://localhost:8005',
        httpClient: client,
      )..accessToken = 'test-sdb-jwt';
    }

    test('getAvailability returns TimeSlot list', () async {
      api = mockApi('/availability', {
        'slots': [
          {
            'time': '09:00',
            'available': true,
            'duration': 60,
          },
          {
            'time': '10:00',
            'available': false,
            'duration': 60,
          },
        ],
      });
      repo = BookingRepository(api);

      final slots = await repo.getAvailability(
        companySlug: 'bella-salon',
        serviceIds: ['svc:1'],
        date: '2026-07-02',
      );

      expect(slots, hasLength(2));
      expect(slots[0].time, '09:00');
      expect(slots[0].available, true);
      expect(slots[1].available, false);
    });

    test('holdSlot returns HoldResponse', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['company_slug'], 'bella-salon');
        expect(body['services'], ['svc:1']);
        expect(body['slot_time'], '09:00');
        return http.Response(
          jsonEncode({
            'hold_id': 'hold-new',
            'expires_at': '2026-07-02T09:10:00Z',
            'final_staff_id': 'staff:1',
            'assigned_resource_id': null,
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });
      api = MercuryApi(
        baseUrl: 'http://localhost:8005',
        httpClient: client,
      )..accessToken = 'test-sdb-jwt';
      repo = BookingRepository(api);

      final hold = await repo.holdSlot(
        companySlug: 'bella-salon',
        serviceIds: ['svc:1'],
        date: '2026-07-02',
        slotTime: '09:00',
        userId: 'user:abc',
      );

      expect(hold.holdId, 'hold-new');
      expect(hold.finalStaffId, 'staff:1');
    });

    test('confirmBooking returns BookingConfirmation', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/bookings/confirm');
        return http.Response(
          jsonEncode({
            'booking_id': 'bk-confirmed',
            'status': 'confirmed',
            'service_title': 'Haircut',
            'price_at_booking': 499.0,
            'start_time': '2026-07-02T09:00:00Z',
            'end_time': '2026-07-02T10:00:00Z',
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });
      api = MercuryApi(
        baseUrl: 'http://localhost:8005',
        httpClient: client,
      )..accessToken = 'test-sdb-jwt';
      repo = BookingRepository(api);

      final conf = await repo.confirmBooking(
        holdId: 'hold-new',
        companySlug: 'bella-salon',
      );

      expect(conf.bookingId, 'bk-confirmed');
      expect(conf.status, 'confirmed');
      expect(conf.priceAtBooking, 499.0);
    });

    test('getBookings returns list', () async {
      api = mockApi('/bookings', {
        'bookings': [
          {
            'booking_id': 'bk-1',
            'status': 'confirmed',
            'establishment': 'bella-salon',
            'service_title': 'Haircut',
            'duration': 60,
            'price_at_booking': 499.0,
            'start_time': '2026-07-02T09:00:00Z',
            'end_time': '2026-07-02T10:00:00Z',
            'staff': 'staff:1',
          },
        ],
      });
      repo = BookingRepository(api);

      final bookings = await repo.getBookings(
        companySlug: 'bella-salon',
      );

      expect(bookings, hasLength(1));
      expect(bookings[0].bookingId, 'bk-1');
      expect(bookings[0].serviceTitle, 'Haircut');
    });

    test('cancelBooking returns CancelResponse', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/bookings/bk-1/cancel');
        return http.Response(
          jsonEncode({
            'booking_id': 'bk-1',
            'status': 'cancelled',
            'cancellation_reason': 'Changed my mind',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      api = MercuryApi(
        baseUrl: 'http://localhost:8005',
        httpClient: client,
      )..accessToken = 'test-sdb-jwt';
      repo = BookingRepository(api);

      final cancel = await repo.cancelBooking(
        bookingId: 'bk-1',
        companySlug: 'bella-salon',
        reason: 'Changed my mind',
      );

      expect(cancel.bookingId, 'bk-1');
      expect(cancel.status, 'cancelled');
      expect(cancel.cancellationReason, 'Changed my mind');
    });

    test('API passes Bearer token from accessToken', () async {
      String? capturedAuth;
      final client = MockClient((request) async {
        capturedAuth = request.headers['Authorization'];
        return http.Response(
          jsonEncode({
            'slots': <dynamic>[],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      api = MercuryApi(
        baseUrl: 'http://localhost:8005',
        httpClient: client,
      )..accessToken = 'my-surrealdb-consumer-jwt';
      repo = BookingRepository(api);

      await repo.getAvailability(
        companySlug: 'test',
        serviceIds: ['svc:1'],
        date: '2026-07-02',
      );

      expect(
        capturedAuth,
        'Bearer my-surrealdb-consumer-jwt',
      );
    });

    test('MercuryApiException on 401 (token expired)', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({'detail': 'Token expired'}),
          401,
          headers: {'content-type': 'application/json'},
        );
      });
      api = MercuryApi(
        baseUrl: 'http://localhost:8005',
        httpClient: client,
      )..accessToken = 'expired-jwt';
      repo = BookingRepository(api);

      expect(
        () => repo.getBookings(companySlug: 'test'),
        throwsA(isA<MercuryApiException>()),
      );
    });
  });
}
