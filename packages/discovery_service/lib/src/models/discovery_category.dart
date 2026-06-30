/// A platform-wide service category from `companies/discovery.category`.
///
/// Admin-managed, displayed as chips on the Home screen for filtering.
class DiscoveryCategory {
  const DiscoveryCategory({
    this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.count = 0,
  });

  /// SurrealDB record ID. Null on create.
  final String? id;

  /// Display name (e.g. "Skjønnhet", "Restaurant").
  final String name;

  /// URL-safe slug (e.g. "skjonnhet", "restaurant").
  final String slug;

  /// Optional description.
  final String? description;

  /// Material icon name (e.g. "content_cut", "restaurant").
  final String? icon;

  /// Number of active listings in this category.
  final int count;

  /// Parse from SurrealDB JSON response.
  factory DiscoveryCategory.fromJson(Map<String, dynamic> json) {
    return DiscoveryCategory(
      id: json['id'] as String?,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      count: json['count'] as int? ?? 0,
    );
  }

  /// Serialize to JSON for SurrealDB CREATE/UPDATE.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'slug': slug,
      'count': count,
    };
    if (description != null) json['description'] = description;
    if (icon != null) json['icon'] = icon;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoveryCategory &&
          runtimeType == other.runtimeType &&
          slug == other.slug &&
          name == other.name;

  @override
  int get hashCode => Object.hash(slug, name);

  @override
  String toString() => 'DiscoveryCategory($name, $slug)';
}
