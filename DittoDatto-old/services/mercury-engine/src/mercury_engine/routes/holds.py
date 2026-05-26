"""Hold routes — transient slot lock management.

Scoped under /companies/{slug}/holds.
Holds are temporary slot reservations with TTL expiration.

Key operations:
- POST: Create a hold (lock a time slot)
- GET: Check hold status
- DELETE: Release hold (hard delete — holds are transient)
- POST confirm: Convert hold → booking (orchestration endpoint)

Middleware tiers (ADR-0010):
- All endpoints: require_auth (any authenticated user)
"""

from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException

from mercury_core.models import Booking, Hold
from mercury_core.models.auth import TokenClaims
from mercury_engine.dependencies import CompanyRepos, get_company_repos, get_current_user

router = APIRouter(
    prefix="/companies/{slug}/holds",
    tags=["holds"],
)


@router.post("", response_model=Hold, status_code=201)
async def create_hold(
    hold: Hold,
    repos: CompanyRepos = Depends(get_company_repos),
    user: TokenClaims = Depends(get_current_user),
) -> Hold:
    """Create a hold to lock a time slot.

    The hold expires after the TTL defined in expires_at.
    Expired holds are cleaned up periodically by the engine.
    """
    return await repos.holds.create(hold)


@router.get("/{hold_id}", response_model=Hold)
async def get_hold(
    hold_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
    user: TokenClaims = Depends(get_current_user),
) -> Hold:
    """Get hold status. Returns 404 if expired or released."""
    result = await repos.holds.get(hold_id)
    if not result:
        raise HTTPException(status_code=404, detail="Hold not found or expired")
    return result


@router.delete("/{hold_id}", status_code=204)
async def release_hold(
    hold_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
    user: TokenClaims = Depends(get_current_user),
) -> None:
    """Release a hold (hard delete — frees the slot immediately)."""
    existing = await repos.holds.get(hold_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Hold not found or expired")
    await repos.holds.delete(hold_id)


@router.post("/{hold_id}/confirm", response_model=Booking, status_code=201)
async def confirm_hold(
    hold_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
    user: TokenClaims = Depends(get_current_user),
) -> Booking:
    """Convert a hold into a confirmed booking.

    This is the core orchestration endpoint:
    1. Fetch the hold
    2. Create a booking from the hold data
    3. Delete the hold (hard delete)
    4. Return the new booking

    Future: payment verification via Vipps happens before step 2.
    """
    hold = await repos.holds.get(hold_id)
    if not hold:
        raise HTTPException(status_code=404, detail="Hold not found or expired")

    # Build booking from hold data
    booking = Booking(
        user_id=hold.user_id,
        establishment=hold.establishment,
        service=hold.services[0] if hold.services else "",
        staff=hold.staff,
        resource=hold.resource,
        status="confirmed",
        service_title="",  # Populated by frontend or enrichment layer
        duration=hold.duration,
        price_at_booking=0.0,  # Populated by pricing engine
        user_name="",  # Populated from user profile
        user_email="",  # Populated from user profile
    )

    created_booking = await repos.bookings.create(booking)

    # Release the hold — slot is now booked
    await repos.holds.delete(hold_id)

    return created_booking
