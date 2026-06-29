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
- [ ] Task: Seed test data via BP
    - [ ] Create 2-3 service groups in House of the North via BP form
    - [ ] Create 5-8 services across groups (mix of standard + tableReservation modes)
    - [ ] Verify data persists in SurrealDB

---

## Phase 3: Marketplace Display

- [ ] Task: Build ServiceCard widget
    - [ ] Write widget tests for all three booking-mode variants
    - [ ] Implement standard variant (title + price + duration + description)
    - [ ] Implement tableReservation variant (title + price + description, no duration)
    - [ ] Implement ticketSystem variant (title + price + description + ticket cue)
- [ ] Task: Build ServiceSection widget
    - [ ] Write widget tests for grouping, collapsibility, sort order, ungrouped fallback
    - [ ] Implement collapsible groups sorted by sortOrder
    - [ ] Implement "Øvrige tjenester" fallback for ungrouped services
    - [ ] Filter out isActive == false
    - [ ] Hide entire section when zero services
- [ ] Task: Build MultiSelectGroup behavior
    - [ ] Write widget tests for checkbox toggle, summary bar calculation
    - [ ] Implement checkbox rendering for multiSelect groups
    - [ ] Implement summary bar (total duration + total price)
- [ ] Task: Wire ServiceSection into EstablishmentPage
    - [ ] Add ServiceSection to the page scroll view (after gallery, before contact)
    - [ ] Verify on phone with real data from Hub

---

## Phase 4: Verification + Deploy

- [ ] Task: Run full test suite
    - [ ] Package tests (establishment_ui)
    - [ ] BP integration tests
    - [ ] BP widget tests
- [ ] Task: Deploy BP to Saturn :8003
    - [ ] Run deploy gate (tests → build → deploy → smoke test)
    - [ ] Verify services CRUD works on Saturn
- [ ] Task: Deploy Marketplace to phone
    - [ ] `flutter run --release -d R5CR61FGVPN`
    - [ ] Verify services display on EstablishmentPage with real data
- [ ] Task: E2E verification
    - [ ] Create a new service in BP on Saturn → verify it appears on phone's EstablishmentPage
    - [ ] Edit service price → verify update on phone
    - [ ] Toggle isActive → verify service disappears/reappears on phone
