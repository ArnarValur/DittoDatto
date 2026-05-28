"""Tests for mercury_core.availability.resources — ported from resource-availability.test.ts.

Pure functions — tests resource conflict detection and best-fit allocation.
"""

from mercury_core.availability.resources import (
    OccupiedInterval,
    get_available_resources_for_slot,
)
from mercury_core.models.resource import Resource, ResourceGroup

# ============================================================================
# Test Fixtures
# ============================================================================


def make_resource(**overrides) -> Resource:
    """Factory for test resources with sensible defaults."""
    defaults = {
        "name": f"Resource {overrides.get('id', '?')}",
        "type": "room",
        "is_bookable": True,
        "priority": "normal",
        "max_capacity": 1,
        "min_capacity": 1,
        "resource_group": "group-1",
        "allow_overlapping": False,
    }
    defaults.update(overrides)
    return Resource(**defaults)


group1 = ResourceGroup(id="group-1", name="Treatment Rooms")
group2 = ResourceGroup(id="group-2", name="Equipment")


# ============================================================================
# get_available_resources_for_slot
# ============================================================================


class TestGetAvailableResourcesForSlot:
    # --- No requirements ---

    def test_returns_available_when_no_groups_required(self):
        result = get_available_resources_for_slot([], [], [], 540, 600, [])
        assert result.available is True
        assert result.assigned_resources == []

    def test_returns_available_when_empty_required_groups(self):
        result = get_available_resources_for_slot([], [], [], 540, 600, [])
        assert result.available is True

    # --- Single group, single resource ---

    def test_assigns_free_resource(self):
        resources = [make_resource(id="r1", resource_group="group-1")]
        result = get_available_resources_for_slot(
            resources, [group1], ["group-1"], 540, 600, []
        )
        assert result.available is True
        assert len(result.assigned_resources) == 1
        assert result.assigned_resources[0].id == "r1"

    def test_returns_unavailable_when_only_resource_occupied(self):
        resources = [make_resource(id="r1", resource_group="group-1")]
        occupied = [OccupiedInterval(start=530, end=590, resource_id="r1")]
        result = get_available_resources_for_slot(
            resources, [group1], ["group-1"], 540, 600, occupied
        )
        assert result.available is False

    def test_assigns_free_resource_when_one_of_two_occupied(self):
        resources = [
            make_resource(id="r1", resource_group="group-1"),
            make_resource(id="r2", resource_group="group-1"),
        ]
        occupied = [OccupiedInterval(start=530, end=590, resource_id="r1")]
        result = get_available_resources_for_slot(
            resources, [group1], ["group-1"], 540, 600, occupied
        )
        assert result.available is True
        assert result.assigned_resources[0].id == "r2"

    # --- Non-overlapping times ---

    def test_treats_non_overlapping_intervals_as_free(self):
        resources = [make_resource(id="r1", resource_group="group-1")]
        # Occupied 08:00-09:00, slot 09:00-10:00 → no overlap
        occupied = [OccupiedInterval(start=480, end=540, resource_id="r1")]
        result = get_available_resources_for_slot(
            resources, [group1], ["group-1"], 540, 600, occupied
        )
        assert result.available is True

    # --- Priority + best-fit sorting ---

    def test_assigns_high_priority_first(self):
        resources = [
            make_resource(id="r-normal", resource_group="group-1", priority="normal"),
            make_resource(id="r-high", resource_group="group-1", priority="high"),
        ]
        result = get_available_resources_for_slot(
            resources, [group1], ["group-1"], 540, 600, []
        )
        assert result.assigned_resources[0].id == "r-high"

    def test_assigns_smallest_capacity_within_same_priority(self):
        resources = [
            make_resource(id="r-big", resource_group="group-1", max_capacity=10),
            make_resource(id="r-small", resource_group="group-1", max_capacity=2),
        ]
        result = get_available_resources_for_slot(
            resources, [group1], ["group-1"], 540, 600, []
        )
        assert result.assigned_resources[0].id == "r-small"

    # --- Multiple required groups ---

    def test_assigns_one_resource_from_each_group(self):
        resources = [
            make_resource(id="room-1", resource_group="group-1"),
            make_resource(id="equip-1", resource_group="group-2"),
        ]
        result = get_available_resources_for_slot(
            resources, [group1, group2], ["group-1", "group-2"], 540, 600, []
        )
        assert result.available is True
        assert len(result.assigned_resources) == 2
        assigned_ids = [r.id for r in result.assigned_resources]
        assert "room-1" in assigned_ids
        assert "equip-1" in assigned_ids

    def test_returns_unavailable_if_any_group_has_no_free_resources(self):
        resources = [
            make_resource(id="room-1", resource_group="group-1"),
            make_resource(id="equip-1", resource_group="group-2"),
        ]
        occupied = [OccupiedInterval(start=530, end=590, resource_id="equip-1")]
        result = get_available_resources_for_slot(
            resources, [group1, group2], ["group-1", "group-2"], 540, 600, occupied
        )
        assert result.available is False

    # --- allowOverlapping ---

    def test_allows_overlapping_resources(self):
        resources = [
            make_resource(id="r1", resource_group="group-1", allow_overlapping=True),
        ]
        occupied = [OccupiedInterval(start=530, end=590, resource_id="r1")]
        result = get_available_resources_for_slot(
            resources, [group1], ["group-1"], 540, 600, occupied
        )
        assert result.available is True

    # --- Non-bookable resources ---

    def test_skips_non_bookable_resources(self):
        resources = [
            make_resource(id="r1", resource_group="group-1", is_bookable=False),
        ]
        result = get_available_resources_for_slot(
            resources, [group1], ["group-1"], 540, 600, []
        )
        assert result.available is False

    # --- Occupied intervals without resourceId ---

    def test_ignores_intervals_without_resource_id(self):
        resources = [make_resource(id="r1", resource_group="group-1")]
        occupied = [OccupiedInterval(start=530, end=590)]  # No resource_id
        result = get_available_resources_for_slot(
            resources, [group1], ["group-1"], 540, 600, occupied
        )
        assert result.available is True
