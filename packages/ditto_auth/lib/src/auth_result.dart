import 'tenant_connection.dart';

/// Result of a successful business signin.
///
/// Contains everything a business app needs: user profile,
/// tenant connection, and the active company slug.
class BusinessAuthResult {
  const BusinessAuthResult({
    required this.email,
    required this.name,
    required this.role,
    required this.companySlug,
    required this.tenant,
  });

  /// Email of the authenticated user.
  final String email;

  /// Display name of the authenticated user.
  final String? name;

  /// Role: 'business', 'admin', or 'super_admin'.
  final String role;

  /// Company slug (e.g. 'testcompany').
  final String companySlug;

  /// Authenticated tenant connection for CRUD operations.
  final TenantConnection tenant;
}

/// Result of a successful consumer signin or signup.
///
/// Consumer auth doesn't involve tenant routing — just user identity.
class ConsumerAuthResult {
  const ConsumerAuthResult({
    required this.email,
    required this.name,
    required this.userId,
  });

  /// Email of the authenticated consumer.
  final String email;

  /// Display name.
  final String? name;

  /// SurrealDB record ID (e.g. 'user:abc123').
  final String userId;
}
