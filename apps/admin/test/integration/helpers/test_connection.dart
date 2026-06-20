import 'package:surrealdb/surrealdb.dart';
import 'package:ditto_admin/core/surreal_connection.dart';

/// Creates a [SurrealConnection] authenticated as NS OWNER on both namespaces
/// against the ephemeral test SurrealDB (port 18000).
///
/// Mirrors how the Admin Panel connects in production: dual WebSocket clients
/// with NS-level credentials on `companies` and `users`.
///
/// The credentials match those created by `scripts/test-db-seed.sh`.
Future<SurrealConnection> connectTestAdmin({
  String url = 'ws://localhost:18000/rpc',
  String user = 'testadmin',
  String pass = 'testadmin-pass',
}) async {
  final result = await SurrealConnection.connect(
    user: user,
    pass: pass,
    url: url,
  );
  return result.connection;
}

/// Deletes all records from a table, swallowing errors if the table is empty.
Future<void> cleanTable(SurrealDB db, String table) async {
  try {
    await db.query('DELETE $table');
  } catch (_) {
    // Table may not exist or be empty — safe to ignore.
  }
}
