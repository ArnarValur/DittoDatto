import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/surreal_auth_service.dart';
import '../../core/surreal_connection.dart';
import '../auth/auth_provider.dart';
import 'establishment_model.dart';

/// Provides the active [SurrealConnection] from the auth service.
///
/// Throws if called before authentication. Guard usage behind auth checks.
final surrealConnectionProvider = Provider<SurrealConnection?>((ref) {
  final authService = ref.watch(authServiceProvider);
  if (authService is SurrealAuthService) {
    return authService.connection;
  }
  return null;
});

/// Fetches all Establishments from the tenant's SurrealDB.
///
/// Uses `SELECT * FROM establishment` on the companies connection.
/// Returns an empty list if the connection is not available.
final establishmentsProvider =
    AsyncNotifierProvider<EstablishmentsNotifier, List<Establishment>>(
  EstablishmentsNotifier.new,
);

/// Manages the list of Establishments with CRUD operations.
class EstablishmentsNotifier extends AsyncNotifier<List<Establishment>> {
  @override
  Future<List<Establishment>> build() async {
    return _fetchAll();
  }

  SurrealConnection? get _db => ref.read(surrealConnectionProvider);

  /// Fetch all establishments from SurrealDB.
  Future<List<Establishment>> _fetchAll() async {
    final db = _db;
    if (db == null) return [];

    final result = await db.companies.query('SELECT * FROM establishment');

    // SurrealDB query returns dynamic — could be List with {result: [...]}
    // or direct list, depending on the driver version.
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
        .map(Establishment.fromJson)
        .toList();
  }

  /// Create a new establishment.
  Future<void> create(Establishment establishment) async {
    final db = _db;
    if (db == null) return;

    final json = establishment.toJson()..remove('id');
    await db.companies.create('establishment', json);
    state = AsyncData(await _fetchAll());
  }

  /// Update an existing establishment.
  Future<void> updateEstablishment(Establishment establishment) async {
    final db = _db;
    if (db == null) return;

    final json = establishment.toJson();
    final id = json.remove('id');
    await db.companies.query(
      r'UPDATE type::record("establishment", $id) MERGE $data',
      {'id': id, 'data': json},
    );
    state = AsyncData(await _fetchAll());
  }

  /// Delete an establishment by ID.
  Future<void> delete(String id) async {
    final db = _db;
    if (db == null) return;

    await db.companies.query(
      r'DELETE type::record("establishment", $id)',
      {'id': id},
    );
    state = AsyncData(await _fetchAll());
  }

  /// Refresh the list from the database.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchAll());
  }
}
