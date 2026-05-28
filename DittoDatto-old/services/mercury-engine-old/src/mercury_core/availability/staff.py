"""MercuryEngine — Staff availability logic.

Replaces: packages/mercury-engine/src/core/shared/staff-availability.ts

Pure functions — no database dependency, fully testable.
Handles shift matching, date overrides, and multi-staff slot filtering.

Design note (V2 vs V1):
    V1 embedded dateOverrides[] in StaffMember.
    V2 stores DateOverride as a separate table (Session 9 scalability decision).
    Functions here accept overrides as a separate list parameter.
"""

from __future__ import annotations

from mercury_core.models.common import DateOverrideType, ShiftDay, StaffStatus, TimeBlock
from mercury_core.models.staff import DateOverride, Staff
from mercury_core.time import get_day_name, parse_time


def is_staff_available(
    staff: Staff,
    date_str: str,
    slot_start_minutes: int,
    slot_end_minutes: int,
    date_overrides: list[DateOverride] | None = None,
) -> bool:
    """Check if a staff member is available for a given time slot on a given date.

    Resolution order:
        1. dateOverrides (off/sick → unavailable, custom → check custom blocks)
        2. weeklyShifts (isWorking + blocks check)
        3. No schedule data → unavailable (fail-closed)

    Args:
        staff: The staff member to check.
        date_str: Date in YYYY-MM-DD format.
        slot_start_minutes: Slot start as minutes from midnight.
        slot_end_minutes: Slot end as minutes from midnight.
        date_overrides: Optional list of DateOverride records for this staff member.

    Returns:
        True if the staff member is available for the slot.
    """
    if not staff.is_bookable or staff.status != StaffStatus.ACTIVE:
        return False

    # 1. Check date overrides first (highest priority)
    if date_overrides:
        override = next((o for o in date_overrides if o.date == date_str), None)
        if override:
            if override.type in (DateOverrideType.OFF, DateOverrideType.SICK):
                return False
            if override.type == DateOverrideType.CUSTOM and override.blocks:
                return _fits_within_blocks(override.blocks, slot_start_minutes, slot_end_minutes)
            return False

    # 2. Check weekly shift pattern
    day_key = get_day_name(date_str)
    if not staff.weekly_shifts:
        return False

    day_shift: ShiftDay | None = staff.weekly_shifts.get(day_key)
    if not day_shift or not day_shift.is_working:
        return False
    if not day_shift.blocks:
        return False

    return _fits_within_blocks(day_shift.blocks, slot_start_minutes, slot_end_minutes)


def _fits_within_blocks(
    blocks: list[TimeBlock],
    slot_start: int,
    slot_end: int,
) -> bool:
    """Check if a time slot fits entirely within at least one shift block."""
    return any(
        slot_start >= parse_time(block.start) and slot_end <= parse_time(block.end)
        for block in blocks
    )


def get_available_staff_for_slot(
    staff_list: list[Staff],
    date_str: str,
    slot_start_minutes: int,
    slot_end_minutes: int,
    all_overrides: list[DateOverride] | None = None,
) -> list[str]:
    """Filter staff to those available for a given slot.

    Args:
        staff_list: All staff members to check.
        date_str: Date in YYYY-MM-DD format.
        slot_start_minutes: Slot start as minutes from midnight.
        slot_end_minutes: Slot end as minutes from midnight.
        all_overrides: All date overrides (will be filtered per staff member).

    Returns:
        List of staff IDs that are available.
    """
    result: list[str] = []
    for s in staff_list:
        # Filter overrides for this specific staff member
        staff_overrides = (
            [o for o in all_overrides if o.staff == s.id] if all_overrides else None
        )
        if (
            is_staff_available(s, date_str, slot_start_minutes, slot_end_minutes, staff_overrides)
            and s.id
        ):
            result.append(s.id)
    return result
