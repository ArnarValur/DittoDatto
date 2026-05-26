"""JWT token minting and verification service.

Pure service — no database dependency. Uses PyJWT for encoding/decoding.
Signing key and algorithm come from Settings (config.py).

ADR-0010 §1: MercuryEngine owns the auth pipeline end-to-end.
"""

from __future__ import annotations

import time

import jwt

from mercury_core.errors import UnauthorizedError
from mercury_core.models.auth import ActorRole, TokenClaims
from mercury_engine.config import settings

# Dev tokens: 7 days. Production operators: 24 hours.
DEV_TOKEN_EXPIRY_SECONDS = 7 * 24 * 60 * 60  # 604800
OPERATOR_TOKEN_EXPIRY_SECONDS = 24 * 60 * 60  # 86400


def mint_token(claims: TokenClaims, *, expiry_seconds: int | None = None) -> str:
    """Encode a JWT from token claims.

    Args:
        claims: The token claims to encode.
        expiry_seconds: Override token lifetime. If None, uses role-based defaults:
            - Operators: 24h (production) or 7d (dev)
            - Agents: no expiry (long-lived)

    Returns:
        Encoded JWT string.
    """
    if expiry_seconds is None:
        if claims.role == ActorRole.AGENT:
            # Agents get long-lived tokens
            expiry_seconds = 365 * 24 * 60 * 60
        elif settings.is_development:
            expiry_seconds = DEV_TOKEN_EXPIRY_SECONDS
        else:
            expiry_seconds = OPERATOR_TOKEN_EXPIRY_SECONDS

    payload = claims.model_dump(exclude_none=True)
    payload["exp"] = int(time.time()) + expiry_seconds

    return jwt.encode(payload, settings.jwt_secret_key, algorithm=settings.jwt_algorithm)


def verify_token(token: str) -> TokenClaims:
    """Decode and validate a JWT, returning structured claims.

    Args:
        token: The raw JWT string from the Authorization header.

    Returns:
        Validated TokenClaims.

    Raises:
        UnauthorizedError: If the token is expired, malformed, or has an invalid signature.
    """
    try:
        payload = jwt.decode(
            token,
            settings.jwt_secret_key,
            algorithms=[settings.jwt_algorithm],
            options={"require": ["sub", "role", "exp"]},
        )
        return TokenClaims(**payload)
    except jwt.ExpiredSignatureError:
        raise UnauthorizedError("Token has expired") from None
    except jwt.InvalidTokenError as e:
        raise UnauthorizedError(f"Invalid token: {e}") from None
