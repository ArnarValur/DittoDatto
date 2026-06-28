# Spec: Services Section — EstablishmentPage Display + BP CRUD

> **Track:** `services_section_20260628`
> **Type:** feature
> **Domain:** services
> **Created:** 2026-06-28

---

## Overview

Add the services section to the consumer-facing EstablishmentPage and build basic BP CRUD for service management. Services are the core offering of every Establishment — what consumers browse, select, and book. This track delivers the display layer (Marketplace) and the minimum input layer (BP) so services can flow from business to consumer through the deployed app.

**Surfaces touched:**
- `packages/establishment_ui/` — Service + ServiceGroup Dart models, ServiceSection + ServiceCard display widgets
- `apps/business-portal/` — "Tjenester" sidebar page with list + create/edit dialog
- `apps/marketplace/` — wiring services into EstablishmentPage via EstablishmentDebugService

---

## Functional Requirements

### Dart Models (in `establishment_ui`)

- **Service** model: `id`, `title`, `description?`, `duration` (int, minutes), `price` (double), `currency` (String, default 'NOK'), `bookingMode` (standard/tableReservation/ticketSystem), `group` (record link?), `isActive` (bool)
- **ServiceGroup** model: `id`, `name`, `description?`, `sortOrder` (int), `showOnBookingPanel` (bool), `multiSelect` (bool)
- Both models with `fromJson` / `toJson` for SurrealDB round-trip

### Marketplace Display

- **ServiceSection** widget on EstablishmentPage — collapsible groups sorted by `sortOrder`, no section header
- **ServiceCard** — three visual variants driven by `bookingMode`:
  - `standard`: title + price (`kr 450`) + duration (`30 min`) + description (1–2 lines)
  - `tableReservation`: title + price (no duration) + description
  - `ticketSystem`: title + price + description + ticket styling
- **MultiSelectGroup** — groups with `multiSelect=true` render checkboxes per service + summary bar (total duration + total price)
- Filter out `isActive == false` services
- Data source: extend `EstablishmentDebugService` to fetch services + service_groups from the same company DB, add to `EstablishmentData`

### BP Services CRUD (minimal)

- Sidebar nav item "Tjenester" — same pattern as Etablissementer
- List view showing services grouped by ServiceGroup (name, price, duration, active badge)
- Dialog/slideover form for create/edit:
  - Fields: title, description, duration (presets: 15/30/45/60/90/120/180), price, currency, bookingMode, group assignment, isActive toggle
  - No staff assignment, no media, no advanced policies (deferred)
- ServiceGroup CRUD: create/edit groups (name, description, sortOrder, multiSelect)
- Delete with confirmation (both services and groups)
- Direct SurrealDB queries to the company DB (same pattern as establishment CRUD)

### Formatting

- Price: `kr 450` — lowercase "kr" prefix, no decimals for whole numbers, decimals when fractional
- Duration: `30 min` / `1 t 30 min` — Norwegian abbreviations

---

## Non-Functional Requirements

- Widget tests for all new components (ServiceCard variants, ServiceSection grouping, MultiSelectGroup)
- Integration tests for BP CRUD (create/read/update/delete services + groups against real SurrealDB)
- Package tests for Service/ServiceGroup model serialization

---

## Acceptance Criteria

1. ✅ Consumer opens EstablishmentPage on phone → sees services grouped by ServiceGroup with collapsible sections
2. ✅ Standard services show title + price + duration + description
3. ✅ Restaurant services (tableReservation) show title + price + description (no duration)
4. ✅ Multi-select groups render checkboxes with summary bar
5. ✅ Business user navigates to "Tjenester" in BP → sees service list grouped by group
6. ✅ Business user creates a service via dialog form → service appears in list
7. ✅ Business user creates a service group → can assign services to it
8. ✅ Service created in BP → visible on Marketplace EstablishmentPage on phone
9. ✅ All tests green (widget + integration + package)

---

## Edge Cases & Constraints

- Establishment with zero services → ServiceSection hidden (not "coming soon")
- Service with no group → renders in an "Øvrige tjenester" (ungrouped) section at the bottom
- multiSelect summary bar only appears when ≥1 service is checked
- Price of 0 → display as "Gratis" instead of "kr 0"
- Schema gate: Dart model fields MUST match `company-blueprint.surql` service/service_group tables exactly

---

## Dependencies

- `packages/establishment_ui/` — existing EstablishmentPage + EstablishmentData model
- `apps/marketplace/` — existing EstablishmentDebugService + EstablishmentTestScreen
- `apps/business-portal/` — existing DittoDashboardShell + sidebar navigation + establishment CRUD patterns
- SurrealDB Hub — `company_dittodatto-as` with `service` + `service_group` tables (already defined in blueprint)

---

## Out of Scope

- Booking flow UX (tap interaction, bottom sheet, booking confirmation) — **separate grill**
- Staff assignment on services
- Service media (cover image, gallery)
- Advanced booking policies (buffer time, slot interval, min notice)
- Discovery service sync layer
- Ticket system card styling (structure exists, visual polish deferred)
- BP services full polish (search, filtering, drag-to-reorder, bulk operations)
