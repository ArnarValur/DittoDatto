"""Authentication and authorization for MercuryEngine.

Implements ADR-0010 + ADR-0011: JWT-based auth with four middleware tiers.
- public: No auth
- require_auth: Valid JWT
- require_operator: JWT + operator role + company access guard
- require_admin: JWT + admin/super_admin role (platform-wide)
"""
