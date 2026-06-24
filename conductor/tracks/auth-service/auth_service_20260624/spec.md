# Auth Service — Specification

> **Track:** `auth_service_20260624`
> **Type:** feature
> **Domain:** auth-service
> **Created:** 2026-06-24

---

## Overview

Auth is currently scattered across DittoDatto surfaces:

| Surface | Current auth | Problem |
|---|---|---|
| **Admin Panel** | NS-level system user (`ROLES OWNER`) | Fine — VPN-only, 2 users (ADR-0006/0007) |
| **Business Portal** | RECORD ACCESS `bp_auth` on `users/users` + `bp_portal` per-tenant service user | Works but bespoke — not reusable by other apps |
| **Public Marketplace** | None | No consumer auth exists yet |
| **MercuryEngine** | Delegated Trust service account | Fine — booking-only (ADR-0006) |

The Auth Service consolidates **consumer** and **business user** authentication into a single, reusable architecture. It does NOT touch Admin Panel auth or MercuryEngine's Delegated Trust.

### Architecture Decision

**SurrealDB-native auth** (RECORD ACCESS + SurrealDB-issued JWTs) with **no separate backend service**. Consistent with ADR-0006 (direct-to-DB). The architecture is designed so a backend intermediary can slot in later when Vipps OIDC integration requires it.

The "service" is:
1. **SurrealDB access definitions** in `schemas/` — the auth rules live in the database
2. **`packages/ditto_auth/`** — shared Dart package consumed by all Flutter client apps

---

## Functional Requirements

### 1. SurrealDB Access Definitions (`schemas/`)

- **`consumer_auth`** — RECORD ACCESS on `users/users` for consumer users (Public Marketplace)
  - SIGNIN: email + password (argon2)
  - SIGNUP: consumer self-registration (creates user record with `role = 'customer'`, argon2 hashing server-side)
  - Designed for future Vipps OIDC extension (consumer-facing only)
  - Token duration: TBD (research phase — pending SDB Sidekick input on refresh patterns)

- **`bp_auth`** — RECORD ACCESS on `users/users` for business users (Business Portal)
  - SIGNIN: email + password (argon2) — existing, to be formalized
  - NO SIGNUP — business users are created by Admin Panel
  - Business role gate (`business`, `admin`, `super_admin`)
  - Vipps NOT planned for BP — password auth is the long-term model here

### 2. Shared Dart Auth Package (`packages/ditto_auth/`)

- **Signin/Signup flows** — encapsulate RECORD ACCESS signin for both `consumer_auth` and `bp_auth`, plus signup for `consumer_auth`
- **Token storage** — `FlutterSecureStorage` for JWT persistence (extends ADR-0007 pattern)
- **Token refresh/restore** — reconnect with stored token, fallback to login on expiry (exact strategy pending SDB Sidekick input)
- **Role checking** — validate user role post-auth
- **Tenant routing** (BP-specific) — `USE NS companies DB company_{slug}` + `bp_portal` service user signin
- **Session persistence** — survive page reloads within token TTL

### 3. `bp_portal` Password Security (per SDB Sidekick analysis)

> This track opens the avenue to fix the `bp_portal` shared-password gap identified in ADR-0017.

- **Unique password per tenant:** Each `company_{slug}` DB gets its own `bp_portal` password — no shared credential across tenants
- **PASSHASH provisioning:** Use `DEFINE USER bp_portal ON DATABASE PASSHASH '...'` instead of `PASSWORD '...'` — no raw passwords in SurrealQL statements or logs
- **No secrets in client bundle:** `bp_portal` credentials must NOT be compiled into the Flutter web app. Secure runtime delivery mechanism TBD in research phase.
- **Session duration:** Apply `DURATION FOR SESSION` on `bp_portal` service users to limit exposure

### 4. BP Migration

- Replace BP's bespoke `auth_provider.dart` with `ditto_auth` package
- All 21 existing BP integration tests must stay green
- Zero user-facing behavior change

### 5. Marketplace Consumer Auth

- Wire `consumer_auth` into Public Marketplace app
- Email + password registration (signup) and login
- No Vipps integration in this track (future scope)

---

## Non-Functional Requirements

- **Security:** argon2 password hashing (SurrealDB-side, per agent rule). No plaintext passwords. No hardcoded secrets (ADR-0015). Unique `bp_portal` passwords per tenant.
- **Scalability:** SurrealDB RECORD ACCESS scales with the database — no bottleneck service process. Design the `ditto_auth` package API so a backend intermediary can replace the direct-to-DB calls without changing the app-facing interface.
- **Token TTL:** Research appropriate durations for consumer vs business tokens (Phase 1 deliverable).
- **Future-proofing:** Package API must support swapping the underlying auth mechanism (e.g., Vipps OIDC for consumers) without breaking app code.

---

## Acceptance Criteria

- [ ] `consumer_auth` RECORD ACCESS defined in `schemas/users.surql` with SIGNIN + SIGNUP
- [ ] `bp_auth` RECORD ACCESS formalized in `schemas/users.surql` (SIGNIN only, reviewed)
- [ ] `packages/ditto_auth/` package created with signin, signup, token storage, role check, tenant routing APIs
- [ ] `bp_portal` provisioning updated: unique password per tenant, PASSHASH, DURATION
- [ ] Business Portal migrated to use `ditto_auth` — all 21 integration tests green
- [ ] Consumer auth flow working in Marketplace (signup + login)
- [ ] Integration tests for `ditto_auth` against real SurrealDB
- [ ] No regression in Admin Panel auth (untouched)
- [ ] No regression in MercuryEngine (untouched)

---

## Edge Cases & Constraints

- **Saturn DB is clean** — no existing user data to migrate. Fresh start.
- **Token expiry race:** If both user token (RECORD ACCESS) and `bp_portal` token expire, the session is dead — handle gracefully with clear UX
- **Multi-company users:** Out of scope for now. One user, one `company_slug`. However, the two-phase auth model makes this architecturally clean: Phase 1 (user identity via `bp_auth`) is company-agnostic, only Phase 2 (tenant routing via `bp_portal`) changes. The `works_at` graph edge in the company blueprint already models multi-company membership. The main complexity is credential delivery — with unique `bp_portal` passwords per tenant, the client can't hold all credentials. This is the natural trigger for upgrading to the backend intermediary (Option 2). Design `ditto_auth` with a `switchCompany()` extension point in mind.
- **Offline/network errors:** `ditto_auth` must surface connection failures clearly (no silent empty results)
- **SurrealDB version:** Tested against SurrealDB 3.1 only
- **Two RECORD ACCESS on one DB:** `consumer_auth` and `bp_auth` coexist on `users/users` — verify no token scope collision (pending SDB Sidekick confirmation)

---

## Dependencies

- **SurrealDB 3.1** — RECORD ACCESS, SIGNUP clause, `crypto::argon2`, JWT issuance, PASSHASH
- **`packages/mercury_client/`** — existing SurrealDB connection infrastructure (may need to coordinate)
- **ADR-0006** — direct-to-DB architecture (respected, not modified)
- **ADR-0016** — current BP auth model (superseded by `ditto_auth` migration, same underlying mechanism)
- **ADR-0017** — company provisioning creates `bp_portal` (updated with unique passwords + PASSHASH)

---

## Out of Scope

- ❌ **Vipps Login / OIDC integration** — future track, no API access, no Norwegian company registration
- ❌ **BankID** — mentioned in context of Vipps only, not a planned feature
- ❌ **Admin Panel auth changes** — stays on NS-level (ADR-0007)
- ❌ **MercuryEngine auth changes** — stays on Delegated Trust (ADR-0006)
- ❌ **Multi-company user support** — one user, one company for now. Architecture is designed to support it (see Edge Cases). Natural trigger for backend intermediary upgrade.
- ❌ **Password reset / forgot password flow** — future enhancement
