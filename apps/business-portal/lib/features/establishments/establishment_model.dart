import 'package:flutter/material.dart';

/// Business type classification for an [Establishment].
///
/// Maps to `store_type` in the SurrealDB schema:
/// `ASSERT $value IN ['store', 'restaurant', 'venue']`.
enum BusinessType {
  store('Butikk', Icons.storefront_rounded),
  restaurant('Restaurant', Icons.restaurant_rounded),
  venue('Spillested', Icons.stadium_rounded);

  const BusinessType(this.label, this.icon);

  /// Norwegian display label.
  final String label;

  /// Material icon for list/card display.
  final IconData icon;

  /// Parse from SurrealDB `store_type` string.
  static BusinessType fromString(String value) => switch (value) {
        'store' => BusinessType.store,
        'restaurant' => BusinessType.restaurant,
        'venue' => BusinessType.venue,
        _ => BusinessType.store,
      };
}

/// An Establishment (business location) in the tenant database.
///
/// Matches the SurrealDB `establishment` table schema from
/// `schemas/company-blueprint.surql`.
class Establishment {
  const Establishment({
    required this.id,
    required this.name,
    required this.slug,
    required this.businessType,
    required this.address,
    required this.city,
    required this.zip,
    this.country = 'NO',
    this.category,
    this.phone,
    this.email,
    this.website,
    this.about,
    this.isPublished = false,
    this.isActive = true,
    this.resourcesEnabled = false,
    this.logoUrl,
    this.coverUrl,
    this.galleryUrls = const [],
    this.coverLayoutMode = 'bento',
    this.latitude,
    this.longitude,
  });

  final String id;
  final String name;
  final String slug;
  final BusinessType businessType;
  final String address;
  final String city;
  final String zip;
  final String country;
  final String? category;
  final String? phone;
  final String? email;
  final String? website;
  final String? about;
  final bool isPublished;
  final bool isActive;
  final bool resourcesEnabled;

  // ── Media fields (maps to schema images.* + cover_layout_mode) ──
  final String? logoUrl;
  final String? coverUrl;
  final List<String> galleryUrls;
  final String coverLayoutMode;

  // ── Geo location (maps to schema `location` geometry<point>) ──
  final double? latitude;
  final double? longitude;

  /// Parse from SurrealDB JSON response.
  factory Establishment.fromJson(Map<String, dynamic> json) {
    return Establishment(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      businessType: BusinessType.fromString(json['store_type'] as String),
      address: json['address'] as String,
      city: json['city'] as String,
      zip: json['zip'] as String,
      country: (json['country'] as String?) ?? 'NO',
      category: json['category'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      about: json['about'] as String?,
      isPublished: json['is_published'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      resourcesEnabled: json['resources_enabled'] as bool? ?? false,
      logoUrl: (json['images'] as Map<String, dynamic>?)?['logo'] as String?,
      coverUrl: (json['images'] as Map<String, dynamic>?)?['cover'] as String?,
      galleryUrls: ((json['images'] as Map<String, dynamic>?)?['gallery'] as List<dynamic>?)
              ?.cast<String>() ??
          const [],
      coverLayoutMode: json['cover_layout_mode'] as String? ?? 'bento',
      latitude: _parseGeoLat(json['location']),
      longitude: _parseGeoLng(json['location']),
    );
  }

  /// Extract latitude from SurrealDB `geometry<point>` GeoJSON.
  /// Format: `{ type: "Point", coordinates: [lng, lat] }`
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

  /// Serialize to JSON for SurrealDB CREATE/UPDATE.
  ///
  /// Strips null values — SurrealDB SCHEMAFULL rejects JSON `null` for
  /// `option<T>` fields. Omitting the key sends NONE, which is accepted.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'name': name,
      'slug': slug,
      'store_type': businessType.name,
      'address': address,
      'city': city,
      'zip': zip,
      'country': country,
      'is_published': isPublished,
      'is_active': isActive,
      'resources_enabled': resourcesEnabled,
    };
    if (category != null) json['category'] = category;
    if (phone != null) json['phone'] = phone;
    if (email != null) json['email'] = email;
    if (website != null) json['website'] = website;
    if (about != null) json['about'] = about;

    // Media — nested images object + cover_layout_mode
    json['images'] = <String, dynamic>{
      if (logoUrl != null) 'logo': logoUrl,
      if (coverUrl != null) 'cover': coverUrl,
      'gallery': galleryUrls,
    };
    json['cover_layout_mode'] = coverLayoutMode;

    // Geo location — serialize as GeoJSON point
    if (latitude != null && longitude != null) {
      json['location'] = {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      };
    }

    return json;
  }

  /// Create a copy with overrides.
  Establishment copyWith({
    String? name,
    String? slug,
    BusinessType? businessType,
    String? address,
    String? city,
    String? zip,
    String? category,
    String? phone,
    String? email,
    String? website,
    String? about,
    bool? isPublished,
    bool? resourcesEnabled,
    String? Function()? logoUrl,
    String? Function()? coverUrl,
    List<String>? galleryUrls,
    String? coverLayoutMode,
    double? Function()? latitude,
    double? Function()? longitude,
  }) {
    return Establishment(
      id: id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      businessType: businessType ?? this.businessType,
      address: address ?? this.address,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      country: country,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      about: about ?? this.about,
      isPublished: isPublished ?? this.isPublished,
      isActive: isActive,
      resourcesEnabled: resourcesEnabled ?? this.resourcesEnabled,
      logoUrl: logoUrl != null ? logoUrl() : this.logoUrl,
      coverUrl: coverUrl != null ? coverUrl() : this.coverUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      coverLayoutMode: coverLayoutMode ?? this.coverLayoutMode,
      latitude: latitude != null ? latitude() : this.latitude,
      longitude: longitude != null ? longitude() : this.longitude,
    );
  }
}
