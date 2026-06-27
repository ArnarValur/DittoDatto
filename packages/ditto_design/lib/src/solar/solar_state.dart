/// Solar phase derived from sun altitude thresholds.
enum SolarPhase {
  /// Sun below -18° — full darkness.
  night('Night'),

  /// Sun between -18° and -12°.
  astronomicalTwilight('Astronomical Twilight'),

  /// Sun between -12° and -6° — stars begin appearing.
  nauticalTwilight('Nautical Twilight'),

  /// Sun between -6° and 0°.
  civilTwilight('Civil Twilight'),

  /// Sun between -2° and 8° — warm golden palette.
  goldenHour('Golden Hour'),

  /// Sun above 0° (outside golden hour range).
  day('Day');

  const SolarPhase(this.label);

  /// Human-readable label.
  final String label;
}

/// Immutable snapshot of the solar engine's computed state.
///
/// Drives atmospheric gradient, star field opacity, and theme mode.
class SolarState {
  /// Sun altitude in degrees.
  final double altitude;

  /// Sun azimuth in degrees.
  final double azimuth;

  /// Atmospheric lightness (0–100).
  final double lightness;

  /// Atmospheric hue in degrees.
  final double hue;

  /// Atmospheric saturation (0–100).
  final double saturation;

  /// Current solar phase.
  final SolarPhase phase;

  /// Star field opacity (0.0–1.0).
  final double starOpacity;

  const SolarState({
    required this.altitude,
    required this.azimuth,
    required this.lightness,
    required this.hue,
    required this.saturation,
    required this.phase,
    required this.starOpacity,
  });

  /// Whether the UI should use dark theme (lightness < 40).
  bool get isDark => lightness < 40;

  /// Default state representing midnight.
  static const SolarState midnight = SolarState(
    altitude: -30,
    azimuth: 0,
    lightness: 5,
    hue: 237, // Moody Blue hue
    saturation: 45,
    phase: SolarPhase.night,
    starOpacity: 1.0,
  );
}
