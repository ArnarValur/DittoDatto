import 'package:mercury_client/mercury_client.dart';

import 'surreal_connection.dart';

/// Authenticates admin users against SurrealDB namespace-level users.
///
/// Login flow:
/// 1. Extract username from email (e.g. `arnar@dittodatto.no` → `arnar`)
/// 2. Connect two WebSocket clients to SurrealDB
/// 3. Signin as namespace user on both `companies` and `users` namespaces
/// 4. If both succeed → [Authenticated]; if either fails → [Unauthenticated]
///
/// Session is page-lifetime on web (no persistence). Page reload requires
/// re-login. Acceptable for a 2-user private tool.
class SurrealAuthService implements AuthService {
  SurrealAuthService({this.wsUrl});

  /// Optional explicit WebSocket URL. If null, derived from page origin.
  final String? wsUrl;

  /// The active connection, available after successful login.
  SurrealConnection? _connection;

  /// Expose the active connection for the repository layer.
  SurrealConnection? get connection => _connection;

  @override
  Future<AuthState> login(String email, String password) async {
    try {
      // Extract username from email prefix.
      final username = email.split('@').first;

      final conn = await SurrealConnection.connect(
        user: username,
        pass: password,
        url: wsUrl,
      );

      _connection = conn;

      // Use the token from signin (we don't actually need it for
      // WebSocket sessions, but AuthState requires it).
      return Authenticated(
        accessToken: 'surreal-ws-session',
        email: email,
      );
    } on Exception {
      // Per PRD: no error feedback. Return unauthenticated silently.
      return const Unauthenticated();
    }
  }

  @override
  Future<AuthState> logout() async {
    _connection?.close();
    _connection = null;
    return const Unauthenticated();
  }

  @override
  Future<AuthState> tryRestore() async {
    // No persistence on web — always unauthenticated on cold start.
    return const Unauthenticated();
  }
}
