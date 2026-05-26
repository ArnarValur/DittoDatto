"""MercuryEngine — Availability Context Builder.

Replaces: packages/mercury-engine/src/core/shared/availability-context.ts

Pure function that transforms raw data into a computed context used by both
the slot calculator (Time Tetris) and hold allocation (concurrency resolution).

This module is PURE — zero database, zero side effects → trivially testable.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime

from mercury_core.models.booking import Booking
from mercury_core.models.common import BookingPolicy, DaySchedule, ShiftDay, TimeBlock
from mercury_core.models.establishment import Establishment
from mercury_core.models.hold import Hold
from mercury_core.models.resource import Resource, ResourceGroup
from mercury_core.models.service import Service
from mercury_core.models.staff import Staff
from mercury_core.time import (
    StoreTimeContext,
    get_day_name,
    get_store_now,
    minutes_from_midnight,
    parse_time,
)

# ============================================================================
# Types
# ============================================================================


@dataclass
class OccupiedInterval:
    """Time interval occupied by a booking or hold."""

    start: int  # minutes from midnight
    end: int  # minutes from midnight
    resource_id: str | None = None


@dataclass
class AvailabilityData:
    """Raw data needed for availability calculation."""

    establishment: Establishment
    bookings: list[Booking]
    holds: list[Hold]
    services: list[Service]
    staff: list[Staff]
    resources: list[Resource]
    resource_groups: list[ResourceGroup]


@dataclass
class AvailabilityContext:
    """Computed values ready for slot calculation and hold validation."""

    # Schedule
    schedule: DaySchedule | None
    open_time: int  # minutes from midnight
    close_time: int  # minutes from midnight
    day_name: str

    # Duration & policy
    total_duration: int
    slot_interval: int
    notice_cutoff_minutes: int
    policy: BookingPolicy
    time_ctx: StoreTimeContext

    # Staff
    normalized_staff: list[Staff]
    eligible_staff: list[Staff]
    has_bookable_staff: bool

    # Occupancy maps
    staff_occupancy: dict[str, list[OccupiedInterval]]
    store_occupied: list[OccupiedInterval]
    resource_occupied: list[OccupiedInterval]

    # Resources
    unique_required_group_ids: list[str]
    has_resource_requirements: bool
    resources: list[Resource]
    resource_groups: list[ResourceGroup]

    # Pass-through
    date: str  # Original YYYY-MM-DD request date
    establishment: Establishment
    bookings: list[Booking]
    holds: list[Hold]
    services: list[Service]


# ============================================================================
# Helpers
# ============================================================================


def _dt_to_str(dt: datetime | str | None) -> str:
    """Convert a datetime or string to an ISO string."""
    if dt is None:
        return ""
    if isinstance(dt, str):
        return dt
    return dt.isoformat()


# ============================================================================
# Builder
# ============================================================================


def build_availability_context(
    data: AvailabilityData,
    date: str,
    staff_id: str | None = None,
) -> AvailabilityContext:
    """Build a fully computed availability context from raw data.

    Args:
        data: Raw data from repository layer.
        date: Request date in 'YYYY-MM-DD' format.
        staff_id: Optional: filter to a specific staff member.

    Returns:
        Computed context ready for slot loop or hold allocation.
    """
    establishment = data.establishment
    bookings = data.bookings
    holds = data.holds
    services = data.services
    staff = data.staff
    resources = data.resources
    resource_groups = data.resource_groups

    # ---- Policy derivation ----
    # Notice: most restrictive (max) across services
    # Interval: smallest (min) across services
    notice_cutoff_minutes = max(
        (s.min_booking_notice_minutes for s in services), default=0
    )
    slot_interval = min((s.slot_interval for s in services), default=15)

    # Date window: establishment-level concern (max_bookable_future_days)
    policy = establishment.booking_policy or BookingPolicy()

    # Time context (timezone-aware "now")
    tz = establishment.timezone or "Europe/Oslo"
    time_ctx = get_store_now(tz, date)

    # ---- Schedule ----
    total_duration = sum(s.duration for s in services)
    day_name = get_day_name(date)
    schedule = establishment.opening_schedule.get(day_name)
    open_time = parse_time(schedule.open) if schedule and schedule.is_open else 0
    close_time = parse_time(schedule.close) if schedule and schedule.is_open else 0

    # ---- Staff normalization ----
    # If a staff member is is_bookable but has no weekly_shifts configured,
    # inject a default shift that mirrors the establishment's opening hours.
    normalized_staff: list[Staff] = []
    for s in staff:
        if s.is_bookable and not s.weekly_shifts and schedule and schedule.is_open:
            default_block = [TimeBlock(start=schedule.open, end=schedule.close)]
            default_shifts = {
                "mon": ShiftDay(is_working=True, blocks=default_block),
                "tue": ShiftDay(is_working=True, blocks=default_block),
                "wed": ShiftDay(is_working=True, blocks=default_block),
                "thu": ShiftDay(is_working=True, blocks=default_block),
                "fri": ShiftDay(is_working=True, blocks=default_block),
                "sat": ShiftDay(is_working=False, blocks=[]),
                "sun": ShiftDay(is_working=False, blocks=[]),
            }
            normalized_staff.append(s.model_copy(update={"weekly_shifts": default_shifts}))
        else:
            normalized_staff.append(s)

    # ---- Staff-service assignment filtering ----
    # For multi-service bookings, use INTERSECTION — staff must be eligible for ALL services.
    # Empty assigned_staff = universal service (anyone can do it).
    restricted_services = [s for s in services if s.assigned_staff]
    eligible_staff = list(normalized_staff)

    if restricted_services:
        eligible_staff = [
            s
            for s in normalized_staff
            if all(s.id in svc.assigned_staff for svc in restricted_services)
        ]

    # If user picked a specific staff member, narrow further
    if staff_id:
        eligible_staff = [s for s in eligible_staff if s.id == staff_id]

    has_bookable_staff = len(eligible_staff) > 0

    # ---- Resource group extraction ----
    required_resource_group_ids: list[str] = []
    for s in services:
        required_resource_group_ids.extend(s.required_resource_groups)
    unique_required_group_ids = list(dict.fromkeys(required_resource_group_ids))
    has_resource_requirements = len(unique_required_group_ids) > 0

    # ---- Occupancy maps ----

    # Per-staff occupancy
    staff_occupancy: dict[str, list[OccupiedInterval]] = {}
    if has_bookable_staff:
        for s in eligible_staff:
            if s.id:
                staff_occupancy[s.id] = []

        for b in bookings:
            if b.staff and b.staff in staff_occupancy and b.start_time and b.end_time:
                staff_occupancy[b.staff].append(
                    OccupiedInterval(
                        start=minutes_from_midnight(_dt_to_str(b.start_time), tz),
                        end=minutes_from_midnight(_dt_to_str(b.end_time), tz),
                    )
                )

        for h in holds:
            if h.staff and h.staff in staff_occupancy:
                start = parse_time(h.slot_time)
                staff_occupancy[h.staff].append(
                    OccupiedInterval(start=start, end=start + h.duration)
                )

    # Store-level fallback (for stores with NO staff and NO resources)
    store_occupied_list: list[OccupiedInterval] = []
    for b in bookings:
        if b.start_time and b.end_time:
            store_occupied_list.append(
                OccupiedInterval(
                    start=minutes_from_midnight(_dt_to_str(b.start_time), tz),
                    end=minutes_from_midnight(_dt_to_str(b.end_time), tz),
                )
            )
    for h in holds:
        start = parse_time(h.slot_time)
        store_occupied_list.append(OccupiedInterval(start=start, end=start + h.duration))
    store_occupied_list.sort(key=lambda x: x.start)

    # Resource-level occupancy
    resource_occupied_list: list[OccupiedInterval] = []
    for b in bookings:
        if b.start_time and b.end_time:
            resource_occupied_list.append(
                OccupiedInterval(
                    start=minutes_from_midnight(_dt_to_str(b.start_time), tz),
                    end=minutes_from_midnight(_dt_to_str(b.end_time), tz),
                    resource_id=b.resource,
                )
            )
    for h in holds:
        start = parse_time(h.slot_time)
        resource_occupied_list.append(
            OccupiedInterval(start=start, end=start + h.duration, resource_id=h.resource)
        )

    return AvailabilityContext(
        schedule=schedule,
        open_time=open_time,
        close_time=close_time,
        day_name=day_name,
        total_duration=total_duration,
        slot_interval=slot_interval,
        notice_cutoff_minutes=notice_cutoff_minutes,
        policy=policy,
        time_ctx=time_ctx,
        normalized_staff=normalized_staff,
        eligible_staff=eligible_staff,
        has_bookable_staff=has_bookable_staff,
        staff_occupancy=staff_occupancy,
        store_occupied=store_occupied_list,
        resource_occupied=resource_occupied_list,
        unique_required_group_ids=unique_required_group_ids,
        has_resource_requirements=has_resource_requirements,
        resources=resources,
        resource_groups=resource_groups,
        date=date,
        establishment=establishment,
        bookings=bookings,
        holds=holds,
        services=services,
    )
