/// A geographic area for discovery filtering from `companies/discovery.area`.
///
/// Supports a parent–child hierarchy (e.g. Viken → Drammen → Bragernes).
class DiscoveryArea {
  const DiscoveryArea({
    this.id,
    required this.name,
    required this.slug,
    this.parentId,
    this.centerLatitude,
    this.centerLongitude,
  });

  /// SurrealDB record ID. Null on create.
  final String? id;

  /// Display name (e.g. "Drammen", "Bragernes").
  final String name;

  /// URL-safe slug.
  final String slug;

  /// Parent area record ID for hierarchical areas.
  final String? parentId;

  /// Center point latitude (for map centering).
  final double? centerLatitude;

  /// Center point longitude (for map centering).
  final double? centerLongitude;

  /// Parse from SurrealDB JSON response.
  factory DiscoveryArea.fromJson(Map<String, dynamic> json) {
    return DiscoveryArea(
      id: json['id'] as String?,
      name: json['name'] as String,
      slug: json['slug'] as String,
      parentId: json['parent'] as String?,
      centerLatitude: _parseGeoLat(json['center']),
      centerLongitude: _parseGeoLng(json['center']),
    );
  }

  /// Serialize to JSON for SurrealDB CREATE/UPDATE.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'slug': slug,
    };
    if (parentId != null) json['parent'] = parentId;
    if (centerLatitude != null && centerLongitude != null) {
      json['center'] = {
        'type': 'Point',
        'coordinates': [centerLongitude, centerLatitude],
      };
    }
    return json;
  }

  static double? _parseGeoLat(dynamic location) {
    if (location is! Map<String, dynamic>) return null;
    final coords = location['coordinates'] as List<dynamic>?;
    if (coords == null || coords.length < 2) return null;
    return (coords[1] as num?)?.toDouble();
  }

  static double? _parseGeoLng(dynamic location) {
    if (location is! Map<String, dynamic>) return null;
    final coords = location['coordinates'] as List<dynamic>?;
    if (coords == null || coords.length < 2) return null;
    return (coords[0] as num?)?.toDouble();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoveryArea &&
          runtimeType == other.runtimeType &&
          slug == other.slug;

  @override
  int get hashCode => slug.hashCode;

  @override
  String toString() => 'DiscoveryArea($name, $slug)';
}
