import 'dart:async';
import 'package:surrealdb/surrealdb.dart';

/// Manages authenticated SurrealDB WebSocket connections for the Business Portal.
///
/// **Security model (ADR-0016):**
/// - `users` connection: RECORD ACCESS auth on `users/users` database.
///   Authenticates against the `password_hash` field in the user's profile.
///   The issued token is scoped to the user's own record (`$auth`).
/// - `companies` connection: database-level system user (`bp_portal`) on
///   `company_{slug}`. This is a deployment credential (injected via
///   `--dart-define`), NOT the user's password. The user never sees it.
///
/// This ensures:
/// - Users authenticate with their OWN password (hashed in their profile)
/// - No database admin/root credentials are used for portal login
/// - Company DB access uses a service credential, not user credentials
/// - Cross-tenant isolation via per-DB system users
class SurrealConnection {
  SurrealConnection._({required this.companies, required this.users});

  /// Connection to the tenant's company database (DB-scoped).
  final SurrealDB companies;

  /// Connection to `users/users` database (RECORD ACCESS scoped).
  final SurrealDB users;

  /// The tenant slug this connection is routed to.
  String? _slug;

  /// The active tenant slug.
  String? get slug => _slug;

  /// Phase 1: Authenticate the user via RECORD ACCESS on `users/users`.
  ///
  /// The SIGNIN clause in the `bp_auth` access definition validates
  /// [username] + [password] against the `password_hash` field in the
  /// user's profile record. No system credentials involved.
  ///
  /// Returns the authenticated users connection and the user's profile.
  /// The token is scoped to the authenticated user's record (`$auth`).
  ///
  /// Throws on invalid credentials.
  static Future<({SurrealDB usersDb, String usersToken, Map<String, dynamic> profile})>
      authenticateUser({
    required String email,
    required String password,
    String? url,
  }) async {
    final wsUrl = url ?? _deriveWsUrl();

    final usersDb = SurrealDB(wsUrl);
    usersDb.connect();
    await usersDb.wait();

    // RECORD ACCESS signin — validates against password_hash in user record.
    // The access method `bp_auth` is defined on the `users/users` database.
    final usersToken = await usersDb.signin(
      namespace: 'users',
      database: 'users',
      access: 'bp_auth',
      extra: {
        'email': email,
        'pass': password,
      },
    );

    // After RECORD ACCESS signin, $auth is the authenticated user record.
    // Query the profile for role and company_slug.
    final profileResult = await usersDb.query(
      r'SELECT role, company_slug FROM $auth',
    );

    final profile = _extractFirstRow(profileResult);
    if (profile == null) {
      usersDb.close();
      throw AuthenticationException('User profile not found');
    }

    return (usersDb: usersDb, usersToken: usersToken, profile: profile);
  }

  /// Phase 2: Connect to the tenant's company database.
  ///
  /// Uses a DB-level system user (`bp_portal`) — a deployment credential
  /// injected via `--dart-define`, NOT the user's password.
  ///
  /// [usersDb] is the RECORD ACCESS-authenticated connection from Phase 1.
  /// [usersToken] is the RECORD ACCESS token for session persistence.
  /// [slug] is the tenant slug from the user's profile.
  /// [serviceUser] and [servicePass] are the `bp_portal` DB-level credentials.
  static Future<({SurrealConnection connection, String companiesToken, String usersToken})>
      connectTenant({
    required SurrealDB usersDb,
    required String usersToken,
    required String slug,
    required String serviceUser,
    required String servicePass,
    String? url,
  }) async {
    final wsUrl = url ?? _deriveWsUrl();

    // DB-level system user signin — scoped to companies/company_{slug}.
    // This is a deployment credential, not the user's password.
    final companiesDb = SurrealDB(wsUrl);
    companiesDb.connect();
    await companiesDb.wait();
    final companiesToken = await companiesDb.signin(
      user: serviceUser,
      pass: servicePass,
      namespace: 'companies',
      database: 'company_$slug',
    );

    final conn = SurrealConnection._(companies: companiesDb, users: usersDb);
    conn._slug = slug;

    return (
      connection: conn,
      companiesToken: companiesToken,
      usersToken: usersToken,
    );
  }

  /// Reconnect using previously obtained JWT tokens.
  ///
  /// [companiesToken] is a DB-scoped token for `companies/company_{slug}`.
  /// [usersToken] is a RECORD ACCESS token for `users/users`.
  static Future<SurrealConnection> connectWithTokens({
    required String companiesToken,
    required String usersToken,
    String? slug,
    String? url,
  }) async {
    final wsUrl = url ?? _deriveWsUrl();

    return Future(() async {
      final companiesDb = SurrealDB(wsUrl);
      companiesDb.connect();
      await companiesDb.wait();
      await companiesDb.authenticate(companiesToken);

      final usersDb = SurrealDB(wsUrl);
      usersDb.connect();
      await usersDb.wait();
      await usersDb.authenticate(usersToken);

      final conn = SurrealConnection._(companies: companiesDb, users: usersDb);
      if (slug != null) {
        conn._slug = slug;
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

  /// Extract the first row from a SurrealDB query result.
  static Map<String, dynamic>? _extractFirstRow(dynamic result) {
    if (result is! List || result.isEmpty) return null;

    final first = result.first;
    if (first is Map && first.containsKey('result')) {
      final inner = first['result'];
      if (inner is List && inner.isNotEmpty && inner.first is Map) {
        return Map<String, dynamic>.from(inner.first as Map);
      }
      return null;
    }

    if (first is Map) {
      return Map<String, dynamic>.from(first);
    }

    return null;
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

/// Thrown when authentication fails during the login flow.
class AuthenticationException implements Exception {
  AuthenticationException(this.message);
  final String message;

  @override
  String toString() => 'AuthenticationException: $message';
}
