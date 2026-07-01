import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import 'opening_schedule.dart';

/// Opening hours editor section for the establishment edit view.
///
/// Displays a 7-day schedule with per-day toggle + time pickers.
/// "Kopier til alle" copies one day's times to all open days.
class OpeningHoursSection extends StatelessWidget {
  const OpeningHoursSection({
    super.key,
    required this.schedule,
    required this.onScheduleChanged,
  });

  final Map<String, OpeningDay> schedule;
  final ValueChanged<Map<String, OpeningDay>> onScheduleChanged;

  void _updateDay(String day, OpeningDay updated) {
    final newSchedule = Map<String, OpeningDay>.from(schedule);
    newSchedule[day] = updated;
    onScheduleChanged(newSchedule);
  }

  void _copyToAll(OpeningDay source) {
    final newSchedule = {
      for (final entry in schedule.entries)
        entry.key: entry.value.isOpen
            ? entry.value.copyWith(open: source.open, close: source.close)
            : entry.value,
    };
    onScheduleChanged(newSchedule);
  }

  Future<void> _pickTime(
    BuildContext context,
    String currentTime,
    ValueChanged<String> onPicked,
  ) async {
    final parts = currentTime.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 9,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      onPicked(
        '${picked.hour.toString().padLeft(2, '0')}:'
        '${picked.minute.toString().padLeft(2, '0')}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final day in weekdayKeys) ...[
          _DayRow(
            label: weekdayLabels[day] ?? day,
            dayData: schedule[day] ?? OpeningDay.closed,
            onToggle: (isOpen) => _updateDay(
              day,
              (schedule[day] ?? OpeningDay.closed).copyWith(isOpen: isOpen),
            ),
            onOpenTap: () => _pickTime(
              context,
              (schedule[day] ?? OpeningDay.closed).open,
              (time) => _updateDay(
                day,
                (schedule[day] ?? OpeningDay.closed).copyWith(open: time),
              ),
            ),
            onCloseTap: () => _pickTime(
              context,
              (schedule[day] ?? OpeningDay.closed).close,
              (time) => _updateDay(
                day,
                (schedule[day] ?? OpeningDay.closed).copyWith(close: time),
              ),
            ),
            onCopyToAll: () =>
                _copyToAll(schedule[day] ?? OpeningDay.defaultOpen),
            theme: theme,
          ),
          if (day != weekdayKeys.last)
            const Divider(height: 1),
        ],
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.label,
    required this.dayData,
    required this.onToggle,
    required this.onOpenTap,
    required this.onCloseTap,
    required this.onCopyToAll,
    required this.theme,
  });

  final String label;
  final OpeningDay dayData;
  final ValueChanged<bool> onToggle;
  final VoidCallback onOpenTap;
  final VoidCallback onCloseTap;
  final VoidCallback onCopyToAll;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DittoSpacing.xs),
      child: Row(
        children: [
          // Day label
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Open/closed toggle
          Switch(
            value: dayData.isOpen,
            onChanged: onToggle,
          ),

          const SizedBox(width: DittoSpacing.sm),

          // Time pickers (disabled when closed)
          Expanded(
            child: AnimatedOpacity(
              opacity: dayData.isOpen ? 1.0 : 0.3,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !dayData.isOpen,
                child: Row(
                  children: [
                    _TimeChip(
                      time: dayData.open,
                      onTap: onOpenTap,
                      theme: theme,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DittoSpacing.xs,
                      ),
                      child: Text(
                        '–',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    _TimeChip(
                      time: dayData.close,
                      onTap: onCloseTap,
                      theme: theme,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.copy_all_rounded, size: 18),
                      tooltip: 'Kopier til alle',
                      onPressed: dayData.isOpen ? onCopyToAll : null,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.time,
    required this.onTap,
    required this.theme,
  });

  final String time;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DittoSpacing.sm,
          vertical: DittoSpacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}
