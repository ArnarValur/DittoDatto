import 'package:flutter_test/flutter_test.dart';
import 'package:media_manager/media_manager.dart';

void main() {
  group('MediaCategory', () {
    test('fromValue parses all known values', () {
      for (final cat in MediaCategory.values) {
        expect(MediaCategory.fromValue(cat.value), cat);
      }
    });

    test('fromValue defaults to general for null', () {
      expect(MediaCategory.fromValue(null), MediaCategory.general);
    });

    test('fromValue defaults to general for unknown value', () {
      expect(MediaCategory.fromValue('nonsense'), MediaCategory.general);
    });

    test('all categories have Norwegian labels', () {
      for (final cat in MediaCategory.values) {
        expect(cat.label, isNotEmpty);
      }
    });

    test('values match SurrealDB ASSERT constraint', () {
      final expectedValues = [
        'general',
        'logo',
        'cover',
        'gallery',
        'staff',
        'service',
        'menu',
      ];
      expect(
        MediaCategory.values.map((c) => c.value).toList(),
        expectedValues,
      );
    });
  });

  group('MediaItem', () {
    final sampleJson = <String, dynamic>{
      'id': 'media:abc123',
      'uploader_id': 'user@test.com',
      'url': 'https://storage.example.com/photo.jpg',
      'storage_path': 'companies/test-co/media/1234-photo.jpg',
      'filename': 'photo.jpg',
      'mime_type': 'image/jpeg',
      'size': 1024 * 500, // 500 KB
      'category': 'logo',
      'tags': ['brand', 'header'],
      'name': 'Company Logo',
      'establishment': 'establishment:xyz',
    };

    test('fromJson parses all fields', () {
      final item = MediaItem.fromJson(sampleJson);

      expect(item.id, 'media:abc123');
      expect(item.uploaderId, 'user@test.com');
      expect(item.url, 'https://storage.example.com/photo.jpg');
      expect(item.storagePath, 'companies/test-co/media/1234-photo.jpg');
      expect(item.filename, 'photo.jpg');
      expect(item.mimeType, 'image/jpeg');
      expect(item.size, 1024 * 500);
      expect(item.category, MediaCategory.logo);
      expect(item.tags, ['brand', 'header']);
      expect(item.name, 'Company Logo');
      expect(item.establishmentId, 'establishment:xyz');
    });

    test('fromJson handles missing optional fields', () {
      final minimalJson = <String, dynamic>{
        'id': 'media:min',
        'uploader_id': 'user@test.com',
        'url': 'https://storage.example.com/img.png',
        'storage_path': 'companies/test/media/img.png',
        'filename': 'img.png',
        'mime_type': 'image/png',
        'size': 2048,
      };

      final item = MediaItem.fromJson(minimalJson);

      expect(item.category, MediaCategory.general);
      expect(item.tags, isEmpty);
      expect(item.name, isNull);
      expect(item.establishmentId, isNull);
    });

    test('toJson includes required fields', () {
      final item = MediaItem.fromJson(sampleJson);
      final json = item.toJson();

      expect(json['uploader_id'], 'user@test.com');
      expect(json['url'], isNotNull);
      expect(json['storage_path'], isNotNull);
      expect(json['filename'], 'photo.jpg');
      expect(json['mime_type'], 'image/jpeg');
      expect(json['size'], 1024 * 500);
      expect(json['category'], 'logo');
      expect(json['tags'], ['brand', 'header']);
    });

    test('toJson includes optional fields when present', () {
      final item = MediaItem.fromJson(sampleJson);
      final json = item.toJson();

      expect(json['establishment'], 'establishment:xyz');
      expect(json['name'], 'Company Logo');
    });

    test('toJson strips null optional fields (NONE for SurrealDB)', () {
      final item = MediaItem.fromJson(<String, dynamic>{
        'id': 'media:min',
        'uploader_id': 'user@test.com',
        'url': 'https://storage.example.com/img.png',
        'storage_path': 'companies/test/media/img.png',
        'filename': 'img.png',
        'mime_type': 'image/png',
        'size': 2048,
      });

      final json = item.toJson();

      expect(json.containsKey('establishment'), isFalse);
      expect(json.containsKey('name'), isFalse);
    });

    test('formattedSize returns human-readable sizes', () {
      expect(
        const MediaItem(
          id: 'x',
          uploaderId: 'u',
          url: 'u',
          storagePath: 'p',
          filename: 'f',
          mimeType: 'm',
          size: 500,
        ).formattedSize,
        '500 B',
      );

      expect(
        const MediaItem(
          id: 'x',
          uploaderId: 'u',
          url: 'u',
          storagePath: 'p',
          filename: 'f',
          mimeType: 'm',
          size: 1024 * 500,
        ).formattedSize,
        '500.0 KB',
      );

      expect(
        const MediaItem(
          id: 'x',
          uploaderId: 'u',
          url: 'u',
          storagePath: 'p',
          filename: 'f',
          mimeType: 'm',
          size: 1024 * 1024 * 3,
        ).formattedSize,
        '3.0 MB',
      );
    });
  });

  group('MediaItem.validateFile', () {
    test('accepts allowed MIME types', () {
      expect(MediaItem.validateFile('image/jpeg', 1000), isNull);
      expect(MediaItem.validateFile('image/png', 1000), isNull);
      expect(MediaItem.validateFile('image/webp', 1000), isNull);
      expect(MediaItem.validateFile('image/svg+xml', 1000), isNull);
    });

    test('rejects unsupported MIME types', () {
      final error = MediaItem.validateFile('image/gif', 1000);
      expect(error, isNotNull);
      expect(error, contains('gif'));
    });

    test('rejects files over 10 MB', () {
      final error =
          MediaItem.validateFile('image/jpeg', 11 * 1024 * 1024);
      expect(error, isNotNull);
      expect(error, contains('10 MB'));
    });

    test('accepts files at exactly 10 MB', () {
      expect(
        MediaItem.validateFile('image/jpeg', 10 * 1024 * 1024),
        isNull,
      );
    });
  });

  group('MediaUploadState', () {
    test('idle state has sensible defaults', () {
      const state = MediaUploadState();
      expect(state.isUploading, isFalse);
      expect(state.progress, 0.0);
      expect(state.currentFileName, isNull);
      expect(state.currentIndex, 0);
      expect(state.totalFiles, 0);
      expect(state.error, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      const state = MediaUploadState(
        isUploading: true,
        progress: 0.5,
        currentFileName: 'test.jpg',
        currentIndex: 2,
        totalFiles: 5,
      );

      final updated = state.copyWith(progress: 0.8);

      expect(updated.isUploading, isTrue);
      expect(updated.progress, 0.8);
      expect(updated.currentFileName, 'test.jpg');
      expect(updated.currentIndex, 2);
      expect(updated.totalFiles, 5);
    });

    test('copyWith clears error when set to null explicitly', () {
      const state = MediaUploadState(error: 'Something failed');
      // error param is not nullable in copyWith, so setting a new state:
      final cleared = state.copyWith(error: null);
      // error defaults to null in the constructor when not provided
      expect(cleared.error, isNull);
    });

    test('idle constant matches default constructor', () {
      expect(MediaUploadState.idle.isUploading, isFalse);
      expect(MediaUploadState.idle.progress, 0.0);
      expect(MediaUploadState.idle.error, isNull);
    });
  });

  group('StorageUploadResult', () {
    test('stores url and storagePath', () {
      const result = StorageUploadResult(
        url: 'https://cdn.example.com/photo.jpg',
        storagePath: 'companies/test/media/photo.jpg',
      );

      expect(result.url, 'https://cdn.example.com/photo.jpg');
      expect(result.storagePath, 'companies/test/media/photo.jpg');
    });
  });
}
