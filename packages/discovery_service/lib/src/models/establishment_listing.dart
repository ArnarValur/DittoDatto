/// A denormalized listing in `companies/discovery.establishment_listing`.
///
/// Projected from the source `establishment` table in a company DB.
/// Optimized for read-heavy DittoBar search and Home screen display.
class EstablishmentListing {
  const EstablishmentListing({
    this.id,
    required this.companySlug,
    required this.sourceId,
    required this.name,
    required this.slug,
    this.about,
    required this.address,
    required this.city,
    required this.zip,
    this.country = 'NO',
    this.latitude,
    this.longitude,
    this.logo,
    this.cover,
    this.storeType = 'store',
    this.category,
    this.categoryRef,
    this.aggregateRating,
    this.favoritesCount = 0,
    this.isActive = true,
    this.keywords = const [],
  });

  /// SurrealDB record ID (e.g. `establishment_listing:xxx`). Null on create.
  final String? id;

  /// The company slug owning this establishment.
  final String companySlug;

  /// The source establishment record ID in the company DB.
  final String sourceId;

  /// Display name.
  final String name;

  /// URL-safe slug.
  final String slug;

  /// Short description / about text.
  final String? about;

  // ── Address ──
  final String address;
  final String city;
  final String zip;
  final String country;

  // ── Geo (from GeoJSON point) ──
  final double? latitude;
  final double? longitude;

  // ── Media ──
  final String? logo;
  final String? cover;

  // ── Classification ──
  final String storeType;
  final String? category;
  final String? categoryRef;

  // ── Metrics ──
  final AggregateRating? aggregateRating;
  final int favoritesCount;

  // ── Status ──
  final bool isActive;

  // ── AI / Search ──
  final List<String> keywords;

  /// Parse from SurrealDB JSON response.
  factory EstablishmentListing.fromJson(Map<String, dynamic> json) {
    return EstablishmentListing(
      id: json['id'] as String?,
      companySlug: json['company_slug'] as String,
      sourceId: json['source_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      about: json['about'] as String?,
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      zip: json['zip'] as String? ?? '',
      country: json['country'] as String? ?? 'NO',
      latitude: _parseGeoLat(json['location']),
      longitude: _parseGeoLng(json['location']),
      logo: json['logo'] as String?,
      cover: json['cover'] as String?,
      storeType: json['store_type'] as String? ?? 'store',
      category: json['category'] as String?,
      categoryRef: json['category_ref'] as String?,
      aggregateRating: json['aggregate_rating'] != null
          ? AggregateRating.fromJson(
              json['aggregate_rating'] as Map<String, dynamic>)
          : null,
      favoritesCount: json['favorites_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      keywords: (json['keywords'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  /// Serialize to JSON for SurrealDB CREATE/UPDATE.
  ///
  /// Strips null values — SurrealDB SCHEMAFULL rejects JSON `null` for
  /// `option<T>` fields. Omitting the key sends NONE, which is accepted.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'company_slug': companySlug,
      'source_id': sourceId,
      'name': name,
      'slug': slug,
      'address': address,
      'city': city,
      'zip': zip,
      'country': country,
      'store_type': storeType,
      'favorites_count': favoritesCount,
      'is_active': isActive,
      'keywords': keywords,
    };
    if (about != null) json['about'] = about;
    if (logo != null) json['logo'] = logo;
    if (cover != null) json['cover'] = cover;
    if (category != null) json['category'] = category;
    if (categoryRef != null) json['category_ref'] = categoryRef;
    if (aggregateRating != null) {
      json['aggregate_rating'] = aggregateRating!.toJson();
    }
    if (latitude != null && longitude != null) {
      json['location'] = {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      };
    }
    return json;
  }

  /// Extract latitude from SurrealDB `geometry<point>` GeoJSON.
  static double? _parseGeoLat(dynamic location) {
    if (location is! Map<String, dynamic>) return null;
    final coords = location['coordinates'] as List<dynamic>?;
    if (coords == null || coords.length < 2) return null;
    return (coords[1] as num?)?.toDouble();
  }

  /// Extract longitude from SurrealDB `geometry<point>` GeoJSON.
  static double? _parseGeoLng(dynamic location) {
    if (location is! Map<String, dynamic>) return null;
    final coords = location['coordinates'] as List<dynamic>?;
    if (coords == null || coords.length < 2) return null;
    return (coords[0] as num?)?.toDouble();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EstablishmentListing &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          companySlug == other.companySlug &&
          sourceId == other.sourceId &&
          name == other.name &&
          slug == other.slug;

  @override
  int get hashCode => Object.hash(id, companySlug, sourceId, name, slug);

  @override
  String toString() => 'EstablishmentListing($name, $companySlug/$slug)';
}

/// Aggregate rating embedded object.
class AggregateRating {
  const AggregateRating({required this.average, required this.count});

  final double average;
  final int count;

  factory AggregateRating.fromJson(Map<String, dynamic> json) {
    return AggregateRating(
      average: (json['average'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'average': average,
        'count': count,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AggregateRating &&
          average == other.average &&
          count == other.count;

  @override
  int get hashCode => Object.hash(average, count);
}
