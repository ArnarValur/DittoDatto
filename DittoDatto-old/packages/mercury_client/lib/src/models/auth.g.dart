// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };

AdminStats _$AdminStatsFromJson(Map<String, dynamic> json) => AdminStats(
  userCount: (json['user_count'] as num).toInt(),
  companyCount: (json['company_count'] as num).toInt(),
  categoryCount: (json['category_count'] as num).toInt(),
  engineHealthy: json['engine_healthy'] as bool,
);

Map<String, dynamic> _$AdminStatsToJson(AdminStats instance) =>
    <String, dynamic>{
      'user_count': instance.userCount,
      'company_count': instance.companyCount,
      'category_count': instance.categoryCount,
      'engine_healthy': instance.engineHealthy,
    };
