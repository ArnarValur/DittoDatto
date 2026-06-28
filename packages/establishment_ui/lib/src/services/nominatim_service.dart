import 'dart:convert';

import 'package:http/http.dart' as http;

/// Forward geocoding service powered by OpenStreetMap Nominatim.
///
/// Converts a human-readable address string into latitude/longitude
/// coordinates. Used as a fallback when Kartverket doesn't provide
/// coordinates (rare) or for non-Norwegian addresses.
///
/// Free, no API key required.
/// Usage policy: max 1 req/sec, meaningful User-Agent header.
/// See: https://operations.osmfoundation.org/policies/nominatim/
class NominatimService {
  NominatimService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static const _baseUrl = 'https://nominatim.openstreetmap.org/search';
  static const _userAgent = 'DittoDatto/1.0 (dittodatto.no)';

  /// Geocode an address string into lat/lng coordinates.
  ///
  /// Returns `null` if the address cannot be geocoded or the API call fails.
  /// The [countryCode] parameter biases results (default: 'no' for Norway).
  Future<({double latitude, double longitude})?> geocode(
    String address, {
    String countryCode = 'no',
  }) async {
    final trimmed = address.trim();
    if (trimmed.isEmpty) return null;

    final url = Uri.parse(
      '$_baseUrl?q=${Uri.encodeComponent(trimmed)}'
      '&format=json&limit=1&countrycodes=$countryCode',
    );

    try {
      final response = await _client.get(
        url,
        headers: {'User-Agent': _userAgent},
      );
      if (response.statusCode != 200) return null;

      final results = jsonDecode(response.body) as List<dynamic>;
      if (results.isEmpty) return null;

      final first = results.first as Map<String, dynamic>;
      final lat = double.tryParse(first['lat']?.toString() ?? '');
      final lng = double.tryParse(first['lon']?.toString() ?? '');

      if (lat == null || lng == null) return null;
      return (latitude: lat, longitude: lng);
    } catch (_) {
      return null;
    }
  }

  /// Dispose the HTTP client.
  void dispose() {
    _client.close();
  }
}
