/// Favorite model — a User's saved Establishment (or Staff, deferred).
///
/// Maps to the `favorite` table in `users/users` namespace.
/// See `schemas/users.surql` L88–96.
class Favorite {
  const Favorite({
    this.id,
    required this.user,
    required this.targetId,
    this.targetType = 'store',
    this.addedAt,
  });

  /// SurrealDB record ID (e.g. `favorite:abc123`). Null before creation.
  final String? id;

  /// Record link to the user who favorited (e.g. `user:xyz`).
  final String user;

  /// String reference to the target entity (cross-namespace, not a record link).
  /// For establishments: the establishment record ID string.
  final String targetId;

  /// Type of target: `'store'` (establishment) or `'person'` (staff, deferred).
  final String targetType;

  /// When the favorite was added. Set by SurrealDB via `VALUE $value OR time::now()`.
  final DateTime? addedAt;

  /// Deserialize from SurrealDB record format.
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: _extractId(json['id']),
      user: _extractId(json['user']) ?? '',
      targetId: json['target_id'] as String? ?? '',
      targetType: json['target_type'] as String? ?? 'store',
      addedAt: json['added_at'] != null
          ? DateTime.tryParse(json['added_at'] as String)
          : null,
    );
  }

  /// Serialize to SurrealDB-compatible map for CREATE.
  ///
  /// Omits `id` (auto-generated) and `added_at` (server-set).
  Map<String, dynamic> toJson() => {
        'target_id': targetId,
        'target_type': targetType,
      };

  /// Extract a string ID from SurrealDB's various ID formats.
  static String? _extractId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map && value.containsKey('tb') && value.containsKey('id')) {
      return '${value['tb']}:${value['id']}';
    }
    return value.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Favorite &&
          runtimeType == other.runtimeType &&
          targetId == other.targetId &&
          targetType == other.targetType;

  @override
  int get hashCode => Object.hash(targetId, targetType);

  @override
  String toString() =>
      'Favorite(id: $id, user: $user, targetId: $targetId, '
      'targetType: $targetType, addedAt: $addedAt)';
}
