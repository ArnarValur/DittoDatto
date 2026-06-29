# Plan: Services Section — EstablishmentPage Display + BP CRUD

> **Track:** `services_section_20260628`
> **Workflow:** strict (TDD)

---

## Phase 1: Data Layer — Dart Models + DB Queries

- [x] Task: Schema Gate — verify service + service_group tables in `company-blueprint.surql`
    - [x] Read schema, confirm all Dart model fields align
    - [x] Document any drift (ref: MercuryEngine audit found rescheduled_from/to drift)
    - [x] **Fixed:** `keywords` and `service_type` missing `DEFAULT []` — added to schema
- [x] Task: Create Service model in `packages/establishment_ui/`
    - [x] Write model serialization tests (fromJson/toJson round-trip)
    - [x] Implement Service model with fields: id, title, description, duration, price, currency, bookingMode, group, isActive
- [x] Task: Create ServiceGroup model in `packages/establishment_ui/`
    - [x] Write model serialization tests
    - [x] Implement ServiceGroup model with fields: id, name, description, sortOrder, showOnBookingPanel, multiSelect
- [x] Task: Extend EstablishmentData to include services + groups
    - [x] Add `List<ServiceGroup> serviceGroups` and `List<Service> services` fields
    - [x] Update fromJson to parse services and groups
- [x] Task: Extend EstablishmentDebugService to fetch services + groups
    - [x] Add SurrealQL queries: `SELECT * FROM service WHERE establishment = $est AND is_active = true`, `SELECT * FROM service_group WHERE establishment = $est`
    - [x] Wire into the existing fetch pipeline (batch query)
- [x] Task: Create format helpers
    - [x] `formatPrice(double price, String currency)` → `kr 450` / `Gratis`
    - [x] `formatDuration(int minutes)` → `30 min` / `1 t 30 min`
    - [x] Write unit tests for edge cases (0 price, 0 duration, >60 min, fractional prices)

---

## Phase 2: BP Services CRUD (Minimal)

- [x] Task: Add "Tjenester" sidebar navigation item
    - [x] Add route `/services` to BP GoRouter *(pre-existed)*
    - [x] Add sidebar icon + label *(pre-existed)*
- [x] Task: Build ServiceGroup CRUD
    - [x] Write integration tests for create/read/update/delete service_group (5 tests)
    - [x] Implement ServiceGroupRepository (SurrealDB queries)
    - [x] Build group list + create/edit dialog (name, description, sortOrder, multiSelect)
- [x] Task: Build Service CRUD
    - [x] Write integration tests for create/read/update/delete service (7 tests)
    - [x] Implement ServiceRepository (SurrealDB queries)
    - [x] Build service list view (grouped by group, showing title/price/duration/active badge)
    - [x] Build service create/edit dialog (title, description, duration presets, price, currency, bookingMode, group assignment, isActive toggle)
    - [x] Delete with confirmation
- [x] Task: Deploy BP with services CRUD to Saturn
    - [x] 75/75 integration tests green
    - [x] Deployed to Saturn :8003, smoke test passed
    - [x] Schema migration applied to live DB (`keywords`/`service_type` DEFAULT [])
    - [x] User verified: groups create ✅, services create ✅ (after schema fix)
- [x] Task: ~~Seed test data via BP~~ — **removed:** User seeds own data per project rules
    - [x] User created service groups + services via BP on Saturn
    - [x] Verified data persists and appears correctly

---

## Phase 3: Marketplace Display

- [x] Task: Build ServiceCard widget
    - [x] Write widget tests for all three booking-mode variants
    - [x] Implement standard variant (title + price + duration + description)
    - [x] Implement tableReservation variant (title + price + description, no duration)
    - [x] Implement ticketSystem variant (title + price + description + ticket accent chip)
- [x] Task: Build ServiceSection widget
    - [x] Write widget tests for grouping, collapsibility, sort order, ungrouped fallback
    - [x] Implement collapsible groups sorted by sortOrder
    - [x] Implement "Øvrige tjenester" fallback for ungrouped services
    - [x] Filter out isActive == false
    - [x] Filter out soft-deleted (deleted_at IS NONE)
    - [x] Hide entire section when zero services
    - [x] Configurable icon/title (no hardcoded icons)
- [x] Task: ~~Build MultiSelectGroup behavior~~ — **deferred** to booking UX grill
- [x] Task: Wire ServiceSection into EstablishmentPage
    - [x] Added ServiceSection to the page scroll view (position #5)
    - [x] Verified on phone with real data from Hub

---

## Phase 4: Verification + Deploy

- [x] Task: Run full test suite
    - [x] Package tests (establishment_ui) — 95/95
    - [x] BP integration tests — 75/75
- [x] Task: Deploy BP to Saturn :8003
    - [x] Run deploy gate (tests → build → deploy → smoke test)
    - [x] Verified services CRUD works on Saturn
- [x] Task: Deploy Marketplace to phone
    - [x] `flutter run --release -d R5CR61FGVPN`
    - [x] Verified services display on EstablishmentPage with real data
- [x] Task: E2E verification
    - [x] User created services in BP on Saturn → verified they appear on phone
    - [x] Deleted service confirmed hidden on Marketplace (soft-delete filter fix)
    - [ ] ~~Toggle isActive~~ — no visual badge in list view yet (minor polish)
