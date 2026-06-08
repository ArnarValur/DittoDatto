import 'package:surrealdb/surrealdb.dart';

/// Manages authenticated SurrealDB WebSocket connections for the Business Portal.
///
/// Similar to the Admin Panel connection but adds tenant routing:
/// after login, the companies connection is switched to `company_{slug}`
/// database per ADR-0013.
///
/// Connections:
/// - `companies` namespace → tenant database (`company_{slug}`)
/// - `users` namespace → profiles database (role verification)
class SurrealConnection {
  SurrealConnection._({required this.companies, required this.users});

  /// Connection to the `companies` namespace (tenant-scoped after login).
  final SurrealDB companies;

  /// Connection to the `users` namespace.
  final SurrealDB users;

  /// Connect and authenticate to both namespaces using credentials.
  ///
  /// [user] and [pass] are SurrealDB namespace-level credentials.
  /// [url] is the WebSocket RPC endpoint (e.g. `wss://host:8002/rpc`).
  /// If [url] is null, it's derived from the current page origin.
  ///
  /// Returns the connection and the JWT tokens for session persistence.
  static Future<({SurrealConnection connection, String companiesToken, String usersToken})> connect({
    required String user,
    required String pass,
    String? url,
  }) async {
    final wsUrl = url ?? _deriveWsUrl();

    final companiesDb = SurrealDB(wsUrl);
    companiesDb.connect();
    await companiesDb.wait();
    final companiesToken = await companiesDb.signin(
      user: user,
      pass: pass,
      namespace: 'companies',
    );

    final usersDb = SurrealDB(wsUrl);
    usersDb.connect();
    await usersDb.wait();
    final usersToken = await usersDb.signin(
      user: user,
      pass: pass,
      namespace: 'users',
    );

    return (
      connection: SurrealConnection._(companies: companiesDb, users: usersDb),
      companiesToken: companiesToken,
      usersToken: usersToken,
    );
  }

  /// Reconnect using previously obtained JWT tokens.
  static Future<SurrealConnection> connectWithTokens({
    required String companiesToken,
    required String usersToken,
    String? url,
  }) async {
    final wsUrl = url ?? _deriveWsUrl();

    final companiesDb = SurrealDB(wsUrl);
    companiesDb.connect();
    await companiesDb.wait();
    await companiesDb.authenticate(companiesToken);

    final usersDb = SurrealDB(wsUrl);
    usersDb.connect();
    await usersDb.wait();
    await usersDb.authenticate(usersToken);

    return SurrealConnection._(companies: companiesDb, users: usersDb);
  }

  /// Close both connections.
  void close() {
    companies.close();
    users.close();
  }

  /// Derive the WebSocket URL from the current browser origin.
  static String _deriveWsUrl() {
    final base = Uri.base;
    final protocol = base.scheme == 'https' ? 'wss' : 'ws';
    final host = base.host;
    final port = base.hasPort ? ':${base.port}' : '';
    return '$protocol://$host$port/rpc';
  }
}
