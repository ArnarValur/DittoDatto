/// A star in the catalog with equatorial coordinates.
class CatalogStar {
  /// Display name.
  final String name;

  /// Right ascension in degrees.
  final double ra;

  /// Declination in degrees.
  final double dec;

  /// Apparent magnitude (lower = brighter, can be negative).
  final double magnitude;

  /// Display color as 32-bit ARGB value.
  final int color;

  const CatalogStar({
    required this.name,
    required this.ra,
    required this.dec,
    required this.magnitude,
    required this.color,
  });
}

/// 30 real stars visible from Drammen, Norway.
///
/// Includes major constellations: Orion, Ursa Major, Cassiopeia,
/// Ursa Minor, plus bright signpost stars (Sirius, Vega, etc.).
const List<CatalogStar> starCatalog = [
  // ── Orion (The Hunter) ──
  CatalogStar(name: 'Betelgeuse', ra: 88.79, dec: 7.4, magnitude: 0.5, color: 0xFFFFDDAA),
  CatalogStar(name: 'Rigel', ra: 78.63, dec: -8.2, magnitude: 0.12, color: 0xFFC9DFFF),
  CatalogStar(name: 'Bellatrix', ra: 81.28, dec: 6.35, magnitude: 1.64, color: 0xFFB0C2FF),
  CatalogStar(name: 'Saiph', ra: 86.94, dec: -9.67, magnitude: 2.07, color: 0xFFB0C2FF),
  // The Belt
  CatalogStar(name: 'Alnitak', ra: 85.19, dec: -1.94, magnitude: 1.74, color: 0xFFFFFFFF),
  CatalogStar(name: 'Alnilam', ra: 84.05, dec: -1.2, magnitude: 1.69, color: 0xFFFFFFFF),
  CatalogStar(name: 'Mintaka', ra: 83.0, dec: -0.3, magnitude: 2.25, color: 0xFFFFFFFF),

  // ── Ursa Major (Big Dipper) ──
  CatalogStar(name: 'Dubhe', ra: 165.93, dec: 61.75, magnitude: 1.8, color: 0xFFFFD2A1),
  CatalogStar(name: 'Merak', ra: 165.46, dec: 56.38, magnitude: 2.3, color: 0xFFFFFFFF),
  CatalogStar(name: 'Phecda', ra: 178.46, dec: 53.69, magnitude: 2.4, color: 0xFFFFFFFF),
  CatalogStar(name: 'Megrez', ra: 183.85, dec: 57.03, magnitude: 3.3, color: 0xFFFFFFFF),
  CatalogStar(name: 'Alioth', ra: 193.5, dec: 55.95, magnitude: 1.7, color: 0xFFFFFFFF),
  CatalogStar(name: 'Mizar', ra: 200.98, dec: 54.92, magnitude: 2.2, color: 0xFFFFFFFF),
  CatalogStar(name: 'Alkaid', ra: 206.88, dec: 49.31, magnitude: 1.8, color: 0xFFBAD1FF),

  // ── Cassiopeia (The W) ──
  CatalogStar(name: 'Schedar', ra: 10.13, dec: 56.53, magnitude: 2.24, color: 0xFFFFD2A1),
  CatalogStar(name: 'Caph', ra: 2.29, dec: 59.15, magnitude: 2.28, color: 0xFFFFFFFF),
  CatalogStar(name: 'Gamma Cas', ra: 14.18, dec: 60.72, magnitude: 2.15, color: 0xFFB0C2FF),
  CatalogStar(name: 'Ruchbah', ra: 21.45, dec: 60.23, magnitude: 2.65, color: 0xFFFFFFFF),
  CatalogStar(name: 'Segin', ra: 28.59, dec: 63.67, magnitude: 3.35, color: 0xFFFFFFFF),

  // ── Ursa Minor (Little Dipper) ──
  CatalogStar(name: 'Polaris', ra: 37.95, dec: 89.26, magnitude: 1.97, color: 0xFFFFFFFF),
  CatalogStar(name: 'Kochab', ra: 222.68, dec: 74.15, magnitude: 2.07, color: 0xFFFFD2A1),

  // ── Bright Signposts ──
  CatalogStar(name: 'Sirius', ra: 101.28, dec: -16.71, magnitude: -1.46, color: 0xFFAEC1D6),
  CatalogStar(name: 'Procyon', ra: 114.82, dec: 5.22, magnitude: 0.38, color: 0xFFFFF3E2),
  CatalogStar(name: 'Aldebaran', ra: 68.98, dec: 16.5, magnitude: 0.85, color: 0xFFFFD2A1),
  CatalogStar(name: 'Capella', ra: 79.17, dec: 45.99, magnitude: 0.08, color: 0xFFFFEEBB),
  CatalogStar(name: 'Pollux', ra: 116.32, dec: 28.02, magnitude: 1.15, color: 0xFFFFDBB8),
  CatalogStar(name: 'Castor', ra: 113.65, dec: 31.88, magnitude: 1.58, color: 0xFFFFFFFF),
  CatalogStar(name: 'Vega', ra: 279.23, dec: 38.78, magnitude: 0.03, color: 0xFFCADFFF),
  CatalogStar(name: 'Altair', ra: 297.69, dec: 8.86, magnitude: 0.77, color: 0xFFFFFFFF),
  CatalogStar(name: 'Deneb', ra: 310.35, dec: 45.28, magnitude: 1.25, color: 0xFFFFFFFF),
  CatalogStar(name: 'Arcturus', ra: 213.91, dec: 19.18, magnitude: -0.04, color: 0xFFFFD2A1),
];
