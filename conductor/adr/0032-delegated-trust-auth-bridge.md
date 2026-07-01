# ADR-0032: Delegated Trust Auth Bridge (ME ↔ Consumer/BP Tokens)

**Status:** Accepted
**Date:** 2026-07-01
**Context:** MercuryEngine needs to authenticate Marketplace consumers and BP operators calling its booking API. Three options evaluated.

## Decision

MercuryEngine validates SurrealDB-issued JWTs via **Delegated Trust verification**: ME calls SurrealDB's `authenticate()` to verify the token, then queries `$auth` for the user's identity and role. ME never decodes the JWT locally and never sees SurrealDB's signing key.

- `consumer_auth` tokens → ME role tier `user`
- `bp_auth` tokens → ME role tier `operator`
- Future agent tokens → mapped by `ac` claim

ME continues to use its own service account (`mercury@companies`) for all booking operations against SurrealDB. The consumer/operator JWT is identity proof only, not a session credential.

## Rationale

- **ADR-0006 compliance:** ME validates tokens, does not issue them. Delegated Trust preserved.
- **No key sharing:** SurrealDB validates its own tokens. ME never touches the signing key.
- **No schema migration:** No `WITH JWT KEY` needed on RECORD ACCESS definitions.
- **Future-proof:** Any SurrealDB-authenticated caller (Ditto, Datto, new surfaces) works identically.

## Rejected Alternatives

- **Option A (Accept SurrealDB JWT directly):** Requires extracting SurrealDB's signing key (schema migration + key-sharing risk). No `role` claim in SurrealDB JWTs breaks ME's 5-tier auth model.
- **Option B (ME issues its own JWTs):** Directly contradicts ADR-0006, ME PRD, and ME ADR-0002. Architectural reversal.

## Consequences

- Extra SurrealDB round-trip per ME API call (~1-5ms LAN). Mitigable with short-lived LRU cache keyed on JWT `jti`.
- ME needs a verify-only SurrealDB connection (separate from service account pool).
- `RoleValidator` must map SurrealDB access method (`ac` claim) to ME role tier instead of reading a `role` claim directly.
