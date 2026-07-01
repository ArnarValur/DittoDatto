/// Booking policy model for an Establishment.
///
/// Maps to the SurrealDB `booking_policy` embedded object (9 subfields).
/// All fields have sane defaults matching the schema DEFAULTs.
class BookingPolicy {
  const BookingPolicy({
    this.maxBookableFutureDays = 60,
    this.minBookingNoticeMinutes = 60,
    this.slotInterval = 15,
    this.clientCancelEnabled = true,
    this.minCancelNoticeHours = 24,
    this.clientRescheduleEnabled = true,
    this.minRescheduleNoticeHours = 24,
    this.bookingConfirmationMessage,
    this.noShowFeePercent = 0,
  });

  /// How far ahead (in days) a customer can book. Default: 60.
  final int maxBookableFutureDays;

  /// Minimum notice (in minutes) before a booking slot starts. Default: 60.
  final int minBookingNoticeMinutes;

  /// Slot grid interval in minutes (5, 10, 15, 30, 60). Default: 15.
  final int slotInterval;

  /// Whether customers can cancel bookings. Default: true.
  final bool clientCancelEnabled;

  /// Cancellation deadline in hours before the booking. Default: 24.
  final int minCancelNoticeHours;

  /// Whether customers can reschedule bookings. Default: true.
  final bool clientRescheduleEnabled;

  /// Reschedule deadline in hours before the booking. Default: 24.
  final int minRescheduleNoticeHours;

  /// Optional custom confirmation message shown after booking.
  final String? bookingConfirmationMessage;

  /// No-show fee as percentage of service price (0–100). Default: 0.
  /// Note: Values > 0 require Vipps payment integration (future).
  final int noShowFeePercent;

  /// Parse from SurrealDB JSON.
  factory BookingPolicy.fromJson(Map<String, dynamic> json) {
    return BookingPolicy(
      maxBookableFutureDays: json['max_bookable_future_days'] as int? ?? 60,
      minBookingNoticeMinutes:
          json['min_booking_notice_minutes'] as int? ?? 60,
      slotInterval: json['slot_interval'] as int? ?? 15,
      clientCancelEnabled:
          json['client_cancel_enabled'] as bool? ?? true,
      minCancelNoticeHours:
          json['min_cancel_notice_hours'] as int? ?? 24,
      clientRescheduleEnabled:
          json['client_reschedule_enabled'] as bool? ?? true,
      minRescheduleNoticeHours:
          json['min_reschedule_notice_hours'] as int? ?? 24,
      bookingConfirmationMessage:
          json['booking_confirmation_message'] as String?,
      noShowFeePercent: json['no_show_fee_percent'] as int? ?? 0,
    );
  }

  /// Serialize to JSON for SurrealDB.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'max_bookable_future_days': maxBookableFutureDays,
      'min_booking_notice_minutes': minBookingNoticeMinutes,
      'slot_interval': slotInterval,
      'client_cancel_enabled': clientCancelEnabled,
      'min_cancel_notice_hours': minCancelNoticeHours,
      'client_reschedule_enabled': clientRescheduleEnabled,
      'min_reschedule_notice_hours': minRescheduleNoticeHours,
      'no_show_fee_percent': noShowFeePercent,
    };
    if (bookingConfirmationMessage != null) {
      json['booking_confirmation_message'] = bookingConfirmationMessage;
    }
    return json;
  }

  /// Create a copy with overrides.
  BookingPolicy copyWith({
    int? maxBookableFutureDays,
    int? minBookingNoticeMinutes,
    int? slotInterval,
    bool? clientCancelEnabled,
    int? minCancelNoticeHours,
    bool? clientRescheduleEnabled,
    int? minRescheduleNoticeHours,
    String? Function()? bookingConfirmationMessage,
    int? noShowFeePercent,
  }) {
    return BookingPolicy(
      maxBookableFutureDays:
          maxBookableFutureDays ?? this.maxBookableFutureDays,
      minBookingNoticeMinutes:
          minBookingNoticeMinutes ?? this.minBookingNoticeMinutes,
      slotInterval: slotInterval ?? this.slotInterval,
      clientCancelEnabled:
          clientCancelEnabled ?? this.clientCancelEnabled,
      minCancelNoticeHours:
          minCancelNoticeHours ?? this.minCancelNoticeHours,
      clientRescheduleEnabled:
          clientRescheduleEnabled ?? this.clientRescheduleEnabled,
      minRescheduleNoticeHours:
          minRescheduleNoticeHours ?? this.minRescheduleNoticeHours,
      bookingConfirmationMessage: bookingConfirmationMessage != null
          ? bookingConfirmationMessage()
          : this.bookingConfirmationMessage,
      noShowFeePercent: noShowFeePercent ?? this.noShowFeePercent,
    );
  }

  /// Default booking policy with all schema defaults.
  static const defaults = BookingPolicy();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingPolicy &&
          maxBookableFutureDays == other.maxBookableFutureDays &&
          minBookingNoticeMinutes == other.minBookingNoticeMinutes &&
          slotInterval == other.slotInterval &&
          clientCancelEnabled == other.clientCancelEnabled &&
          minCancelNoticeHours == other.minCancelNoticeHours &&
          clientRescheduleEnabled == other.clientRescheduleEnabled &&
          minRescheduleNoticeHours == other.minRescheduleNoticeHours &&
          bookingConfirmationMessage == other.bookingConfirmationMessage &&
          noShowFeePercent == other.noShowFeePercent;

  @override
  int get hashCode => Object.hash(
        maxBookableFutureDays,
        minBookingNoticeMinutes,
        slotInterval,
        clientCancelEnabled,
        minCancelNoticeHours,
        clientRescheduleEnabled,
        minRescheduleNoticeHours,
        bookingConfirmationMessage,
        noShowFeePercent,
      );
}
