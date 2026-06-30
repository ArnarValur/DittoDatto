/// Represents an available time slot for booking.
///
/// Mock data for now — will be computed by MercuryEngine's
/// availability engine when it ships.
class MockTimeSlot {
  const MockTimeSlot({
    required this.time,
    required this.period,
  });

  /// Time as HH:mm string (e.g. "09:00").
  final String time;

  /// Period grouping: 'morning' or 'afternoon'.
  final String period;

  /// Generate synthetic 30-min slots for a given date.
  ///
  /// Morning: 09:00–11:30, Afternoon: 12:00–16:00.
  /// Skips some slots pseudo-randomly to look realistic.
  static List<MockTimeSlot> generateForDate(DateTime date) {
    final slots = <MockTimeSlot>[];
    final seed = date.day + date.month;

    // Morning slots (09:00 - 11:30)
    for (var hour = 9; hour < 12; hour++) {
      for (final min in [0, 30]) {
        // Skip ~30% of slots to look realistic.
        if ((hour + min + seed) % 3 == 0) continue;
        final timeStr =
            '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
        slots.add(MockTimeSlot(time: timeStr, period: 'morning'));
      }
    }

    // Afternoon slots (12:00 - 16:00)
    for (var hour = 12; hour <= 16; hour++) {
      for (final min in [0, 30]) {
        if (hour == 16 && min == 30) break; // Stop at 16:00.
        if ((hour + min + seed) % 4 == 0) continue;
        final timeStr =
            '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
        slots.add(MockTimeSlot(time: timeStr, period: 'afternoon'));
      }
    }

    return slots;
  }
}
