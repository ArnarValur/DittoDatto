import 'package:ditto_design/ditto_design.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';

import '../models/booking_state.dart';
import '../models/mock_staff.dart';
import '../models/mock_time_slot.dart';
import '../steps/date_time_selection_step.dart';
import '../steps/payment_placeholder_step.dart';
import '../steps/review_step.dart';
import '../steps/service_selection_step.dart';
import '../steps/staff_selection_step.dart';
import 'booking_step_indicator.dart';

/// The main booking flow — a 5-step journey from service selection
/// to payment.
///
/// Manages the [BookingState] and step navigation. The step indicator
/// uses the Stitch Step 1 style (numbered circles, checkmarks for
/// completed steps). Tapping completed step circles navigates back.
/// Selection state is preserved across back-navigation.
///
/// Usage:
/// ```dart
/// BookingFlowPage(
///   establishmentData: data,
///   onClose: () => Navigator.pop(context),
/// )
/// ```
class BookingFlowPage extends StatefulWidget {
  const BookingFlowPage({
    super.key,
    required this.establishmentData,
    required this.onClose,
    this.onFetchSlots,
    this.staffList,
    this.onConfirmBooking,
  });

  /// The establishment being booked — provides services, groups,
  /// name, and address.
  final EstablishmentData establishmentData;

  /// Called when the user closes the booking flow (X button or
  /// back from Step 1).
  final VoidCallback onClose;

  /// Optional callback to fetch real time slots from ME API.
  ///
  /// When null, falls back to [MockTimeSlot.generateForDate].
  /// Signature: (date, serviceIds, staffId?) → List<MockTimeSlot>
  final Future<List<MockTimeSlot>> Function(
    DateTime date,
    List<String> serviceIds,
    String? staffId,
  )? onFetchSlots;

  /// Optional list of real staff members.
  ///
  /// When null, falls back to [MockStaff.demoStaff].
  final List<MockStaff>? staffList;

  /// Optional callback invoked when the user confirms (Step 5).
  ///
  /// Returns the booking ID on success, null on failure.
  final Future<String?> Function(BookingState state)? onConfirmBooking;

  @override
  State<BookingFlowPage> createState() => _BookingFlowPageState();
}

class _BookingFlowPageState extends State<BookingFlowPage> {
  int _currentStep = 0;
  late BookingState _state;

  @override
  void initState() {
    super.initState();
    _state = BookingState(
      establishmentName: widget.establishmentData.name,
      establishmentAddress:
          '${widget.establishmentData.address}, ${widget.establishmentData.city}',
    );
  }

  void _goToStep(int step) {
    if (step >= 0 && step <= 4) {
      setState(() => _currentStep = step);
    }
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      _handleClose();
    }
  }

  Future<void> _handleClose() async {
    // Show confirmation if user has made selections.
    if (_state.hasServices) {
      final confirmed = await showDittoConfirmDialog(
        context: context,
        title: 'Avbryt bestilling?',
        message:
            'Du har gjort valg som vil gå tapt. Er du sikker på at du vil avbryte?',
        confirmLabel: 'Avbryt bestilling',
      );
      if (confirmed != true) return;
    }
    widget.onClose();
  }

  void _updateState(BookingState newState) {
    setState(() => _state = newState);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _previousStep,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('DittoDatto'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _handleClose,
            icon: const Icon(Icons.close),
          ),
        ],
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Step indicator.
          BookingStepIndicator(
            currentStep: _currentStep,
            onStepTapped: (step) {
              if (step < _currentStep) {
                _goToStep(step);
              }
            },
          ),

          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),

          // Step content.
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: _buildCurrentStep(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    return switch (_currentStep) {
      0 => ServiceSelectionStep(
          key: const ValueKey('step-0'),
          services: widget.establishmentData.services,
          serviceGroups: widget.establishmentData.serviceGroups,
          state: _state,
          onStateChanged: _updateState,
          onContinue: _nextStep,
        ),
      1 => StaffSelectionStep(
          key: const ValueKey('step-1'),
          state: _state,
          onStateChanged: _updateState,
          onContinue: _nextStep,
          staffList: widget.staffList,
        ),
      2 => DateTimeSelectionStep(
          key: const ValueKey('step-2'),
          state: _state,
          onStateChanged: _updateState,
          onContinue: _nextStep,
          onFetchSlots: widget.onFetchSlots,
        ),
      3 => ReviewStep(
          key: const ValueKey('step-3'),
          state: _state,
          onStateChanged: _updateState,
          onContinue: _nextStep,
          onEditStep: _goToStep,
        ),
      4 => PaymentPlaceholderStep(
          key: const ValueKey('step-4'),
          state: _state,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
