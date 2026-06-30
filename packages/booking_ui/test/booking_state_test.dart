import 'package:booking_ui/booking_ui.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── Test fixtures ─────────────────────────────────────────────────────

  final multiSelectGroup = const ServiceGroup(
    id: 'service_group:hair',
    name: 'Hair',
    multiSelect: true,
  );

  final singleSelectGroup = const ServiceGroup(
    id: 'service_group:treatments',
    name: 'Treatments',
    multiSelect: false,
  );

  final groups = [multiSelectGroup, singleSelectGroup];

  final haircut = const Service(
    id: 'service:haircut',
    title: 'Classic Haircut',
    duration: 30,
    price: 450.0,
    groupId: 'service_group:hair',
  );

  final beardTrim = const Service(
    id: 'service:beard',
    title: 'Beard Trim & Shape',
    duration: 20,
    price: 250.0,
    groupId: 'service_group:hair',
  );

  final scalpMassage = const Service(
    id: 'service:scalp',
    title: 'Scalp Massage',
    duration: 15,
    price: 150.0,
    groupId: 'service_group:treatments',
  );

  final deepTissue = const Service(
    id: 'service:deep',
    title: 'Deep Tissue',
    duration: 60,
    price: 800.0,
    groupId: 'service_group:treatments',
  );

  // ── Price calculation ─────────────────────────────────────────────────

  group('Price calculation', () {
    test('empty state has zero totals', () {
      const state = BookingState();
      expect(state.subtotal, 0.0);
      expect(state.taxAmount, 0.0);
      expect(state.totalPrice, 0.0);
      expect(state.totalDuration, 0);
    });

    test('single service calculates correctly', () {
      final state = BookingState(selectedServices: [haircut]);
      expect(state.subtotal, 450.0);
      expect(state.taxAmount, 112.5); // 25% MVA
      expect(state.totalPrice, 562.5);
      expect(state.totalDuration, 30);
    });

    test('multiple services aggregate correctly', () {
      final state = BookingState(
        selectedServices: [haircut, beardTrim, scalpMassage],
      );
      expect(state.subtotal, 850.0); // 450 + 250 + 150
      expect(state.taxAmount, 212.5); // 25% of 850
      expect(state.totalPrice, 1062.5);
      expect(state.totalDuration, 65); // 30 + 20 + 15
    });
  });

  // ── Service selection logic ───────────────────────────────────────────

  group('Service toggling', () {
    test('toggle adds a service', () {
      const state = BookingState();
      final updated = state.toggleService(haircut, groups);
      expect(updated.selectedServices, contains(haircut));
      expect(updated.selectedServices.length, 1);
    });

    test('toggle removes a selected service', () {
      final state = BookingState(selectedServices: [haircut]);
      final updated = state.toggleService(haircut, groups);
      expect(updated.selectedServices, isEmpty);
    });

    test('multiSelect=true group allows multiple services', () {
      final state = BookingState(selectedServices: [haircut]);
      final updated = state.toggleService(beardTrim, groups);
      expect(updated.selectedServices, containsAll([haircut, beardTrim]));
      expect(updated.selectedServices.length, 2);
    });

    test('multiSelect=false group deselects previous (radio)', () {
      final state = BookingState(selectedServices: [scalpMassage]);
      final updated = state.toggleService(deepTissue, groups);
      expect(updated.selectedServices, contains(deepTissue));
      expect(updated.selectedServices, isNot(contains(scalpMassage)));
      expect(updated.selectedServices.length, 1);
    });

    test('radio group does not affect other groups', () {
      final state = BookingState(
        selectedServices: [haircut, scalpMassage],
      );
      // Selecting deepTissue should only deselect scalpMassage (same group),
      // not haircut (different group).
      final updated = state.toggleService(deepTissue, groups);
      expect(updated.selectedServices, containsAll([haircut, deepTissue]));
      expect(updated.selectedServices, isNot(contains(scalpMassage)));
      expect(updated.selectedServices.length, 2);
    });
  });

  // ── Gate checks ───────────────────────────────────────────────────────

  group('Gate checks', () {
    test('hasServices is false when empty', () {
      const state = BookingState();
      expect(state.hasServices, false);
    });

    test('hasServices is true with selections', () {
      final state = BookingState(selectedServices: [haircut]);
      expect(state.hasServices, true);
    });

    test('hasDateTime is false without both date and time', () {
      const state = BookingState();
      expect(state.hasDateTime, false);

      final withDate = state.copyWith(
        selectedDateFn: () => DateTime(2026, 7, 1),
      );
      expect(withDate.hasDateTime, false);
    });

    test('hasDateTime is true with both', () {
      final state = BookingState(
        selectedDate: DateTime(2026, 7, 1),
        selectedTimeSlot: const MockTimeSlot(
          time: '09:00',
          period: 'morning',
        ),
      );
      expect(state.hasDateTime, true);
    });
  });

  // ── Staff display ─────────────────────────────────────────────────────

  group('Staff display', () {
    test('no staff selected shows "Ingen preferanse"', () {
      const state = BookingState();
      expect(state.staffDisplayName, 'Ingen preferanse');
    });

    test('selected staff shows their name', () {
      final state = BookingState(
        selectedStaff: MockStaff.demoStaff.first,
      );
      expect(state.staffDisplayName, 'Lars Jensen');
    });
  });

  // ── Mock time slots ───────────────────────────────────────────────────

  group('MockTimeSlot.generateForDate', () {
    test('generates non-empty morning and afternoon slots', () {
      final slots = MockTimeSlot.generateForDate(DateTime(2026, 7, 1));
      expect(slots, isNotEmpty);

      final morningSlots =
          slots.where((s) => s.period == 'morning').toList();
      final afternoonSlots =
          slots.where((s) => s.period == 'afternoon').toList();

      expect(morningSlots, isNotEmpty);
      expect(afternoonSlots, isNotEmpty);
    });

    test('different dates produce different slot patterns', () {
      final slots1 = MockTimeSlot.generateForDate(DateTime(2026, 7, 1));
      final slots2 = MockTimeSlot.generateForDate(DateTime(2026, 7, 2));

      // The sets should differ (pseudo-random skip is date-seeded).
      final times1 = slots1.map((s) => s.time).toSet();
      final times2 = slots2.map((s) => s.time).toSet();
      expect(times1, isNot(equals(times2)));
    });

    test('morning slots are before 12:00', () {
      final slots = MockTimeSlot.generateForDate(DateTime(2026, 7, 1));
      for (final slot in slots.where((s) => s.period == 'morning')) {
        final hour = int.parse(slot.time.split(':')[0]);
        expect(hour, lessThan(12));
      }
    });

    test('afternoon slots are 12:00 or later', () {
      final slots = MockTimeSlot.generateForDate(DateTime(2026, 7, 1));
      for (final slot in slots.where((s) => s.period == 'afternoon')) {
        final hour = int.parse(slot.time.split(':')[0]);
        expect(hour, greaterThanOrEqualTo(12));
      }
    });
  });
}
