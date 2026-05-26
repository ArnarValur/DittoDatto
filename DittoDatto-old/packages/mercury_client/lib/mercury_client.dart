/// MercuryClient — shared API client for DittoDatto Flutter apps.
///
/// Provides:
/// - HTTP client with JWT injection ([MercuryApi])
/// - Auth service with secure token storage ([AuthService])
/// - Admin API for platform management ([AdminApi])
/// - Dart models mirroring MercuryEngine Pydantic schemas
///
/// Usage:
/// ```dart
/// import 'package:mercury_client/mercury_client.dart';
///
/// final api = MercuryApi(baseUrl: 'http://pluto.local:5002');
/// final auth = AuthService(api: api);
/// await auth.login(email: 'admin@example.com', password: '12345678');
///
/// final admin = AdminApi(api);
/// final stats = await admin.getStats();
/// ```
library;

export 'src/api/api.dart';
export 'src/auth/auth.dart';
export 'src/models/models.dart';
