"""Auth routes — dev-login endpoint.

POST /auth/dev-login: Development-only operator login.
This router is ONLY registered when settings.environment == "development".
It is physically absent from production builds (ADR-0010 §8).

Production auth (Vipps OIDC) will be added when merchant registration is complete.
"""

from __future__ import annotations

import logging

import bcrypt
from fastapi import APIRouter, Depends

from mercury_core.errors import UnauthorizedError
from mercury_core.models.auth import ActorRole, DevLoginRequest, TokenClaims, TokenResponse
from mercury_engine.auth.token_service import DEV_TOKEN_EXPIRY_SECONDS, mint_token
from mercury_engine.dependencies import get_user_repo

router = APIRouter(prefix="/auth", tags=["auth"])

logger = logging.getLogger("mercury-engine.auth")


@router.post("/dev-login", response_model=TokenResponse)
async def dev_login(
    body: DevLoginRequest,
    user_repo=Depends(get_user_repo),
) -> TokenResponse:
    """Authenticate with email + password (development only).

    Returns the same JWT format that Vipps OIDC would produce.
    Gated by environment flag — this router is not registered in production.
    """
    # Look up user by email
    user = await user_repo.get_by_email(body.email)
    if not user:
        logger.warning("Dev login failed: unknown email %s", body.email)
        raise UnauthorizedError("Invalid credentials")

    # Verify password
    if not user.password_hash:
        raise UnauthorizedError("User has no dev-login password set")

    if not bcrypt.checkpw(body.password.encode("utf-8"), user.password_hash.encode("utf-8")):
        logger.warning("Dev login failed: wrong password for %s", body.email)
        raise UnauthorizedError("Invalid credentials")

    # Mint JWT with claims appropriate to the user's role
    # Admin/super_admin: platform-wide access (no company scope)
    # Operator: company-scoped access
    if user.role in (ActorRole.ADMIN, ActorRole.SUPER_ADMIN):
        allowed = ["*"]
    elif user.company_slug:
        allowed = [user.company_slug]
    else:
        allowed = []

    claims = TokenClaims(
        sub=f"vipps_{user.vipps_sub}",
        role=user.role,
        company_slug=user.company_slug,
        allowed_companies=allowed,
        bankid_verified=True,
        name=user.name,
        email=user.email,
    )

    token = mint_token(claims, expiry_seconds=DEV_TOKEN_EXPIRY_SECONDS)

    logger.info("Dev login successful: %s → %s", body.email, user.company_slug)

    return TokenResponse(
        access_token=token,
        expires_in=DEV_TOKEN_EXPIRY_SECONDS,
    )
