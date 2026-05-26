"""MercuryEngine — Availability domain.

Re-exports from submodules for clean imports.
"""

from mercury_core.availability.staff import (
    get_available_staff_for_slot,
    is_staff_available,
)

__all__ = [
    "get_available_staff_for_slot",
    "is_staff_available",
]
