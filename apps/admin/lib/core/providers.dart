import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../features/auth/auth_provider.dart';
import 'surreal_admin_repository.dart';
import 'surreal_auth_service.dart';

/// Whether to use mock implementations (set via `--dart-define=USE_MOCKS=true`).
const _useMocks = bool.fromEnvironment('USE_MOCKS');

/// Provider for the admin repository.
///
/// In mock mode, returns [MockAdminRepository].
/// In production mode, returns [SurrealAdminRepository] wired to the
/// authenticated SurrealDB connections.
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  if (_useMocks) return MockAdminRepository();

  // Watch authProvider to reactively update when authentication state changes.
  final authState = ref.watch(authProvider);

  if (authState is Authenticated) {
    final authService = ref.read(authServiceProvider);
    if (authService is SurrealAuthService) {
      final connection = authService.connection;
      if (connection != null) {
        return SurrealAdminRepository(connection: connection);
      }
    }
  }

  throw StateError('SurrealDB connection not established. Authenticate first.');
});
