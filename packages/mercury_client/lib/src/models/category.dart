import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

/// A service category used to organize companies and offerings.
@JsonSerializable()
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.count = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final int count;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
