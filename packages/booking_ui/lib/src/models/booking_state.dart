import 'package:establishment_ui/establishment_ui.dart';

import 'mock_staff.dart';
import 'mock_time_slot.dart';

/// Immutable aggregate of all booking selections across the 5 steps.
///
/// Each step reads/writes the relevant fields. The state is preserved
/// when navigating backwards so users don't lose their picks.
class BookingState {
  const BookingState({
    this.selectedServices = const [],
    this.selectedStaff,
    this.selectedDate,
    this.selectedTimeSlot,
    this.customerNote,
    this.establishmentName,
    this.establishmentAddress,
  });

  /// Services selected in Step 1.
  final List<Service> selectedServices;

  /// Staff selected in Step 2 (null = "No Preference").
  final MockStaff? selectedStaff;

  /// Date selected in Step 3.
  final DateTime? selectedDate;

  /// Time slot selected in Step 3.
  final MockTimeSlot? selectedTimeSlot;

  /// Optional customer note from Step 4.
  final String? customerNote;

  /// Establishment name for the review card.
  final String? establishmentName;

  /// Establishment address for the review card.
  final String? establishmentAddress;

  // ── Computed fields ──────────────────────────────────────────────────────

  /// Sum of all selected service prices.
  double get subtotal =>
      selectedServices.fold(0.0, (sum, s) => sum + s.price);

  /// Norwegian MVA at 25%.
  double get taxAmount => subtotal * 0.25;

  /// Total including tax.
  double get totalPrice => subtotal + taxAmount;

  /// Total duration in minutes.
  int get totalDuration =>
      selectedServices.fold(0, (sum, s) => sum + s.duration);

  /// Whether at least one service is selected (Step 1 gate).
  bool get hasServices => selectedServices.isNotEmpty;

  /// Whether a date and time slot are selected (Step 3 gate).
  bool get hasDateTime => selectedDate != null && selectedTimeSlot != null;

  /// Display name for the selected staff.
  String get staffDisplayName =>
      selectedStaff?.name ?? 'Ingen preferanse';

  // ── Service selection logic ──────────────────────────────────────────────

  /// Whether a specific service is currently selected.
  bool isServiceSelected(Service service) =>
      selectedServices.any((s) => s.id == service.id);

  /// Toggle a service, respecting the group's multiSelect flag.
  ///
  /// If the service's group has `multiSelect=false`, selecting this
  /// service deselects any other service in the same group (radio behavior).
  BookingState toggleService(
    Service service,
    List<ServiceGroup> groups,
  ) {
    final isSelected = isServiceSelected(service);
    final updatedServices = List<Service>.from(selectedServices);

    if (isSelected) {
      updatedServices.removeWhere((s) => s.id == service.id);
    } else {
      // Check group's multiSelect flag.
      final group = groups
          .where((g) => g.id == service.groupId)
          .firstOrNull;

      if (group != null && !group.multiSelect) {
        // Radio behavior: remove other services from the same group.
        updatedServices.removeWhere((s) => s.groupId == service.groupId);
      }

      updatedServices.add(service);
    }

    return copyWith(selectedServices: updatedServices);
  }

  // ── Copy helpers ─────────────────────────────────────────────────────────

  BookingState copyWith({
    List<Service>? selectedServices,
    MockStaff? Function()? selectedStaffFn,
    DateTime? Function()? selectedDateFn,
    MockTimeSlot? Function()? selectedTimeSlotFn,
    String? Function()? customerNoteFn,
    String? establishmentName,
    String? establishmentAddress,
  }) {
    return BookingState(
      selectedServices: selectedServices ?? this.selectedServices,
      selectedStaff:
          selectedStaffFn != null ? selectedStaffFn() : selectedStaff,
      selectedDate:
          selectedDateFn != null ? selectedDateFn() : selectedDate,
      selectedTimeSlot: selectedTimeSlotFn != null
          ? selectedTimeSlotFn()
          : selectedTimeSlot,
      customerNote:
          customerNoteFn != null ? customerNoteFn() : customerNote,
      establishmentName: establishmentName ?? this.establishmentName,
      establishmentAddress: establishmentAddress ?? this.establishmentAddress,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingState &&
          runtimeType == other.runtimeType &&
          selectedServices == other.selectedServices &&
          selectedStaff == other.selectedStaff &&
          selectedDate == other.selectedDate &&
          selectedTimeSlot == other.selectedTimeSlot &&
          customerNote == other.customerNote;

  @override
  int get hashCode => Object.hash(
        Object.hashAll(selectedServices),
        selectedStaff,
        selectedDate,
        selectedTimeSlot,
        customerNote,
      );
}
