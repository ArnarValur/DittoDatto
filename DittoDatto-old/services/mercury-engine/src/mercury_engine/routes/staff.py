"""Staff CRUD routes.

Scoped under /companies/{slug}/staff.
Staff members can be assigned to multiple establishments within a company.

Middleware tiers (ADR-0010):
- GET endpoints: public (no auth required)
- POST/PUT/DELETE: require_operator (JWT + role + company access guard)
"""

from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException

from mercury_core.models import Staff
from mercury_core.models.auth import TokenClaims
from mercury_engine.dependencies import CompanyRepos, get_company_repos, get_operator

router = APIRouter(
    prefix="/companies/{slug}/staff",
    tags=["staff"],
)


@router.get("", response_model=list[Staff])
async def list_staff(
    establishment_id: str | None = None,
    repos: CompanyRepos = Depends(get_company_repos),
) -> list[Staff]:
    """List staff, optionally filtered by establishment.

    Query params:
        establishment_id: Filter by establishment (without table prefix).
    """
    if establishment_id:
        return await repos.staff.list_by_establishment(establishment_id)
    return await repos.staff.list()


@router.get("/{staff_id}", response_model=Staff)
async def get_staff(
    staff_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
) -> Staff:
    """Get a single staff member by ID."""
    result = await repos.staff.get(staff_id)
    if not result:
        raise HTTPException(status_code=404, detail="Staff member not found")
    return result


@router.post("", response_model=Staff, status_code=201)
async def create_staff(
    staff: Staff,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> Staff:
    """Create a new staff member. Requires operator auth."""
    return await repos.staff.create(staff)


@router.put("/{staff_id}", response_model=Staff)
async def update_staff(
    staff_id: str,
    staff: Staff,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> Staff:
    """Update an existing staff member. Requires operator auth."""
    existing = await repos.staff.get(staff_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Staff member not found")
    return await repos.staff.update(staff_id, staff)


@router.delete("/{staff_id}", status_code=204)
async def delete_staff(
    staff_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> None:
    """Soft-delete a staff member. Requires operator auth."""
    deleted = await repos.staff.delete(staff_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Staff member not found")
