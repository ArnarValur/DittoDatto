/// DittoDatto API client.
///
/// Provides HTTP client with JWT injection, authentication service,
/// data models, and admin API layer for interacting with MercuryEngine.
library;

// API
export 'src/api/mercury_api.dart';

// Auth
export 'src/auth/auth_service.dart';
export 'src/auth/auth_state.dart';

// Exceptions
export 'src/exceptions.dart';

// Models
export 'src/models/admin_stats.dart';
export 'src/models/category.dart';
export 'src/models/company.dart';
export 'src/models/enums.dart';
export 'src/models/paginated_response.dart';
export 'src/models/token_response.dart';
export 'src/models/user.dart';

// Repository
export 'src/repository/admin_repository.dart';
