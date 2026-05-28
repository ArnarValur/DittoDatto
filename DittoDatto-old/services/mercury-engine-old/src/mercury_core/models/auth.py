"""Auth domain models for MercuryEngine.

Defines the JWT claims schema and request/response types for authentication.
Based on ADR-0010 (Session 14 auth grill).

Identity tiers:
- Operator: Establishment owner/staff, BankID-verified via Vipps OIDC
- Agent: AI agents (Ditto/Datto), pre-issued JWTs
- Guest: No JWT, no account (inline info on booking record)
"""

from __future__ import annotations

from enum import StrEnum

from pydantic import BaseModel, Field


class ActorRole(StrEnum):
    """Authenticated actor types in the platform.

    Guests are NOT an actor role — they have no JWT.

    Matches users.surql assertion:
        ASSERT $value IN ['customer', 'business', 'admin', 'super_admin']
    """

    OPERATOR = "business"
    AGENT = "agent"
    ADMIN = "admin"
    SUPER_ADMIN = "super_admin"


class TokenClaims(BaseModel):
    """Decoded JWT payload — shared schema for operators and agents.

    Maps to ADR-0010 §6 JWT Claims Schema.
    """

    sub: str = Field(..., description="Subject — 'vipps_{sub}' for operators, 'agent_X' for agents")
    role: ActorRole
    company_slug: str | None = Field(
        default=None, description="Operator's company slug (null for agents)"
    )
    allowed_companies: list[str] = Field(
        default_factory=list,
        description="Companies this actor can access. ['*'] for global agent access.",
    )
    bankid_verified: bool = False
    name: str | None = None
    email: str | None = None
    exp: int | None = None
    iss: str = "mercury-engine"


class DevLoginRequest(BaseModel):
    """Request body for POST /auth/dev-login.

    Development-only endpoint — physically absent in production builds.
    """

    email: str
    password: str


class TokenResponse(BaseModel):
    """JWT token response returned by auth endpoints."""

    access_token: str
    token_type: str = "bearer"
    expires_in: int = Field(..., description="Token lifetime in seconds")
