import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'company.g.dart';

/// Social media and website links for a company.
@JsonSerializable()
class CompanySocialLinks {
  const CompanySocialLinks({this.website, this.facebook, this.instagram});

  factory CompanySocialLinks.fromJson(Map<String, dynamic> json) =>
      _$CompanySocialLinksFromJson(json);

  final String? website;
  final String? facebook;
  final String? instagram;

  Map<String, dynamic> toJson() => _$CompanySocialLinksToJson(this);
}

/// Cancellation and no-show policies for a company's store.
@JsonSerializable()
class StorePolicy {
  const StorePolicy({
    this.cancellationHours = 24,
    this.noShowFeePercent = 0,
  });

  factory StorePolicy.fromJson(Map<String, dynamic> json) =>
      _$StorePolicyFromJson(json);

  @JsonKey(name: 'cancellation_hours')
  final int cancellationHours;

  @JsonKey(name: 'no_show_fee_percent')
  final int noShowFeePercent;

  Map<String, dynamic> toJson() => _$StorePolicyToJson(this);
}

/// Feature flags controlling what modules a company has access to.
@JsonSerializable()
class EnabledFeatures {
  const EnabledFeatures({
    this.bookings = true,
    this.products = false,
    this.analytics = false,
  });

  factory EnabledFeatures.fromJson(Map<String, dynamic> json) =>
      _$EnabledFeaturesFromJson(json);

  final bool bookings;
  final bool products;
  final bool analytics;

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

  @JsonKey(name: 'postal_code')
  final String? postalCode;

  final String country;
  final CompanyTier tier;

  @JsonKey(name: 'onboarding_status')
  final OnboardingStatus onboardingStatus;

  @JsonKey(name: 'owner_email')
  final String? ownerEmail;

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
