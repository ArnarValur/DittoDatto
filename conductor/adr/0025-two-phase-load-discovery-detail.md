# Two-Phase Load: Discovery Index + Company Detail

> **Recorded:** 2026-06-30 20:15
> **Status:** accepted

Marketplace uses a two-phase load pattern for establishment data. Phase 1 (index): the Home tab queries `companies/discovery.establishment_listing` for lightweight cards (name, cover, category, rating, city). Phase 2 (detail): tapping a card loads full `EstablishmentData` (services, staff, gallery, hours) from `company_{slug}` DB via a `marketplace_reader` VIEWER service user. Discovery stays lean as an index; company DBs remain the source of truth for rich detail.

## Considered Options

- **Discovery-only (fat listing)** — fatten `establishment_listing` to include services, hours, gallery. Rejected: massive denormalization, stale data risk, violates single-source-of-truth.
- **Intermediate cache** — Redis or SDB cache layer for full detail. Rejected: overkill for current scale.

## Consequences

- Company DBs must define a `marketplace_reader` service user in the blueprint (SELECT-only on published establishments, active services, service groups).
- Marketplace needs on-demand DB connections to arbitrary company DBs — `discovery_service` package manages this.
