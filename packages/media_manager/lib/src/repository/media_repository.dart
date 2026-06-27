import 'package:ditto_auth/ditto_auth.dart';

import '../models/media_category.dart';
import '../models/media_item.dart';

/// Repository for media CRUD operations against SurrealDB.
///
/// Takes a [TenantConnection] (from `ditto_auth`) — same pattern as
/// establishment providers. All SurrealDB query logic for the `media`
/// table lives here; consuming apps never write raw media queries.
class MediaRepository {
  MediaRepository(this._connection);

  final TenantConnection _connection;

  /// The active tenant slug.
  String get slug => _connection.slug;

  /// Fetch all media items, newest first.
  Future<List<MediaItem>> fetchAll() async {
    final result = await _connection.companies
        .query('SELECT * FROM media ORDER BY created_at DESC');
    return _parseRows(result);
  }

  /// Fetch media items filtered by category.
  Future<List<MediaItem>> fetchByCategory(MediaCategory category) async {
    final result = await _connection.companies.query(
      r'SELECT * FROM media WHERE category = $cat ORDER BY created_at DESC',
      {'cat': category.value},
    );
    return _parseRows(result);
  }

  /// Fetch media items for a specific establishment.
  Future<List<MediaItem>> fetchByEstablishment(String establishmentId) async {
    final result = await _connection.companies.query(
      r'SELECT * FROM media WHERE establishment = $est ORDER BY created_at DESC',
      {'est': establishmentId},
    );
    return _parseRows(result);
  }

  /// Create a media metadata record in SurrealDB.
  ///
  /// Call this AFTER uploading bytes to the storage backend.
  /// The [url] and [storagePath] come from [StorageUploadResult].
  Future<MediaItem?> create({
    required String uploaderId,
    required String url,
    required String storagePath,
    required String filename,
    required String mimeType,
    required int size,
    MediaCategory category = MediaCategory.general,
    String? establishmentId,
    List<String> tags = const [],
  }) async {
    final data = <String, dynamic>{
      'uploader_id': uploaderId,
      'url': url,
      'storage_path': storagePath,
      'filename': filename,
      'mime_type': mimeType,
      'size': size,
      'category': category.value,
      'tags': tags,
    };
    if (establishmentId != null) {
      data['establishment'] = establishmentId;
    }

    final result = await _connection.companies.query(
      r'CREATE media CONTENT $data',
      {'data': data},
    );

    final rows = _parseRows(result);
    return rows.isEmpty ? null : rows.first;
  }

  /// Delete a media metadata record from SurrealDB.
  ///
  /// Does NOT delete from object storage — caller is responsible
  /// for deleting from [MediaStorageBackend] first.
  Future<bool> delete(String id) async {
    try {
      await _connection.companies.query(
        r'DELETE $id',
        {'id': id},
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Update the display name of a media item.
  ///
  /// Pass `null` to clear the name (sends NONE to SurrealDB).
  Future<bool> updateName(String id, String? name) async {
    try {
      if (name != null) {
        await _connection.companies.query(
          r'UPDATE $id SET name = $name',
          {'id': id, 'name': name},
        );
      } else {
        await _connection.companies.query(
          r'UPDATE $id SET name = NONE',
          {'id': id},
        );
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Update the tags of a media item.
  Future<bool> updateTags(String id, List<String> tags) async {
    try {
      await _connection.companies.query(
        r'UPDATE $id SET tags = $tags',
        {'id': id, 'tags': tags},
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Parse SurrealDB query result into [MediaItem] list.
  List<MediaItem> _parseRows(dynamic result) {
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

    return rows
        .whereType<Map<String, dynamic>>()
        .map(MediaItem.fromJson)
        .toList();
  }
}
