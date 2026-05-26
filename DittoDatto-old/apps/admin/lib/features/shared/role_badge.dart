import 'package:flutter/material.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../theme/app_colors.dart';

/// Colored badge for user roles.
class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final ActorRole role;

  Color get _color => switch (role) {
        ActorRole.superAdmin => AppColors.warning,
        ActorRole.admin => AppColors.moodyBlue,
        ActorRole.operator => const Color(0xFF6b7280),
        ActorRole.agent => AppColors.success,
      };

  String get _label => switch (role) {
        ActorRole.superAdmin => 'Super Admin',
        ActorRole.admin => 'Admin',
        ActorRole.operator => 'Operator',
        ActorRole.agent => 'Agent',
      };

  @override
  Widget build(BuildContext context) => _Badge(label: _label, color: _color);
}

/// Colored badge for company tier.
class TierBadge extends StatelessWidget {
  const TierBadge({super.key, required this.tier});

  final CompanyTier tier;

  Color get _color => switch (tier) {
        CompanyTier.free => AppColors.freeBadge,
        CompanyTier.premium => AppColors.premiumBadge,
      };

  String get _label => switch (tier) {
        CompanyTier.free => 'Free',
        CompanyTier.premium => 'Premium',
      };

  @override
  Widget build(BuildContext context) => _Badge(label: _label, color: _color);
}

/// Colored badge for onboarding status.
class OnboardingBadge extends StatelessWidget {
  const OnboardingBadge({super.key, required this.status});

  final OnboardingStatus status;

  Color get _color => switch (status) {
        OnboardingStatus.notStarted => const Color(0xFF6b7280),
        OnboardingStatus.aiSuggested => AppColors.moodyBlue,
        OnboardingStatus.verified => AppColors.warning,
        OnboardingStatus.complete => AppColors.success,
      };

  String get _label => switch (status) {
        OnboardingStatus.notStarted => 'Not Started',
        OnboardingStatus.aiSuggested => 'AI Suggested',
        OnboardingStatus.verified => 'Verified',
        OnboardingStatus.complete => 'Complete',
      };

  @override
  Widget build(BuildContext context) => _Badge(label: _label, color: _color);
}

/// Internal badge widget — pill-shaped with colored background + border.
class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
