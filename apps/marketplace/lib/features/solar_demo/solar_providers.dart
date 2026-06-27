import 'dart:async';

import 'package:ditto_design/ditto_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The solar engine instance — Drammen defaults, Moody Blue hue.
final solarEngineProvider = Provider<SolarEngine>((ref) {
  return const SolarEngine();
});

/// The star map instance — same location as the engine.
final starMapProvider = Provider<StarMap>((ref) {
  return const StarMap();
});

/// Manual time override in minutes since midnight (0–1439).
/// When null, the engine uses the real clock.
final solarTimeOverrideProvider =
    NotifierProvider<SolarTimeOverrideNotifier, int?>(
  SolarTimeOverrideNotifier.new,
);

/// Notifier for the manual time override.
class SolarTimeOverrideNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void set(int? minutes) => state = minutes;
  void clear() => state = null;
}

/// Live solar state — recomputes every 60 seconds or on manual override.
final solarStateProvider =
    NotifierProvider<SolarStateNotifier, SolarState>(SolarStateNotifier.new);

/// Projected stars for the current time.
final projectedStarsProvider = Provider<List<ProjectedStar>>((ref) {
  final starMap = ref.watch(starMapProvider);
  final override = ref.watch(solarTimeOverrideProvider);

  final dateTime = _dateTimeFromOverride(override);
  return starMap.project(dateTime);
});

DateTime _dateTimeFromOverride(int? override) {
  if (override == null) return DateTime.now();
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day).add(
    Duration(minutes: override),
  );
}

/// Manages solar state with a 60-second auto-tick.
class SolarStateNotifier extends Notifier<SolarState> {
  Timer? _timer;

  @override
  SolarState build() {
    // Listen for manual override changes
    ref.listen(solarTimeOverrideProvider, (_, override) {
      _recompute(override);
    });

    // Auto-tick every 60 seconds (only when not in manual mode)
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (ref.read(solarTimeOverrideProvider) == null) {
        _recompute(null);
      }
    });

    ref.onDispose(() => _timer?.cancel());

    // Initial compute
    final engine = ref.read(solarEngineProvider);
    final override = ref.read(solarTimeOverrideProvider);
    return engine.compute(_dateTimeFromOverride(override));
  }

  void _recompute(int? override) {
    final engine = ref.read(solarEngineProvider);
    final dateTime = _dateTimeFromOverride(override);
    state = engine.compute(dateTime);
  }

  /// Force an immediate recompute.
  void refresh() => _recompute(ref.read(solarTimeOverrideProvider));
}
