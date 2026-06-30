@Tags(['integration'])
library;

import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surrealdb/surrealdb.dart';

/// Integration tests for Service + ServiceGroup CRUD against real SurrealDB.
///
/// Validates that shared models correctly serialize/deserialize with the
/// SCHEMAFULL tables in `company-blueprint.surql`.
///
/// Prerequisites:
///   ./scripts/test-db-up.sh   (starts + seeds ephemeral SurrealDB)
///
/// Run:
///   cd apps/business-portal
///   flutter test --tags integration
void main() {
  const testUrl = String.fromEnvironment(
    'SURREAL_TEST_URL',
    defaultValue: 'ws://localhost:18000/rpc',
  );

  const serviceUser = 'bp_portal';
  const servicePass = 'test-portal-pass';

  late SurrealDB db;

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

  /// Extract rows from SurrealDB query result.
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

  /// Get (or create) an establishment for service linking.
  Future<String> ensureEstablishment() async {
    final existing = await db.query(
      'SELECT id FROM establishment LIMIT 1',
    );
    final rows = extractRows(existing);
    if (rows.isNotEmpty) return rows.first['id'] as String;

    // Create a minimal establishment.
    final result = await db.query(
      r'''CREATE establishment CONTENT {
        name: "Test Salon",
        slug: "test-salon",
        store_type: "store",
        address: "Testgate 1",
        city: "Oslo",
        zip: "0150"
      }''',
    );
    return extractRows(result).first['id'] as String;
  }

  setUp(() async {
    await connectDb();
    // Clean slate.
    await db.query('DELETE service');
    await db.query('DELETE service_group');
  });

  tearDown(() {
    db.close();
  });

  // ── ServiceGroup CRUD ────────────────────────────────────────────────

  group('ServiceGroup CREATE', () {
    test('creates a group with required fields only', () async {
      final estId = await ensureEstablishment();
      final result = await db.query(
        r'CREATE service_group CONTENT $data',
        {
          'data': {
            'establishment': estId,
            'name': 'Hårklipp',
          },
        },
      );
      final rows = extractRows(result);
      expect(rows, hasLength(1));

      final group = ServiceGroup.fromJson(rows.first);
      expect(group.name, 'Hårklipp');
      expect(group.sortOrder, 0); // schema DEFAULT
      expect(group.showOnBookingPanel, true); // schema DEFAULT
      expect(group.multiSelect, false); // schema DEFAULT
      expect(group.description, isNull);
    });

    test('creates a group with all fields', () async {
      final estId = await ensureEstablishment();
      final result = await db.query(
        r'CREATE service_group CONTENT $data',
        {
          'data': {
            'establishment': estId,
            'name': 'Behandlinger',
            'description': 'Alle behandlinger',
            'sort_order': 2,
            'show_on_booking_panel': false,
            'multi_select': true,
          },
        },
      );
      final group = ServiceGroup.fromJson(extractRows(result).first);
      expect(group.name, 'Behandlinger');
      expect(group.description, 'Alle behandlinger');
      expect(group.sortOrder, 2);
      expect(group.showOnBookingPanel, false);
      expect(group.multiSelect, true);
    });
  });

  group('ServiceGroup READ', () {
    test('round-trips through SurrealDB', () async {
      final estId = await ensureEstablishment();
      await db.query(
        r'CREATE service_group CONTENT $data',
        {
          'data': {
            'establishment': estId,
            'name': 'Test Group',
            'sort_order': 5,
          },
        },
      );

      final result = await db.query(
        'SELECT * FROM service_group ORDER BY sort_order',
      );
      final groups =
          extractRows(result).map(ServiceGroup.fromJson).toList();
      expect(groups, hasLength(1));
      expect(groups.first.name, 'Test Group');
      expect(groups.first.sortOrder, 5);
    });
  });

  group('ServiceGroup UPDATE', () {
    test('updates name and sort_order', () async {
      final estId = await ensureEstablishment();
      final createResult = await db.query(
        r'CREATE service_group CONTENT $data',
        {
          'data': {
            'establishment': estId,
            'name': 'Original',
            'sort_order': 0,
          },
        },
      );
      final id = extractRows(createResult).first['id'] as String;

      await db.query(
        r'UPDATE type::record("service_group", $id) MERGE $data',
        {
          'id': id,
          'data': {'name': 'Updated', 'sort_order': 10},
        },
      );

      final readResult = await db.query(
        r'SELECT * FROM type::record("service_group", $id)',
        {'id': id},
      );
      final updated = ServiceGroup.fromJson(extractRows(readResult).first);
      expect(updated.name, 'Updated');
      expect(updated.sortOrder, 10);
    });
  });

  group('ServiceGroup DELETE', () {
    test('soft-deletes by setting deleted_at', () async {
      final estId = await ensureEstablishment();
      final createResult = await db.query(
        r'CREATE service_group CONTENT $data',
        {
          'data': {'establishment': estId, 'name': 'To Delete'},
        },
      );
      final id = extractRows(createResult).first['id'] as String;

      await db.query(
        r'UPDATE type::record("service_group", $id) SET deleted_at = time::now()',
        {'id': id},
      );

      // Should not appear in active query.
      final result = await db.query(
        'SELECT * FROM service_group WHERE deleted_at IS NONE',
      );
      expect(extractRows(result), isEmpty);
    });
  });

  // ── Service CRUD ─────────────────────────────────────────────────────

  group('Service CREATE', () {
    test('creates a service with required fields only', () async {
      final estId = await ensureEstablishment();
      final result = await db.query(
        r'CREATE service CONTENT $data',
        {
          'data': {
            'establishment': estId,
            'title': 'Herreklipp',
            'duration': 30,
            'price': 450,
          },
        },
      );
      final rows = extractRows(result);
      expect(rows, hasLength(1));

      final service = Service.fromJson(rows.first);
      expect(service.title, 'Herreklipp');
      expect(service.duration, 30);
      expect(service.price, 450.0);
      expect(service.currency, 'NOK'); // schema DEFAULT
      expect(service.bookingMode, 'standard'); // schema DEFAULT
      expect(service.isActive, true); // schema DEFAULT
      expect(service.description, isNull);
      expect(service.groupId, isNull);
    });

    test('creates with all fields including group link', () async {
      final estId = await ensureEstablishment();

      // Create a group first.
      final groupResult = await db.query(
        r'CREATE service_group CONTENT $data',
        {
          'data': {'establishment': estId, 'name': 'Klipp'},
        },
      );
      final groupId = extractRows(groupResult).first['id'] as String;

      final result = await db.query(
        r'CREATE service CONTENT $data',
        {
          'data': {
            'establishment': estId,
            'title': 'Dameklipp',
            'description': 'Komplett klipp med styling',
            'group': groupId,
            'duration': 60,
            'price': 850.50,
            'currency': 'NOK',
            'booking_mode': 'standard',
            'is_active': true,
          },
        },
      );
      final service = Service.fromJson(extractRows(result).first);
      expect(service.title, 'Dameklipp');
      expect(service.description, 'Komplett klipp med styling');
      expect(service.duration, 60);
      expect(service.price, 850.50);
    });

    test('handles zero price (gratis)', () async {
      final estId = await ensureEstablishment();
      final result = await db.query(
        r'CREATE service CONTENT $data',
        {
          'data': {
            'establishment': estId,
            'title': 'Gratis konsultasjon',
            'duration': 15,
            'price': 0,
          },
        },
      );
      final service = Service.fromJson(extractRows(result).first);
      expect(service.price, 0);
      expect(formatPrice(service.price, service.currency), 'Gratis');
    });

    test('handles tableReservation booking mode', () async {
      final estId = await ensureEstablishment();
      final result = await db.query(
        r'CREATE service CONTENT $data',
        {
          'data': {
            'establishment': estId,
            'title': 'Bord for 4',
            'duration': 120,
            'price': 0,
            'booking_mode': 'tableReservation',
          },
        },
      );
      final service = Service.fromJson(extractRows(result).first);
      expect(service.bookingMode, 'tableReservation');
    });
  });

  group('Service READ', () {
    test('fetches and parses all services', () async {
      final estId = await ensureEstablishment();
      for (final title in ['B-tjeneste', 'A-tjeneste', 'C-tjeneste']) {
        await db.query(
          r'CREATE service CONTENT $data',
          {
            'data': {
              'establishment': estId,
              'title': title,
              'duration': 30,
              'price': 300,
            },
          },
        );
      }

      final result = await db.query(
        'SELECT * FROM service ORDER BY title',
      );
      final services =
          extractRows(result).map(Service.fromJson).toList();
      expect(services, hasLength(3));
      expect(services[0].title, 'A-tjeneste');
      expect(services[1].title, 'B-tjeneste');
      expect(services[2].title, 'C-tjeneste');
    });
  });

  group('Service UPDATE', () {
    test('updates price and duration', () async {
      final estId = await ensureEstablishment();
      final createResult = await db.query(
        r'CREATE service CONTENT $data',
        {
          'data': {
            'establishment': estId,
            'title': 'Klipp',
            'duration': 30,
            'price': 300,
          },
        },
      );
      final id = extractRows(createResult).first['id'] as String;

      await db.query(
        r'UPDATE type::record("service", $id) MERGE $data',
        {
          'id': id,
          'data': {'price': 500, 'duration': 45},
        },
      );

      final readResult = await db.query(
        r'SELECT * FROM type::record("service", $id)',
        {'id': id},
      );
      final updated = Service.fromJson(extractRows(readResult).first);
      expect(updated.price, 500);
      expect(updated.duration, 45);
      expect(updated.title, 'Klipp'); // unchanged
    });
  });

  group('Service DELETE', () {
    test('soft-deletes by setting deleted_at', () async {
      final estId = await ensureEstablishment();
      final createResult = await db.query(
        r'CREATE service CONTENT $data',
        {
          'data': {
            'establishment': estId,
            'title': 'To Delete',
            'duration': 30,
            'price': 100,
          },
        },
      );
      final id = extractRows(createResult).first['id'] as String;

      await db.query(
        r'UPDATE type::record("service", $id) SET deleted_at = time::now()',
        {'id': id},
      );

      final result = await db.query(
        'SELECT * FROM service WHERE deleted_at IS NONE',
      );
      expect(extractRows(result), isEmpty);
    });
  });
}
