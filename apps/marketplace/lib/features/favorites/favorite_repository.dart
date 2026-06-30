import 'package:surrealdb/surrealdb.dart';

import 'favorite_model.dart';

/// Repository for CRUD operations on the `favorite` table in `users/users`.
///
/// Requires an authenticated consumer DB connection (`DittoAuth.consumerDb`).
class FavoriteRepository {
  const FavoriteRepository(this._db);

  final SurrealDB _db;

  /// Add a favorite. Returns the created record.
  ///
  /// The unique index `idx_favorite_unique` prevents duplicates —
  /// SurrealDB will throw if the user already favorited this target.
  Future<Favorite> addFavorite(
    String targetId, {
    String targetType = 'store',
  }) async {
    final result = await _db.query(
      r'''
      CREATE favorite SET
        target_id   = $target_id,
        target_type = $target_type
      ''',
      {
        'target_id': targetId,
        'target_type': targetType,
      },
    );

    final row = _extractFirstRow(result);
    if (row == null) {
      throw Exception('Failed to create favorite — no row returned');
    }
    return Favorite.fromJson(row);
  }

  /// Remove a favorite by target. Idempotent — no error if not found.
  Future<void> removeFavorite(
    String targetId, {
    String targetType = 'store',
  }) async {
    await _db.query(
      r'''
      DELETE favorite WHERE
        target_id   = $target_id AND
        target_type = $target_type
      ''',
      {
        'target_id': targetId,
        'target_type': targetType,
      },
    );
  }

  /// Check if the current user has favorited a specific target.
  Future<bool> isFavorited(
    String targetId, {
    String targetType = 'store',
  }) async {
    final result = await _db.query(
      r'''
      SELECT * FROM favorite WHERE
        target_id   = $target_id AND
        target_type = $target_type
      LIMIT 1
      ''',
      {
        'target_id': targetId,
        'target_type': targetType,
      },
    );

    final row = _extractFirstRow(result);
    return row != null;
  }

  /// List all favorites for the current user.
  ///
  /// The RECORD ACCESS scoping on `users/users` means the query
  /// automatically filters to the authenticated user's records.
  Future<List<Favorite>> listFavorites({
    String targetType = 'store',
  }) async {
    final result = await _db.query(
      r'''
      SELECT * FROM favorite WHERE
        target_type = $target_type
      ORDER BY added_at DESC
      ''',
      {'target_type': targetType},
    );

    final rows = _extractRows(result);
    return rows.map(Favorite.fromJson).toList();
  }

  /// Extract the first row from a SurrealDB query result.
  static Map<String, dynamic>? _extractFirstRow(dynamic result) {
    if (result is! List || result.isEmpty) return null;
    final first = result.first;
    if (first is Map && first.containsKey('result')) {
      final inner = first['result'];
      if (inner is List && inner.isNotEmpty && inner.first is Map) {
        return Map<String, dynamic>.from(inner.first as Map);
      }
      return null;
    }
    if (first is Map) {
      return Map<String, dynamic>.from(first);
    }
    return null;
  }

  /// Extract all rows from a SurrealDB query result.
  static List<Map<String, dynamic>> _extractRows(dynamic result) {
    if (result is! List || result.isEmpty) return [];
    final first = result.first;
    if (first is Map && first.containsKey('result')) {
      final inner = first['result'];
      if (inner is List) {
        return inner
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      return [];
    }
    if (first is Map) {
      return [Map<String, dynamic>.from(first)];
    }
    return [];
  }
}
