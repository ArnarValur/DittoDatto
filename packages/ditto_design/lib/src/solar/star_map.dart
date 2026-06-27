import 'dart:math';

import 'star_catalog.dart';
import 'sun_calc.dart';

/// A star projected to screen-space percentage coordinates.
class ProjectedStar {
  /// Star name.
  final String name;

  /// X position as percentage (0–100) of screen width.
  final double x;

  /// Y position as percentage (0–100) of screen height.
  final double y;

  /// Display size in logical pixels.
  final double size;

  /// Star color as 32-bit ARGB value.
  final int color;

  /// Whether this is a planet (rendered larger).
  final bool isPlanet;

  const ProjectedStar({
    required this.name,
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    this.isPlanet = false,
  });
}

/// Projects the star catalog to screen coordinates using sidereal time.
///
/// Port of `useStarMap.ts` from the Nuxt SolarTheme.
/// Default location: Drammen, Norway (59.74°N, 10.20°E).
class StarMap {
  /// Observer latitude in degrees.
  final double latitude;

  /// Observer longitude in degrees.
  final double longitude;

  const StarMap({
    this.latitude = 59.74,
    this.longitude = 10.20,
  });

  static double _rad(double d) => d * pi / 180;
  static double _deg(double r) => r * 180 / pi;

  static final DateTime _j2000 = DateTime.utc(2000, 1, 1, 12);

  /// Project all visible stars and planets for the given [dateTime].
  ///
  /// Returns screen-space percentage coordinates (0–100 on both axes).
  List<ProjectedStar> project(DateTime dateTime) {
    // 1. Sidereal time — Earth's rotation angle
    final d =
        (dateTime.millisecondsSinceEpoch - _j2000.millisecondsSinceEpoch) /
            86400000;
    final gmst = (18.697374558 + 24.06570982441908 * d) % 24;
    final lstDeg = ((gmst + longitude / 15 + 24) % 24) * 15;

    final projected = <ProjectedStar>[];
    final latRad = _rad(latitude);

    for (final star in starCatalog) {
      // 2. Equatorial → horizontal coordinates
      final ha = (lstDeg - star.ra + 360) % 360;
      final haRad = _rad(ha);
      final decRad = _rad(star.dec);

      final sinAlt =
          sin(decRad) * sin(latRad) + cos(decRad) * cos(latRad) * cos(haRad);
      final altDeg = _deg(asin(sinAlt));

      final cosAlt = cos(_rad(altDeg));
      final cosAz = (sin(decRad) - sin(_rad(altDeg)) * sin(latRad)) /
          (cosAlt * cos(latRad));
      var azDeg = _deg(acos(cosAz.clamp(-1.0, 1.0)));
      if (sin(haRad) > 0) azDeg = 360 - azDeg;

      // 3. Project to screen — show stars slightly below horizon
      //    for smooth rising/setting
      if (altDeg > -5) {
        projected.add(ProjectedStar(
          name: star.name,
          x: (azDeg / 360) * 100,
          y: 100 - (altDeg / 90) * 100,
          size: (4 - star.magnitude).clamp(1.0, 6.0),
          color: star.color,
        ));
      }
    }

    // 4. Planets — rough positioning relative to the sun
    final sunPos = SunCalc.getPosition(dateTime, latitude, longitude);
    const planets = [
      (name: 'Jupiter', offset: 120.0, color: 0xFFFFE4B5),
      (name: 'Mars', offset: 40.0, color: 0xFFFF9166),
    ];

    for (final p in planets) {
      final pAz = (sunPos.azimuthDeg + 180 + p.offset) % 360;
      final pAlt = sunPos.altitudeDeg + 5;

      if (pAlt > 0) {
        projected.add(ProjectedStar(
          name: p.name,
          x: (pAz / 360) * 100,
          y: 100 - (pAlt / 90) * 100,
          size: 5,
          color: p.color,
          isPlanet: true,
        ));
      }
    }

    return projected;
  }
}
