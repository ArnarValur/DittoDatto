// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnabledFeatures _$EnabledFeaturesFromJson(Map<String, dynamic> json) =>
    EnabledFeatures(
      tableReservation: json['table_reservation'] as bool? ?? false,
      aiAssistance: json['ai_assistance'] as bool? ?? false,
      ticketSystem: json['ticket_system'] as bool? ?? false,
      eventSystem: json['event_system'] as bool? ?? false,
    );

Map<String, dynamic> _$EnabledFeaturesToJson(EnabledFeatures instance) =>
    <String, dynamic>{
      'table_reservation': instance.tableReservation,
      'ai_assistance': instance.aiAssistance,
      'ticket_system': instance.ticketSystem,
      'event_system': instance.eventSystem,
    };

StorePolicy _$StorePolicyFromJson(Map<String, dynamic> json) => StorePolicy(
  maxStores: (json['max_stores'] as num?)?.toInt() ?? 1,
  canCreateOwnStores: json['can_create_own_stores'] as bool? ?? false,
);

Map<String, dynamic> _$StorePolicyToJson(StorePolicy instance) =>
    <String, dynamic>{
      'max_stores': instance.maxStores,
      'can_create_own_stores': instance.canCreateOwnStores,
    };

CompanySocialLinks _$CompanySocialLinksFromJson(Map<String, dynamic> json) =>
    CompanySocialLinks(
      fb: json['fb'] as String?,
      ig: json['ig'] as String?,
      x: json['x'] as String?,
    );

Map<String, dynamic> _$CompanySocialLinksToJson(CompanySocialLinks instance) =>
    <String, dynamic>{'fb': instance.fb, 'ig': instance.ig, 'x': instance.x};

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
  id: json['id'] as String?,
  ownerId: json['owner_id'] as String,
  ownerEmail: json['owner_email'] as String?,
  name: json['name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  website: json['website'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  zip: json['zip'] as String?,
  country: json['country'] as String? ?? 'NO',
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  logoUrl: json['logo_url'] as String?,
  tier:
      $enumDecodeNullable(_$CompanyTierEnumMap, json['tier']) ??
      CompanyTier.free,
  onboardingStatus:
      $enumDecodeNullable(
        _$OnboardingStatusEnumMap,
        json['onboarding_status'],
      ) ??
      OnboardingStatus.notStarted,
  enabledFeatures: json['enabled_features'] == null
      ? const EnabledFeatures()
      : EnabledFeatures.fromJson(
          json['enabled_features'] as Map<String, dynamic>,
        ),
  storePolicy: json['store_policy'] == null
      ? const StorePolicy()
      : StorePolicy.fromJson(json['store_policy'] as Map<String, dynamic>),
  socialLinks: json['social_links'] == null
      ? null
      : CompanySocialLinks.fromJson(
          json['social_links'] as Map<String, dynamic>,
        ),
  dbSlug: json['db_slug'] as String? ?? '',
  managerIds: (json['manager_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  memberIds: (json['member_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'id': instance.id,
  'owner_id': instance.ownerId,
  'owner_email': instance.ownerEmail,
  'name': instance.name,
  'slug': instance.slug,
  'description': instance.description,
  'website': instance.website,
  'address': instance.address,
  'city': instance.city,
  'zip': instance.zip,
  'country': instance.country,
  'email': instance.email,
  'phone': instance.phone,
  'logo_url': instance.logoUrl,
  'tier': instance.tier,
  'onboarding_status': instance.onboardingStatus,
  'enabled_features': instance.enabledFeatures,
  'store_policy': instance.storePolicy,
  'social_links': instance.socialLinks,
  'db_slug': instance.dbSlug,
  'manager_ids': instance.managerIds,
  'member_ids': instance.memberIds,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
};

const _$CompanyTierEnumMap = {
  CompanyTier.free: 'free',
  CompanyTier.premium: 'premium',
};

const _$OnboardingStatusEnumMap = {
  OnboardingStatus.notStarted: 'not_started',
  OnboardingStatus.aiSuggested: 'ai_suggested',
  OnboardingStatus.verified: 'verified',
  OnboardingStatus.complete: 'complete',
};
