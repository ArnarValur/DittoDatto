/// Generates a URL-safe slug from a [name].
///
/// Converts to lowercase, replaces spaces and special characters with hyphens,
/// removes consecutive hyphens, and trims leading/trailing hyphens.
///
/// Example: "Frisør & Barbershop" → "frisor-barbershop"
String generateSlug(String name) {
  return name
      .toLowerCase()
      .replaceAll(RegExp(r'[æ]'), 'ae')
      .replaceAll(RegExp(r'[ø]'), 'o')
      .replaceAll(RegExp(r'[å]'), 'a')
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
      .replaceAll(RegExp(r'[\s]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}
