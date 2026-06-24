# Auth Service Architecture — SurrealDB-Native with Intermediary Escape Hatch

> **Recorded:** 2026-06-24 16:17
> **Status:** accepted
> **Domain:** auth-service

## Context

Auth is scattered across DittoDatto surfaces: Admin Panel uses NS-level system users (ADR-0006/0007), Business Portal uses RECORD ACCESS `bp_auth` with `bp_portal` service users (ADR-0016), and the Public Marketplace has no auth at all. Each new app would re-implement its own auth flow. A consolidated auth architecture is needed.

## Decision

We adopt **SurrealDB-native auth** (RECORD ACCESS + SurrealDB-issued JWTs) with **no separate backend service**. The "Auth Service" is:

1. **SurrealDB access definitions** in `schemas/` — two RECORD ACCESS definitions on `users/users`: `consumer_auth` (consumer signup + signin, future Vipps OIDC) and `bp_auth` (business signin, role-gated).
2. **`packages/ditto_auth/`** — a shared Dart auth package consumed by all Flutter client apps, encapsulating signin, signup, token storage, refresh, role checking, and tenant routing.

This is consistent with ADR-0006 (direct-to-DB). The package API is designed with an abstraction layer so a **backend intermediary can slot in later** when Vipps OIDC integration or multi-company credential delivery requires it. Admin Panel auth (NS-level) and MercuryEngine (Delegated Trust) are untouched.

## Consequences

- No additional backend service to deploy, monitor, or scale for auth.
- Token refresh uses SurrealDB's native `WITH REFRESH` mechanism (15m access tokens + refresh tokens).
- The escape hatch to a backend intermediary is the natural upgrade path when: (a) Vipps OIDC lands, or (b) multi-company users need credential delivery across tenant DBs.
- `bp_portal` passwords become unique per tenant (PASSHASH provisioning), but secure delivery to the client requires the backend intermediary for production.
