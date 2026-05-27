import 'package:json_annotation/json_annotation.dart';

part 'admin_stats.g.dart';

/// Dashboard statistics returned by the admin stats endpoint.
@JsonSerializable()
class AdminStats {
  const AdminStats({
    required this.userCount,
    required this.companyCount,
    required this.categoryCount,
    required this.engineHealthy,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsFromJson(json);

  /// Total number of registered users.
  @JsonKey(name: 'user_count')
  final int userCount;

  /// Total number of registered companies.
  @JsonKey(name: 'company_count')
  final int companyCount;

  /// Total number of categories.
  @JsonKey(name: 'category_count')
  final int categoryCount;

  /// Whether MercuryEngine is reporting healthy.
  @JsonKey(name: 'engine_healthy')
  final bool engineHealthy;

  Map<String, dynamic> toJson() => _$AdminStatsToJson(this);
}
