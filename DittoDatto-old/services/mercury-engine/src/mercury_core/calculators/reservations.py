"""MercuryEngine — Reservation Calculator.

Replaces: packages/mercury-engine/src/core/reservations/calculator.ts

Pure functions for restaurant-specific booking logic:
- Time slot generation
- Overlap detection
- Best-fit table assignment
- Slot availability (pool mode vs table mode)
"""

from __future__ import annotations

from dataclasses import dataclass

from mercury_core.models.establishment import Establishment
from mercury_core.models.resource import Resource
from mercury_core.time import (
    StoreTimeContext,
    get_store_now,
    is_slot_in_past,
    minutes_to_time,
    parse_time,
)

# ============================================================================
# Types
# ============================================================================


@dataclass
class Reservation:
    """Simplified reservation representation for calculator logic."""

    id: str = ""
    time: str = ""  # HH:MM
    duration: int = 90
    status: str = "confirmed"
    guest_count: int = 2
    table_id: str | None = None


@dataclass
class SlotFilterOptions:
    """Options for filtering past slots during generation."""

    store_timezone: str = "Europe/Oslo"
    request_date: str = ""
    notice_cutoff_minutes: int = 0


@dataclass
class SlotAvailabilityResult:
    """Result of slot availability check."""

    available: bool
    table_id: str | None = None
    remaining_capacity: int = 0
    reason: str | None = None


# ============================================================================
# Priority order for table assignment
# ============================================================================

_PRIORITY_ORDER = {"high": 0, "normal": 1, "low": 2}


# ============================================================================
# Time Slot Generation
# ============================================================================


def generate_time_slots(
    start_time: str,
    end_time: str,
    interval: int,
    filter_options: SlotFilterOptions | None = None,
) -> list[str]:
    """Generate evenly-spaced time slots between start and end.

    Args:
        start_time: Opening time (HH:MM).
        end_time: Closing time (HH:MM).
        interval: Minutes between slots.
        filter_options: Optional options for filtering past slots.

    Returns:
        List of time strings in HH:MM format.
    """
    start = parse_time(start_time)
    end = parse_time(end_time)
    slots: list[str] = []

    # Get time context for past-slot filtering
    time_ctx: StoreTimeContext | None = None
    notice_cutoff = 0
    if filter_options and filter_options.request_date:
        tz = filter_options.store_timezone or "Europe/Oslo"
        time_ctx = get_store_now(tz, filter_options.request_date)
        notice_cutoff = filter_options.notice_cutoff_minutes

    cursor = start
    while cursor < end:
        if time_ctx and is_slot_in_past(cursor, time_ctx, notice_cutoff):
            cursor += interval
            continue
        slots.append(minutes_to_time(cursor))
        cursor += interval

    return slots


# ============================================================================
# Overlap Detection
# ============================================================================


def get_overlapping_reservations(
    reservations: list[Reservation],
    slot_time: str,
    duration: int,
) -> list[Reservation]:
    """Find active reservations that overlap with a proposed slot.

    Args:
        reservations: All reservations for the day.
        slot_time: Proposed slot time (HH:MM).
        duration: Duration in minutes.

    Returns:
        List of overlapping, non-cancelled reservations.
    """
    slot_start = parse_time(slot_time)
    slot_end = slot_start + duration

    result: list[Reservation] = []
    for r in reservations:
        # Skip cancelled and no-show
        if r.status in ("cancelled", "no_show"):
            continue

        r_start = parse_time(r.time)
        r_end = r_start + r.duration

        # Overlap check: [slot_start, slot_end) ∩ [r_start, r_end)
        if slot_start < r_end and slot_end > r_start:
            result.append(r)

    return result


# ============================================================================
# Best-Fit Table Assignment
# ============================================================================


def find_best_table(
    tables: list[Resource],
    occupied_reservations: list[Reservation],
    slot_time: str,
    duration: int,
    party_size: int,
) -> Resource | None:
    """Find the best-fit table for a reservation.

    Priority order:
        1. Tables where party_size <= maxCapacity
        2. High priority > Normal > Low
        3. Smallest capacity first (best-fit)

    Args:
        tables: All available tables.
        occupied_reservations: Reservations overlapping with this slot.
        slot_time: Proposed slot time (HH:MM).
        duration: Duration in minutes.
        party_size: Number of guests.

    Returns:
        Best-fit Resource, or None if no table fits.
    """
    slot_start = parse_time(slot_time)
    slot_end = slot_start + duration

    # Filter: bookable + capacity fits (both min and max)
    candidates = [
        t
        for t in tables
        if t.is_bookable and t.max_capacity >= party_size and party_size >= t.min_capacity
    ]

    # Sort: priority (high first), then capacity (smallest first = best-fit)
    candidates.sort(key=lambda t: (
        _PRIORITY_ORDER.get(t.priority, 1),
        t.max_capacity,
    ))

    # Check occupancy
    for table in candidates:
        is_occupied = any(
            r.table_id == table.id
            and parse_time(r.time) < slot_end
            and parse_time(r.time) + r.duration > slot_start
            for r in occupied_reservations
            if r.status not in ("cancelled", "no_show")
        )
        if not is_occupied:
            return table

    return None


# ============================================================================
# Slot Availability (Pool Mode vs Table Mode)
# ============================================================================


def calculate_slot_availability(
    establishment: Establishment,
    slot_time: str,
    duration: int,
    party_size: int,
    reservations: list[Reservation],
    tables: list[Resource] | None = None,
) -> SlotAvailabilityResult:
    """Calculate availability for a reservation slot.

    Supports two modes:
        - Table mode: assign best-fit table
        - Pool mode: check against total capacity

    Args:
        establishment: The restaurant establishment.
        slot_time: Proposed slot time (HH:MM).
        duration: Duration in minutes.
        party_size: Number of guests.
        reservations: All reservations for the day.
        tables: Tables (if table mode is used).

    Returns:
        SlotAvailabilityResult with availability and details.
    """
    config = establishment.reservation_config
    if not config:
        return SlotAvailabilityResult(
            available=False,
            reason="No capacity configuration found",
        )

    # Table mode: if tables are provided, do table assignment
    if tables:
        active_reservations = [
            r for r in reservations if r.status not in ("cancelled", "no_show")
        ]
        best_table = find_best_table(tables, active_reservations, slot_time, duration, party_size)

        if not best_table:
            return SlotAvailabilityResult(
                available=False,
                reason="No suitable table available",
            )

        # Count remaining free tables
        slot_start = parse_time(slot_time)
        slot_end = slot_start + duration
        occupied_table_ids = set()
        for r in active_reservations:
            r_start = parse_time(r.time)
            r_end = r_start + r.duration
            if r.table_id and slot_start < r_end and slot_end > r_start:
                occupied_table_ids.add(r.table_id)

        bookable_tables = [t for t in tables if t.is_bookable]
        remaining = sum(1 for t in bookable_tables if t.id not in occupied_table_ids)

        return SlotAvailabilityResult(
            available=True,
            table_id=best_table.id,
            remaining_capacity=remaining,
        )

    # Pool mode: check total capacity
    total_capacity = config.total_capacity or 0
    slot_start = parse_time(slot_time)
    slot_end = slot_start + duration

    occupied_guests = sum(
        r.guest_count
        for r in reservations
        if r.status not in ("cancelled", "no_show")
        and parse_time(r.time) < slot_end
        and parse_time(r.time) + r.duration > slot_start
    )

    remaining = total_capacity - occupied_guests

    if party_size > remaining:
        return SlotAvailabilityResult(
            available=False,
            remaining_capacity=remaining,
            reason="Not enough capacity",
        )

    return SlotAvailabilityResult(
        available=True,
        remaining_capacity=remaining,
    )
