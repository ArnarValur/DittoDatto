import 'solar_state.dart';
import 'sun_calc.dart';

/// Maps real-time sun position to atmospheric HSL values and solar phase.
///
/// Pure Dart — no framework dependency. Port of `useSolarEngine.ts`
/// from the Nuxt SolarTheme, re-seeded with Moody Blue (hue 237).
///
/// Default location: Drammen, Norway (59.74°N, 10.20°E).
class SolarEngine {
  /// Observer latitude in degrees.
  final double latitude;

  /// Observer longitude in degrees.
  final double longitude;

  /// Base hue for the atmospheric gradient.
  ///
  /// Default 237 ≈ Moody Blue. The original Nuxt "slate" preset was 215.
  final double baseHue;

  /// Base saturation for the atmospheric gradient (0–100).
  final double baseSaturation;

  const SolarEngine({
    this.latitude = 59.74,
    this.longitude = 10.20,
    this.baseHue = 237,
    this.baseSaturation = 45,
  });

  /// Compute solar state for the given [dateTime].
  ///
  /// Pure function — no side effects, no timers.
  SolarState compute(DateTime dateTime) {
    final position = SunCalc.getPosition(dateTime, latitude, longitude);
    final altitudeDeg = position.altitudeDeg;
    final azimuthDeg = position.azimuthDeg;

    // 1. Lightness from altitude
    //    Map -20° (dark) → 5%, 60° (bright) → 95%
    var lightness = ((altitudeDeg + 20) / 80) * 90 + 5;
    lightness = lightness.clamp(5.0, 95.0);

    // 2. Start from base palette
    var hue = baseHue;
    var saturation = baseSaturation;

    // 3. Saturation damping — "Nordic Studio" vibe
    //    As the sky brightens past 50% lightness, desaturate for
    //    that washed Scandinavian daylight feel.
    if (lightness > 50 && baseSaturation > 0) {
      final dampFactor = (1 - (lightness - 50) / 55).clamp(0.0, 1.0);
      saturation = (saturation * dampFactor).clamp(5.0, baseSaturation);
    }

    // 4. Golden hour override — warm the palette near the horizon
    if (altitudeDeg >= -2 && altitudeDeg <= 8) {
      hue = 40; // warm golden
      saturation = 70;
    }

    // 5. Star visibility — stars ramp in below -6°
    var starOpacity = 0.0;
    if (altitudeDeg < -6) {
      starOpacity = ((altitudeDeg.abs() - 6) / 12).clamp(0.0, 1.0);
    }

    // 6. Phase classification
    final phase = _classifyPhase(altitudeDeg);

    return SolarState(
      altitude: altitudeDeg,
      azimuth: azimuthDeg,
      lightness: lightness,
      hue: hue,
      saturation: saturation,
      phase: phase,
      starOpacity: starOpacity,
    );
  }

  static SolarPhase _classifyPhase(double altitudeDeg) {
    // Golden hour takes priority when altitude is near the horizon
    if (altitudeDeg > -2 && altitudeDeg < 8) return SolarPhase.goldenHour;
    if (altitudeDeg > 0) return SolarPhase.day;
    if (altitudeDeg > -6) return SolarPhase.civilTwilight;
    if (altitudeDeg > -12) return SolarPhase.nauticalTwilight;
    if (altitudeDeg > -18) return SolarPhase.astronomicalTwilight;
    return SolarPhase.night;
  }
}
