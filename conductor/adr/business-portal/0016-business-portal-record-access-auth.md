# ADR-0016: Business Portal RECORD ACCESS Authentication

> **Recorded:** 2026-06-19 13:24
> **Status:** accepted
> **Supersedes:** [ADR-0013](../business-portal/0013-business-portal-multi-tenant-authentication.md)
> **Domain:** business-portal

## Context

ADR-0013 specified a "direct-to-database WebSocket login sequence" for the Business Portal but was implemented using SurrealDB **namespace-level system users** (`DEFINE USER ... ON NAMESPACE ROLES OWNER`). This meant:

- The user's login password **was** the database namespace admin password
- A logged-in portal user had **OWNER access to every database** in both namespaces
- Zero tenant isolation — `routeToTenant()` was cosmetic (token still had full NS access)
- The same credential pattern as the Admin Panel was blindly copied to a company-facing surface

This is a critical security flaw. Company portal users should authenticate with their **own** password (stored as a hash in their user profile), not with database administrator credentials.

## Decision

We replace namespace-level system user authentication with a two-phase model:

### Phase 1: User Authentication — RECORD ACCESS

Define `DEFINE ACCESS bp_auth ON DATABASE TYPE RECORD` on the `users/users` database. The SIGNIN clause validates the user's password against the `password_hash` field in their profile record using `crypto::argon2::compare()`.

```sql
DEFINE ACCESS bp_auth ON DATABASE TYPE RECORD
  SIGNIN (
    SELECT * FROM user
    WHERE username = $username
      AND crypto::argon2::compare(password_hash, $pass)
  )
  DURATION FOR TOKEN 24h, FOR SESSION 7d;
```

The issued JWT is scoped to the authenticated user's record (`$auth`). The user can query their own profile but has no access to other databases or namespaces.

### Phase 2: Tenant Database Access — DB-level Service User

Each company database (`company_{slug}`) has a DB-level system user `bp_portal` with EDITOR role:

```sql
USE NS companies DB company_{slug};
DEFINE USER bp_portal ON DATABASE PASSWORD '<deployment-secret>' ROLES EDITOR;
```

This is a **deployment credential** injected via `--dart-define=BP_PORTAL_PASS=<secret>` at build time. It is:
- NOT the user's password
- NOT a namespace-wide credential
- Scoped to a single tenant database (EDITOR, not OWNER)

### Login Flow

1. User enters email + password on login screen
2. Extract username from email prefix
3. RECORD ACCESS signin on `users/users` → validates `password_hash` via argon2
4. Query `$auth` for role and `company_slug`
5. Reject if role is not `business`, `admin`, or `super_admin`
6. DB-level signin on `companies/company_{slug}` using `bp_portal` service credential
7. Store both JWT tokens + slug for session persistence

## Consequences

- Users authenticate with their **own password**, validated against `password_hash` — standard application auth
- No database admin/root/namespace credentials are used for portal login
- Company DB access uses a scoped service credential (EDITOR role, single DB)
- Admin Panel remains on namespace-level auth (ADR-0007) — internal tool, VPN-only, different trust model
- User provisioning must now set `password_hash` on user records (argon2)
- Company provisioning must create `bp_portal` DB user on each new company database
- When BankID/Vipps OIDC is implemented (ADR-0006), the RECORD ACCESS definition will be extended or replaced with OIDC token validation
