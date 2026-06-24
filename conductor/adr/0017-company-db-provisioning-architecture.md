# Company DB Provisioning Architecture

> **Recorded:** 2026-06-24 14:03
> **Status:** accepted

## Context

DittoDatto uses database-per-tenant isolation (ADR-0002): each company gets its own SurrealDB database (`company_{slug}`) within the `companies` namespace. When a company is created through the Admin Panel, its tenant database must be provisioned automatically — including schema, service accounts, and registry status.

## Decision

Company creation in the Admin Panel triggers automatic provisioning:

1. **Create database:** `DEFINE DATABASE company_{slug}` in the `companies` namespace.
2. **Apply blueprint:** Load `company-blueprint.surql` (bundled as a Flutter asset) and execute each statement sequentially against the new database. Statement-by-statement execution works around the SurrealDB SDK's multi-result handling limitations.
3. **Create service user:** `DEFINE USER bp_portal ON DATABASE PASSHASH '...' ROLES EDITOR` — the Business Portal's service account for tenant data access.
4. **Mark provisioned:** Update the company record in `companies/registry` with `provisioned = true`.

Deprovisioning on company deletion reverses the process: removes the database and marks `provisioned = false`.

The DB-per-tenant model was evaluated against shared-database-with-row-isolation. SurrealDB databases within a namespace are lightweight (metadata + RocksDB column families), making hundreds of tenant databases architecturally sound. The isolation benefits (no cross-tenant data leaks, clean teardown, per-tenant backups) outweigh the migration overhead (schema changes applied to N databases).

## Consequences

- Each company is fully isolated at the database level — no query cross-talk.
- Blueprint drift is the primary operational risk: schema changes must be applied to all existing tenant databases (future migration tooling required).
- The `bp_portal` service user password strategy is transitional: shared `--dart-define` for staging, backend proxy (MercuryEngine) for production. See future Auth Service track.
