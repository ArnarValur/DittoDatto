import 'package:surrealdb/surrealdb.dart';

/// Wraps authenticated SurrealDB connections for a business session.
///
/// Replaces BP's bespoke `SurrealConnection` class.
/// The repository layer uses [companies] for tenant CRUD queries
/// and [users] for user profile operations.
class TenantConnection {
  TenantConnection({
    required this.companies,
    required this.users,
    required this.slug,
  });

  /// Connection to `company_{slug}` DB (via `bp_portal` service user).
  final SurrealDB companies;

  /// Connection to `users/users` DB (via RECORD ACCESS `bp_auth`).
  final SurrealDB users;

  /// The active tenant slug (e.g. 'testcompany').
  final String slug;

  /// Close both connections.
  void close() {
    companies.close();
    users.close();
  }
}
