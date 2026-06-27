import 'dart:math';

/// Sun position in the sky (altitude and azimuth in radians).
class SunPosition {
  /// Altitude above the horizon in radians.
  final double altitude;

  /// Azimuth (compass bearing) in radians.
  final double azimuth;

  const SunPosition({required this.altitude, required this.azimuth});

  /// Altitude in degrees.
  double get altitudeDeg => altitude * 180 / pi;

  /// Azimuth in degrees.
  double get azimuthDeg => azimuth * 180 / pi;
}

/// Pure Dart port of the suncalc npm package (sun position only).
///
/// Original: https://github.com/mourner/suncalc
/// Only implements [getPosition] — the minimum needed for SolarTheme.
abstract final class SunCalc {
  static const double _rad = pi / 180;
  static const double _dayMs = 86400000;
  static const double _j1970 = 2440588;
  static const double _j2000 = 2451545;
  static const double _e = _rad * 23.4397; // obliquity of the Earth

  static double _toJulian(DateTime date) =>
      date.millisecondsSinceEpoch / _dayMs - 0.5 + _j1970;

  static double _toDays(DateTime date) => _toJulian(date) - _j2000;

  static double _rightAscension(double l, double b) =>
      atan2(sin(l) * cos(_e) - tan(b) * sin(_e), cos(l));

  static double _declination(double l, double b) =>
      asin(sin(b) * cos(_e) + cos(b) * sin(_e) * sin(l));

  static double _azimuth(double h, double phi, double dec) =>
      atan2(sin(h), cos(h) * sin(phi) - tan(dec) * cos(phi));

  static double _altitude(double h, double phi, double dec) =>
      asin(sin(phi) * sin(dec) + cos(phi) * cos(dec) * cos(h));

  static double _siderealTime(double d, double lw) =>
      _rad * (280.16 + 360.9856235 * d) - lw;

  static double _solarMeanAnomaly(double d) =>
      _rad * (357.5291 + 0.98560028 * d);

  static double _eclipticLongitude(double m) {
    final c = _rad *
        (1.9148 * sin(m) + 0.02 * sin(2 * m) + 0.0003 * sin(3 * m));
    const p = _rad * 102.9372; // perihelion of the Earth
    return m + c + p + pi;
  }

  /// Calculate sun position for [date] at [lat]/[lng].
  ///
  /// Returns altitude and azimuth in radians.
  static SunPosition getPosition(DateTime date, double lat, double lng) {
    final lw = _rad * -lng;
    final phi = _rad * lat;
    final d = _toDays(date);
    final m = _solarMeanAnomaly(d);
    final l = _eclipticLongitude(m);
    final dec = _declination(l, 0);
    final ra = _rightAscension(l, 0);
    final h = _siderealTime(d, lw) - ra;

    return SunPosition(
      altitude: _altitude(h, phi, dec),
      azimuth: _azimuth(h, phi, dec) + pi,
    );
  }
}
