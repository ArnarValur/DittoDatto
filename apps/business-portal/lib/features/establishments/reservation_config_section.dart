import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import 'reservation_config.dart';

/// Reservation config editor section for the establishment edit view.
///
/// Only shown when `establishmentType == restaurant` (ADR-0027).
/// Covers: max guests, large party handling, duration, slot interval,
/// buffer, capacity mode, auto-confirm.
class ReservationConfigSection extends StatelessWidget {
  const ReservationConfigSection({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  final ReservationConfig config;
  final ValueChanged<ReservationConfig> onConfigChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Max guests ──
        _NumberField(
          label: 'Maks gjester per reservasjon',
          value: config.maxGuests,
          min: 1,
          max: 50,
          onChanged: (v) =>
              onConfigChanged(config.copyWith(maxGuests: v)),
        ),
        const SizedBox(height: DittoSpacing.base),

        // ── Large party handling ──
        Text('Håndtering av store selskaper', style: theme.textTheme.labelLarge),
        const SizedBox(height: DittoSpacing.xs),
        Text(
          'Hva skjer når gjester overstiger maks?',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: DittoSpacing.sm),
        ...ReservationConfig.largePartyHandlingValues.map(
          (value) => RadioListTile<String>(
            title: Text(
              ReservationConfig.largePartyHandlingLabels[value] ?? value,
            ),
            value: value,
            groupValue: config.largePartyHandling,
            onChanged: (v) => onConfigChanged(
              config.copyWith(largePartyHandling: v),
            ),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),

        // ── Contact field for email/call ──
        if (config.largePartyHandling == 'email' ||
            config.largePartyHandling == 'call') ...[
          const SizedBox(height: DittoSpacing.sm),
          TextFormField(
            initialValue: config.largePartyContact,
            decoration: InputDecoration(
              labelText: config.largePartyHandling == 'email'
                  ? 'E-postadresse for store selskaper'
                  : 'Telefonnummer for store selskaper',
              hintText: config.largePartyHandling == 'email'
                  ? 'booking@restaurant.no'
                  : '+47 ...',
            ),
            onChanged: (v) => onConfigChanged(
              config.copyWith(largePartyContact: () => v.isEmpty ? null : v),
            ),
          ),
        ],
        const SizedBox(height: DittoSpacing.lg),

        // ── Duration + timing ──
        const Divider(),
        const SizedBox(height: DittoSpacing.sm),
        _NumberField(
          label: 'Standard varighet',
          value: config.defaultDuration,
          min: 15,
          max: 300,
          step: 15,
          suffix: 'min',
          onChanged: (v) =>
              onConfigChanged(config.copyWith(defaultDuration: v)),
        ),
        const SizedBox(height: DittoSpacing.base),

        _NumberField(
          label: 'Tidslukeintervall',
          value: config.slotInterval,
          min: 15,
          max: 120,
          step: 15,
          suffix: 'min',
          onChanged: (v) =>
              onConfigChanged(config.copyWith(slotInterval: v)),
        ),
        const SizedBox(height: DittoSpacing.base),

        _NumberField(
          label: 'Buffer mellom reservasjoner',
          value: config.bufferBetweenSlots,
          min: 0,
          max: 60,
          step: 5,
          suffix: 'min',
          onChanged: (v) =>
              onConfigChanged(config.copyWith(bufferBetweenSlots: v)),
        ),
        const SizedBox(height: DittoSpacing.lg),

        // ── Capacity ──
        const Divider(),
        const SizedBox(height: DittoSpacing.sm),
        Text('Kapasitetsmodus', style: theme.textTheme.labelLarge),
        const SizedBox(height: DittoSpacing.xs),
        SegmentedButton<String>(
          segments: ReservationConfig.capacityModeValues
              .map((v) => ButtonSegment(
                    value: v,
                    label: Text(
                      ReservationConfig.capacityModeLabels[v] ?? v,
                    ),
                  ))
              .toList(),
          selected: {config.capacityMode},
          onSelectionChanged: (s) =>
              onConfigChanged(config.copyWith(capacityMode: s.first)),
        ),

        if (config.capacityMode != 'pool') ...[
          const SizedBox(height: DittoSpacing.base),
          _NumberField(
            label: 'Total kapasitet (plasser)',
            value: config.totalCapacity ?? 40,
            min: 1,
            max: 500,
            onChanged: (v) =>
                onConfigChanged(config.copyWith(totalCapacity: () => v)),
          ),
        ],
        const SizedBox(height: DittoSpacing.lg),

        // ── Auto-confirm ──
        const Divider(),
        const SizedBox(height: DittoSpacing.sm),
        SwitchListTile(
          title: const Text('Automatisk bekreftelse'),
          subtitle: const Text(
            'Reservasjoner bekreftes umiddelbart uten manuell godkjenning',
          ),
          value: config.autoConfirm,
          onChanged: (v) =>
              onConfigChanged(config.copyWith(autoConfirm: v)),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

/// Compact numeric stepper (shared with BookingPolicySection pattern).
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
