import 'package:surrealdb/surrealdb.dart';

/// Abstraction over the auth transport layer.
///
/// Today: direct SurrealDB WebSocket calls ([SurrealAuthBackend]).
/// Tomorrow: HTTP proxy to a backend intermediary (when Vipps OIDC
/// or production-grade credential delivery requires server-side logic).
abstract class AuthBackend {
  /// Phase 1: Authenticate user identity via RECORD ACCESS.
  ///
  /// Validates [email] + [password] against the user's `password_hash`
  /// using the specified [accessMethod] ('bp_auth' or 'consumer_auth').
  ///
  /// Returns raw user auth result with connection, token, and profile.
  Future<UserAuthResult> authenticateUser({
    required String email,
    required String password,
    required String accessMethod,
  });

  /// Phase 2: Connect to tenant DB with service credentials.
  ///
  /// Uses the `bp_portal` DB-level service user. Only needed for
  /// business auth flow (consumer auth doesn't have tenant routing).
  Future<TenantAuthResult> connectTenant({
    required SurrealDB usersDb,
    required String usersToken,
    required String slug,
  });

  /// Restore a session using previously stored tokens.
  ///
  /// Returns the restored connections, or throws [SessionExpired]
  /// if tokens are invalid/expired.
  Future<RestoredSession> restoreSession({
    required String usersToken,
    String? tenantToken,
    String? tenantSlug,
  });

  /// Close all active connections.
  Future<void> disconnect();
}

/// Raw result from Phase 1 user authentication.
class UserAuthResult {
  const UserAuthResult({
    required this.usersDb,
    required this.usersToken,
    required this.profile,
  });

  /// Authenticated connection to users/users.
  final SurrealDB usersDb;

  /// JWT token from RECORD ACCESS signin.
  final String usersToken;

  /// User profile map from `SELECT ... FROM $auth`.
  final Map<String, dynamic> profile;
}

/// Raw result from Phase 2 tenant connection.
class TenantAuthResult {
  const TenantAuthResult({
    required this.companiesDb,
    required this.companiesToken,
  });

  /// Authenticated connection to company_{slug}.
  final SurrealDB companiesDb;

  /// JWT token from bp_portal signin.
  final String companiesToken;
}

/// Restored session with re-authenticated connections.
class RestoredSession {
  const RestoredSession({
    required this.usersDb,
    this.companiesDb,
    this.slug,
  });

  /// Restored users/users connection.
  final SurrealDB usersDb;

  /// Restored company DB connection (null for consumer sessions).
  final SurrealDB? companiesDb;

  /// Tenant slug (null for consumer sessions).
  final String? slug;
}
