"""Resource and ResourceGroup models.

Source: schemas/company-blueprint.surql §4.1–4.2
Zod origin: packages/shared-types/src/resource.ts

Resources represent physical or logical entities (rooms, tables, stations, equipment)
that can be assigned to bookings. The best-fit allocation algorithm in
resource-availability.ts uses these for optimal resource matching.
"""

from __future__ import annotations

from .common import (
    Currency,
    MercuryModel,
    ResourcePriority,
    ResourceType,
    TimestampMixin,
)


class ResourceGroup(MercuryModel, TimestampMixin):
    """Logical grouping of resources (e.g., 'Massage Rooms', 'Window Tables')."""

    id: str | None = None
    establishment: str = ""  # record<establishment>
    name: str = ""
    description: str | None = None
    sort_order: int = 0
    show_on_storefront: bool = False


class Resource(MercuryModel, TimestampMixin):
    """A bookable physical or logical resource.

    Used in the best-fit allocation algorithm during hold creation.
    """

    id: str | None = None
    establishment: str = ""  # record<establishment>
    resource_group: str | None = None  # record<resource_group>

    # Identity
    name: str = ""
    description: str | None = None
    type: ResourceType = ResourceType.ROOM

    # Capacity (table reservation mode)
    min_capacity: int = 1
    max_capacity: int = 1

    # Pricing (add-on resources)
    price: float | None = None
    currency: Currency = Currency.NOK

    image_url: str | None = None

    # Booking behavior
    is_bookable: bool = True
    allow_overlapping: bool = False
    booking_interval: int | None = None
    priority: ResourcePriority = ResourcePriority.NORMAL
    sort_order: int = 0
