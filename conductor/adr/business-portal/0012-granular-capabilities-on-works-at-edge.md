# ADR-0012: Store Granular Capabilities on the works_at Edge

> **Recorded:** 2026-06-08
> **Status:** accepted
> **Domain:** business-portal

## Context

In multi-location businesses, staff permissions and capabilities can vary between establishments. For example, a receptionist might be permitted to manage calendars and bookings at a specific store but should not have permission to edit service prices or staff schedules globally across all of the company's locations.

## Decision

We will define fine-grained staff capabilities (`StaffCapability`) as an array of string tokens (e.g., `can_manage_services`, `can_view_all_bookings`) stored directly on the **`works_at` graph edge** that connects a `staff` member to an `establishment` in the tenant database.

- **Edge Schema Definition:** The `works_at` relation table will enforce fields: `role` (owner/admin/employee), `capabilities` (array of strings), and `since` (datetime).
- **Authorization Resolution:** The client application will query the `works_at` edge for the logged-in user to populate the active permissions context, checking permissions against both global roles and location-specific capability tokens.

## Consequences

- Supports location-scoped capability overrides natively within the graph topology.
- Keeps the `staff` document simple and decoupled from specific establishment structures.
- Allows SurrealDB's row-level security (RLS) policies on the tenant database to perform efficient permissions checks by traversing the `works_at` edges directly during queries.
