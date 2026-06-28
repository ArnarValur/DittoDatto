/// Model for a Norwegian address result from Kartverket API.
///
/// Maps the JSON response from `ws.geonorge.no/adresser/v1/sok`.
class NorwegianAddress {
  const NorwegianAddress({
    required this.streetAddress,
    required this.postalCode,
    required this.city,
    this.municipality,
    this.latitude,
    this.longitude,
  });

  /// Street name and number (e.g. "Skolegata 9").
  final String streetAddress;

  /// Norwegian postal code (e.g. "3046").
  final String postalCode;

  /// City / post office name (e.g. "DRAMMEN").
  final String city;

  /// Municipality name (e.g. "DRAMMEN").
  final String? municipality;

  /// Latitude from Kartverket response (representasjonspunkt.lat).
  final double? latitude;

  /// Longitude from Kartverket response (representasjonspunkt.lon).
  final double? longitude;

  /// Display string for autocomplete dropdown.
  String get displayText => '$streetAddress, $postalCode $city';

  /// Parse from Kartverket JSON response item.
  factory NorwegianAddress.fromJson(Map<String, dynamic> json) {
    final repPunkt = json['representasjonspunkt'] as Map<String, dynamic>?;
    return NorwegianAddress(
      streetAddress: json['adressetekst'] as String? ?? '',
      postalCode: json['postnummer'] as String? ?? '',
      city: json['poststed'] as String? ?? '',
      municipality: json['kommunenavn'] as String?,
      latitude: repPunkt?['lat'] as double?,
      longitude: repPunkt?['lon'] as double?,
    );
  }

  @override
  String toString() => displayText;
}
