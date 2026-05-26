"""Establishment CRUD routes.

Scoped under /companies/{slug}/establishments.
All routes use CompanyRepos dependency for database access.

Middleware tiers (ADR-0010):
- GET endpoints: public (no auth required)
- POST/PUT/DELETE: require_operator (JWT + role + company access guard)
"""

from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException

from mercury_core.models import Establishment
from mercury_core.models.auth import TokenClaims
from mercury_engine.dependencies import CompanyRepos, get_company_repos, get_operator

router = APIRouter(
    prefix="/companies/{slug}/establishments",
    tags=["establishments"],
)


@router.get("", response_model=list[Establishment])
async def list_establishments(
    repos: CompanyRepos = Depends(get_company_repos),
) -> list[Establishment]:
    """List all active establishments for a company."""
    return await repos.establishments.list_active()


@router.get("/{establishment_id}", response_model=Establishment)
async def get_establishment(
    establishment_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
) -> Establishment:
    """Get a single establishment by ID."""
    result = await repos.establishments.get(establishment_id)
    if not result:
        raise HTTPException(status_code=404, detail="Establishment not found")
    return result


@router.post("", response_model=Establishment, status_code=201)
async def create_establishment(
    establishment: Establishment,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> Establishment:
    """Create a new establishment. Requires operator auth."""
    return await repos.establishments.create(establishment)


@router.put("/{establishment_id}", response_model=Establishment)
async def update_establishment(
    establishment_id: str,
    establishment: Establishment,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> Establishment:
    """Update an existing establishment. Requires operator auth."""
    existing = await repos.establishments.get(establishment_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Establishment not found")
    return await repos.establishments.update(establishment_id, establishment)


@router.delete("/{establishment_id}", status_code=204)
async def delete_establishment(
    establishment_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> None:
    """Soft-delete an establishment. Requires operator auth."""
    deleted = await repos.establishments.delete(establishment_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Establishment not found")
