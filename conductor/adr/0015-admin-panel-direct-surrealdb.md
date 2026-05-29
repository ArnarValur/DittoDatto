# Admin Panel — Direct SurrealDB Data Path

> **Recorded:** 2026-05-29 15:40
> **Status:** accepted

The admin panel authenticates and queries SurrealDB directly over WebSocket — no MercuryEngine intermediary. Two namespace-level system users (`arnar`, `hoddi`) with `ROLES OWNER` authenticate via the `surrealdb` Dart package (1.1.2). Each login establishes two WebSocket connections (one per namespace: `companies` for registry/discovery, `users` for profiles). This is deliberate: the admin panel is a 2-user private tool (ADR-0013) managing platform infrastructure, while MercuryEngine serves business/consumer traffic. Coupling admin ops to MercuryEngine would introduce an unnecessary dependency and failure mode for a tool that just needs direct database access.

## Consequences

- Admin panel has no dependency on MercuryEngine being deployed or healthy.
- Schema changes in SurrealDB may require updates to both MercuryEngine and the admin panel independently.
- The `surrealdb` Dart package is an admin-only dependency (in `apps/admin/pubspec.yaml`, not `mercury_client`).
