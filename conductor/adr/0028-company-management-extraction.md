# ADR-0028: Company Management Extraction

**Status:** Accepted
**Date:** 2026-07-01
**Deciders:** Arnar Valur

## Context

Entity CRUD operations (establishments, services, staff, resources, schedules) were initially assumed to live within MercuryEngine. Domain-driven analysis during ME 1.0 development revealed this is a separate bounded context.

## Decision

- **Company Management** is a separate bounded context from booking.
- Datto is the Company Management agent — operators and Datto write entity data.
- MercuryEngine and Discovery **read** entity data via shared kernel (SurrealDB `companies/{slug}`).
- SurrealDB is the integration point — no API coupling between contexts.
- No shared ORM or API contracts; each context reads from the same DB tables independently.

## Consequences

- MercuryEngine stays focused on booking lifecycle (Hold → Confirm → Cancel → Reschedule).
- Company Management can evolve independently (Business Portal, Datto agent).
- Data consistency relies on SurrealDB schema definitions, not cross-service API calls.
