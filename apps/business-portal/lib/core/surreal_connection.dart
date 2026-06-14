import 'dart:async';
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

  /// The tenant slug this connection is routed to (e.g. `sawasdee`).
  /// Null until [routeToTenant] is called.
  String? _slug;

  /// The active tenant slug, or null if not yet routed.
  String? get slug => _slug;

  /// Route the companies connection to a specific tenant database.
  ///
  /// Executes `USE NS companies DB company_{slug}` — all subsequent queries
  /// on [companies] will be scoped to that tenant's isolated database.
  Future<void> routeToTenant(String slug) async {
    await companies.use('companies', 'company_$slug');
    _slug = slug;
  }

  /// Connect and authenticate to both namespaces using credentials.
  ///
  /// [user] and [pass] are SurrealDB namespace-level credentials.
  /// [url] is the WebSocket RPC endpoint (e.g. `wss://host:8002/rpc`).
  /// If [url] is null, it's derived from the current page origin.
  ///
  /// After signin, the `users` connection is immediately routed to
  /// `users/profiles`. The `companies` connection remains unrouted —
  /// call [routeToTenant] after discovering the user's `company_slug`.
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

    // Users connection always targets the profiles database.
    await usersDb.use('users', 'profiles');

    return (
      connection: SurrealConnection._(companies: companiesDb, users: usersDb),
      companiesToken: companiesToken,
      usersToken: usersToken,
    );
  }

  /// Reconnect using previously obtained JWT tokens.
  ///
  /// If [slug] is provided, the companies connection is routed to that
  /// tenant database and the users connection to `users/profiles`.
  static Future<SurrealConnection> connectWithTokens({
    required String companiesToken,
    required String usersToken,
    String? slug,
    String? url,
  }) async {
    final wsUrl = url ?? _deriveWsUrl();

    // Timeout the entire reconnection — if WebSockets hang on page reload,
    // we fall back to the login screen instead of blank-screening.
    return Future(() async {
      final companiesDb = SurrealDB(wsUrl);
      companiesDb.connect();
      await companiesDb.wait();
      await companiesDb.authenticate(companiesToken);

      final usersDb = SurrealDB(wsUrl);
      usersDb.connect();
      await usersDb.wait();
      await usersDb.authenticate(usersToken);

      // Route to profiles so downstream queries work.
      await usersDb.use('users', 'profiles');

      final conn = SurrealConnection._(companies: companiesDb, users: usersDb);

      // Re-route to the tenant database if slug was persisted.
      if (slug != null) {
        await conn.routeToTenant(slug);
      }

      return conn;
    }).timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw TimeoutException('Session restore timed out'),
    );
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
