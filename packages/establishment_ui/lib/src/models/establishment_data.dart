import 'package:flutter/material.dart';

/// Business type classification for establishments.
///
/// Shared enum used by both Business Portal and Public Marketplace.
/// Maps to `store_type` in the SurrealDB schema:
/// `ASSERT $value IN ['store', 'restaurant', 'venue']`.
enum EstablishmentType {
  store('Butikk', Icons.storefront_rounded),
  restaurant('Restaurant', Icons.restaurant_rounded),
  venue('Spillested', Icons.stadium_rounded);

  const EstablishmentType(this.label, this.icon);

  /// Norwegian display label.
  final String label;

  /// Material icon for display.
  final IconData icon;

  /// Parse from SurrealDB `store_type` string.
  static EstablishmentType fromString(String value) => switch (value) {
        'store' => EstablishmentType.store,
        'restaurant' => EstablishmentType.restaurant,
        'venue' => EstablishmentType.venue,
        _ => EstablishmentType.store,
      };
}

/// Immutable data class for rendering an [EstablishmentPage].
///
/// Decoupled from SurrealDB serialization — each consuming app maps its
/// own model to this class. This keeps the shared UI package free of
/// database concerns.
class EstablishmentData {
  const EstablishmentData({
    required this.name,
    required this.businessType,
    required this.address,
    required this.city,
    required this.zip,
    this.country = 'NO',
    this.category,
    this.about,
    this.phone,
    this.email,
    this.website,
    this.isPublished = false,
  });

  /// Establishment display name.
  final String name;

  /// Business classification (store, restaurant, venue).
  final EstablishmentType businessType;

  /// Street address.
  final String address;

  /// City name.
  final String city;

  /// Postal code.
  final String zip;

  /// Country code (default: 'NO').
  final String country;

  /// Optional category label.
  final String? category;

  /// Optional about/description text.
  final String? about;

  /// Optional phone number.
  final String? phone;

  /// Optional email address.
  final String? email;

  /// Optional website URL.
  final String? website;

  /// Whether the establishment is published (visible to customers).
  final bool isPublished;

  /// Formatted address line: "Skolegata 9, Drammen 3046".
  String get addressLine => '$address, $city $zip';

  /// Whether any contact information is available.
  bool get hasContactInfo => phone != null || email != null || website != null;

  /// Create a copy with overrides.
  EstablishmentData copyWith({
    String? name,
    EstablishmentType? businessType,
    String? address,
    String? city,
    String? zip,
    String? country,
    String? category,
    String? about,
    String? phone,
    String? email,
    String? website,
    bool? isPublished,
  }) {
    return EstablishmentData(
      name: name ?? this.name,
      businessType: businessType ?? this.businessType,
      address: address ?? this.address,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      category: category ?? this.category,
      about: about ?? this.about,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EstablishmentData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          businessType == other.businessType &&
          address == other.address &&
          city == other.city &&
          zip == other.zip &&
          country == other.country &&
          category == other.category &&
          about == other.about &&
          phone == other.phone &&
          email == other.email &&
          website == other.website &&
          isPublished == other.isPublished;

  @override
  int get hashCode => Object.hash(
        name,
        businessType,
        address,
        city,
        zip,
        country,
        category,
        about,
        phone,
        email,
        website,
        isPublished,
      );
}
