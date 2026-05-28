"""Booking CRUD routes.

Scoped under /companies/{slug}/bookings.
The core transactional entity — represents confirmed or pending appointments.

Middleware tiers (ADR-0010):
- GET list: require_operator (operator dashboard view)
- GET single: public (customer can view own booking)
- POST: require_operator (direct creation from portal/admin)
- PUT: require_operator (status changes, cancellations)
- DELETE: require_operator (soft-delete)
"""

from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException, Query

from mercury_core.models import Booking
from mercury_core.models.auth import TokenClaims
from mercury_core.models.common import BookingStatus
from mercury_engine.dependencies import CompanyRepos, get_company_repos, get_operator

router = APIRouter(
    prefix="/companies/{slug}/bookings",
    tags=["bookings"],
)


@router.get("", response_model=list[Booking])
async def list_bookings(
    establishment_id: str | None = Query(None),
    status: BookingStatus | None = Query(None),
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> list[Booking]:
    """List bookings, optionally filtered by establishment and/or status.

    Requires operator auth — this is the operator dashboard view.
    """
    filters: dict[str, object] = {}
    if establishment_id:
        filters["establishment_id"] = establishment_id
    if status:
        filters["status"] = status

    if establishment_id:
        return await repos.bookings.list_by_establishment(
            establishment_id, status=status.value if status else None
        )
    return await repos.bookings.list(**filters)


@router.get("/{booking_id}", response_model=Booking)
async def get_booking(
    booking_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
) -> Booking:
    """Get a single booking by ID."""
    result = await repos.bookings.get(booking_id)
    if not result:
        raise HTTPException(status_code=404, detail="Booking not found")
    return result


@router.post("", response_model=Booking, status_code=201)
async def create_booking(
    booking: Booking,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> Booking:
    """Create a booking. Requires operator auth.

    In the full flow, bookings are created by confirming a hold.
    This endpoint exists for direct creation (e.g., portal, admin).
    """
    return await repos.bookings.create(booking)


@router.put("/{booking_id}", response_model=Booking)
async def update_booking(
    booking_id: str,
    booking: Booking,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> Booking:
    """Update a booking (status change, cancellation, etc.). Requires operator auth."""
    existing = await repos.bookings.get(booking_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Booking not found")
    return await repos.bookings.update(booking_id, booking)


@router.delete("/{booking_id}", status_code=204)
async def delete_booking(
    booking_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> None:
    """Soft-delete a booking. Requires operator auth."""
    deleted = await repos.bookings.delete(booking_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Booking not found")
