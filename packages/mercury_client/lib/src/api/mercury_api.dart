import 'dart:convert';

import 'package:http/http.dart' as http;

import '../exceptions.dart';

/// Low-level HTTP client for MercuryEngine API.
///
/// Handles JSON serialization, JWT injection, timeouts, and
/// platform-agnostic error handling (no `dart:io` imports).
class MercuryApi {
  MercuryApi({
    required this.baseUrl,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 15),
  }) : _client = httpClient ?? http.Client();

  /// Base URL of the MercuryEngine API (e.g., `https://api.dittodatto.no`).
  final String baseUrl;

  /// HTTP timeout for all requests.
  final Duration timeout;

  final http.Client _client;

  /// Current JWT access token. Set after authentication.
  String? accessToken;

  /// Common headers for all requests.
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  /// Sends a GET request to [path] and returns the decoded JSON.
  Future<dynamic> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(timeout);
      return _handleResponse(response, uri);
    } on http.ClientException catch (e) {
      throw MercuryConnectionException(message: e.message, uri: uri);
    }
  }

  /// Sends a POST request to [path] with [body] and returns decoded JSON.
  Future<dynamic> post(String path, {Object? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await _client
          .post(uri, headers: _headers, body: jsonEncode(body))
          .timeout(timeout);
      return _handleResponse(response, uri);
    } on http.ClientException catch (e) {
      throw MercuryConnectionException(message: e.message, uri: uri);
    }
  }

  /// Sends a PUT request to [path] with [body] and returns decoded JSON.
  Future<dynamic> put(String path, {Object? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await _client
          .put(uri, headers: _headers, body: jsonEncode(body))
          .timeout(timeout);
      return _handleResponse(response, uri);
    } on http.ClientException catch (e) {
      throw MercuryConnectionException(message: e.message, uri: uri);
    }
  }

  /// Sends a DELETE request to [path] and returns decoded JSON.
  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await _client
          .delete(uri, headers: _headers)
          .timeout(timeout);
      return _handleResponse(response, uri);
    } on http.ClientException catch (e) {
      throw MercuryConnectionException(message: e.message, uri: uri);
    }
  }

  /// Decodes response body and throws [MercuryApiException] on non-2xx.
  dynamic _handleResponse(http.Response response, Uri uri) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    throw MercuryApiException(
      statusCode: response.statusCode,
      body: response.body,
      uri: uri,
    );
  }

  /// Closes the underlying HTTP client.
  void close() => _client.close();
}
