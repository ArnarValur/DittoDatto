import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/norwegian_address.dart';

/// Norwegian address autocomplete service powered by Kartverket (Geonorge).
///
/// TODO: Norway-only for now. Explore Swedish address support in the near
/// future — candidates: Lantmäteriet (requires API key) or Nominatim fallback
/// for non-NO countries.
///
/// Uses the official Norwegian Mapping Authority API:
/// `https://ws.geonorge.no/adresser/v1/sok`
///
/// Free, no API key, no authentication required.
/// Also returns coordinates via `representasjonspunkt` — so in many cases
/// we get lat/lng without needing a separate Nominatim geocode call.
class KartverketService {
  KartverketService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static const _baseUrl = 'https://ws.geonorge.no/adresser/v1/sok';

  /// Minimum query length before sending a request.
  static const minQueryLength = 3;

  /// Maximum results per request.
  static const maxResults = 5;

  /// Search for Norwegian addresses matching [query].
  ///
  /// Returns an empty list if [query] is shorter than [minQueryLength]
  /// or if the API call fails.
  Future<List<NorwegianAddress>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < minQueryLength) return [];

    final url = Uri.parse(
      '$_baseUrl?sok=${Uri.encodeComponent(trimmed)}&treffPerSide=$maxResults',
    );

    try {
      final response = await _client.get(url);
      if (response.statusCode != 200) return [];

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final addresses = json['adresser'] as List<dynamic>? ?? [];

      return addresses
          .whereType<Map<String, dynamic>>()
          .map(NorwegianAddress.fromJson)
          .toList();
    } catch (_) {
      // Fail silently — return empty list on network errors.
      return [];
    }
  }

  /// Dispose the HTTP client if we own it.
  void dispose() {
    _client.close();
  }
}
