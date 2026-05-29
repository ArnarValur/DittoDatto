# Auth Identity Model + Base Tiers

> **Recorded:** 2026-05-26 (promoted from legacy ADR-0010 Session 14; namespace rename applied; admin tiers split into ADR-0005)
> **Status:** accepted

## Context

MercuryEngine needs an authentication and authorization model. The original PostIT (Session 3) proposed Vipps → Firebase Auth custom tokens, but Firebase Auth was deprecated in ADR-0001 (sole SurrealDB). This ADR defines the auth pipeline for the Python/FastAPI/SurrealDB stack.

SurrealDB 3.0 supports native record-based auth, JWT validation, and field-level permissions — but the Vipps OIDC exchange must happen at the application layer.

## Decisions

### 1. JWT Ownership — MercuryEngine as Issuer

**MercuryEngine owns the auth pipeline end-to-end.** SurrealDB is the user *store* (`users/profiles`), not the auth issuer.

- MercuryEngine handles Vipps OIDC exchange, user upsert, JWT minting (PyJWT).
- SurrealDB validates the same JWTs via `DEFINE ACCESS TYPE JWT` for defense-in-depth.
- Shared signing key between MercuryEngine and SurrealDB.
- Single owner of auth logic — no split-brain between Python and SurrealQL.

### 2. Three-Tier Identity Model

| Tier | Who | Auth Method | BankID? |
|---|---|---|---|
| **Company Operator** | Establishment owners, admin staff | Vipps Login (OIDC) | Yes — mandatory |
| **Public Consumer** | Anyone who books (Norwegians, tourists, immigrants) | Guest booking (no auth) | No |
| **Agent** | Ditto/Datto AI agents | Pre-issued JWT with `role: agent` | No |

Registered power consumers (v1.5+) will require BankID when that tier is introduced.

### 3. No NIN Storage

Vipps returns the Norwegian National ID Number (fødselsnummer). **We do not store it.** The `vipps_sub` (Vipps's opaque user ID) is sufficient for identity. Less PII = less GDPR liability. Can be revisited if regulatory requirements change.

User record in `users/profiles` stores: `vipps_sub`, `name`, `email`, `phone`.

### 4. Agent Auth — JWT with `role: agent` Claim

Agents authenticate via pre-issued JWTs with explicit claims:

```json
{
  "sub": "agent_ditto",
  "role": "agent",
  "allowed_companies": ["*"],
  "exp": 2147483647,
  "iss": "mercury-engine"
}
```

Same JWT validation middleware as operators. Actor type differentiated by claims, not by auth path.

SurrealDB independently validates agent JWTs via:
```surql
DEFINE ACCESS agent_access ON NAMESPACE TYPE JWT ALGORITHM HS256 KEY "shared-secret";
```

### 5. Company Context — Path Parameter + JWT Validation

Company slug is a **path parameter** in the URL: `/companies/{slug}/services`.

- MercuryEngine calls `db.use(namespace="companies", database=slug)` per request.
- Operators: JWT `company_slug` claim must match the path parameter (prevents horizontal escalation).
- Agents: `slug` must be in `allowed_companies` list (or `["*"]`).
- Guest bookings: company slug from the public booking URL, no JWT validation needed.

### 6. JWT Claims Schema

| Claim | Operator | Agent |
|---|---|---|
| `sub` | `vipps_{vipps_sub}` | `agent_ditto` |
| `role` | `operator` | `agent` |
| `company_slug` | `"sawasdee"` | `null` |
| `allowed_companies` | `["sawasdee"]` | `["*"]` |
| `bankid_verified` | `true` | `false` |
| `name` | From Vipps | `"Ditto"` |
| `email` | From Vipps | `null` |
| `exp` | 24h | Long-lived |
| `iss` | `mercury-engine` | `mercury-engine` |

**Guests do not receive JWTs.** Guest identity (name, phone, email) is stored inline on the booking record. No token = guest.

### 7. Base Middleware Tiers

| Tier | Checks | Endpoints |
|---|---|---|
| `public` | None | `GET /health`, `GET /companies/{slug}/services`, guest booking submission |
| `require_auth` | Valid JWT, decodes `sub` + `role` | Any authenticated action |
| `require_operator` | `require_auth` + `role == operator` + company access guard | Service/staff CRUD, operator dashboard |

**Company access guard:** Operators → `token.company_slug == path.slug`. Agents → `slug in token.allowed_companies`.

Admin and super-admin tiers (`require_admin`, `require_super_admin`) are formalized separately in ADR-0005.

Request flow:
```
Authenticated: Request → require_auth → company_access → handler → db.use(companies, slug)
Guest:         Request → (public) → handler → db.use(companies, slug) → inline guest info
```

### 8. Vipps OIDC for Production, Dev Bypass for Development & Staging

**Production (Cloud Run):** All operator auth goes through Vipps Login (browser-based OIDC with PKCE).

**Development (workstation) and Staging (Saturn — ADR-0003):** A `POST /auth/dev-login` endpoint (email + password) is registered only when `environment in {"development", "staging"}`. Returns the exact same JWT format as Vipps would. Gated by environment flag — physically absent in production builds.

Dev users are seeded during database bootstrap.

## Architecture

```
Flutter clients (Admin, Business Portal, Marketplace) / Future agents
    │
    ├─ Operator: Vipps OIDC (PKCE) ──→ MercuryEngine /auth/vipps
    │       exchange code → fetch userinfo → upsert users/profiles → mint JWT
    │
    ├─ Guest: No auth ──→ MercuryEngine /companies/{slug}/bookings (public)
    │       inline name + phone + email on booking record
    │
    └─ Agent: Pre-issued JWT ──→ MercuryEngine (any endpoint)
            same validation pipeline, role=agent in claims

MercuryEngine (FastAPI)
    ├── Middleware: JWT validation (PyJWT)
    ├── Guard: company_access (path vs claim)
    └── DB: db.use(namespace="companies", database=slug)

SurrealDB 3.0 (DittoDatto Hub on Saturn for staging; Cloud Run-attached for production)
    ├── DEFINE ACCESS TYPE JWT (defense-in-depth validation)
    ├── companies/{slug} — business data
    ├── companies/discovery — search aggregator
    ├── companies/registry — company registry
    └── users/profiles — consumer profiles (vipps_sub, name, email)
```

## Payment

**Deferred to v1.3.** The auth model does not block any payment integration path (Vipps ePayment, Stripe Connect, Adyen). Guest booking with payment at checkout is compatible with all options.

## Consequences

- Firebase Auth is fully replaced — no Google dependency for identity.
- One JWT format for all authenticated actors (operators + agents).
- Guests are zero-friction — no account required to book.
- NIN is never stored — minimal GDPR surface.
- Dev bypass enables fast iteration without Vipps sandbox in dev + staging.
- Company isolation is enforced at both middleware AND database level.
- Future tiers (registered consumers, power users) are additive — extend JWT claims + add middleware tier.

---

*Origin: Session 14 Auth Grill (2026-05-05) — 8 decisions locked. Promoted into canonical conductor/adr/ with namespace rename and staging context during /grill foundation 2026-05-26. Admin + super-admin tier expansion split into ADR-0005.*
