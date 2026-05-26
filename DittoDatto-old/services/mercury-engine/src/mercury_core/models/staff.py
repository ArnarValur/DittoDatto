"""Staff and DateOverride models.

Source: schemas/company-blueprint.surql §1.4, §3.1
Zod origin: packages/shared-types/src/staff.ts, shift.ts
"""

from __future__ import annotations

from datetime import datetime

from pydantic import Field

from .common import (
    DateOverrideType,
    MercuryModel,
    ShiftDay,
    SoftDeleteMixin,
    StaffStatus,
    TimeBlock,
    TimestampMixin,
)


class Staff(MercuryModel, TimestampMixin, SoftDeleteMixin):
    """A staff member who can be assigned to establishments and services.

    Auth link (user_id) is a cross-DB reference to enceladus/users — stored as
    string, not record link (different namespace).
    """

    id: str | None = None

    # Auth link (cross-DB reference — enceladus/users)
    user_id: str | None = None
    email: str = ""
    display_name: str = ""
    avatar_url: str | None = None

    # Multi-store assignment (record links as strings)
    store_ids: list[str] = Field(default_factory=list)
    position: str | None = None

    # Capabilities
    default_capabilities: list[str] = Field(default_factory=list)
    store_capabilities: dict[str, list[str]] = Field(default_factory=dict)

    # Bookability
    is_bookable: bool = False
    show_on_storefront: bool = False

    # Weekly shifts (embedded — dict with day keys: mon, tue, ..., sun)
    weekly_shifts: dict[str, ShiftDay] | None = None

    # Lifecycle
    status: StaffStatus = StaffStatus.INVITED
    invited_at: datetime | None = None
    joined_at: datetime | None = None


class DateOverride(MercuryModel):
    """Staff schedule override for a specific date.

    Separate table for scalability — staff accumulate overrides over years.
    Source: company-blueprint.surql §3.1
    """

    id: str | None = None
    staff: str = ""  # record<staff>
    date: str = ""  # YYYY-MM-DD
    type: DateOverrideType = DateOverrideType.OFF
    reason: str | None = None
    blocks: list[TimeBlock] | None = None
    created_at: datetime | None = None
