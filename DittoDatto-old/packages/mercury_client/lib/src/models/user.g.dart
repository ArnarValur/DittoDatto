// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String?,
  vippsSub: json['vipps_sub'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  role:
      $enumDecodeNullable(_$ActorRoleEnumMap, json['role']) ??
      ActorRole.operator,
  companySlug: json['company_slug'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'vipps_sub': instance.vippsSub,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'role': instance.role,
  'company_slug': instance.companySlug,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$ActorRoleEnumMap = {
  ActorRole.operator: 'business',
  ActorRole.agent: 'agent',
  ActorRole.admin: 'admin',
  ActorRole.superAdmin: 'super_admin',
};
