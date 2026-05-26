"""Admin routes — platform management endpoints.

All endpoints under /admin require ADMIN or SUPER_ADMIN role (ADR-0011).
These are platform-wide operations — no company slug scoping.

Covers:
- Dashboard stats (user/company/category counts + health)
- User management (list, get, role change)
- Company registry CRUD
- Category taxonomy CRUD
"""

from __future__ import annotations

import logging
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, Field

from mercury_core.models.auth import ActorRole, TokenClaims
from mercury_core.models.category import Category
from mercury_core.models.company import Company
from mercury_core.models.user import User
from mercury_core.repositories.categories import CategoryRepository
from mercury_core.repositories.companies import CompanyRepository
from mercury_core.repositories.users import UserRepository
from mercury_engine.dependencies import (
    get_admin,
    get_category_repo,
    get_company_repo,
    get_user_repo,
)

router = APIRouter(prefix="/admin", tags=["admin"])

logger = logging.getLogger("mercury-engine.admin")


# ─── Request/Response DTOs ───────────────────────────────────────────────


class AdminStats(BaseModel):
    """Dashboard statistics response."""

    user_count: int
    company_count: int
    category_count: int
    engine_healthy: bool


class RoleUpdateRequest(BaseModel):
    """Request body for PUT /admin/users/{id}/role."""

    role: ActorRole = Field(..., description="New role to assign")


class PaginatedUsers(BaseModel):
    """Paginated user list response."""

    items: list[User]
    total: int
    limit: int
    offset: int


class PaginatedCompanies(BaseModel):
    """Paginated company list response."""

    items: list[Company]
    total: int
    limit: int
    offset: int


# ─── Stats ───────────────────────────────────────────────────────────────


@router.get("/stats", response_model=AdminStats)
async def get_stats(
    actor: TokenClaims = Depends(get_admin),
    user_repo: UserRepository = Depends(get_user_repo),
    company_repo: CompanyRepository = Depends(get_company_repo),
    category_repo: CategoryRepository = Depends(get_category_repo),
) -> AdminStats:
    """Dashboard stats — live counts from SurrealDB.

    Returns user, company, and category counts plus engine health status.
    Low-traffic endpoint (admin panel only), so live queries are fine.
    """
    user_count = await user_repo.count()
    company_count = await company_repo.count()
    category_count = await category_repo.count()

    return AdminStats(
        user_count=user_count,
        company_count=company_count,
        category_count=category_count,
        engine_healthy=True,
    )


# ─── Users ───────────────────────────────────────────────────────────────


@router.get("/users", response_model=PaginatedUsers)
async def list_users(
    actor: TokenClaims = Depends(get_admin),
    user_repo: UserRepository = Depends(get_user_repo),
    limit: Annotated[int, Query(ge=1, le=100)] = 50,
    offset: Annotated[int, Query(ge=0)] = 0,
) -> PaginatedUsers:
    """List all platform users (paginated).

    Returns users with limit/offset pagination.
    """
    total = await user_repo.count()
    users = await user_repo.list(limit=limit, offset=offset)

    return PaginatedUsers(
        items=users,
        total=total,
        limit=limit,
        offset=offset,
    )


@router.get("/users/{user_id}", response_model=User)
async def get_user(
    user_id: str,
    actor: TokenClaims = Depends(get_admin),
    user_repo: UserRepository = Depends(get_user_repo),
) -> User:
    """Get a single user by ID."""
    user = await user_repo.get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@router.put("/users/{user_id}/role", response_model=User)
async def update_user_role(
    user_id: str,
    body: RoleUpdateRequest,
    actor: TokenClaims = Depends(get_admin),
    user_repo: UserRepository = Depends(get_user_repo),
) -> User:
    """Change a user's platform role.

    Only SUPER_ADMIN can promote to ADMIN or SUPER_ADMIN.
    ADMIN can assign OPERATOR roles.
    """
    user = await user_repo.get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Guard: only super_admin can grant admin-level roles
    if (
        body.role in (ActorRole.ADMIN, ActorRole.SUPER_ADMIN)
        and actor.role != ActorRole.SUPER_ADMIN
    ):
        raise HTTPException(
            status_code=403,
            detail="Only super_admin can grant admin roles",
        )

    user.role = body.role
    updated = await user_repo.update(user_id, user)
    logger.info(
        "Role updated: user=%s role=%s by=%s",
        user_id,
        body.role,
        actor.sub,
    )
    return updated


# ─── Companies ───────────────────────────────────────────────────────────


@router.get("/companies", response_model=PaginatedCompanies)
async def list_companies(
    actor: TokenClaims = Depends(get_admin),
    company_repo: CompanyRepository = Depends(get_company_repo),
    limit: Annotated[int, Query(ge=1, le=100)] = 50,
    offset: Annotated[int, Query(ge=0)] = 0,
) -> PaginatedCompanies:
    """List all registered companies (paginated)."""
    total = await company_repo.count()
    companies = await company_repo.list(limit=limit, offset=offset)

    return PaginatedCompanies(
        items=companies,
        total=total,
        limit=limit,
        offset=offset,
    )


@router.post("/companies", response_model=Company, status_code=201)
async def create_company(
    company: Company,
    actor: TokenClaims = Depends(get_admin),
    company_repo: CompanyRepository = Depends(get_company_repo),
) -> Company:
    """Create a new company registry entry.

    This creates the record in titan/platform.company.
    Database provisioning (titan/company_{slug}) is handled
    separately via Surrealist — see ADR-0011 §2.
    """
    # Set db_slug to match slug for database mapping
    if not company.db_slug:
        company.db_slug = company.slug

    created = await company_repo.create(company)
    logger.info(
        "Company created: slug=%s by=%s",
        company.slug,
        actor.sub,
    )
    return created


@router.put("/companies/{company_id}", response_model=Company)
async def update_company(
    company_id: str,
    company: Company,
    actor: TokenClaims = Depends(get_admin),
    company_repo: CompanyRepository = Depends(get_company_repo),
) -> Company:
    """Update a company's registry entry."""
    existing = await company_repo.get(company_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Company not found")

    updated = await company_repo.update(company_id, company)
    logger.info(
        "Company updated: id=%s by=%s",
        company_id,
        actor.sub,
    )
    return updated


# ─── Categories ──────────────────────────────────────────────────────────


@router.get("/categories", response_model=list[Category])
async def list_categories(
    actor: TokenClaims = Depends(get_admin),
    category_repo: CategoryRepository = Depends(get_category_repo),
) -> list[Category]:
    """List all platform categories.

    No pagination — category count is expected to be small (< 100).
    """
    return await category_repo.list()


@router.post("/categories", response_model=Category, status_code=201)
async def create_category(
    category: Category,
    actor: TokenClaims = Depends(get_admin),
    category_repo: CategoryRepository = Depends(get_category_repo),
) -> Category:
    """Create a new platform category."""
    created = await category_repo.create(category)
    logger.info(
        "Category created: slug=%s by=%s",
        category.slug,
        actor.sub,
    )
    return created


@router.put("/categories/{category_id}", response_model=Category)
async def update_category(
    category_id: str,
    category: Category,
    actor: TokenClaims = Depends(get_admin),
    category_repo: CategoryRepository = Depends(get_category_repo),
) -> Category:
    """Update an existing category."""
    existing = await category_repo.get(category_id)
    if not existing:
        raise HTTPException(status_code=404, detail="Category not found")

    updated = await category_repo.update(category_id, category)
    logger.info(
        "Category updated: id=%s by=%s",
        category_id,
        actor.sub,
    )
    return updated


@router.delete("/categories/{category_id}", status_code=204)
async def delete_category(
    category_id: str,
    actor: TokenClaims = Depends(get_admin),
    category_repo: CategoryRepository = Depends(get_category_repo),
) -> None:
    """Delete a category (hard delete — no soft-delete for taxonomy)."""
    deleted = await category_repo.delete(category_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Category not found")
    logger.info(
        "Category deleted: id=%s by=%s",
        category_id,
        actor.sub,
    )
