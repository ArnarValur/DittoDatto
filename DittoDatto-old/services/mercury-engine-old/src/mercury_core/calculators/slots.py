"""MercuryEngine — Slot Calculator (Time Tetris).

Replaces: packages/mercury-engine/src/core/bookings/calculator.ts → calculateSlotsFromContext

Pure function — takes an AvailabilityContext, returns a list of available time slots.
Zero database access.
"""

from __future__ import annotations

from mercury_core.availability.context import AvailabilityContext, OccupiedInterval
from mercury_core.availability.staff import is_staff_available
from mercury_core.time import is_slot_in_past, minutes_to_time


def _intervals_overlap(
    slot_start: int, slot_end: int, intervals: list[OccupiedInterval]
) -> bool:
    """Check if any occupied interval overlaps with the given slot."""
    return any(slot_start < i.end and slot_end > i.start for i in intervals)


def _is_any_staff_free(
    ctx: AvailabilityContext,
    slot_start: int,
    slot_end: int,
) -> bool:
    """Check if at least one eligible staff member is free for this slot."""
    for staff in ctx.eligible_staff:
        if not staff.id:
            continue
        if not is_staff_available(staff, ctx.date, slot_start, slot_end):
            continue
        staff_intervals = ctx.staff_occupancy.get(staff.id, [])
        if not _intervals_overlap(slot_start, slot_end, staff_intervals):
            return True
    return False


def calculate_slots_from_context(ctx: AvailabilityContext) -> list[str]:
    """Generate available time slots from a prebuilt AvailabilityContext.

    This is the pure slot generation loop ("Time Tetris") extracted from
    the V1 `calculateSlotsFromContext`. It checks store hours, staff shifts,
    existing bookings, active holds, and booking notice windows to determine
    which slots are bookable.

    Args:
        ctx: Fully built AvailabilityContext.

    Returns:
        Sorted list of available time strings in "HH:MM" format.
    """
    # Closed day → no slots
    if not ctx.schedule or not ctx.schedule.is_open:
        return []

    slots: list[str] = []
    cursor = ctx.open_time

    while cursor + ctx.total_duration <= ctx.close_time:
        slot_start = cursor
        slot_end = cursor + ctx.total_duration

        # 1. Notice / past-time check
        if is_slot_in_past(slot_start, ctx.time_ctx, ctx.notice_cutoff_minutes):
            cursor += ctx.slot_interval
            continue

        # 2. Check occupancy based on what the store has
        if ctx.has_bookable_staff:
            # Staff-aware: slot is available if ANY eligible staff member is free
            if not _is_any_staff_free(ctx, slot_start, slot_end):
                cursor += ctx.slot_interval
                continue
        else:
            # Store-level fallback: no staff → check store-level occupancy
            if _intervals_overlap(slot_start, slot_end, ctx.store_occupied):
                cursor += ctx.slot_interval
                continue

        slots.append(minutes_to_time(slot_start))
        cursor += ctx.slot_interval

    return slots
