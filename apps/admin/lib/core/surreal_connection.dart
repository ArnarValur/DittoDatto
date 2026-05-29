import 'package:surrealdb/surrealdb.dart';

/// Manages two authenticated SurrealDB WebSocket connections.
///
/// The admin panel needs cross-namespace access:
/// - `companies` namespace → registry + discovery databases
/// - `users` namespace → profiles database
///
/// Each connection authenticates as a namespace-level system user
/// (DEFINE USER ... ON NAMESPACE ... ROLES OWNER) which grants full
/// access to all databases within that namespace.
class SurrealConnection {
  SurrealConnection._({required this.companies, required this.users});

  /// Connection to the `companies` namespace.
  final SurrealDB companies;

  /// Connection to the `users` namespace.
  final SurrealDB users;

  /// Connect and authenticate to both namespaces.
  ///
  /// [user] and [pass] are SurrealDB namespace-level credentials.
  /// [url] is the WebSocket RPC endpoint (e.g. `wss://host:8002/rpc`).
  /// If [url] is null, it's derived from the current page origin.
  static Future<SurrealConnection> connect({
    required String user,
    required String pass,
    String? url,
  }) async {
    final wsUrl = url ?? _deriveWsUrl();

    final companiesDb = SurrealDB(wsUrl);
    companiesDb.connect();
    await companiesDb.wait();
    await companiesDb.signin(
      user: user,
      pass: pass,
      namespace: 'companies',
    );

    final usersDb = SurrealDB(wsUrl);
    usersDb.connect();
    await usersDb.wait();
    await usersDb.signin(
      user: user,
      pass: pass,
      namespace: 'users',
    );

    return SurrealConnection._(companies: companiesDb, users: usersDb);
  }

  /// Close both connections.
  void close() {
    companies.close();
    users.close();
  }

  /// Derive the WebSocket URL from the current browser origin.
  ///
  /// Uses [Uri.base] which works in Flutter web (resolves to the page URL).
  /// `https://host:8002` → `wss://host:8002/rpc`
  /// `http://host:8002`  → `ws://host:8002/rpc`
  static String _deriveWsUrl() {
    final base = Uri.base;
    final protocol = base.scheme == 'https' ? 'wss' : 'ws';
    final host = base.host;
    final port = base.hasPort ? ':${base.port}' : '';
    return '$protocol://$host$port/rpc';
  }
}

