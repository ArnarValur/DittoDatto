import 'package:flutter/material.dart';

import '../models/booking_state.dart';

/// Step 4: Review & confirm — summary of all selections.
///
/// Shows summary cards (service, staff, date/time, location) with
/// edit icons that navigate back to the relevant step. Optional
/// customer note field. Payment summary with MVA.
class ReviewStep extends StatelessWidget {
  const ReviewStep({
    super.key,
    required this.state,
    required this.onStateChanged,
    required this.onContinue,
    required this.onEditStep,
  });

  final BookingState state;
  final ValueChanged<BookingState> onStateChanged;
  final VoidCallback onContinue;

  /// Called to navigate back to a specific step for editing.
  final ValueChanged<int> onEditStep;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Se over bestillingen',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sjekk at alt stemmer før du fortsetter til betaling.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Summary cards.
                _buildSummaryCard(
                  context,
                  icon: Icons.content_cut,
                  label: 'TJENESTE',
                  title: state.selectedServices.length == 1
                      ? state.selectedServices.first.title
                      : '${state.selectedServices.length} tjenester',
                  subtitle:
                      '${state.totalDuration} minutter • ${state.selectedServices.map((s) => s.bookingMode).toSet().first}',
                  onEdit: () => onEditStep(0),
                ),
                _buildSummaryCard(
                  context,
                  icon: Icons.person,
                  label: 'PERSONALE',
                  title: state.staffDisplayName,
                  subtitle: state.selectedStaff?.title ?? 'Tilgjengelig personale',
                  onEdit: () => onEditStep(1),
                ),
                if (state.selectedDate != null &&
                    state.selectedTimeSlot != null)
                  _buildSummaryCard(
                    context,
                    icon: Icons.calendar_today,
                    label: 'DATO OG TID',
                    title: _formatDate(state.selectedDate!),
                    subtitle: '${state.selectedTimeSlot!.time} - ${_estimateEndTime(state.selectedTimeSlot!.time, state.totalDuration)}',
                    onEdit: () => onEditStep(2),
                  ),
                if (state.establishmentName != null)
                  _buildSummaryCard(
                    context,
                    icon: Icons.location_on,
                    label: 'STED',
                    title: state.establishmentName!,
                    subtitle: state.establishmentAddress ?? '',
                    showEdit: false,
                  ),
                const SizedBox(height: 16),

                // Customer note.
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Legg til en melding (valgfritt)',
                    hintText: 'F.eks. Vennligst fokuser på korsryggen...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.edit_note),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    onStateChanged(
                      state.copyWith(
                        customerNoteFn: () => value.isEmpty ? null : value,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Payment summary.
                _buildPaymentSummary(context),
              ],
            ),
          ),
        ),

        // Continue to payment.
        _buildBottomButton(context),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String title,
    required String subtitle,
    VoidCallback? onEdit,
    bool showEdit = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (showEdit && onEdit != null)
              IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Betalingsoversikt',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            context,
            'Tjenester',
            'Kr ${state.subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            context,
            'MVA (25%)',
            'Kr ${state.taxAmount.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 12),
          Divider(color: colorScheme.onPrimary.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Totalt',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Kr ${state.totalPrice.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onPrimary.withValues(alpha: 0.8),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            label: const Text('Fortsett til betaling'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final dayNames = [
      '', 'Mandag', 'Tirsdag', 'Onsdag', 'Torsdag',
      'Fredag', 'Lørdag', 'Søndag',
    ];
    final monthNames = [
      '', 'januar', 'februar', 'mars', 'april', 'mai', 'juni',
      'juli', 'august', 'september', 'oktober', 'november', 'desember',
    ];
    return '${dayNames[date.weekday]} ${date.day}. ${monthNames[date.month]} ${date.year}';
  }

  static String _estimateEndTime(String startTime, int durationMinutes) {
    final parts = startTime.split(':');
    final startHour = int.parse(parts[0]);
    final startMin = int.parse(parts[1]);
    final totalMinutes = startHour * 60 + startMin + durationMinutes;
    final endHour = (totalMinutes ~/ 60) % 24;
    final endMin = totalMinutes % 60;
    return '${endHour.toString().padLeft(2, '0')}:${endMin.toString().padLeft(2, '0')}';
  }
}
