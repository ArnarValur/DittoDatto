import 'package:flutter/material.dart';

import '../models/booking_state.dart';
import '../models/mock_staff.dart';

/// Step 2: Staff selection with mock data.
///
/// "No Preference" default + staff cards with avatar, name,
/// title, rating, and review count. Radio behavior.
class StaffSelectionStep extends StatelessWidget {
  const StaffSelectionStep({
    super.key,
    required this.state,
    required this.onStateChanged,
    required this.onContinue,
  });

  final BookingState state;
  final ValueChanged<BookingState> onStateChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Velg personale',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Velg din foretrukne profesjonelle.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // "No Preference" card.
                _buildNoPreferenceCard(context),
                const SizedBox(height: 20),

                // Divider.
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: colorScheme.outlineVariant),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'ELLER VELG SPESIFIKT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: colorScheme.outlineVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Staff cards.
                ...MockStaff.demoStaff.map(
                  (staff) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildStaffCard(context, staff: staff),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Continue button.
        _buildBottomButton(context),
      ],
    );
  }

  Widget _buildNoPreferenceCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = state.selectedStaff == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onStateChanged(
            state.copyWith(selectedStaffFn: () => null),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.1)
                : null,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.people_outline,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingen preferanse',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Hvilket som helst tilgjengelig personale',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<bool>(
                value: true,
                groupValue: isSelected ? true : null,
                onChanged: (_) {
                  onStateChanged(
                    state.copyWith(selectedStaffFn: () => null),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaffCard(
    BuildContext context, {
    required MockStaff staff,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = state.selectedStaff?.id == staff.id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onStateChanged(
            state.copyWith(selectedStaffFn: () => staff),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.1)
                : null,
          ),
          child: Row(
            children: [
              // Avatar or initials.
              CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: staff.avatarUrl != null
                    ? NetworkImage(staff.avatarUrl!)
                    : null,
                child: staff.avatarUrl == null
                    ? Text(
                        staff.name
                            .split(' ')
                            .map((n) => n[0])
                            .take(2)
                            .join(),
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Name + title + rating.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      staff.title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star_outline,
                          size: 16,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${staff.rating}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${staff.reviewCount} anmeldelser)',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Radio<bool>(
                value: true,
                groupValue: isSelected ? true : null,
                onChanged: (_) {
                  onStateChanged(
                    state.copyWith(selectedStaffFn: () => staff),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onContinue,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Fortsett til tid'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}
