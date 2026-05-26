import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

/// Platform-wide service category (taxonomy).
///
/// Mirrors: mercury_core/models/category.py
/// Stored in: titan/discovery.category
@JsonSerializable(fieldRename: FieldRename.snake)
class Category {
  const Category({
    this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.count = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final int count;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
