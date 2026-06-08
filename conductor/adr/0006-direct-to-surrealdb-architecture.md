# Direct-to-SurrealDB Architecture

> **Recorded:** 2026-05-29 17:32
> **Status:** accepted

## Context

Using intermediate API gateways or servers to proxy all database queries and authentication adds latency, single-point-of-failure bottlenecks, and substantial boilerplate. SurrealDB 3.1 provides robust native user management, OIDC (Vipps integration), and row-level security (RLS), enabling client applications to interact with it directly.

## Decision

We use a **direct-to-database** connection and authentication architecture for all platform surfaces.

1. **Admin Panel:** Connects directly to SurrealDB via WebSocket. Authenticates using native namespace-level user credentials (`arnar`/`hoddi`) with `ROLES OWNER` access.
2. **Business Portal & Public Marketplace:** Authenticate directly to SurrealDB using native OIDC integration (`DEFINE ACCESS ... TYPE OIDC`) via Vipps.
3. **MercuryEngine (Booking Engine):** Operates purely on the booking hold/booking lifecycle and Time Tetris calculator. It does not issue tokens, handle OIDC, or expose admin endpoints. It accesses SurrealDB using its own high-privilege service account credentials (`mercury@companies`, `mercury@users`), executing booking transactions with **Delegated Trust**.

## Consequences

- Intermediate `/admin/*` routes, `/auth/dev-login` endpoints, and custom JWT issuers are completely eliminated from MercuryEngine.
- Client applications are highly performant and secure, operating on hard database-level isolation boundaries.
- No split-brain authentication: SurrealDB is the sole source of truth for both data and security tokens.
