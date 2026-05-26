"""MercuryEngine — Resource availability logic.

Replaces: packages/mercury-engine/src/core/shared/resource-availability.ts

Pure functions — no database dependency, fully testable.
For each required resource group, find >= 1 bookable resource not occupied
in the time window. If ALL required groups have an available resource,
the slot is bookable from a resource perspective.
"""

from __future__ import annotations

from dataclasses import dataclass, field

from mercury_core.models.resource import Resource, ResourceGroup


@dataclass
class OccupiedInterval:
    """Occupied interval in minutes from midnight."""

    start: int
    end: int
    resource_id: str | None = None


@dataclass
class ResourceAvailabilityResult:
    """Result of resource availability check."""

    available: bool
    assigned_resources: list[Resource] = field(default_factory=list)


# Priority sort order (lower value = preferred first)
_PRIORITY_ORDER = {"high": 0, "normal": 1, "low": 2}


def get_available_resources_for_slot(
    resources: list[Resource],
    resource_groups: list[ResourceGroup],
    required_group_ids: list[str],
    slot_start: int,
    slot_end: int,
    occupied_intervals: list[OccupiedInterval],
) -> ResourceAvailabilityResult:
    """Check if resources are available for a given slot.

    Args:
        resources: All bookable resources for the store.
        resource_groups: All resource groups for the store.
        required_group_ids: Resource group IDs required by the service.
        slot_start: Start of the slot (minutes from midnight).
        slot_end: End of the slot (minutes from midnight).
        occupied_intervals: All occupied intervals (from bookings + holds).

    Returns:
        ResourceAvailabilityResult with availability status and assigned resources.
    """
    # No resource requirements → always available
    if not required_group_ids:
        return ResourceAvailabilityResult(available=True, assigned_resources=[])

    assigned_resources: list[Resource] = []
    used_resource_ids: set[str] = set()

    # Check each required group — all must have >= 1 available resource
    for group_id in required_group_ids:
        group_resources = [
            r for r in resources if r.resource_group == group_id and r.is_bookable
        ]

        # Sort by priority (high > normal > low), then by capacity (smallest first = best-fit)
        group_resources.sort(key=lambda r: (
            _PRIORITY_ORDER.get(r.priority, 1),
            r.max_capacity,
        ))

        found_resource: Resource | None = None

        for resource in group_resources:
            # Skip already-assigned resources (one resource per group per slot)
            if resource.id and resource.id in used_resource_ids:
                continue

            # Check if this resource is occupied during the slot
            is_occupied = any(
                occ.resource_id == resource.id
                and slot_start < occ.end
                and slot_end > occ.start
                for occ in occupied_intervals
                if occ.resource_id  # Only check intervals tied to a specific resource
            )

            if not is_occupied or resource.allow_overlapping:
                found_resource = resource
                break

        if not found_resource:
            # This required group has no available resource → slot not bookable
            return ResourceAvailabilityResult(available=False, assigned_resources=[])

        assigned_resources.append(found_resource)
        if found_resource.id:
            used_resource_ids.add(found_resource.id)

    return ResourceAvailabilityResult(available=True, assigned_resources=assigned_resources)
