"""Hold model — transient slot locks managed by MercuryEngine.

Source: schemas/company-blueprint.surql §2.2
Zod origin: packages/shared-types/src/hold.ts

Holds are TTL-managed. The cleanup endpoint removes expired holds periodically.
"""

from __future__ import annotations

from datetime import datetime

from pydantic import Field

from .common import MercuryModel, PaymentStatus


class Hold(MercuryModel):
    """A temporary slot reservation (TTL-managed).

    Holds lock a time slot for a user while they complete payment or confirmation.
    They are automatically cleaned up after expiration.
    """

    id: str | None = None

    # Relationships
    user_id: str = ""
    establishment: str = ""  # record<establishment>
    services: list[str] = Field(default_factory=list)  # array<record<service>>
    staff: str | None = None  # record<staff>
    resource: str | None = None  # record<resource>

    # Slot details
    date: str = ""  # YYYY-MM-DD
    slot_time: str = ""  # HH:MM
    duration: int = 0  # minutes

    # Lifecycle
    expires_at: datetime | None = None
    created_at: datetime | None = None

    # Payment (Vipps, v1.3)
    payment_status: PaymentStatus | None = None
    vipps_order_id: str | None = None
