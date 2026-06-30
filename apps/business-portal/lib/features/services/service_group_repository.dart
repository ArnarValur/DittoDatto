import 'package:establishment_ui/establishment_ui.dart';

/// SurrealDB-backed repository for ServiceGroup CRUD.
///
/// Queries the `service_group` SCHEMAFULL table in the tenant DB.
/// Follows the same pattern as EstablishmentsNotifier for DB access.
class ServiceGroupRepository {
  ServiceGroupRepository(this._query);

  /// SurrealDB query function (injected from TenantConnection.companies.query).
  final Future<dynamic> Function(String query, [Map<String, dynamic>? vars])
      _query;

  /// Fetch all service groups, ordered by sort_order.
  Future<List<ServiceGroup>> fetchAll() async {
    final result = await _query(
      'SELECT * FROM service_group WHERE deleted_at IS NONE ORDER BY sort_order',
    );
    return _extractRows(result).map(ServiceGroup.fromJson).toList();
  }

  /// Create a new service group.
  Future<ServiceGroup> create({
    required String establishmentId,
    required String name,
    String? description,
    int sortOrder = 0,
    bool showOnBookingPanel = true,
    bool multiSelect = false,
  }) async {
    final data = <String, dynamic>{
      'establishment': establishmentId,
      'name': name,
      'sort_order': sortOrder,
      'show_on_booking_panel': showOnBookingPanel,
      'multi_select': multiSelect,
    };
    if (description != null) data['description'] = description;

    final result = await _query(
      r'CREATE service_group CONTENT $data',
      {'data': data},
    );
    final rows = _extractRows(result);
    if (rows.isEmpty) throw StateError('CREATE service_group returned no rows');
    return ServiceGroup.fromJson(rows.first);
  }

  /// Update an existing service group.
  Future<void> update(ServiceGroup group) async {
    final data = <String, dynamic>{
      'name': group.name,
      'sort_order': group.sortOrder,
      'show_on_booking_panel': group.showOnBookingPanel,
      'multi_select': group.multiSelect,
    };
    if (group.description != null) data['description'] = group.description;

    await _query(
      r'UPDATE type::record("service_group", $id) MERGE $data',
      {
        'id': group.id,
        'data': data,
      },
    );
  }

  /// Soft-delete a service group (sets deleted_at).
  Future<void> delete(String id) async {
    await _query(
      r'UPDATE type::record("service_group", $id) SET deleted_at = time::now()',
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
