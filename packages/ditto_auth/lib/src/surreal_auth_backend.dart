import 'dart:async';

import 'package:surrealdb/surrealdb.dart';

import 'auth_backend.dart';
import 'exceptions.dart';

/// Direct SurrealDB WebSocket implementation of [AuthBackend].
///
/// Performs the same two-phase auth that BP's SurrealConnection did,
/// now behind the [AuthBackend] interface for swappability.
class SurrealAuthBackend implements AuthBackend {
  SurrealAuthBackend({
    this.wsUrl,
    required this.serviceUser,
    required this.servicePass,
  });

  /// WebSocket URL. If null, derived from the browser's page origin.
  final String? wsUrl;

  /// DB-level service user name (typically 'bp_portal').
  final String serviceUser;

  /// DB-level service user password.
  final String servicePass;

  /// Roles permitted to access the Business Portal.
  static const allowedBusinessRoles = {'business', 'admin', 'super_admin'};

  @override
  Future<UserAuthResult> authenticateUser({
    required String email,
    required String password,
    required String accessMethod,
  }) async {
    final wsEndpoint = wsUrl ?? deriveWsUrl();

    final usersDb = SurrealDB(wsEndpoint);
    usersDb.connect();
    await usersDb.wait();

    try {
      // RECORD ACCESS signin — validates against password_hash in user record.
      final usersToken = await usersDb.signin(
        namespace: 'users',
        database: 'users',
        access: accessMethod,
        extra: {
          'email': email,
          'pass': password,
        },
      );

      // Query the authenticated user's profile.
      final profileResult = await usersDb.query(
        r'SELECT name, role, company_slug, company_name FROM $auth',
      );

      final profile = extractFirstRow(profileResult);
      if (profile == null) {
        usersDb.close();
        throw const InvalidCredentials('User profile not found after signin');
      }

      return UserAuthResult(
        usersDb: usersDb,
        usersToken: usersToken,
        profile: profile,
      );
    } catch (e) {
      usersDb.close();
      if (e is DittoAuthException) rethrow;
      throw const InvalidCredentials();
    }
  }

  @override
  Future<TenantAuthResult> connectTenant({
    required SurrealDB usersDb,
    required String usersToken,
    required String slug,
  }) async {
    final wsEndpoint = wsUrl ?? deriveWsUrl();

    if (servicePass.isEmpty) {
      throw const TenantConnectionFailed(
        'BP_PORTAL_PASS not configured. '
        'Set via --dart-define=BP_PORTAL_PASS=<value>',
      );
    }

    try {
      final companiesDb = SurrealDB(wsEndpoint);
      companiesDb.connect();
      await companiesDb.wait();

      final companiesToken = await companiesDb.signin(
        user: serviceUser,
        pass: servicePass,
        namespace: 'companies',
        database: 'company_$slug',
      );

      return TenantAuthResult(
        companiesDb: companiesDb,
        companiesToken: companiesToken,
      );
    } catch (e) {
      if (e is DittoAuthException) rethrow;
      throw TenantConnectionFailed(e.toString());
    }
  }

  @override
  Future<RestoredSession> restoreSession({
    required String usersToken,
    String? tenantToken,
    String? tenantSlug,
  }) async {
    final wsEndpoint = wsUrl ?? deriveWsUrl();

    try {
      // Restore users connection.
      final usersDb = SurrealDB(wsEndpoint);
      usersDb.connect();
      await usersDb.wait();
      await usersDb.authenticate(usersToken);

      // Restore tenant connection if tokens are available.
      SurrealDB? companiesDb;
      if (tenantToken != null) {
        companiesDb = SurrealDB(wsEndpoint);
        companiesDb.connect();
        await companiesDb.wait();
        await companiesDb.authenticate(tenantToken);
      }

      return RestoredSession(
        usersDb: usersDb,
        companiesDb: companiesDb,
        slug: tenantSlug,
      );
    } catch (e) {
      throw const SessionExpired();
    }
  }

  @override
  Future<void> disconnect() async {
    // No persistent state in the backend — connections are managed by DittoAuth.
  }

  /// Derive the WebSocket URL from the browser's page origin.
  static String deriveWsUrl() {
    final base = Uri.base;
    final protocol = base.scheme == 'https' ? 'wss' : 'ws';
    final host = base.host;
    final port = base.hasPort ? ':${base.port}' : '';
    return '$protocol://$host$port/rpc';
  }

  /// Extract the first row from a SurrealDB query result.
  static Map<String, dynamic>? extractFirstRow(dynamic result) {
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
}
