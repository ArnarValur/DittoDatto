@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:surrealdb/surrealdb.dart';

import 'package:media_manager/media_manager.dart';

/// Integration tests for the `media` table CRUD against a real SurrealDB.
///
/// Requires `./scripts/test-db-up.sh` to be running.
///
/// These tests verify the SurrealDB schema + MediaItem model roundtrip.
/// Firebase Storage is NOT tested here — only the metadata layer.
void main() {
  const testUrl = String.fromEnvironment(
    'SURREAL_TEST_URL',
    defaultValue: 'ws://localhost:18000/rpc',
  );

  // Service credentials for company DB (matches test-db-seed.sh).
  const serviceUser = 'bp_portal';
  const servicePass = 'test-portal-pass';

  late SurrealDB db;

  /// Connect as bp_portal to company_testcompany.
  Future<void> connectDb() async {
    db = SurrealDB(testUrl);
    db.connect();
    await db.wait();
    await db.signin(
      user: serviceUser,
      pass: servicePass,
      namespace: 'companies',
      database: 'company_testcompany',
    );
  }

  /// Helper: extract rows from SurrealDB query result.
  List<Map<String, dynamic>> extractRows(dynamic result) {
    if (result is List && result.isNotEmpty) {
      final first = result.first;
      if (first is Map && first.containsKey('result')) {
        final inner = first['result'];
        if (inner is List) {
          return inner.cast<Map<String, dynamic>>();
        }
      }
      if (first is Map<String, dynamic>) {
        return result.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  setUpAll(() async {
    await connectDb();
  });

  setUp(() async {
    // Clean media table before each test
    await db.query('DELETE media');
  });

  tearDownAll(() async {
    await db.query('DELETE media');
    db.close();
  });

  group('Media CRUD', () {
    test('CREATE media record and verify fields', () async {
      final rows = extractRows(
        await db.query(
          r'CREATE media CONTENT $data',
          {
            'data': {
              'uploader_id': 'test@dittodatto.no',
              'url': 'https://storage.example.com/photo.jpg',
              'storage_path': 'companies/testco/media/1234-photo.jpg',
              'filename': 'photo.jpg',
              'mime_type': 'image/jpeg',
              'size': 524288,
              'tags': ['gallery', 'store'],
              'name': 'Test Photo',
              'category': 'logo',
            },
          },
        ),
      );

      expect(rows, hasLength(1));

      final item = MediaItem.fromJson(rows.first);
      expect(item.uploaderId, 'test@dittodatto.no');
      expect(item.url, 'https://storage.example.com/photo.jpg');
      expect(item.storagePath, 'companies/testco/media/1234-photo.jpg');
      expect(item.filename, 'photo.jpg');
      expect(item.mimeType, 'image/jpeg');
      expect(item.size, 524288);
      expect(item.tags, ['gallery', 'store']);
      expect(item.name, 'Test Photo');
      expect(item.category, MediaCategory.logo);
      expect(item.id, startsWith('media:'));
    });

    test('SELECT all media returns list', () async {
      // Create 3 records
      for (var i = 1; i <= 3; i++) {
        await db.query(
          r'CREATE media CONTENT $data',
          {
            'data': {
              'uploader_id': 'test@dittodatto.no',
              'url': 'https://storage.example.com/img$i.jpg',
              'storage_path': 'companies/testco/media/img$i.jpg',
              'filename': 'img$i.jpg',
              'mime_type': 'image/jpeg',
              'size': 1000 * i,
              'tags': ['test'],
            },
          },
        );
      }

      final rows = extractRows(
        await db.query('SELECT * FROM media ORDER BY created_at DESC'),
      );

      expect(rows, hasLength(3));

      final items = rows.map(MediaItem.fromJson).toList();
      expect(items, hasLength(3));
      // All should default to 'general' since we didn't specify category
      for (final item in items) {
        expect(item.category, MediaCategory.general);
      }
    });

    test('DELETE media removes the record', () async {
      // Create
      final rows = extractRows(
        await db.query(
          r'CREATE media CONTENT $data',
          {
            'data': {
              'uploader_id': 'test@dittodatto.no',
              'url': 'https://storage.example.com/del.jpg',
              'storage_path': 'companies/testco/media/del.jpg',
              'filename': 'del.jpg',
              'mime_type': 'image/png',
              'size': 2048,
            },
          },
        ),
      );
      expect(rows, hasLength(1));
      final id = rows.first['id'] as String;

      // Delete
      await db.query(r'DELETE $id', {'id': id});

      // Verify gone
      final afterRows = extractRows(
        await db.query('SELECT * FROM media'),
      );
      expect(afterRows, isEmpty);
    });

    test('rejects invalid MIME type', () async {
      expect(
        () => db.query(
          r'CREATE media CONTENT $data',
          {
            'data': {
              'uploader_id': 'test@dittodatto.no',
              'url': 'https://storage.example.com/bad.pdf',
              'storage_path': 'companies/testco/media/bad.pdf',
              'filename': 'bad.pdf',
              'mime_type': 'application/pdf', // Not allowed
              'size': 1024,
            },
          },
        ),
        throwsA(anything),
      );
    });

    test('CREATE with explicit category persists correctly', () async {
      for (final cat in MediaCategory.values) {
        final rows = extractRows(
          await db.query(
            r'CREATE media CONTENT $data',
            {
              'data': {
                'uploader_id': 'test@dittodatto.no',
                'url': 'https://storage.example.com/${cat.value}.jpg',
                'storage_path': 'companies/testco/media/${cat.value}.jpg',
                'filename': '${cat.value}.jpg',
                'mime_type': 'image/jpeg',
                'size': 1024,
                'category': cat.value,
              },
            },
          ),
        );

        expect(rows, hasLength(1));
        final item = MediaItem.fromJson(rows.first);
        expect(item.category, cat,
            reason: 'Category ${cat.value} should roundtrip');
      }
    });

    test('CREATE without category defaults to general', () async {
      final rows = extractRows(
        await db.query(
          r'CREATE media CONTENT $data',
          {
            'data': {
              'uploader_id': 'test@dittodatto.no',
              'url': 'https://storage.example.com/nocat.jpg',
              'storage_path': 'companies/testco/media/nocat.jpg',
              'filename': 'nocat.jpg',
              'mime_type': 'image/jpeg',
              'size': 1024,
            },
          },
        ),
      );

      expect(rows, hasLength(1));
      final item = MediaItem.fromJson(rows.first);
      expect(item.category, MediaCategory.general);
    });

    test('rejects invalid category', () async {
      expect(
        () => db.query(
          r'CREATE media CONTENT $data',
          {
            'data': {
              'uploader_id': 'test@dittodatto.no',
              'url': 'https://storage.example.com/badcat.jpg',
              'storage_path': 'companies/testco/media/badcat.jpg',
              'filename': 'badcat.jpg',
              'mime_type': 'image/jpeg',
              'size': 1024,
              'category': 'invalid_category',
            },
          },
        ),
        throwsA(anything),
      );
    });

    test('MediaItem.validateFile rejects oversized files', () {
      final error = MediaItem.validateFile('image/jpeg', 11 * 1024 * 1024);
      expect(error, isNotNull);
      expect(error, contains('for stor'));
    });

    test('MediaItem.validateFile rejects bad MIME types', () {
      final error = MediaItem.validateFile('application/pdf', 1024);
      expect(error, isNotNull);
      expect(error, contains('ikke støttet'));
    });

    test('MediaItem.validateFile accepts valid files', () {
      expect(MediaItem.validateFile('image/jpeg', 5 * 1024 * 1024), isNull);
      expect(MediaItem.validateFile('image/png', 1024), isNull);
      expect(MediaItem.validateFile('image/webp', 1024), isNull);
      expect(MediaItem.validateFile('image/svg+xml', 512), isNull);
    });

    test('MediaItem.formattedSize returns human-readable sizes', () {
      const small = MediaItem(
        id: 'media:1',
        uploaderId: 'x',
        url: 'x',
        storagePath: 'x',
        filename: 'x',
        mimeType: 'image/jpeg',
        size: 512,
      );
      expect(small.formattedSize, '512 B');

      const medium = MediaItem(
        id: 'media:2',
        uploaderId: 'x',
        url: 'x',
        storagePath: 'x',
        filename: 'x',
        mimeType: 'image/jpeg',
        size: 2048,
      );
      expect(medium.formattedSize, '2.0 KB');

      const large = MediaItem(
        id: 'media:3',
        uploaderId: 'x',
        url: 'x',
        storagePath: 'x',
        filename: 'x',
        mimeType: 'image/jpeg',
        size: 5 * 1024 * 1024,
      );
      expect(large.formattedSize, '5.0 MB');
    });

    test('MediaCategory.fromValue handles all known values', () {
      for (final cat in MediaCategory.values) {
        expect(MediaCategory.fromValue(cat.value), cat);
      }
    });

    test('MediaCategory.fromValue defaults to general for unknown', () {
      expect(MediaCategory.fromValue(null), MediaCategory.general);
      expect(MediaCategory.fromValue('unknown'), MediaCategory.general);
      expect(MediaCategory.fromValue(''), MediaCategory.general);
    });

    test('MediaItem.toJson includes category', () {
      const item = MediaItem(
        id: 'media:x',
        uploaderId: 'test@dittodatto.no',
        url: 'https://example.com/logo.png',
        storagePath: 'companies/testco/media/logo.png',
        filename: 'logo.png',
        mimeType: 'image/png',
        size: 1024,
        category: MediaCategory.logo,
      );
      final json = item.toJson();
      expect(json['category'], 'logo');
    });
  });
}
