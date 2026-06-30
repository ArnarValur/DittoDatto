import 'package:flutter/material.dart';

import '../models/booking_state.dart';
import '../models/mock_time_slot.dart';

/// Step 3: Date & time selection with mock slots.
///
/// Calendar month view with navigable months. Past dates greyed out.
/// Selecting a date shows available time slots grouped by
/// Morning / Afternoon.
class DateTimeSelectionStep extends StatefulWidget {
  const DateTimeSelectionStep({
    super.key,
    required this.state,
    required this.onStateChanged,
    required this.onContinue,
  });

  final BookingState state;
  final ValueChanged<BookingState> onStateChanged;
  final VoidCallback onContinue;

  @override
  State<DateTimeSelectionStep> createState() => _DateTimeSelectionStepState();
}

class _DateTimeSelectionStepState extends State<DateTimeSelectionStep> {
  late DateTime _focusedMonth;
  final _today = DateUtils.dateOnly(DateTime.now());

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(
      widget.state.selectedDate?.year ?? _today.year,
      widget.state.selectedDate?.month ?? _today.month,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedDate = widget.state.selectedDate;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Velg dato og tid',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    'Velg en dato og et tidspunkt for timen din.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Calendar.
                _buildCalendar(context),
                const SizedBox(height: 24),

                // Time slots (only if date selected).
                if (selectedDate != null) ...[
                  _buildTimeSlots(context, selectedDate),
                ],
              ],
            ),
          ),
        ),

        // Continue button.
        _buildBottomButton(context),
      ],
    );
  }

  // ── Calendar ────────────────────────────────────────────────────────────

  Widget _buildCalendar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final firstDayOfMonth = DateTime(year, month, 1);
    // Monday = 1, so offset = (weekday - 1) for Monday-start.
    // But Stitch design shows Sunday-start. Let's do Sunday-start.
    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final monthName = _norwegianMonthName(month);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Month navigation.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(year, month - 1);
                  });
                },
                icon: const Icon(Icons.chevron_left),
                iconSize: 20,
              ),
              Text(
                '$monthName $year',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(year, month + 1);
                  });
                },
                icon: const Icon(Icons.chevron_right),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Weekday headers.
          Row(
            children: ['Sø', 'Ma', 'Ti', 'On', 'To', 'Fr', 'Lø']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Day grid.
          ...List.generate(6, (week) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: List.generate(7, (dayOfWeek) {
                  final dayIndex = week * 7 + dayOfWeek - startWeekday + 1;
                  if (dayIndex < 1 || dayIndex > daysInMonth) {
                    // Empty cell for overflow days.
                    return Expanded(
                      child: SizedBox(
                        height: 40,
                        child: dayIndex < 1 && week == 0
                            ? Center(
                                child: Text(
                                  '${DateUtils.getDaysInMonth(year, month - 1) + dayIndex}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    );
                  }

                  final date = DateTime(year, month, dayIndex);
                  final isPast = date.isBefore(_today);
                  final isSelected =
                      widget.state.selectedDate != null &&
                      DateUtils.isSameDay(widget.state.selectedDate!, date);
                  final isToday = DateUtils.isSameDay(date, _today);

                  return Expanded(
                    child: GestureDetector(
                      onTap: isPast
                          ? null
                          : () {
                              widget.onStateChanged(
                                widget.state.copyWith(
                                  selectedDateFn: () => date,
                                  // Clear time slot when date changes.
                                  selectedTimeSlotFn: () => null,
                                ),
                              );
                            },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? colorScheme.primary : null,
                          border: isToday && !isSelected
                              ? Border.all(
                                  color: colorScheme.primary,
                                  width: 1.5,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '$dayIndex',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isPast
                                  ? colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.3)
                                  : isSelected
                                      ? colorScheme.onPrimary
                                      : null,
                              fontWeight:
                                  isToday || isSelected
                                      ? FontWeight.w700
                                      : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Time Slots ──────────────────────────────────────────────────────────

  Widget _buildTimeSlots(BuildContext context, DateTime date) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final slots = MockTimeSlot.generateForDate(date);
    final morningSlots =
        slots.where((s) => s.period == 'morning').toList();
    final afternoonSlots =
        slots.where((s) => s.period == 'afternoon').toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Ledige tider for ${date.day}. ${_norwegianMonthName(date.month).toLowerCase()}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (morningSlots.isNotEmpty) ...[
            Text(
              'Morgen',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildSlotGrid(context, morningSlots),
            const SizedBox(height: 16),
          ],

          if (afternoonSlots.isNotEmpty) ...[
            Text(
              'Ettermiddag',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildSlotGrid(context, afternoonSlots),
          ],
        ],
      ),
    );
  }

  Widget _buildSlotGrid(BuildContext context, List<MockTimeSlot> slots) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: slots.map((slot) {
        final isSelected =
            widget.state.selectedTimeSlot?.time == slot.time;

        return ChoiceChip(
          label: Text(slot.time),
          selected: isSelected,
          onSelected: (_) {
            widget.onStateChanged(
              widget.state.copyWith(
                selectedTimeSlotFn: () => slot,
              ),
            );
          },
          selectedColor: colorScheme.primary,
          labelStyle: TextStyle(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
          ),
          showCheckmark: false,
        );
      }).toList(),
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
            onPressed: widget.state.hasDateTime ? widget.onContinue : null,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Se bestilling'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  static String _norwegianMonthName(int month) {
    const months = [
      '', 'Januar', 'Februar', 'Mars', 'April', 'Mai', 'Juni',
      'Juli', 'August', 'September', 'Oktober', 'November', 'Desember',
    ];
    return months[month];
  }
}
