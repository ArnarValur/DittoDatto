import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'mercury_api_exception.dart';

/// HTTP client for MercuryEngine with JWT header injection and error mapping.
///
/// All admin/auth endpoints flow through this client.
/// Token is set after login and injected into every subsequent request.
class MercuryApi {
  MercuryApi({required this.baseUrl, http.Client? httpClient})
    : _client = httpClient ?? http.Client();

  /// Base URL of the MercuryEngine instance (e.g. http://pluto.local:5002).
  final String baseUrl;

  final http.Client _client;

  /// JWT access token. Set after successful login.
  String? _token;

  /// Set the JWT for subsequent requests.
  void setToken(String? token) {
    _token = token;
  }

  /// Current token (for storage/debugging).
  String? get token => _token;

  /// Whether a token is currently set.
  bool get isAuthenticated => _token != null;

  // ─── HTTP Methods ─────────────────────────────────────────────────────

  /// GET request with JSON response.
  Future<dynamic> get(String path, {Map<String, String>? queryParams}) async {
    final uri = _buildUri(path, queryParams);
    final response = await _send('GET', uri);
    return _parseResponse(response);
  }

  /// POST request with JSON body and response.
  Future<dynamic> post(String path, {Object? body}) async {
    final uri = _buildUri(path);
    final response = await _send('POST', uri, body: body);
    return _parseResponse(response);
  }

  /// PUT request with JSON body and response.
  Future<dynamic> put(String path, {Object? body}) async {
    final uri = _buildUri(path);
    final response = await _send('PUT', uri, body: body);
    return _parseResponse(response);
  }

  /// DELETE request.
  Future<void> delete(String path) async {
    final uri = _buildUri(path);
    final response = await _send('DELETE', uri);
    if (response.statusCode >= 400) {
      _throwApiException(response);
    }
  }

  // ─── Internals ────────────────────────────────────────────────────────

  Uri _buildUri(String path, [Map<String, String>? queryParams]) {
    final url = '$baseUrl$path';
    final uri = Uri.parse(url);
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<http.Response> _send(
    String method,
    Uri uri, {
    Object? body,
  }) async {
    try {
      final request = http.Request(method, uri);
      request.headers.addAll(_headers);
      if (body != null) {
        request.body = jsonEncode(body);
      }

      final streamedResponse = await _client.send(request).timeout(
        const Duration(seconds: 15),
      );
      return await http.Response.fromStream(streamedResponse);
    } on SocketException catch (e) {
      throw MercuryConnectionException(
        'Cannot reach MercuryEngine at $baseUrl',
        e,
      );
    } on http.ClientException catch (e) {
      throw MercuryConnectionException(
        'Connection error: ${e.message}',
        e,
      );
    }
  }

  dynamic _parseResponse(http.Response response) {
    if (response.statusCode >= 400) {
      _throwApiException(response);
    }

    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  Never _throwApiException(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw MercuryApiException(
        statusCode: response.statusCode,
        error: body['error'] as String? ?? 'unknown',
        message: body['message'] as String? ?? response.reasonPhrase ?? '',
        details: body['details'],
      );
    } on FormatException {
      throw MercuryApiException(
        statusCode: response.statusCode,
        error: 'unknown',
        message: response.reasonPhrase ?? 'Unknown error',
      );
    }
  }

  /// Dispose the HTTP client.
  void dispose() {
    _client.close();
  }
}
