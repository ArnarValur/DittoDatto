/// Opening schedule models for an Establishment.
///
/// Maps to the SurrealDB `opening_schedule` embedded object:
/// ```sql
/// DEFINE FIELD opening_schedule   ON establishment TYPE option<object>;
/// DEFINE FIELD opening_schedule.* ON establishment TYPE object;
/// DEFINE FIELD opening_schedule.*.is_open ON establishment TYPE bool;
/// DEFINE FIELD opening_schedule.*.open    ON establishment TYPE string;
/// DEFINE FIELD opening_schedule.*.close   ON establishment TYPE string;
/// ```
library;


/// A single day's opening hours.
class OpeningDay {
  const OpeningDay({
    required this.isOpen,
    this.open = '09:00',
    this.close = '17:00',
  });

  /// Whether the establishment is open on this day.
  final bool isOpen;

  /// Opening time in `HH:MM` format (e.g., `"09:00"`).
  final String open;

  /// Closing time in `HH:MM` format (e.g., `"17:00"`).
  final String close;

  /// Parse from SurrealDB JSON.
  factory OpeningDay.fromJson(Map<String, dynamic> json) {
    return OpeningDay(
      isOpen: json['is_open'] as bool? ?? false,
      open: json['open'] as String? ?? '09:00',
      close: json['close'] as String? ?? '17:00',
    );
  }

  /// Serialize to JSON for SurrealDB.
  Map<String, dynamic> toJson() => {
        'is_open': isOpen,
        'open': open,
        'close': close,
      };

  /// Create a copy with overrides.
  OpeningDay copyWith({
    bool? isOpen,
    String? open,
    String? close,
  }) {
    return OpeningDay(
      isOpen: isOpen ?? this.isOpen,
      open: open ?? this.open,
      close: close ?? this.close,
    );
  }

  /// Default closed day.
  static const closed = OpeningDay(isOpen: false);

  /// Default open day (09:00–17:00).
  static const defaultOpen = OpeningDay(isOpen: true);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpeningDay &&
          isOpen == other.isOpen &&
          open == other.open &&
          close == other.close;

  @override
  int get hashCode => Object.hash(isOpen, open, close);

  @override
  String toString() =>
      isOpen ? 'OpeningDay($open–$close)' : 'OpeningDay(closed)';
}

/// Weekday keys matching SurrealDB `opening_schedule.*` wildcard keys.
///
/// Order is Monday-first (Norwegian business convention).
const weekdayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

/// Norwegian weekday labels for display.
const weekdayLabels = {
  'mon': 'Mandag',
  'tue': 'Tirsdag',
  'wed': 'Onsdag',
  'thu': 'Torsdag',
  'fri': 'Fredag',
  'sat': 'Lørdag',
  'sun': 'Søndag',
};

/// Maps Dart [DateTime.weekday] (1=Mon .. 7=Sun) to schedule key.
const weekdayKeyByIndex = {
  1: 'mon',
  2: 'tue',
  3: 'wed',
  4: 'thu',
  5: 'fri',
  6: 'sat',
  7: 'sun',
};

/// Parse a full opening schedule from SurrealDB JSON.
///
/// Returns a map of weekday key → [OpeningDay]. Missing days default to closed.
Map<String, OpeningDay> parseOpeningSchedule(Map<String, dynamic>? json) {
  if (json == null || json.isEmpty) {
    return {for (final key in weekdayKeys) key: OpeningDay.closed};
  }
  return {
    for (final key in weekdayKeys)
      key: json.containsKey(key)
          ? OpeningDay.fromJson(json[key] as Map<String, dynamic>)
          : OpeningDay.closed,
  };
}

/// Serialize a full opening schedule to JSON for SurrealDB.
Map<String, dynamic> serializeOpeningSchedule(Map<String, OpeningDay> schedule) {
  return {
    for (final entry in schedule.entries)
      entry.key: entry.value.toJson(),
  };
}

/// Check if the establishment is currently open based on schedule and time.
///
/// Uses [now] to determine the current weekday and compares against the
/// schedule's open/close times for today. Returns `null` if no schedule
/// data is available.
bool? isCurrentlyOpen(Map<String, OpeningDay>? schedule, {DateTime? now}) {
  if (schedule == null || schedule.isEmpty) return null;

  final currentTime = now ?? DateTime.now();
  final dayKey = weekdayKeyByIndex[currentTime.weekday];
  if (dayKey == null) return null;

  final today = schedule[dayKey];
  if (today == null || !today.isOpen) return false;

  // Parse open/close times and compare.
  final openParts = today.open.split(':');
  final closeParts = today.close.split(':');
  if (openParts.length < 2 || closeParts.length < 2) return null;

  final openMinutes =
      int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
  final closeMinutes =
      int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);
  final currentMinutes = currentTime.hour * 60 + currentTime.minute;

  return currentMinutes >= openMinutes && currentMinutes < closeMinutes;
}
