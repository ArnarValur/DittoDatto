import 'package:flutter/material.dart';

import 'service.dart';
import 'service_group.dart';

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

/// Cover image layout mode for the establishment storefront page.
///
/// Matches the layout options in the Business Portal edit view:
/// - [bento]: Cover image (2/3) + gallery thumbnails in a 2×1 grid (1/3)
/// - [showcase]: Cover image (3/4) + vertical gallery strip
/// - [spotlight]: Full-width cover image only
enum CoverLayoutMode {
  bento,
  showcase,
  spotlight;

  /// Parse from stored string value, defaulting to [bento].
  static CoverLayoutMode fromString(String value) => switch (value) {
        'bento' => CoverLayoutMode.bento,
        'showcase' => CoverLayoutMode.showcase,
        'spotlight' => CoverLayoutMode.spotlight,
        _ => CoverLayoutMode.bento,
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
    this.logoUrl,
    this.coverUrl,
    this.galleryUrls = const [],
    this.coverLayoutMode = CoverLayoutMode.bento,
    this.showServices = true,
    this.showEvents = false,
    this.showStaff = false,
    this.openingStatus,
    this.isOpen,
    this.latitude,
    this.longitude,
    this.serviceGroups = const [],
    this.services = const [],
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

  /// Optional logo image URL.
  final String? logoUrl;

  /// Optional cover/hero image URL.
  final String? coverUrl;

  /// Gallery image URLs.
  final List<String> galleryUrls;

  /// Cover image layout mode.
  final CoverLayoutMode coverLayoutMode;

  /// Section visibility flags — controlled from BP edit view.
  /// Determines which sections appear on the page and in shortcuts.
  final bool showServices;
  final bool showEvents;
  final bool showStaff;

  /// Opening status display text (e.g. 'Stengt i dag', 'Åpent til 18:00').
  /// TODO: Derive from opening_schedule when schedule parsing is implemented.
  final String? openingStatus;

  /// Whether the establishment is currently open.
  /// TODO: Derive from opening_schedule when schedule parsing is implemented.
  final bool? isOpen;

  /// Latitude from SurrealDB `location` `geometry<point>`.
  /// GeoJSON format: `{ type: "Point", coordinates: [lng, lat] }`.
  final double? latitude;

  /// Service groups for this establishment, sorted by [ServiceGroup.sortOrder].
  final List<ServiceGroup> serviceGroups;

  /// Services offered by this establishment.
  final List<Service> services;

  /// Longitude from SurrealDB `location` `geometry<point>`.
  final double? longitude;

  /// Whether geo coordinates are available for map display.
  bool get hasLocation => latitude != null && longitude != null;

  /// Whether any media (cover or gallery) is available.
  bool get hasMedia => coverUrl != null || galleryUrls.isNotEmpty;

  /// Total number of gallery images (cover + gallery).
  int get totalPhotoCount => (coverUrl != null ? 1 : 0) + galleryUrls.length;

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
    String? logoUrl,
    String? coverUrl,
    List<String>? galleryUrls,
    CoverLayoutMode? coverLayoutMode,
    bool? showServices,
    bool? showEvents,
    bool? showStaff,
    String? openingStatus,
    bool? isOpen,
    double? latitude,
    double? longitude,
    List<ServiceGroup>? serviceGroups,
    List<Service>? services,
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
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      coverLayoutMode: coverLayoutMode ?? this.coverLayoutMode,
      showServices: showServices ?? this.showServices,
      showEvents: showEvents ?? this.showEvents,
      showStaff: showStaff ?? this.showStaff,
      openingStatus: openingStatus ?? this.openingStatus,
      isOpen: isOpen ?? this.isOpen,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      serviceGroups: serviceGroups ?? this.serviceGroups,
      services: services ?? this.services,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EstablishmentData) return false;
    if (runtimeType != other.runtimeType) return false;
    // Deep-compare lists
    if (galleryUrls.length != other.galleryUrls.length) return false;
    for (var i = 0; i < galleryUrls.length; i++) {
      if (galleryUrls[i] != other.galleryUrls[i]) return false;
    }
    if (serviceGroups.length != other.serviceGroups.length) return false;
    for (var i = 0; i < serviceGroups.length; i++) {
      if (serviceGroups[i] != other.serviceGroups[i]) return false;
    }
    if (services.length != other.services.length) return false;
    for (var i = 0; i < services.length; i++) {
      if (services[i] != other.services[i]) return false;
    }
    return name == other.name &&
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
        isPublished == other.isPublished &&
        logoUrl == other.logoUrl &&
        coverUrl == other.coverUrl &&
        coverLayoutMode == other.coverLayoutMode &&
        showServices == other.showServices &&
        showEvents == other.showEvents &&
        showStaff == other.showStaff &&
        openingStatus == other.openingStatus &&
        isOpen == other.isOpen &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        true; // serviceGroups + services compared above via deep-compare
  }

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
        logoUrl,
        coverUrl,
        Object.hashAll(galleryUrls),
        coverLayoutMode,
        showServices,
        showEvents,
        showStaff,
        // Object.hash supports up to 20 positional args; nest remaining.
        Object.hash(
          openingStatus,
          isOpen,
          latitude,
          longitude,
          Object.hashAll(serviceGroups),
          Object.hashAll(services),
        ),
      );
}
