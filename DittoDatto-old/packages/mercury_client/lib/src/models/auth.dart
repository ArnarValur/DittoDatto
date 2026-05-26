import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

/// JWT token response from auth endpoints.
///
/// Mirrors: mercury_core/models/auth.py → TokenResponse
@JsonSerializable(fieldRename: FieldRename.snake)
class TokenResponse {
  const TokenResponse({
    required this.accessToken,
    this.tokenType = 'bearer',
    required this.expiresIn,
  });

  final String accessToken;
  final String tokenType;
  final int expiresIn;

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}

/// Dashboard statistics response.
///
/// Mirrors: mercury_engine/routes/admin.py → AdminStats
@JsonSerializable(fieldRename: FieldRename.snake)
class AdminStats {
  const AdminStats({
    required this.userCount,
    required this.companyCount,
    required this.categoryCount,
    required this.engineHealthy,
  });

  final int userCount;
  final int companyCount;
  final int categoryCount;
  final bool engineHealthy;

  factory AdminStats.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsFromJson(json);
  Map<String, dynamic> toJson() => _$AdminStatsToJson(this);
}

/// Generic paginated response.
///
/// Mirrors: mercury_engine/routes/admin.py → PaginatedUsers/PaginatedCompanies
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  final List<T> items;
  final int total;
  final int limit;
  final int offset;

  /// Parse from JSON with a factory for the item type.
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      limit: json['limit'] as int,
      offset: json['offset'] as int,
    );
  }
}
