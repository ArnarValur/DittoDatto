import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

/// A time slot returned by ME's /availability endpoint.
@JsonSerializable()
class TimeSlot {
  const TimeSlot({
    required this.time,
    required this.available,
    this.staffId,
    this.staffName,
    this.duration,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);

  /// Slot start time (HH:MM format).
  final String time;

  /// Whether this slot is available for booking.
  final bool available;

  /// Assigned staff ID (if staff-specific).
  @JsonKey(name: 'staff_id')
  final String? staffId;

  /// Staff display name.
  @JsonKey(name: 'staff_name')
  final String? staffName;

  /// Total duration in minutes.
  final int? duration;

  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
}

/// Response from ME's POST /holds endpoint.
@JsonSerializable()
class HoldResponse {
  const HoldResponse({
    required this.holdId,
    required this.expiresAt,
    this.finalStaffId,
    this.assignedResourceId,
  });

  factory HoldResponse.fromJson(Map<String, dynamic> json) =>
      _$HoldResponseFromJson(json);

  @JsonKey(name: 'hold_id')
  final String holdId;

  @JsonKey(name: 'expires_at')
  final String expiresAt;

  @JsonKey(name: 'final_staff_id')
  final String? finalStaffId;

  @JsonKey(name: 'assigned_resource_id')
  final String? assignedResourceId;

  Map<String, dynamic> toJson() => _$HoldResponseToJson(this);
}

/// Response from ME's POST /bookings/confirm endpoint.
@JsonSerializable()
class BookingConfirmation {
  const BookingConfirmation({
    required this.bookingId,
    required this.status,
    required this.serviceTitle,
    required this.priceAtBooking,
    required this.startTime,
    required this.endTime,
  });

  factory BookingConfirmation.fromJson(Map<String, dynamic> json) =>
      _$BookingConfirmationFromJson(json);

  @JsonKey(name: 'booking_id')
  final String bookingId;

  final String status;

  @JsonKey(name: 'service_title')
  final String serviceTitle;

  @JsonKey(name: 'price_at_booking')
  final double priceAtBooking;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  Map<String, dynamic> toJson() => _$BookingConfirmationToJson(this);
}

/// A booking item from ME's GET /bookings and GET /bookings/{id} endpoints.
@JsonSerializable()
class BookingListItem {
  const BookingListItem({
    required this.bookingId,
    required this.status,
    required this.establishment,
    required this.serviceTitle,
    required this.duration,
    required this.priceAtBooking,
    this.startTime,
    this.endTime,
    this.staff,
    this.resource,
    this.userId,
    this.cancellationReason,
    this.rescheduledFrom,
    this.rescheduledTo,
  });

  factory BookingListItem.fromJson(Map<String, dynamic> json) =>
      _$BookingListItemFromJson(json);

  @JsonKey(name: 'booking_id')
  final String bookingId;

  final String status;

  final String establishment;

  @JsonKey(name: 'service_title')
  final String serviceTitle;

  final int duration;

  @JsonKey(name: 'price_at_booking')
  final double priceAtBooking;

  @JsonKey(name: 'start_time')
  final String? startTime;

  @JsonKey(name: 'end_time')
  final String? endTime;

  final String? staff;

  final String? resource;

  @JsonKey(name: 'user_id')
  final String? userId;

  @JsonKey(name: 'cancellation_reason')
  final String? cancellationReason;

  @JsonKey(name: 'rescheduled_from')
  final String? rescheduledFrom;

  @JsonKey(name: 'rescheduled_to')
  final String? rescheduledTo;

  Map<String, dynamic> toJson() => _$BookingListItemToJson(this);
}

/// Response from ME's POST /bookings/{id}/cancel endpoint.
@JsonSerializable()
class CancelResponse {
  const CancelResponse({
    required this.bookingId,
    required this.status,
    this.cancellationReason,
  });

  factory CancelResponse.fromJson(Map<String, dynamic> json) =>
      _$CancelResponseFromJson(json);

  @JsonKey(name: 'booking_id')
  final String bookingId;

  final String status;

  @JsonKey(name: 'cancellation_reason')
  final String? cancellationReason;

  Map<String, dynamic> toJson() => _$CancelResponseToJson(this);
}
