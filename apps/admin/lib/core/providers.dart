import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../features/auth/auth_provider.dart';
import 'surreal_admin_repository.dart';
import 'surreal_auth_service.dart';

/// Provider for the company blueprint SQL.
///
/// Loads `schemas/company-blueprint.surql` from Flutter assets (bundled at build time).
final blueprintSqlProvider = FutureProvider<String>((ref) async {
  return rootBundle.loadString('assets/company-blueprint.surql');
});

/// Default password for the `bp_portal` database user on new company databases.
///
/// TODO(arnar): Move to secure configuration / environment variable.
const _defaultBpPortalPassword = 'test-portal-pass';

/// Provider for the admin repository.
///
/// Returns [SurrealAdminRepository] wired to the authenticated SurrealDB connection.
/// Includes blueprint SQL for auto-provisioning company databases on creation.
final adminRepositoryProvider = Provider<AdminRepository>((ref) {

  // Watch authProvider to reactively update when authentication state changes.
  final authAsync = ref.watch(authProvider);
  final authState = authAsync.value;

  if (authState is Authenticated) {
    final authService = ref.read(authServiceProvider);
    if (authService is SurrealAuthService) {
      final connection = authService.connection;
      if (connection != null) {
        // Load blueprint SQL if available (non-blocking — may be null on first frame).
        final blueprintAsync = ref.watch(blueprintSqlProvider);
        final blueprintSql = blueprintAsync.value;

        return SurrealAdminRepository(
          connection: connection,
          blueprintSql: blueprintSql,
          bpPortalPassword: blueprintSql != null ? _defaultBpPortalPassword : null,
        );
      }
    }
  }

  throw StateError('SurrealDB connection not established. Authenticate first.');
});
