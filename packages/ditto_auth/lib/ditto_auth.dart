/// DittoDatto shared authentication package.
///
/// Provides SurrealDB-native auth flows (consumer + business),
/// token lifecycle, tenant routing, and session persistence
/// behind a swappable [AuthBackend] interface.
library;

export 'src/auth_backend.dart';
export 'src/auth_result.dart';
export 'src/ditto_auth.dart';
export 'src/exceptions.dart';
export 'src/surreal_auth_backend.dart';
export 'src/tenant_connection.dart';
export 'src/token_store.dart';
