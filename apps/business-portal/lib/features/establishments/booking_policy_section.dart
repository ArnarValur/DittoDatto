import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import 'booking_policy.dart';

/// Booking policy editor section for the establishment edit view.
///
/// Shows all 9 booking policy fields with appropriate input types:
/// - Numeric steppers for days/minutes/hours/percentage
/// - Toggles for cancel/reschedule enabled
/// - Optional text for confirmation message
class BookingPolicySection extends StatelessWidget {
  const BookingPolicySection({
    super.key,
    required this.policy,
    required this.onPolicyChanged,
  });

  final BookingPolicy policy;
  final ValueChanged<BookingPolicy> onPolicyChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Booking window ──
        _NumberField(
          label: 'Maks dager fremover for booking',
          value: policy.maxBookableFutureDays,
          min: 1,
          max: 365,
          suffix: 'dager',
          onChanged: (v) =>
              onPolicyChanged(policy.copyWith(maxBookableFutureDays: v)),
        ),
        const SizedBox(height: DittoSpacing.base),

        _NumberField(
          label: 'Minimum varsel før booking',
          value: policy.minBookingNoticeMinutes,
          min: 0,
          max: 10080, // 7 days
          step: 15,
          suffix: 'min',
          onChanged: (v) =>
              onPolicyChanged(policy.copyWith(minBookingNoticeMinutes: v)),
        ),
        const SizedBox(height: DittoSpacing.base),

        // ── Slot interval ──
        Text('Tidslukeintervall', style: theme.textTheme.labelLarge),
        const SizedBox(height: DittoSpacing.xs),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 5, label: Text('5 min')),
            ButtonSegment(value: 10, label: Text('10 min')),
            ButtonSegment(value: 15, label: Text('15 min')),
            ButtonSegment(value: 30, label: Text('30 min')),
            ButtonSegment(value: 60, label: Text('60 min')),
          ],
          selected: {policy.slotInterval},
          onSelectionChanged: (s) =>
              onPolicyChanged(policy.copyWith(slotInterval: s.first)),
        ),
        const SizedBox(height: DittoSpacing.lg),

        // ── Cancellation ──
        const Divider(),
        const SizedBox(height: DittoSpacing.sm),
        SwitchListTile(
          title: const Text('Tillat avbestilling'),
          subtitle: const Text('Kunder kan avbestille egne bookinger'),
          value: policy.clientCancelEnabled,
          onChanged: (v) =>
              onPolicyChanged(policy.copyWith(clientCancelEnabled: v)),
          contentPadding: EdgeInsets.zero,
        ),
        if (policy.clientCancelEnabled) ...[
          const SizedBox(height: DittoSpacing.sm),
          _NumberField(
            label: 'Avbestillingsfrist',
            value: policy.minCancelNoticeHours,
            min: 0,
            max: 168, // 7 days
            suffix: 'timer før',
            onChanged: (v) =>
                onPolicyChanged(policy.copyWith(minCancelNoticeHours: v)),
          ),
        ],
        const SizedBox(height: DittoSpacing.base),

        // ── Rescheduling ──
        SwitchListTile(
          title: const Text('Tillat ombooking'),
          subtitle: const Text('Kunder kan flytte sine bookinger'),
          value: policy.clientRescheduleEnabled,
          onChanged: (v) =>
              onPolicyChanged(policy.copyWith(clientRescheduleEnabled: v)),
          contentPadding: EdgeInsets.zero,
        ),
        if (policy.clientRescheduleEnabled) ...[
          const SizedBox(height: DittoSpacing.sm),
          _NumberField(
            label: 'Ombookingsfrist',
            value: policy.minRescheduleNoticeHours,
            min: 0,
            max: 168,
            suffix: 'timer før',
            onChanged: (v) =>
                onPolicyChanged(policy.copyWith(minRescheduleNoticeHours: v)),
          ),
        ],
        const SizedBox(height: DittoSpacing.lg),

        // ── No-show fee ──
        const Divider(),
        const SizedBox(height: DittoSpacing.sm),
        _NumberField(
          label: 'Uteblivelsesgebyr',
          value: policy.noShowFeePercent,
          min: 0,
          max: 100,
          suffix: '%',
          onChanged: (v) =>
              onPolicyChanged(policy.copyWith(noShowFeePercent: v)),
        ),
        if (policy.noShowFeePercent > 0)
          Padding(
            padding: const EdgeInsets.only(top: DittoSpacing.xs),
            child: Text(
              'Krever Vipps-integrasjon (kommer snart)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        const SizedBox(height: DittoSpacing.lg),

        // ── Confirmation message ──
        const Divider(),
        const SizedBox(height: DittoSpacing.sm),
        TextFormField(
          initialValue: policy.bookingConfirmationMessage,
          decoration: const InputDecoration(
            labelText: 'Bekreftelsesmelding (valgfritt)',
            hintText: 'Vises til kunden etter booking...',
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          onChanged: (v) => onPolicyChanged(
            policy.copyWith(
              bookingConfirmationMessage: () => v.isEmpty ? null : v,
            ),
          ),
        ),
      ],
    );
  }
}

/// A compact numeric stepper input.
class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.suffix,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        IconButton(
          icon: const Icon(Icons.remove_rounded, size: 18),
          onPressed: value > min
              ? () => onChanged((value - step).clamp(min, max))
              : null,
          visualDensity: VisualDensity.compact,
        ),
        Container(
          constraints: const BoxConstraints(minWidth: 48),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: DittoSpacing.xs,
            vertical: DittoSpacing.xs,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            suffix != null ? '$value $suffix' : '$value',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_rounded, size: 18),
          onPressed: value < max
              ? () => onChanged((value + step).clamp(min, max))
              : null,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
