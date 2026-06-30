import 'package:surrealdb/surrealdb.dart';

import '../models/discovery_area.dart';
import '../models/discovery_category.dart';
import '../models/establishment_listing.dart';

/// Read-side access to `companies/discovery`.
///
/// Fetches listings, categories, and areas for the Marketplace Home screen.
/// All methods expect a [SurrealDB] instance already connected and
/// authenticated to `companies/discovery`.
class DiscoveryRepository {
  const DiscoveryRepository(this._db);

  final SurrealDB _db;

  // ── Listings ──────────────────────────────────────────────────────────────

  /// Fetch active listings with optional filters.
  ///
  /// [category] — filter by category slug.
  /// [city] — filter by city name.
  /// [limit] — max results (default 50).
  Future<List<EstablishmentListing>> fetchListings({
    String? category,
    String? city,
    int limit = 50,
  }) async {
    final conditions = <String>['is_active = true'];
    final vars = <String, dynamic>{'limit': limit};

    if (category != null) {
      conditions.add(r'category = $category');
      vars['category'] = category;
    }
    if (city != null) {
      conditions.add(r'city = $city');
      vars['city'] = city;
    }

    final where = conditions.join(' AND ');
    final query =
        'SELECT * FROM establishment_listing WHERE $where ORDER BY synced_at DESC LIMIT \$limit';

    final result = await _db.query(query, vars);
    return _parseList(result, EstablishmentListing.fromJson);
  }

  /// Full-text search via BM25 on `name` and `about` fields.
  ///
  /// Uses the Norwegian snowball analyzer defined in `discovery.surql`.
  Future<List<EstablishmentListing>> searchListings(String query) async {
    if (query.trim().isEmpty) return fetchListings();

    final result = await _db.query(
      r'''
      SELECT *,
        search::score(1) + search::score(2) AS _score
      FROM establishment_listing
      WHERE name @1@ $query OR about @2@ $query
      ORDER BY _score DESC
      LIMIT 50
      ''',
      {'query': query.trim()},
    );
    return _parseList(result, EstablishmentListing.fromJson);
  }

  // ── Categories ────────────────────────────────────────────────────────────

  /// Fetch all platform categories, ordered by name.
  Future<List<DiscoveryCategory>> fetchCategories() async {
    final result =
        await _db.query('SELECT * FROM category ORDER BY name ASC');
    return _parseList(result, DiscoveryCategory.fromJson);
  }

  // ── Areas ─────────────────────────────────────────────────────────────────

  /// Fetch areas, optionally filtered by parent.
  Future<List<DiscoveryArea>> fetchAreas({String? parentId}) async {
    String query;
    Map<String, dynamic> vars;

    if (parentId != null) {
      query = r'SELECT * FROM area WHERE parent = $parent ORDER BY name ASC';
      vars = {'parent': parentId};
    } else {
      query = 'SELECT * FROM area WHERE parent IS NONE ORDER BY name ASC';
      vars = {};
    }

    final result = await _db.query(query, vars);
    return _parseList(result, DiscoveryArea.fromJson);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Parse SurrealDB query response into a typed list.
  ///
  /// SurrealDB returns either `[{result: [...]}]` or a flat list,
  /// depending on the driver version. This handles both.
  static List<T> _parseList<T>(
    dynamic result,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    List<dynamic> rows;
    if (result is List && result.isNotEmpty) {
      final first = result.first;
      if (first is Map && first.containsKey('result')) {
        rows = first['result'] as List<dynamic>? ?? [];
      } else {
        rows = result;
      }
    } else {
      return [];
    }

    return rows.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }
}
