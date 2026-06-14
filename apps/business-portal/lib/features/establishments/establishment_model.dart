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
    );
  }

  /// Serialize to JSON for SurrealDB CREATE/UPDATE.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'store_type': businessType.name,
        'address': address,
        'city': city,
        'zip': zip,
        'country': country,
        'category': category,
        'phone': phone,
        'email': email,
        'website': website,
        'about': about,
        'is_published': isPublished,
        'is_active': isActive,
        'resources_enabled': resourcesEnabled,
      };

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
    );
  }
}
