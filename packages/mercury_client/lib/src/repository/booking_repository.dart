import '../api/mercury_api.dart';
import '../models/booking.dart';

/// Repository for booking operations against MercuryEngine API.
///
/// Uses [MercuryApi] for HTTP transport. The consumer's SurrealDB JWT
/// is passed as the Bearer token (Delegated Trust — ADR-0032).
class BookingRepository {
  BookingRepository(this._api);

  final MercuryApi _api;

  /// Fetch available time slots for a company/service/date.
  ///
  /// Calls ME's `GET /availability?company_slug=...&service_ids=...&date=...`.
  Future<List<TimeSlot>> getAvailability({
    required String companySlug,
    required List<String> serviceIds,
    required String date,
    String? staffId,
  }) async {
    final params = <String, String>{
      'company_slug': companySlug,
      'date': date,
    };
    // ME expects repeated `service_ids` query params
    final serviceParams =
        serviceIds.map((id) => 'service_ids=$id').join('&');
    final staffParam =
        staffId != null ? '&staff_id=$staffId' : '';
    final path =
        '/availability?company_slug=$companySlug&$serviceParams&date=$date$staffParam';

    final data = await _api.get(path) as Map<String, dynamic>;
    final slots = data['slots'] as List<dynamic>;
    return slots
        .map(
          (s) => TimeSlot.fromJson(s as Map<String, dynamic>),
        )
        .toList();
  }

  /// Create a hold on a time slot.
  ///
  /// Calls ME's `POST /holds`.
  Future<HoldResponse> holdSlot({
    required String companySlug,
    required List<String> serviceIds,
    required String date,
    required String slotTime,
    required String userId,
    String? staffId,
  }) async {
    final data = await _api.post(
      '/holds',
      body: {
        'company_slug': companySlug,
        'services': serviceIds,
        'date': date,
        'slot_time': slotTime,
        'user_id': userId,
        if (staffId != null) 'staff': staffId,
      },
    ) as Map<String, dynamic>;
    return HoldResponse.fromJson(data);
  }

  /// Confirm a held booking.
  ///
  /// Calls ME's `POST /bookings/confirm`.
  Future<BookingConfirmation> confirmBooking({
    required String holdId,
    required String companySlug,
  }) async {
    final data = await _api.post(
      '/bookings/confirm',
      body: {
        'hold_id': holdId,
        'company_slug': companySlug,
      },
    ) as Map<String, dynamic>;
    return BookingConfirmation.fromJson(data);
  }

  /// List bookings for a company, optionally filtered by status.
  ///
  /// Calls ME's `GET /bookings?company_slug=...&status=...`.
  Future<List<BookingListItem>> getBookings({
    required String companySlug,
    String? status,
  }) async {
    final statusParam =
        status != null ? '&status=$status' : '';
    final path =
        '/bookings?company_slug=$companySlug$statusParam';

    final data = await _api.get(path) as Map<String, dynamic>;
    final bookings = data['bookings'] as List<dynamic>;
    return bookings
        .map(
          (b) => BookingListItem.fromJson(
            b as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Get a single booking by ID.
  ///
  /// Calls ME's `GET /bookings/{id}?company_slug=...`.
  Future<BookingListItem> getBookingById({
    required String bookingId,
    required String companySlug,
  }) async {
    final data = await _api.get(
      '/bookings/$bookingId?company_slug=$companySlug',
    ) as Map<String, dynamic>;
    return BookingListItem.fromJson(data);
  }

  /// Cancel a booking.
  ///
  /// Calls ME's `POST /bookings/{id}/cancel`.
  Future<CancelResponse> cancelBooking({
    required String bookingId,
    required String companySlug,
    String? reason,
  }) async {
    final data = await _api.post(
      '/bookings/$bookingId/cancel',
      body: {
        'company_slug': companySlug,
        if (reason != null) 'reason': reason,
      },
    ) as Map<String, dynamic>;
    return CancelResponse.fromJson(data);
  }
}
