import 'package:json_annotation/json_annotation.dart';

/// User role in the DittoDatto platform.
@JsonEnum(valueField: 'value')
enum ActorRole {
  customer('customer'),
  business('business'),
  admin('admin'),
  superAdmin('super_admin');

  const ActorRole(this.value);
  final String value;
}

/// Company subscription tier.
@JsonEnum(valueField: 'value')
enum CompanyTier {
  free('free'),
  premium('premium');

  const CompanyTier(this.value);
  final String value;
}

/// Company onboarding progress.
@JsonEnum(valueField: 'value')
enum OnboardingStatus {
  notStarted('not_started'),
  aiSuggested('ai_suggested'),
  verified('verified'),
  complete('complete');

  const OnboardingStatus(this.value);
  final String value;
}
