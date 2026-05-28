"""FastAPI auth middleware dependencies.

Three tiers per ADR-0010 §7:
- public:           No checks (just don't inject these dependencies)
- require_auth:     Valid JWT → returns TokenClaims
- require_operator: require_auth + role==operator + company access guard

Usage in routes:
    @router.post("/companies/{slug}/services")
    async def create_service(
        ...,
        actor: TokenClaims = Depends(require_operator),
    ):
        ...
"""

from __future__ import annotations

from fastapi import Depends, Path, Request

from mercury_core.errors import ForbiddenError, UnauthorizedError
from mercury_core.models.auth import ActorRole, TokenClaims
from mercury_engine.auth.token_service import verify_token


def _extract_bearer_token(request: Request) -> str:
    """Extract JWT from Authorization: Bearer <token> header.

    Raises:
        UnauthorizedError: If header is missing or malformed.
    """
    auth_header = request.headers.get("Authorization")
    if not auth_header:
        raise UnauthorizedError("Missing Authorization header")

    parts = auth_header.split(" ", 1)
    if len(parts) != 2 or parts[0].lower() != "bearer":
        raise UnauthorizedError("Authorization header must be 'Bearer <token>'")

    return parts[1]


async def require_auth(request: Request) -> TokenClaims:
    """Middleware tier: require a valid JWT.

    Extracts the Bearer token, verifies it, and returns decoded claims.
    Inject via Depends(require_auth) on any endpoint needing authentication.

    Returns:
        Decoded and validated TokenClaims.

    Raises:
        UnauthorizedError: If no valid JWT is present.
    """
    token = _extract_bearer_token(request)
    return verify_token(token)


def company_access_guard(claims: TokenClaims, slug: str) -> None:
    """Verify the authenticated actor has access to the requested company.

    ADR-0010 §5:
    - Operators: JWT company_slug must match path slug
    - Agents: slug must be in allowed_companies list (or ["*"])

    Args:
        claims: Decoded JWT claims from require_auth.
        slug: Company slug from the URL path.

    Raises:
        ForbiddenError: If the actor cannot access this company.
    """
    if claims.role == ActorRole.OPERATOR:
        if claims.company_slug != slug:
            raise ForbiddenError(f"Operator does not have access to company '{slug}'")
    elif claims.role == ActorRole.AGENT and (
        "*" not in claims.allowed_companies and slug not in claims.allowed_companies
    ):
        raise ForbiddenError(f"Agent does not have access to company '{slug}'")


async def require_operator(
    claims: TokenClaims = Depends(require_auth),
    slug: str = Path(..., description="Company URL slug"),
) -> TokenClaims:
    """Middleware tier: require an authenticated operator with company access.

    Chains: require_auth → role check → company access guard.

    Returns:
        Validated TokenClaims for an authorized operator.

    Raises:
        UnauthorizedError: If no valid JWT.
        ForbiddenError: If not an operator or wrong company.
    """
    if claims.role != ActorRole.OPERATOR:
        raise ForbiddenError("This endpoint requires business operator access")

    company_access_guard(claims, slug)
    return claims


async def require_admin(
    claims: TokenClaims = Depends(require_auth),
) -> TokenClaims:
    """Middleware tier: require ADMIN or SUPER_ADMIN role.

    Platform-wide access — no company slug, no company access guard.
    Used by /admin/* routes for user management, company provisioning,
    and category taxonomy.

    Returns:
        Validated TokenClaims for an authorized admin.

    Raises:
        UnauthorizedError: If no valid JWT.
        ForbiddenError: If not an admin or super_admin.
    """
    if claims.role not in (ActorRole.ADMIN, ActorRole.SUPER_ADMIN):
        raise ForbiddenError("This endpoint requires admin access")
    return claims
