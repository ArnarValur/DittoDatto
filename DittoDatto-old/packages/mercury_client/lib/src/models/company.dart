import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'company.g.dart';

/// Feature flags for a company.
///
/// Transitional SaaS scaffolding — will become Datto-mediated in v1.5.
@JsonSerializable(fieldRename: FieldRename.snake)
class EnabledFeatures {
  const EnabledFeatures({
    this.tableReservation = false,
    this.aiAssistance = false,
    this.ticketSystem = false,
    this.eventSystem = false,
  });

  final bool tableReservation;
  final bool aiAssistance;
  final bool ticketSystem;
  final bool eventSystem;

  factory EnabledFeatures.fromJson(Map<String, dynamic> json) =>
      _$EnabledFeaturesFromJson(json);
  Map<String, dynamic> toJson() => _$EnabledFeaturesToJson(this);
}

/// Company-level store creation policy.
@JsonSerializable(fieldRename: FieldRename.snake)
class StorePolicy {
  const StorePolicy({
    this.maxStores = 1,
    this.canCreateOwnStores = false,
  });

  final int maxStores;
  final bool canCreateOwnStores;

  factory StorePolicy.fromJson(Map<String, dynamic> json) =>
      _$StorePolicyFromJson(json);
  Map<String, dynamic> toJson() => _$StorePolicyToJson(this);
}

/// Social media links for a company.
@JsonSerializable(fieldRename: FieldRename.snake)
class CompanySocialLinks {
  const CompanySocialLinks({this.fb, this.ig, this.x});

  final String? fb;
  final String? ig;
  final String? x;

  factory CompanySocialLinks.fromJson(Map<String, dynamic> json) =>
      _$CompanySocialLinksFromJson(json);
  Map<String, dynamic> toJson() => _$CompanySocialLinksToJson(this);
}

/// Platform company registry record.
///
/// Mirrors: mercury_core/models/company.py
/// Stored in: titan/platform.company
@JsonSerializable(fieldRename: FieldRename.snake)
class Company {
  const Company({
    this.id,
    required this.ownerId,
    this.ownerEmail,
    required this.name,
    required this.slug,
    this.description,
    this.website,
    this.address,
    this.city,
    this.zip,
    this.country = 'NO',
    this.email,
    this.phone,
    this.logoUrl,
    this.tier = CompanyTier.free,
    this.onboardingStatus = OnboardingStatus.notStarted,
    this.enabledFeatures = const EnabledFeatures(),
    this.storePolicy = const StorePolicy(),
    this.socialLinks,
    this.dbSlug = '',
    this.managerIds,
    this.memberIds,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String? id;
  final String ownerId;
  final String? ownerEmail;
  final String name;
  final String slug;
  final String? description;
  final String? website;

  // Address
  final String? address;
  final String? city;
  final String? zip;
  final String country;

  // Contact
  final String? email;
  final String? phone;
  final String? logoUrl;

  // Tier & onboarding
  final CompanyTier tier;
  final OnboardingStatus onboardingStatus;

  // Feature flags & policies
  final EnabledFeatures enabledFeatures;
  final StorePolicy storePolicy;
  final CompanySocialLinks? socialLinks;

  // Database reference
  final String dbSlug;

  // Manager/member references
  final List<String>? managerIds;
  final List<String>? memberIds;

  // Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
