import 'package:flutter/material.dart';
import 'package:mercury_client/mercury_client.dart';

/// Pill-shaped badge for [ActorRole] values.
class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final ActorRole role;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (role) {
      ActorRole.superAdmin => (const Color(0xFFef4444), 'Super Admin'),
      ActorRole.admin => (const Color(0xFFf59e0b), 'Admin'),
      ActorRole.business => (const Color(0xFF3b82f6), 'Business'),
      ActorRole.customer => (const Color(0xFF6b7280), 'Customer'),
    };

    return _Badge(color: color, label: label);
  }
}

/// Pill-shaped badge for [CompanyTier] values.
class TierBadge extends StatelessWidget {
  const TierBadge({super.key, required this.tier});

  final CompanyTier tier;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (tier) {
      CompanyTier.premium => (const Color(0xFF3b82f6), 'Premium'),
      CompanyTier.free => (const Color(0xFF6b7280), 'Free'),
    };

    return _Badge(color: color, label: label);
  }
}

/// Pill-shaped badge for [OnboardingStatus] values.
class OnboardingBadge extends StatelessWidget {
  const OnboardingBadge({super.key, required this.status});

  final OnboardingStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      OnboardingStatus.complete => (const Color(0xFF22c55e), 'Complete'),
      OnboardingStatus.verified => (const Color(0xFF3b82f6), 'Verified'),
      OnboardingStatus.aiSuggested => (const Color(0xFFf59e0b), 'AI Suggested'),
      OnboardingStatus.notStarted => (const Color(0xFF6b7280), 'Not Started'),
    };

    return _Badge(color: color, label: label);
  }
}

/// Shared pill-shaped badge widget.
class _Badge extends StatelessWidget {
  const _Badge({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
