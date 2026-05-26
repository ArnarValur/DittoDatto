"""User model for operator profiles.

Stored in enceladus/users (GDPR-isolated namespace per ADR-0009).
Operators are created via Vipps OIDC user upsert (or dev-login seed).

ADR-0010 §3: No NIN storage. vipps_sub is the identity anchor.
"""

from __future__ import annotations

from mercury_core.models.auth import ActorRole
from mercury_core.models.common import MercuryModel, TimestampMixin


class User(MercuryModel, TimestampMixin):
    """Platform user — operators and (future) registered consumers.

    Guests are NOT users. Guest identity is stored inline on booking records.

    Attributes:
        vipps_sub: Opaque Vipps user ID (identity anchor, not NIN).
        name: Display name from Vipps userinfo.
        email: Email from Vipps userinfo.
        phone: Phone number (optional).
        role: Actor role — defaults to operator.
        company_slug: The company this operator belongs to.
        password_hash: Bcrypt hash (dev-login only, null for Vipps users).
    """

    id: str | None = None
    vipps_sub: str
    name: str
    email: str
    phone: str | None = None
    role: ActorRole = ActorRole.OPERATOR
    company_slug: str | None = None
    password_hash: str | None = None
