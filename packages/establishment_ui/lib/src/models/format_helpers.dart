/// Formatting helpers for service display — Norwegian locale conventions.

/// Format a price for display.
///
/// - Zero → `'Gratis'`
/// - Whole number → `'kr 450'`
/// - Fractional → `'kr 199,50'` (Norwegian comma decimal)
///
/// Currency prefix is always `kr` (Norwegian convention for NOK/SEK).
String formatPrice(double price, String currency) {
  if (price == 0) return 'Gratis';

  // Check if the price is a whole number.
  if (price == price.truncateToDouble()) {
    return 'kr ${price.toInt()}';
  }

  // Norwegian decimal: comma, always two decimal places.
  final formatted = price.toStringAsFixed(2).replaceAll('.', ',');
  return 'kr $formatted';
}

/// Format a duration in minutes for display.
///
/// - `0` → `'0 min'`
/// - `30` → `'30 min'`
/// - `60` → `'1 t'`
/// - `90` → `'1 t 30 min'`
/// - `120` → `'2 t'`
String formatDuration(int minutes) {
  if (minutes < 60) return '$minutes min';

  final hours = minutes ~/ 60;
  final remaining = minutes % 60;

  if (remaining == 0) return '$hours t';
  return '$hours t $remaining min';
}
