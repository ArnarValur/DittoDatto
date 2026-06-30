# BP Direct-Write Discovery Sync

> **Recorded:** 2026-06-30 20:15
> **Status:** accepted

When a business owner sets `is_published=true` in the Business Portal, BP writes/updates the denormalized `establishment_listing` directly to `companies/discovery`. The `bp_portal` service user on the discovery DB is upgraded from VIEWER to EDITOR for listings (remains VIEWER for categories). No MercuryEngine middleman — ME is booking-only per ADR scope. The sync is immediate (not eventually consistent), and BP has all the data needed for the projection (establishment fields, services, geo, media).

## Considered Options

- **MercuryEngine dual-write** — original schema comment. Rejected: ME scope is Hold→Booking lifecycle only. Would couple discovery to the booking engine.
- **SurrealDB EVENT-based sync** — auto-push via `DEFINE EVENT`. Rejected: cross-database events are not supported in SurrealDB 3.1 (company DBs → discovery DB).
- **Admin-curated approval** — listings reviewed before publish. Rejected for v1: adds friction. May revisit for quality control at scale.
