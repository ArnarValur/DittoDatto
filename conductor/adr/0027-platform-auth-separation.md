# ADR-0027: Platform Auth Separation

**Status:** Accepted
**Date:** 2026-07-01
**Deciders:** Arnar Valur

## Context

MercuryEngine was initially assumed to issue JWTs (partially implied by ADR-0004 §1). As the platform architecture matured, it became clear that auth issuance is a platform-level concern, not a booking engine concern.

## Decision

- Auth issuance is a **platform concern**, separate from MercuryEngine.
- SurrealDB native auth (`DEFINE ACCESS`) handles internal tools (Admin Panel).
- Vipps OIDC is reserved for public/portal surfaces (future, separate bounded context).
- MercuryEngine **retains** 5-tier JWT validation middleware (`public` / `require_auth` / `require_operator` / `require_admin` / `require_super_admin`) but does NOT issue tokens.

## Consequences

- MercuryEngine scope is cleaner — booking only, no auth issuance.
- Auth service can evolve independently.
- Partially supersedes ADR-0004 §1 assumptions about MercuryEngine issuing JWTs.
