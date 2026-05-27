import 'package:http/http.dart' as http;

/// Base exception for MercuryEngine API errors.
///
/// Wraps HTTP response errors with status code, response body,
/// and the original request URI for debugging.
class MercuryApiException implements Exception {
  const MercuryApiException({
    required this.statusCode,
    required this.body,
    required this.uri,
  });

  /// HTTP status code returned by the server.
  final int statusCode;

  /// Response body (may contain error details as JSON).
  final String body;

  /// The request URI that produced this error.
  final Uri uri;

  @override
  String toString() => 'MercuryApiException($statusCode): $body [$uri]';
}

/// Exception for network/connection errors.
///
/// Wraps [http.ClientException] — platform-agnostic (no `dart:io`).
class MercuryConnectionException implements Exception {
  const MercuryConnectionException({
    required this.message,
    this.uri,
  });

  final String message;
  final Uri? uri;

  @override
  String toString() => 'MercuryConnectionException: $message';
}
