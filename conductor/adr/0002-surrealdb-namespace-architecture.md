# SurrealDB Namespace Architecture (`companies`, `users`)

> **Recorded:** 2026-05-26 (promoted from legacy ADR-0009 Sessions 8–9; namespace rename applied)
> **Status:** accepted

## Context

With SurrealDB as the sole platform database (ADR-0001), we need a multi-tenant architecture that provides company isolation, GDPR compliance, a shared discovery aggregator, and platform-level operational data.

## Decision

Two namespaces, four database categories:

```
companies (namespace)
├── {slug}                  ← One DB per company (from company-blueprint schema)
├── discovery               ← Public aggregator for DittoBar search
└── registry                ← Company registry, system alerts, audit log

users (namespace)
└── profiles                ← GDPR-isolated consumer PII
```

The legacy codenames `titan` and `enceladus` are retired in favor of these self-explanatory names. The legacy `titan/company_{slug}` prefix is dropped (the namespace already says "companies"); the legacy `titan/platform` is renamed to `companies/registry` to resolve the awkward "platform inside platform" connotation.

## Why Two Namespaces (Not One)

GDPR requires that consumer personal data cannot be accessed via the same credentials used for business operations. SurrealDB namespace-level users provide this boundary:

- `mercury@companies` — MercuryEngine service account for all company + discovery + registry operations.
- `mercury@users` — Separate credentials for user PII access.

A single namespace with database-level isolation would allow one leaked credential to access everything. Namespace separation makes the GDPR boundary a hard architectural line, not a policy one.

## Company Database Isolation

Each company gets its own database: `companies/{slug}`. This provides:

- Zero cross-talk — a query in `companies/sawasdee` cannot access `companies/acme` data.
- Independent lifecycle — companies can be provisioned and decommissioned cleanly.
- Simple backups — per-company export/import.
- No need for `companyId` fields; the database IS the company.

The company-blueprint schema template (19 tables) is applied on company onboarding.

## Cross-Database References

SurrealDB cannot do cross-namespace record links. Cross-database references use string IDs:

| Direction | Field Pattern | Example |
|---|---|---|
| Company → User | `user_id TYPE string` | `staff.user_id = "user:abc123"` |
| User → Company | `company_slug TYPE string` | `booking_ref.company_slug = "sawasdee"` |
| Discovery → Company | `source_id TYPE string` | `listing.source_id = "establishment:xyz"` |

MercuryEngine resolves cross-DB lookups at the application layer.

## Discovery Sync (Dual-Write)

MercuryEngine is the source of truth. When company data changes, MercuryEngine writes to both:
1. The company database (primary).
2. `companies/discovery` (denormalized projection via `syncToDiscovery()`).

This is a dual-write **within the same SurrealDB instance** — not a cross-system sync pipe. Both writes can be wrapped in a transaction if needed.

## Graph vs Record Link Heuristic

| Pattern | Use | Example |
|---|---|---|
| Record link (`TYPE record<T>`) | Ownership, single-hop, no edge metadata | `service.establishment` |
| Graph edge (`TYPE RELATION`) | Traversable, carries metadata, many-to-many | `staff->works_at->establishment` |

Rule: *If the relationship has metadata or needs multi-hop traversal, use a graph edge. Otherwise, use a record link.*

## Schema Summary

| Database | Tables | Key Tables |
|---|---|---|
| `companies/{slug}` | 19 | establishment, service, staff, booking, hold, resource |
| `companies/discovery` | 6 | establishment_listing, category, area, search_event |
| `companies/registry` | 4 | company, system_alert, icon_collection, audit_log |
| `users/profiles` | 3 | user, favorite, booking_ref |

Schemas currently live in `DittoDatto-old/schemas/` (to be migrated to `services/mercury-engine/` in a future MercuryEngine migration track).

## Deployment Context

The DittoDatto Hub (Saturn-deployed SurrealDB — ADR-0003) hosts BOTH namespaces. Local dev runs an independent SurrealDB instance with the same namespace topology but isolated data.

## Consequences

- Every company gets its own database — provisioned on onboard, removed on deactivation.
- GDPR boundary is a hard namespace split, not just a policy.
- MercuryEngine needs two SurrealDB connections (`companies` + `users`).
- Cross-DB references are strings, resolved at the application layer.
- Discovery data is eventually consistent (dual-write from MercuryEngine).
- Company templates are versioned via the company-blueprint schema.
- Any code, schema, or doc still using `titan` / `enceladus` is pre-rename and needs migration.

---

*Origin: Session 8 Grill (initial namespace architecture), Session 9 (schema sequencing), Session 10 (schema blueprint writing + testing). Promoted into canonical conductor/adr/ with namespace rename during /grill foundation 2026-05-26.*
