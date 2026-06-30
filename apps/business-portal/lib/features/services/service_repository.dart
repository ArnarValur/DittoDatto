import 'package:establishment_ui/establishment_ui.dart';

/// SurrealDB-backed repository for Service CRUD.
///
/// Queries the `service` SCHEMAFULL table in the tenant DB.
class ServiceRepository {
  ServiceRepository(this._query);

  /// SurrealDB query function (injected from TenantConnection.companies.query).
  final Future<dynamic> Function(String query, [Map<String, dynamic>? vars])
      _query;

  /// Fetch all active services, ordered by title.
  Future<List<Service>> fetchAll() async {
    final result = await _query(
      'SELECT * FROM service WHERE deleted_at IS NONE ORDER BY title',
    );
    return _extractRows(result).map(Service.fromJson).toList();
  }

  /// Create a new service.
  Future<Service> create({
    required String establishmentId,
    required String title,
    required int duration,
    required double price,
    String? description,
    String? groupId,
    String currency = 'NOK',
    String bookingMode = 'standard',
    bool isActive = true,
  }) async {
    final data = <String, dynamic>{
      'establishment': establishmentId,
      'title': title,
      'duration': duration,
      'price': price,
      'currency': currency,
      'booking_mode': bookingMode,
      'is_active': isActive,
    };
    if (description != null) data['description'] = description;
    if (groupId != null) data['group'] = groupId;

    final result = await _query(
      r'CREATE service CONTENT $data',
      {'data': data},
    );
    final rows = _extractRows(result);
    if (rows.isEmpty) throw StateError('CREATE service returned no rows');
    return Service.fromJson(rows.first);
  }

  /// Update an existing service.
  Future<void> update(Service service) async {
    final data = <String, dynamic>{
      'title': service.title,
      'duration': service.duration,
      'price': service.price,
      'currency': service.currency,
      'booking_mode': service.bookingMode,
      'is_active': service.isActive,
    };
    if (service.description != null) data['description'] = service.description;
    if (service.groupId != null) data['group'] = service.groupId;

    await _query(
      r'UPDATE type::record("service", $id) MERGE $data',
      {
        'id': service.id,
        'data': data,
      },
    );
  }

  /// Soft-delete a service.
  Future<void> delete(String id) async {
    await _query(
      r'UPDATE type::record("service", $id) SET deleted_at = time::now()',
      {'id': id},
    );
  }

  // ── Result extraction ──────────────────────────────────────────────────

  static List<Map<String, dynamic>> _extractRows(dynamic result) {
    if (result is List && result.isNotEmpty) {
      final first = result.first;
      if (first is Map && first.containsKey('result')) {
        final inner = first['result'];
        if (inner is List) {
          return inner
              .whereType<Map<String, dynamic>>()
              .toList();
        }
      }
      if (first is Map<String, dynamic>) {
        return result.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }
}
