import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'company.g.dart';

/// Social media and website links for a company.
@JsonSerializable()
class CompanySocialLinks {
  const CompanySocialLinks({this.website, this.fb, this.ig, this.x});

  factory CompanySocialLinks.fromJson(Map<String, dynamic> json) =>
      _$CompanySocialLinksFromJson(json);

  final String? website;
  final String? fb;
  final String? ig;
  final String? x;

  Map<String, dynamic> toJson() => _$CompanySocialLinksToJson(this);
}

/// Store policy config for a company.
@JsonSerializable()
class StorePolicy {
  const StorePolicy({
    this.maxStores = 1,
    this.canCreateOwnStores = false,
  });

  factory StorePolicy.fromJson(Map<String, dynamic> json) =>
      _$StorePolicyFromJson(json);

  @JsonKey(name: 'max_stores')
  final int maxStores;

  @JsonKey(name: 'can_create_own_stores')
  final bool canCreateOwnStores;

  Map<String, dynamic> toJson() => _$StorePolicyToJson(this);
}

/// Feature flags controlling what modules a company has access to.
@JsonSerializable()
class EnabledFeatures {
  const EnabledFeatures({
    this.tableReservation = false,
    this.aiAssistance = false,
    this.ticketSystem = false,
    this.eventSystem = false,
  });

  factory EnabledFeatures.fromJson(Map<String, dynamic> json) =>
      _$EnabledFeaturesFromJson(json);

  @JsonKey(name: 'table_reservation')
  final bool tableReservation;

  @JsonKey(name: 'ai_assistance')
  final bool aiAssistance;

  @JsonKey(name: 'ticket_system')
  final bool ticketSystem;

  @JsonKey(name: 'event_system')
  final bool eventSystem;

  Map<String, dynamic> toJson() => _$EnabledFeaturesToJson(this);
}

/// A company (business) registered on the DittoDatto platform.
@JsonSerializable()
class Company {
  const Company({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.postalCode,
    this.country = 'NO',
    required this.tier,
    required this.onboardingStatus,
    this.ownerEmail,
    required this.ownerId,
    required this.dbSlug,
    this.socialLinks = const CompanySocialLinks(),
    this.storePolicy = const StorePolicy(),
    this.enabledFeatures = const EnabledFeatures(),
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;

  @JsonKey(name: 'zip')
  final String? postalCode;

  final String country;
  final CompanyTier tier;

  @JsonKey(name: 'onboarding_status')
  final OnboardingStatus onboardingStatus;

  @JsonKey(name: 'owner_email')
  final String? ownerEmail;

  @JsonKey(name: 'owner_id')
  final String ownerId;

  @JsonKey(name: 'db_slug')
  final String dbSlug;

  @JsonKey(name: 'social_links')
  final CompanySocialLinks socialLinks;

  @JsonKey(name: 'store_policy')
  final StorePolicy storePolicy;

  @JsonKey(name: 'enabled_features')
  final EnabledFeatures enabledFeatures;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
