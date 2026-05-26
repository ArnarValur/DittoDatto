import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'user.g.dart';

/// Platform user — operators and registered consumers.
///
/// Mirrors: mercury_core/models/user.py
/// Stored in: enceladus/users (GDPR-isolated namespace)
///
/// Note: password_hash is excluded — never sent over the wire.
@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  const User({
    this.id,
    required this.vippsSub,
    required this.name,
    required this.email,
    this.phone,
    this.role = ActorRole.operator,
    this.companySlug,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String vippsSub;
  final String name;
  final String email;
  final String? phone;
  final ActorRole role;
  final String? companySlug;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
