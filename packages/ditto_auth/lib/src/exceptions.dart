/// Exception hierarchy for ditto_auth failures.
///
/// Sealed class enables exhaustive pattern matching in callers.
sealed class DittoAuthException implements Exception {
  const DittoAuthException(this.message);

  /// Human-readable error description.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// User's credentials are wrong (email not found, bad password).
///
/// UI should show a generic "invalid credentials" message —
/// never reveal whether the email or password was wrong.
final class InvalidCredentials extends DittoAuthException {
  const InvalidCredentials([super.message = 'Invalid email or password']);
}

/// User authenticated but doesn't have the required role.
///
/// e.g. consumer user trying to log into Business Portal.
final class InsufficientRole extends DittoAuthException {
  const InsufficientRole(String role)
      : super('Role "$role" is not permitted for this access method');
}

/// User has no company_slug assigned — can't route to tenant.
final class NoCompanyAssigned extends DittoAuthException {
  const NoCompanyAssigned()
      : super('User has no company_slug — cannot route to tenant database');
}

/// Tenant DB connection failed (bp_portal creds wrong, DB doesn't exist).
///
/// This is a deployment/config error, not a user error.
final class TenantConnectionFailed extends DittoAuthException {
  const TenantConnectionFailed(String detail)
      : super('Tenant connection failed: $detail');
}

/// Network/WebSocket failure.
final class ConnectionFailed extends DittoAuthException {
  const ConnectionFailed(String detail)
      : super('Connection failed: $detail');
}

/// Token expired and refresh failed — user must re-authenticate.
final class SessionExpired extends DittoAuthException {
  const SessionExpired()
      : super('Session expired — please sign in again');
}
