// Enum types mirroring MercuryEngine Pydantic models.
//
// Source of truth: services/mercury-engine/src/mercury_core/models/

import 'package:json_annotation/json_annotation.dart';

/// Authenticated actor types in the platform.
///
/// Matches users.surql assertion:
///     ASSERT $value IN ['customer', 'business', 'admin', 'super_admin']
enum ActorRole {
  @JsonValue('business')
  operator('business'),
  @JsonValue('agent')
  agent('agent'),
  @JsonValue('admin')
  admin('admin'),
  @JsonValue('super_admin')
  superAdmin('super_admin');

  const ActorRole(this.value);
  final String value;

  static ActorRole fromJson(String json) =>
      values.firstWhere((e) => e.value == json);

  String toJson() => value;
}

/// Company subscription tier.
enum CompanyTier {
  @JsonValue('free')
  free('free'),
  @JsonValue('premium')
  premium('premium');

  const CompanyTier(this.value);
  final String value;

  static CompanyTier fromJson(String json) =>
      values.firstWhere((e) => e.value == json);

  String toJson() => value;
}

/// Company onboarding progress (Reverse Conductor pattern).
enum OnboardingStatus {
  @JsonValue('not_started')
  notStarted('not_started'),
  @JsonValue('ai_suggested')
  aiSuggested('ai_suggested'),
  @JsonValue('verified')
  verified('verified'),
  @JsonValue('complete')
  complete('complete');

  const OnboardingStatus(this.value);
  final String value;

  static OnboardingStatus fromJson(String json) =>
      values.firstWhere((e) => e.value == json);

  String toJson() => value;
}
