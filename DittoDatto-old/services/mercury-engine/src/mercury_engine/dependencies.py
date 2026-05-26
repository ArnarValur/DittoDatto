"""FastAPI dependency injection for SurrealDB-backed repositories.

Provides request-scoped repository bundles tied to a company slug.
The company slug comes from the URL path parameter (/companies/{slug}/...).

Usage in route handlers:
    @router.get("/companies/{slug}/services")
    async def list_services(repos: CompanyRepos = Depends(get_company_repos)):
        return await repos.services.list_active_by_establishment(...)

Auth dependencies (Session 16):
    @router.post("/companies/{slug}/services")
    async def create_service(
        ...,
        actor: TokenClaims = Depends(get_operator),
    ):
        ...

Admin dependencies (Session 18 — ADR-0011):
    @router.get("/admin/users")
    async def list_users(
        actor: TokenClaims = Depends(get_admin),
    ):
        ...

Architecture:
- SurrealDBClient is a singleton on app.state (created at startup)
- CompanyRepos is a bundle of repositories scoped to one company DB
- get_company_repos() extracts the slug from the path and scopes the connection
- Auth dependencies chain: get_current_user → get_operator (with company guard)
- Admin dependencies: get_admin → require_admin (platform-wide, no company scope)
"""

from __future__ import annotations

from dataclasses import dataclass

from fastapi import Depends, Path, Request

from mercury_core.models.auth import TokenClaims
from mercury_core.repositories import (
    BookingRepository,
    CategoryRepository,
    CompanyRepository,
    CustomerRepository,
    DateOverrideRepository,
    EstablishmentRepository,
    HoldRepository,
    ResourceGroupRepository,
    ResourceRepository,
    ServiceGroupRepository,
    ServiceRepository,
    StaffRepository,
    UserRepository,
)
from mercury_engine.auth.middleware import require_admin, require_auth, require_operator
from mercury_engine.db.adapters import (
    SurrealBookingRepo,
    SurrealCategoryRepo,
    SurrealCompanyRepo,
    SurrealCustomerRepo,
    SurrealDateOverrideRepo,
    SurrealEstablishmentRepo,
    SurrealHoldRepo,
    SurrealResourceGroupRepo,
    SurrealResourceRepo,
    SurrealServiceGroupRepo,
    SurrealServiceRepo,
    SurrealStaffRepo,
    SurrealUserRepo,
)
from mercury_engine.db.client import SurrealDBClient


@dataclass
class CompanyRepos:
    """Bundle of repositories scoped to a single company database.

    All repositories share the same SurrealDB connection, pre-scoped
    to the company's database via db.use("titan", f"company_{slug}").
    """

    establishments: EstablishmentRepository
    services: ServiceRepository
    service_groups: ServiceGroupRepository
    staff: StaffRepository
    date_overrides: DateOverrideRepository
    bookings: BookingRepository
    holds: HoldRepository
    resources: ResourceRepository
    resource_groups: ResourceGroupRepository
    customers: CustomerRepository


def get_db(request: Request) -> SurrealDBClient:
    """Get the shared SurrealDB client from app state.

    The client is created during app startup (lifespan) and stored
    on app.state.db.
    """
    return request.app.state.db


async def get_company_repos(
    slug: str = Path(..., description="Company URL slug"),
    db: SurrealDBClient = Depends(get_db),
) -> CompanyRepos:
    """Get a repository bundle scoped to a specific company.

    Extracts the company slug from the URL path, calls
    db.use("titan", f"company_{slug}") to scope the connection,
    then creates adapter instances for all repository types.

    Args:
        slug: Company slug from the URL path parameter.
        db: The shared SurrealDB client.

    Returns:
        A CompanyRepos bundle with all repositories ready for use.
    """
    conn = await db.titan(slug)

    return CompanyRepos(
        establishments=SurrealEstablishmentRepo(conn),
        services=SurrealServiceRepo(conn),
        service_groups=SurrealServiceGroupRepo(conn),
        staff=SurrealStaffRepo(conn),
        date_overrides=SurrealDateOverrideRepo(conn),
        bookings=SurrealBookingRepo(conn),
        holds=SurrealHoldRepo(conn),
        resources=SurrealResourceRepo(conn),
        resource_groups=SurrealResourceGroupRepo(conn),
        customers=SurrealCustomerRepo(conn),
    )


# ─── Auth dependencies (Session 16) ─────────────────────────────────────


async def get_user_repo(
    db: SurrealDBClient = Depends(get_db),
) -> UserRepository:
    """Get the user repository (enceladus/users).

    Unlike company repos, users live in the shared enceladus namespace.
    """
    conn = await db.enceladus()
    return SurrealUserRepo(conn)


async def get_current_user(
    claims: TokenClaims = Depends(require_auth),
) -> TokenClaims:
    """Get the authenticated user's claims.

    Wraps require_auth for semantic clarity in route handlers.
    Used by holds routes (any authenticated user).
    """
    return claims


async def get_operator(
    claims: TokenClaims = Depends(require_operator),
) -> TokenClaims:
    """Get an authenticated operator with company access verified.

    Wraps require_operator for semantic clarity in route handlers.
    Used by establishments, services, staff, and bookings write endpoints.
    """
    return claims


# ─── Admin dependencies (Session 18 — ADR-0011) ─────────────────────────


async def get_admin(
    claims: TokenClaims = Depends(require_admin),
) -> TokenClaims:
    """Get an authenticated admin or super_admin.

    Wraps require_admin for semantic clarity in route handlers.
    Used by /admin/* routes for platform management.
    """
    return claims


async def get_category_repo(
    db: SurrealDBClient = Depends(get_db),
) -> CategoryRepository:
    """Get the category repository (titan/discovery).

    Categories are platform-wide taxonomy entries managed by admins.
    """
    conn = await db.discovery()
    return SurrealCategoryRepo(conn)


async def get_company_repo(
    db: SurrealDBClient = Depends(get_db),
) -> CompanyRepository:
    """Get the company repository (titan/platform).

    Companies are the top-level registry entries managed by admins.
    """
    conn = await db.platform()
    return SurrealCompanyRepo(conn)
