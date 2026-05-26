---
title: "ADR-0009: SurrealDB Namespace Architecture"
type: "adr"
status: "accepted"
date: "2026-05-03"
session:
  - 8
  - 9
domain: "Infrastructure"
tags:
  - "surrealdb"
  - "namespace"
  - "titan"
  - "enceladus"
  - "gdpr"
---

# SurrealDB Namespace Architecture

## Context

With SurrealDB as the sole platform database (ADR-0008), we need a multi-tenant architecture that provides:
1. **Company isolation** — each company's data is fully separated
2. **GDPR compliance** — consumer PII is isolated from business data
3. **Shared discovery** — a public aggregator across all companies
4. **Platform ops** — system-level data accessible to MercuryEngine

## Decision

Two namespaces, four database categories:

```
titan (namespace)
├── company_{slug}           ← One DB per company (from company-blueprint.surql)
├── discovery                ← Public aggregator for DittoBar search
└── platform                 ← Company registry, system alerts, audit log

enceladus (namespace)
└── users                    ← GDPR-isolated consumer PII
```

### Why Two Namespaces (Not One)

GDPR requires that consumer personal data cannot be accessed via the same credentials used for business operations. SurrealDB namespace-level users provide this boundary:

- `mercury@titan` — MercuryEngine service account for all company + discovery + platform operations
- `mercury@enceladus` — Separate credentials for user PII access

A single namespace with database-level isolation would allow one leaked credential to access everything. Namespace separation makes the GDPR boundary a hard architectural line, not a policy one.

### Company Database Isolation

Each company gets its own database: `titan/company_{slug}`. This provides:

- **Zero cross-talk** — a query in `company_sawasdee` cannot access `company_acme` data
- **Independent lifecycle** — companies can be provisioned and decommissioned cleanly
- **Simple backups** — per-company export/import
- **companyId elimination** — no need for `companyId` fields; the database IS the company

The `company-blueprint.surql` template (19 tables, 282 statements) is applied on company onboard.

### Cross-Database References

SurrealDB cannot do cross-namespace record links. Cross-database references use string IDs:

| Direction | Field Pattern | Example |
|-----------|--------------|---------|
| Company → User | `user_id TYPE string` | `staff.user_id = "user:abc123"` |
| User → Company | `company_slug TYPE string` | `booking_ref.company_slug = "sawasdee"` |
| Discovery → Company | `source_id TYPE string` | `listing.source_id = "establishment:xyz"` |

MercuryEngine resolves cross-DB lookups at the application layer.

### Discovery Sync (Dual-Write)

MercuryEngine is the source of truth. When company data changes, MercuryEngine writes to both:
1. The company database (primary)
2. `titan/discovery` (denormalized projection via `syncToDiscovery()`)

This is a **dual-write within the same SurrealDB instance** — not a cross-system sync pipe. Both writes can be wrapped in a transaction if needed.

## Graph vs Record Link Heuristic

| Pattern | Use | Example |
|---------|-----|---------|
| **Record link** (`TYPE record<T>`) | Ownership, single-hop, no edge metadata | `service.establishment` |
| **Graph edge** (`TYPE RELATION`) | Traversable, carries metadata, many-to-many | `staff->works_at->establishment` |

Decision rule: *"If the relationship has metadata or needs multi-hop traversal, use a graph edge. Otherwise, use a record link."*

## Schema Summary

| Database | Tables | Key Tables |
|----------|--------|------------|
| `company_{slug}` | 19 | establishment, service, staff, booking, hold, resource |
| `discovery` | 6 | establishment_listing, category, area, search_event |
| `users` | 3 | user, favorite, booking_ref |
| `platform` | 4 | company, system_alert, icon_collection, audit_log |

See `schemas/README.md` for the complete architecture diagram and apply instructions.

## Consequences

- Every company gets its own database — provisioned on onboard, removed on deactivation
- GDPR boundary is a hard namespace split, not just a policy
- MercuryEngine needs two SurrealDB connections (titan + enceladus)
- Cross-DB references are strings, resolved at the application layer
- Discovery data is eventually consistent (dual-write from MercuryEngine)
- Company templates are versioned via `company-blueprint.surql`

---

*Origin: Session 8 Grill (namespace architecture), Session 9 Grill (schema sequencing), Session 10 (schema blueprint writing + testing)*
