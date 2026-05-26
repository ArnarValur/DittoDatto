"""Customer model — cross-DB projection from enceladus/users.

Source: schemas/company-blueprint.surql §1.5
Zod origin: packages/shared-types/src/customer.ts

Direction: enceladus → company_X. Never reverse. (Session 9 contract)
This is a CRM view of the customer within a specific company database.
The authoritative user record lives in enceladus/users.
"""

from __future__ import annotations

from datetime import datetime

from pydantic import Field

from .common import (
    CustomerChannel,
    CustomerStatus,
    MercuryModel,
    SoftDeleteMixin,
    TimestampMixin,
)


class Customer(MercuryModel, TimestampMixin, SoftDeleteMixin):
    """A customer as seen by a specific company (CRM projection).

    The user_id links back to enceladus/users via string (cross-namespace,
    cannot use record link).
    """

    id: str | None = None

    # Cross-DB reference (string, not record link — different namespace)
    user_id: str | None = None
    store_ids: list[str] = Field(default_factory=list)

    # Profile
    name: str = ""
    first_name: str | None = None
    last_name: str | None = None
    email: str | None = None
    phone: str | None = None
    phone_country_code: str | None = None

    # CRM
    notes: str | None = None
    status: CustomerStatus = CustomerStatus.NEW
    staff_ids: list[str] = Field(default_factory=list)
    channel: CustomerChannel = CustomerChannel.APP

    # Booking refs
    last_booking: str | None = None  # record<booking>

    # Metrics
    total_visits: int = 0
    total_spent: float = 0.0
    first_visit_at: datetime | None = None
    last_visit_at: datetime | None = None
