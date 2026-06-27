import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:media_manager/media_manager.dart';

/// Concrete test double for [MediaStorageBackend].
///
/// Records calls and returns canned responses for verifying interactions.
class FakeMediaStorageBackend extends MediaStorageBackend {
  /// Recorded upload calls.
  final uploads = <({
    Uint8List bytes,
    String companySlug,
    String filename,
    String mimeType,
  })>[];

  /// Recorded delete calls.
  final deletes = <String>[];

  /// What [upload] returns.
  StorageUploadResult uploadResult = const StorageUploadResult(
    url: 'https://cdn.example.com/test.jpg',
    storagePath: 'companies/test-co/media/test.jpg',
  );

  /// Whether [upload] should throw.
  Exception? uploadException;

  /// Whether [delete] should throw.
  Exception? deleteException;

  /// Whether [clearCache] was called.
  bool clearCacheCalled = false;

  @override
  Future<StorageUploadResult> upload({
    required Uint8List bytes,
    required String companySlug,
    required String filename,
    required String mimeType,
    void Function(double progress)? onProgress,
  }) async {
    if (uploadException != null) throw uploadException!;
    uploads.add((
      bytes: bytes,
      companySlug: companySlug,
      filename: filename,
      mimeType: mimeType,
    ));
    // Simulate progress callbacks
    onProgress?.call(0.5);
    onProgress?.call(1.0);
    return uploadResult;
  }

  @override
  Future<void> delete(String storagePath) async {
    if (deleteException != null) throw deleteException!;
    deletes.add(storagePath);
  }

  @override
  Future<void> clearCache() async {
    clearCacheCalled = true;
  }
}

/// Concrete override that provides a custom thumbnail URL.
class ThumbnailStorageBackend extends MediaStorageBackend {
  @override
  Future<StorageUploadResult> upload({
    required Uint8List bytes,
    required String companySlug,
    required String filename,
    required String mimeType,
    void Function(double progress)? onProgress,
  }) async {
    throw UnimplementedError('Not needed for thumbnail test');
  }

  @override
  Future<void> delete(String storagePath) async {
    throw UnimplementedError('Not needed for thumbnail test');
  }

  @override
  String getThumbnailUrl(String storagePath, {int maxDimension = 300}) {
    return '$storagePath?w=$maxDimension';
  }
}

void main() {
  group('MediaStorageBackend — default implementations', () {
    test('getThumbnailUrl returns storagePath unchanged by default', () {
      final backend = FakeMediaStorageBackend();
      const path = 'companies/test-co/media/photo.jpg';
      expect(backend.getThumbnailUrl(path), path);
    });

    test('getThumbnailUrl ignores maxDimension by default', () {
      final backend = FakeMediaStorageBackend();
      const path = 'companies/test-co/media/photo.jpg';
      expect(backend.getThumbnailUrl(path, maxDimension: 150), path);
    });

    test('clearCache completes without error by default', () async {
      final backend = FakeMediaStorageBackend();
      // Should not throw
      await backend.clearCache();
      expect(backend.clearCacheCalled, isTrue);
    });
  });

  group('MediaStorageBackend — concrete override', () {
    test('getThumbnailUrl can be overridden to add query params', () {
      final backend = ThumbnailStorageBackend();
      expect(
        backend.getThumbnailUrl('path/to/img.jpg', maxDimension: 200),
        'path/to/img.jpg?w=200',
      );
    });

    test('clearCache is a no-op by default (no override needed)', () async {
      final backend = ThumbnailStorageBackend();
      // Default from abstract class — should not throw
      await backend.clearCache();
    });
  });

  group('FakeMediaStorageBackend — test double behavior', () {
    test('upload records call and returns configured result', () async {
      final backend = FakeMediaStorageBackend();
      final bytes = Uint8List.fromList([1, 2, 3]);

      final result = await backend.upload(
        bytes: bytes,
        companySlug: 'test-co',
        filename: 'photo.jpg',
        mimeType: 'image/jpeg',
      );

      expect(result.url, 'https://cdn.example.com/test.jpg');
      expect(result.storagePath, 'companies/test-co/media/test.jpg');
      expect(backend.uploads, hasLength(1));
      expect(backend.uploads.first.filename, 'photo.jpg');
      expect(backend.uploads.first.companySlug, 'test-co');
    });

    test('upload fires progress callbacks', () async {
      final backend = FakeMediaStorageBackend();
      final progressValues = <double>[];

      await backend.upload(
        bytes: Uint8List(10),
        companySlug: 'slug',
        filename: 'f.png',
        mimeType: 'image/png',
        onProgress: progressValues.add,
      );

      expect(progressValues, [0.5, 1.0]);
    });

    test('upload throws configured exception', () async {
      final backend = FakeMediaStorageBackend();
      backend.uploadException = Exception('network down');

      expect(
        () => backend.upload(
          bytes: Uint8List(1),
          companySlug: 's',
          filename: 'f',
          mimeType: 'image/png',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('delete records path', () async {
      final backend = FakeMediaStorageBackend();
      await backend.delete('companies/test/media/old.jpg');

      expect(backend.deletes, ['companies/test/media/old.jpg']);
    });

    test('delete throws configured exception', () async {
      final backend = FakeMediaStorageBackend();
      backend.deleteException = Exception('permission denied');

      expect(
        () => backend.delete('any/path'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('MediaRepository._parseRows logic', () {
    // We can't instantiate MediaRepository without a TenantConnection,
    // but we CAN test the parsing logic indirectly by verifying
    // MediaItem.fromJson works with the exact shape that SurrealDB returns.

    test('parses SurrealDB wrapped result format', () {
      // SurrealDB returns: [{"result": [...rows], "status": "OK"}]
      final surrealResult = [
        {
          'status': 'OK',
          'result': [
            {
              'id': 'media:abc',
              'uploader_id': 'user@test.com',
              'url': 'https://cdn.example.com/img.jpg',
              'storage_path': 'companies/co/media/img.jpg',
              'filename': 'img.jpg',
              'mime_type': 'image/jpeg',
              'size': 1024,
              'category': 'logo',
              'tags': ['brand'],
            },
          ],
        },
      ];

      // Simulate _parseRows logic
      final rows = _parseRows(surrealResult);
      expect(rows, hasLength(1));
      expect(rows.first.id, 'media:abc');
      expect(rows.first.category, MediaCategory.logo);
      expect(rows.first.tags, ['brand']);
    });

    test('parses flat list result format', () {
      // Some SDK versions return flat lists
      final flatResult = [
        <String, dynamic>{
          'id': 'media:flat1',
          'uploader_id': 'u',
          'url': 'u',
          'storage_path': 'p',
          'filename': 'f.jpg',
          'mime_type': 'image/jpeg',
          'size': 100,
        },
        <String, dynamic>{
          'id': 'media:flat2',
          'uploader_id': 'u',
          'url': 'u',
          'storage_path': 'p',
          'filename': 'g.png',
          'mime_type': 'image/png',
          'size': 200,
        },
      ];

      final rows = _parseRows(flatResult);
      expect(rows, hasLength(2));
      expect(rows[0].id, 'media:flat1');
      expect(rows[1].id, 'media:flat2');
    });

    test('handles empty result list', () {
      expect(_parseRows([]), isEmpty);
    });

    test('handles null-ish result', () {
      expect(_parseRows(null), isEmpty);
      expect(_parseRows('not a list'), isEmpty);
    });

    test('handles wrapped result with null result field', () {
      final result = [
        {'status': 'OK', 'result': null},
      ];
      expect(_parseRows(result), isEmpty);
    });

    test('handles wrapped result with empty result list', () {
      final result = [
        {'status': 'OK', 'result': <dynamic>[]},
      ];
      expect(_parseRows(result), isEmpty);
    });

    test('skips non-Map entries in results', () {
      final result = [
        {
          'status': 'OK',
          'result': [
            'not a map',
            42,
            {
              'id': 'media:valid',
              'uploader_id': 'u',
              'url': 'u',
              'storage_path': 'p',
              'filename': 'f',
              'mime_type': 'image/png',
              'size': 1,
            },
          ],
        },
      ];

      final rows = _parseRows(result);
      expect(rows, hasLength(1));
      expect(rows.first.id, 'media:valid');
    });
  });
}

/// Mirror of [MediaRepository._parseRows] for unit testing.
///
/// Extracted here because [MediaRepository] requires a live [TenantConnection]
/// and we want to test parsing without a DB connection.
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
