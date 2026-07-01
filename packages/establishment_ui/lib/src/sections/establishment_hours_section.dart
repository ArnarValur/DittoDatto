import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';
import '../models/opening_schedule.dart';

/// Opening hours section displaying the weekly schedule.
///
/// Renders as a [SliverToBoxAdapter] inside an outlined card — matching
/// the "Om oss" and "Finn oss" section styling pattern.
/// Hidden when [EstablishmentData.hasOpeningSchedule] is `false`.
///
/// Features:
/// - Section header: clock icon + "Åpningstider"
/// - One row per day (Mandag–Søndag) with open/close times
/// - Today's row highlighted with primary color
/// - Closed days show "Stengt" in muted text
class EstablishmentHoursSection extends StatelessWidget {
  const EstablishmentHoursSection({
    required this.data,
    super.key,
  });

  final EstablishmentData data;

  @override
  Widget build(BuildContext context) {
    if (!data.hasOpeningSchedule) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final todayIndex = DateTime.now().weekday; // 1=Mon .. 7=Sun

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DittoSpacing.base),
        child: Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(DittoSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header — matches "Om oss" / "Finn oss" pattern.
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: DittoSpacing.sm),
                    Text(
                      'Åpningstider',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DittoSpacing.sm),

                // Day rows.
                for (var i = 0; i < weekdayKeys.length; i++)
                  _buildDayRow(
                    theme: theme,
                    colorScheme: colorScheme,
                    dayKey: weekdayKeys[i],
                    isToday: (i + 1) == todayIndex,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a single day row: day name + open/close times or "Stengt".
  Widget _buildDayRow({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String dayKey,
    required bool isToday,
  }) {
    final schedule = data.openingSchedule!;
    final day = schedule[dayKey] ?? OpeningDay.closed;
    final label = weekdayLabels[dayKey] ?? dayKey;

    final bgColor = isToday
        ? colorScheme.primaryContainer.withValues(alpha: 0.3)
        : Colors.transparent;
    final nameStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
      color: isToday ? colorScheme.primary : colorScheme.onSurface,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          // Day name — fixed width for alignment.
          SizedBox(
            width: 80,
            child: Text(label, style: nameStyle),
          ),
          const Spacer(),
          // Hours or "Stengt".
          if (day.isOpen)
            Text(
              '${day.open} – ${day.close}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                color: isToday ? colorScheme.primary : colorScheme.onSurface,
              ),
            )
          else
            Text(
              'Stengt',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
