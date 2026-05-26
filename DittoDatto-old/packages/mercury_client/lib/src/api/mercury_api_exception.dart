/// Exception thrown by [MercuryApi] when the engine returns an error.
///
/// Maps the engine's JSON error format:
/// ```json
/// {"error": "...", "message": "...", "details": ...}
/// ```
class MercuryApiException implements Exception {
  const MercuryApiException({
    required this.statusCode,
    required this.error,
    required this.message,
    this.details,
  });

  final int statusCode;
  final String error;
  final String message;
  final dynamic details;

  /// Whether this is an authentication error (token expired/invalid).
  bool get isUnauthorized => statusCode == 401;

  /// Whether this is a permissions error.
  bool get isForbidden => statusCode == 403;

  /// Whether the requested resource was not found.
  bool get isNotFound => statusCode == 404;

  @override
  String toString() => 'MercuryApiException($statusCode): $error — $message';
}

/// Exception thrown when the engine is unreachable.
class MercuryConnectionException implements Exception {
  const MercuryConnectionException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'MercuryConnectionException: $message';
}
