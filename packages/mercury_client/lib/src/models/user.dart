import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'user.g.dart';

/// A user profile from the `users/users` namespace.
@JsonSerializable()
class User {
  const User({
    required this.id,
    this.vippsSub,
    this.username,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.companySlug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final String id;

  @JsonKey(name: 'vipps_sub')
  final String? vippsSub;

  final String? username;

  final String name;
  final String email;
  final String? phone;
  final ActorRole role;

  @JsonKey(name: 'company_slug')
  final String? companySlug;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? vippsSub,
    String? username,
    String? name,
    String? email,
    String? phone,
    ActorRole? role,
    String? companySlug,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      vippsSub: vippsSub ?? this.vippsSub,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      companySlug: companySlug ?? this.companySlug,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
