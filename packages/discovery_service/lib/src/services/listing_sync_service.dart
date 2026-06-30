import 'package:surrealdb/surrealdb.dart';

import '../models/establishment_listing.dart';

/// Write-side service for syncing establishment data to `companies/discovery`.
///
/// Called by the Business Portal when `is_published` toggles or when
/// an already-published establishment is updated.
///
/// Requires a [SurrealDB] connection authenticated with EDITOR role
/// on `companies/discovery`.
class ListingSyncService {
  const ListingSyncService(this._db);

  final SurrealDB _db;

  /// Sync an establishment to the discovery listing.
  ///
  /// Creates or updates the `establishment_listing` record keyed by
  /// `(company_slug, slug)` unique index.
  ///
  /// [data] is a map of establishment fields from the company DB.
  /// [companySlug] identifies which company this belongs to.
  Future<void> syncListing({
    required Map<String, dynamic> data,
    required String companySlug,
  }) async {
    final listing = projectToListing(data: data, companySlug: companySlug);
    final json = listing.toJson();

    // Upsert using deterministic record ID: company_slug + slug.
    // UPSERT creates if missing, updates if exists.
    final recordId = '${companySlug}_${listing.slug}';
    await _db.query(
      r'''
      UPSERT type::record("establishment_listing", $record_id)
        SET company_slug = $company_slug,
            source_id    = <string> $source_id,
            name         = $name,
            slug         = $slug,
            about        = $about,
            address      = $address,
            city         = $city,
            zip          = $zip,
            country      = $country,
            location     = $location,
            logo         = $logo,
            cover        = $cover,
            store_type   = $store_type,
            category     = $category,
            category_ref = $category_ref,
            is_active    = true,
            keywords     = $keywords,
            favorites_count = $favorites_count
      ''',
      {...json, 'record_id': recordId},
    );

    // Create/update the categorized_as graph edge if category exists.
    if (listing.category != null) {
      await _db.query(
        r'''
        LET $listing = type::record("establishment_listing", $record_id);
        LET $cat = (SELECT id FROM category WHERE slug = $category)[0].id;
        IF $cat != NONE {
          DELETE categorized_as WHERE in = $listing;
          RELATE $listing -> categorized_as -> $cat;
        };
        ''',
        {
          'record_id': recordId,
          'category': listing.category,
        },
      );
    }
  }

  /// Soft-remove a listing from discovery (set `is_active=false`).
  ///
  /// Called when a business owner unpublishes an establishment.
  Future<void> deactivateListing({
    required String companySlug,
    required String establishmentSlug,
  }) async {
    final recordId = '${companySlug}_$establishmentSlug';
    await _db.query(
      r'''
      UPDATE type::record("establishment_listing", $record_id)
        SET is_active = false
      ''',
      {'record_id': recordId},
    );
  }

  /// Project a company-DB establishment record into an [EstablishmentListing].
  ///
  /// This is the denormalization logic — maps the source `establishment`
  /// fields to the flat `establishment_listing` schema.
  static EstablishmentListing projectToListing({
    required Map<String, dynamic> data,
    required String companySlug,
  }) {
    // Extract geo from either direct lat/lng or GeoJSON location.
    double? lat;
    double? lng;
    final location = data['location'];
    if (location is Map<String, dynamic>) {
      final coords = location['coordinates'] as List<dynamic>?;
      if (coords != null && coords.length >= 2) {
        lng = (coords[0] as num?)?.toDouble();
        lat = (coords[1] as num?)?.toDouble();
      }
    }

    // Extract media from nested images object.
    final images = data['images'] as Map<String, dynamic>?;

    return EstablishmentListing(
      companySlug: companySlug,
      sourceId: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      slug: data['slug'] as String? ?? '',
      about: data['about'] as String?,
      address: data['address'] as String? ?? '',
      city: data['city'] as String? ?? '',
      zip: data['zip'] as String? ?? '',
      country: data['country'] as String? ?? 'NO',
      latitude: lat,
      longitude: lng,
      logo: images?['logo'] as String?,
      cover: images?['cover'] as String?,
      storeType: data['store_type'] as String? ?? 'store',
      category: data['category'] as String?,
      isActive: true,
    );
  }
}
