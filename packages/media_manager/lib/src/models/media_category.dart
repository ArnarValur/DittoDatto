/// Category for organizing media by purpose.
///
/// Values match the SurrealDB `category` ASSERT constraint exactly:
/// `ASSERT $value IN ['general', 'logo', 'cover', 'gallery', 'staff', 'service', 'menu']`
///
/// Each category carries a list of commonly associated file extensions
/// for auto-detection during upload (inspired by SwanFlutter's enhanced
/// enum pattern).
enum MediaCategory {
  general('general', 'Generelt', ['jpg', 'jpeg', 'png', 'webp', 'svg']),
  logo('logo', 'Logo', ['svg', 'png']),
  cover('cover', 'Omslag', ['jpg', 'jpeg', 'webp']),
  gallery('gallery', 'Galleri', ['jpg', 'jpeg', 'png', 'webp']),
  staff('staff', 'Ansatte', ['jpg', 'jpeg', 'png']),
  service('service', 'Tjenester', ['jpg', 'jpeg', 'png', 'webp']),
  menu('menu', 'Meny', ['jpg', 'jpeg', 'png', 'webp', 'pdf']);

  const MediaCategory(this.value, this.label, this.typicalExtensions);

  /// The value stored in SurrealDB (must match schema ASSERT).
  final String value;

  /// Norwegian display label for the UI.
  final String label;

  /// File extensions commonly associated with this category.
  /// Used for auto-suggestion during upload, not for enforcement.
  final List<String> typicalExtensions;

  /// Parse from SurrealDB string value, defaulting to [general].
  static MediaCategory fromValue(String? value) {
    if (value == null) return MediaCategory.general;
    return MediaCategory.values.firstWhere(
      (c) => c.value == value,
      orElse: () => MediaCategory.general,
    );
  }

  /// Suggest a category based on file extension.
  ///
  /// Returns [general] if no specific category matches.
  /// This is a hint — the user can always override.
  static MediaCategory fromExtension(String? extension) {
    if (extension == null) return MediaCategory.general;
    final ext = extension.toLowerCase().replaceAll('.', '');

    // Check specific categories first (logo/cover are more specific
    // than gallery/general, so they win on overlapping extensions).
    if (logo.typicalExtensions.contains(ext) && ext == 'svg') {
      return MediaCategory.logo;
    }
    if (menu.typicalExtensions.contains(ext) && ext == 'pdf') {
      return MediaCategory.menu;
    }

    // Default to general — category is user-selected anyway.
    return MediaCategory.general;
  }

  /// All file extensions accepted by the media manager.
  static const allExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'svg',
    'pdf',
  ];
}
