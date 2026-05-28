"""MercuryEngine — Hold Allocation Resolver.

Replaces: packages/mercury-engine/src/core/bookings/hold.ts → resolveHoldAllocation

Pure function — determines staff/resource assignment and composite holdId
without touching the database.
"""

from __future__ import annotations

from dataclasses import dataclass

from mercury_core.availability.context import AvailabilityContext, OccupiedInterval
from mercury_core.availability.resources import (
    OccupiedInterval as ResourceOccupiedInterval,
)
from mercury_core.availability.resources import (
    get_available_resources_for_slot,
)
from mercury_core.availability.staff import is_staff_available
from mercury_core.errors import SlotUnavailableError
from mercury_core.time import parse_time


@dataclass
class HoldAllocationResult:
    """Result of hold allocation resolution."""

    hold_id: str
    total_duration: int
    final_staff_id: str | None = None
    assigned_resource_id: str | None = None


def _intervals_overlap(
    slot_start: int, slot_end: int, intervals: list[OccupiedInterval]
) -> bool:
    return any(slot_start < i.end and slot_end > i.start for i in intervals)


def resolve_hold_allocation(
    ctx: AvailabilityContext,
    store_id: str,
    slot_time: str,
    user_id: str,
    requested_staff_id: str | None = None,
) -> HoldAllocationResult:
    """Resolve staff/resource allocation for a new hold.

    This is the pure concurrency resolution function. It does NOT write to
    the database — it only determines WHAT should be allocated.

    Args:
        ctx: Fully built AvailabilityContext.
        store_id: Establishment ID.
        slot_time: Requested slot time (HH:MM).
        user_id: User requesting the hold.
        requested_staff_id: Optional specific staff member requested.

    Returns:
        HoldAllocationResult with holdId, duration, staff/resource assignment.

    Raises:
        SlotUnavailableError: If the slot is not available.
    """
    # Sanitize stringified null/undefined from network layer
    if requested_staff_id in ("undefined", "null", ""):
        requested_staff_id = None

    slot_start = parse_time(slot_time)
    slot_end = slot_start + ctx.total_duration
    differentiator = user_id  # default: user-based dedup

    # ---- Staff resolution ----
    final_staff_id: str | None = None
    if ctx.has_bookable_staff:
        if requested_staff_id:
            # Validate the requested staff is eligible
            matching = [s for s in ctx.eligible_staff if s.id == requested_staff_id]
            if not matching:
                raise SlotUnavailableError(
                    "Requested staff member cannot perform all selected services"
                )
            staff = matching[0]
            if not is_staff_available(staff, ctx.date, slot_start, slot_end):
                raise SlotUnavailableError("This time slot is no longer available")
            staff_intervals = ctx.staff_occupancy.get(staff.id or "", [])
            if _intervals_overlap(slot_start, slot_end, staff_intervals):
                raise SlotUnavailableError("This time slot is no longer available")
            final_staff_id = requested_staff_id
        else:
            # Auto-assign: find first free staff
            for staff in ctx.eligible_staff:
                if not staff.id:
                    continue
                if not is_staff_available(staff, ctx.date, slot_start, slot_end):
                    continue
                staff_intervals = ctx.staff_occupancy.get(staff.id, [])
                if not _intervals_overlap(slot_start, slot_end, staff_intervals):
                    final_staff_id = staff.id
                    break

            if final_staff_id is None:
                raise SlotUnavailableError("This time slot is no longer available")

        differentiator = final_staff_id

    # ---- Resource resolution ----
    assigned_resource_id: str | None = None
    if ctx.has_resource_requirements:
        resource_intervals = [
            ResourceOccupiedInterval(
                start=occ.start, end=occ.end, resource_id=occ.resource_id
            )
            for occ in ctx.resource_occupied
        ]
        result = get_available_resources_for_slot(
            ctx.resources,
            ctx.resource_groups,
            ctx.unique_required_group_ids,
            slot_start,
            slot_end,
            resource_intervals,
        )
        if not result.available:
            raise SlotUnavailableError("This time slot is no longer available")
        if result.assigned_resources:
            assigned_resource_id = result.assigned_resources[0].id
            differentiator = assigned_resource_id or differentiator

    # ---- Store-level fallback (no staff, no resources) ----
    if (
        not ctx.has_bookable_staff
        and not ctx.has_resource_requirements
        and _intervals_overlap(slot_start, slot_end, ctx.store_occupied)
    ):
        raise SlotUnavailableError("This time slot is no longer available")

    # Build composite holdId
    hold_id = f"{store_id}_{ctx.date}_{slot_time}_{differentiator}"

    return HoldAllocationResult(
        hold_id=hold_id,
        total_duration=ctx.total_duration,
        final_staff_id=final_staff_id,
        assigned_resource_id=assigned_resource_id,
    )
