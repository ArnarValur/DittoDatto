"""Tests for JWT token minting and verification.

Covers:
- Mint → verify round-trip
- Expired tokens
- Invalid signatures
- Malformed tokens
- Claims schema validation
"""

from __future__ import annotations

import time

import jwt
import pytest

from mercury_core.errors import UnauthorizedError
from mercury_core.models.auth import ActorRole, TokenClaims
from mercury_engine.auth.token_service import (
    DEV_TOKEN_EXPIRY_SECONDS,
    mint_token,
    verify_token,
)
from mercury_engine.config import settings

# ─── Fixtures ────────────────────────────────────────────────────────────


def _operator_claims() -> TokenClaims:
    """Standard operator claims for testing."""
    return TokenClaims(
        sub="vipps_dev_arnar",
        role=ActorRole.OPERATOR,
        company_slug="merkurial-studio",
        allowed_companies=["merkurial-studio"],
        bankid_verified=True,
        name="Arnar Valur",
        email="arnar@merkurial-studio.com",
    )


def _agent_claims() -> TokenClaims:
    """Standard agent claims for testing."""
    return TokenClaims(
        sub="agent_ditto",
        role=ActorRole.AGENT,
        allowed_companies=["*"],
        name="Ditto",
    )


# ─── Mint & Verify Round-Trip ────────────────────────────────────────────


class TestMintAndVerify:
    """Token minting and verification round-trips."""

    def test_operator_round_trip(self) -> None:
        """Mint an operator token and verify it decodes correctly."""
        claims = _operator_claims()
        token = mint_token(claims)
        decoded = verify_token(token)

        assert decoded.sub == "vipps_dev_arnar"
        assert decoded.role == ActorRole.OPERATOR
        assert decoded.company_slug == "merkurial-studio"
        assert decoded.allowed_companies == ["merkurial-studio"]
        assert decoded.bankid_verified is True
        assert decoded.name == "Arnar Valur"
        assert decoded.email == "arnar@merkurial-studio.com"
        assert decoded.iss == "mercury-engine"

    def test_agent_round_trip(self) -> None:
        """Mint an agent token and verify it decodes correctly."""
        claims = _agent_claims()
        token = mint_token(claims)
        decoded = verify_token(token)

        assert decoded.sub == "agent_ditto"
        assert decoded.role == ActorRole.AGENT
        assert decoded.allowed_companies == ["*"]
        assert decoded.name == "Ditto"

    def test_custom_expiry(self) -> None:
        """Custom expiry is honored."""
        claims = _operator_claims()
        token = mint_token(claims, expiry_seconds=3600)  # 1 hour
        decoded = verify_token(token)

        # exp should be ~1 hour from now
        assert decoded.exp is not None
        expected = int(time.time()) + 3600
        assert abs(decoded.exp - expected) < 5  # within 5 seconds

    def test_dev_expiry_default(self) -> None:
        """Dev mode uses 7-day expiry for operators."""
        assert settings.is_development  # test environment is always dev
        claims = _operator_claims()
        token = mint_token(claims)
        decoded = verify_token(token)

        assert decoded.exp is not None
        expected = int(time.time()) + DEV_TOKEN_EXPIRY_SECONDS
        assert abs(decoded.exp - expected) < 5


# ─── Verification Failures ──────────────────────────────────────────────


class TestVerifyFailures:
    """Token verification failure cases."""

    def test_expired_token(self) -> None:
        """Expired tokens raise UnauthorizedError."""
        claims = _operator_claims()
        # Mint with expiry in the past
        token = mint_token(claims, expiry_seconds=-10)

        with pytest.raises(UnauthorizedError, match="expired"):
            verify_token(token)

    def test_invalid_signature(self) -> None:
        """Tokens signed with wrong key raise UnauthorizedError."""
        claims = _operator_claims()
        payload = claims.model_dump(exclude_none=True)
        payload["exp"] = int(time.time()) + 3600

        # Sign with a different key
        token = jwt.encode(payload, "wrong-secret", algorithm="HS256")

        with pytest.raises(UnauthorizedError, match="Invalid token"):
            verify_token(token)

    def test_malformed_token(self) -> None:
        """Completely malformed tokens raise UnauthorizedError."""
        with pytest.raises(UnauthorizedError, match="Invalid token"):
            verify_token("not.a.valid.jwt")

    def test_empty_token(self) -> None:
        """Empty string raises UnauthorizedError."""
        with pytest.raises(UnauthorizedError, match="Invalid token"):
            verify_token("")

    def test_missing_required_claims(self) -> None:
        """Tokens missing required claims (sub, role, exp) raise UnauthorizedError."""
        payload = {"name": "incomplete"}
        token = jwt.encode(payload, settings.jwt_secret_key, algorithm="HS256")

        with pytest.raises(UnauthorizedError, match="Invalid token"):
            verify_token(token)
