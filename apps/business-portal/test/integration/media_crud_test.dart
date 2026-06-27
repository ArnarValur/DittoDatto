@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:ditto_auth/ditto_auth.dart';

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

  // ── MediaRepository integration tests ────────────────────────────────────

  group('MediaRepository (via TenantConnection)', () {
    late SurrealDB companiesDb;
    late TenantConnection connection;
    late MediaRepository repo;

    setUpAll(() async {
      companiesDb = SurrealDB(testUrl);
      companiesDb.connect();
      await companiesDb.wait();
      await companiesDb.signin(
        user: serviceUser,
        pass: servicePass,
        namespace: 'companies',
        database: 'company_testcompany',
      );

      // users DB not needed for media tests — reuse same connection
      connection = TenantConnection(
        companies: companiesDb,
        users: companiesDb,
        slug: 'testcompany',
      );
      repo = MediaRepository(connection);
    });

    setUp(() async {
      await companiesDb.query('DELETE media');
    });

    tearDownAll(() async {
      await companiesDb.query('DELETE media');
      companiesDb.close();
    });

    test('slug returns tenant slug', () {
      expect(repo.slug, 'testcompany');
    });

    test('fetchAll returns empty list when no media', () async {
      final items = await repo.fetchAll();
      expect(items, isEmpty);
    });

    test('create returns a MediaItem with all fields', () async {
      final item = await repo.create(
        uploaderId: 'test@dittodatto.no',
        url: 'https://cdn.example.com/repo-test.jpg',
        storagePath: 'companies/testcompany/media/repo-test.jpg',
        filename: 'repo-test.jpg',
        mimeType: 'image/jpeg',
        size: 4096,
        category: MediaCategory.logo,
        tags: ['brand', 'header'],
      );

      expect(item, isNotNull);
      expect(item!.id, startsWith('media:'));
      expect(item.uploaderId, 'test@dittodatto.no');
      expect(item.url, 'https://cdn.example.com/repo-test.jpg');
      expect(item.filename, 'repo-test.jpg');
      expect(item.category, MediaCategory.logo);
      expect(item.tags, ['brand', 'header']);
      expect(item.size, 4096);
    });

    test('create with establishment stores establishmentId', () async {
      // Schema requires record<establishment>
      await companiesDb.query(
        'CREATE establishment:testabc SET name = "Test ABC", slug = "testabc", address = "Test St 1", city = "Oslo", zip = "0001"',
      );

      final item = await repo.create(
        uploaderId: 'test@dittodatto.no',
        url: 'https://cdn.example.com/est.jpg',
        storagePath: 'companies/testcompany/media/est.jpg',
        filename: 'est.jpg',
        mimeType: 'image/jpeg',
        size: 1024,
        establishmentId: 'establishment:testabc',
      );

      expect(item, isNotNull);
      expect(item!.establishmentId, 'establishment:testabc');

      await companiesDb.query('DELETE establishment:testabc');
    });

    test('fetchAll returns created items newest-first', () async {
      // Create 3 items with a small delay so created_at differs
      for (var i = 1; i <= 3; i++) {
        await repo.create(
          uploaderId: 'test@dittodatto.no',
          url: 'https://cdn.example.com/$i.jpg',
          storagePath: 'companies/testcompany/media/$i.jpg',
          filename: '$i.jpg',
          mimeType: 'image/jpeg',
          size: 1000 * i,
        );
      }

      final items = await repo.fetchAll();
      expect(items, hasLength(3));
      // Should be ordered newest-first by created_at
      // (SurrealDB auto-generates created_at)
    });

    test('fetchByCategory filters correctly', () async {
      await repo.create(
        uploaderId: 'u',
        url: 'u1',
        storagePath: 'p1',
        filename: 'logo.jpg',
        mimeType: 'image/jpeg',
        size: 100,
        category: MediaCategory.logo,
      );
      await repo.create(
        uploaderId: 'u',
        url: 'u2',
        storagePath: 'p2',
        filename: 'gallery.jpg',
        mimeType: 'image/jpeg',
        size: 100,
        category: MediaCategory.gallery,
      );

      final logos = await repo.fetchByCategory(MediaCategory.logo);
      expect(logos, hasLength(1));
      expect(logos.first.filename, 'logo.jpg');

      final galleries = await repo.fetchByCategory(MediaCategory.gallery);
      expect(galleries, hasLength(1));
      expect(galleries.first.filename, 'gallery.jpg');
    });

    test('fetchByEstablishment filters correctly', () async {
      // Create establishment records (schema requires record<establishment>)
      await companiesDb.query(
        'CREATE establishment:est1 SET name = "Est 1", slug = "est1", address = "A", city = "Oslo", zip = "0001"',
      );
      await companiesDb.query(
        'CREATE establishment:est2 SET name = "Est 2", slug = "est2", address = "B", city = "Oslo", zip = "0002"',
      );

      await repo.create(
        uploaderId: 'u',
        url: 'u1',
        storagePath: 'p1',
        filename: 'est1.jpg',
        mimeType: 'image/jpeg',
        size: 100,
        establishmentId: 'establishment:est1',
      );
      await repo.create(
        uploaderId: 'u',
        url: 'u2',
        storagePath: 'p2',
        filename: 'est2.jpg',
        mimeType: 'image/jpeg',
        size: 100,
        establishmentId: 'establishment:est2',
      );

      final items = await repo.fetchByEstablishment('establishment:est1');
      expect(items, hasLength(1));
      expect(items.first.filename, 'est1.jpg');

      // Cleanup establishment records
      await companiesDb.query('DELETE establishment:est1');
      await companiesDb.query('DELETE establishment:est2');
    });

    test('delete removes a record and returns true', () async {
      final item = await repo.create(
        uploaderId: 'u',
        url: 'u',
        storagePath: 'p',
        filename: 'del.jpg',
        mimeType: 'image/jpeg',
        size: 100,
      );
      expect(item, isNotNull);

      final deleted = await repo.delete(item!.id);
      expect(deleted, isTrue);

      final remaining = await repo.fetchAll();
      expect(remaining, isEmpty);
    });

    test('delete returns true for nonexistent id (no-op)', () async {
      // SurrealDB DELETE on missing ID doesn't throw
      final result = await repo.delete('media:nonexistent');
      expect(result, isTrue);
    });
  });
}

