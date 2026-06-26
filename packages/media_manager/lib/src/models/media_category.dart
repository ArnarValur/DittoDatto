/// Category for organizing media by purpose.
///
/// Values match the SurrealDB `category` ASSERT constraint exactly:
/// `ASSERT $value IN ['general', 'logo', 'cover', 'gallery', 'staff', 'service', 'menu']`
enum MediaCategory {
  general('general', 'Generelt'),
  logo('logo', 'Logo'),
  cover('cover', 'Omslag'),
  gallery('gallery', 'Galleri'),
  staff('staff', 'Ansatte'),
  service('service', 'Tjenester'),
  menu('menu', 'Meny');

  const MediaCategory(this.value, this.label);

  /// The value stored in SurrealDB (must match schema ASSERT).
  final String value;

  /// Norwegian display label for the UI.
  final String label;

  /// Parse from SurrealDB string value, defaulting to [general].
  static MediaCategory fromValue(String? value) {
    if (value == null) return MediaCategory.general;
    return MediaCategory.values.firstWhere(
      (c) => c.value == value,
      orElse: () => MediaCategory.general,
    );
  }
}
