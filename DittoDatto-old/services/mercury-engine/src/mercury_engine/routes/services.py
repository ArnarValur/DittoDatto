"""Service CRUD routes.

Scoped under /companies/{slug}/services.
Services belong to establishments within a company database.

Middleware tiers (ADR-0010):
- GET endpoints: public (no auth required)
- POST/PUT/DELETE: require_operator (JWT + role + company access guard)
"""

from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException

from mercury_core.models import Service
from mercury_core.models.auth import TokenClaims
from mercury_engine.dependencies import CompanyRepos, get_company_repos, get_operator

router = APIRouter(
    prefix="/companies/{slug}/services",
    tags=["services"],
)


@router.get("", response_model=list[Service])
async def list_services(
    establishment_id: str | None = None,
    repos: CompanyRepos = Depends(get_company_repos),
) -> list[Service]:
    """List services, optionally filtered by establishment.

    Query params:
        establishment_id: Filter by establishment (without table prefix).
    """
    if establishment_id:
        return await repos.services.list_active_by_establishment(establishment_id)
    return await repos.services.list()


@router.get("/{service_id}", response_model=Service)
async def get_service(
    service_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
) -> Service:
    """Get a single service by ID."""
    result = await repos.services.get(service_id)
    if not result:
        raise HTTPException(status_code=404, detail="Service not found")
    return result


@router.post("", response_model=Service, status_code=201)
async def create_service(
    service: Service,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> Service:
    """Create a new service. Requires operator auth."""
    return await repos.services.create(service)


@router.put("/{service_id}", response_model=Service)
async def update_service(
    service_id: str,
    service: Service,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> Service:
    """Update an existing service. Requires operator auth."""
    existing = await repos.services.get(service_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Service not found")
    return await repos.services.update(service_id, service)


@router.delete("/{service_id}", status_code=204)
async def delete_service(
    service_id: str,
    repos: CompanyRepos = Depends(get_company_repos),
    actor: TokenClaims = Depends(get_operator),
) -> None:
    """Soft-delete a service. Requires operator auth."""
    deleted = await repos.services.delete(service_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Service not found")
