# Plan: BP Establishment Configuration

> **Track:** `bp_establishment_config_20260701`
> **Workflow:** strict (TDD)
> **Phases:** 4

---

## Phase 1: Schema Migration + Dart Model Layer

Foundation phase — all data plumbing before any UI work.

### 1.1 Schema Migration

- [ ] Task: Rename `store_type` → `establishment_type` in `schemas/company-blueprint.surql`
    - [ ] Rename field definition, update ASSERT values: `shop`/`restaurant`/`venue` (default `shop`)
    - [ ] Remove `booking_form_type` field entirely
    - [ ] Update `large_party_handling` ASSERT: `notify`/`email`/`call`/`form`/`disabled` (default `notify`)
    - [ ] Redefine `social_links` as `TYPE option<array<object>>` with `platform` (string) + `url` (string) subfields
- [ ] Task: Update `schemas/discovery.surql`
    - [ ] Rename `store_type` → `establishment_type` on `establishment_listing`
- [ ] Task: Write migration script for existing data on staging
    - [ ] Rename `store_type` → `establishment_type` value `store` → `shop` on all existing establishments
    - [ ] Migrate `social_links` from object `{fb, ig, x}` to array format `[{platform, url}]`
    - [ ] Remove `booking_form_type` values from existing records
    - [ ] Apply to all company DBs on Saturn (Dream On AS, DittoDatto AS, Merkurial Studio)

### 1.2 Dart Model Classes

- [ ] Task: Create `OpeningDay` model
    - [ ] Write tests for `OpeningDay.fromJson`/`toJson` (open day, closed day, edge cases)
    - [ ] Implement `OpeningDay` class: `isOpen` (bool), `open` (String), `close` (String)
    - [ ] Create `OpeningSchedule` typedef/helper for `Map<String, OpeningDay>` (mon–sun)
- [ ] Task: Create `BookingPolicy` model
    - [ ] Write tests for `BookingPolicy.fromJson`/`toJson` (defaults, all fields, partial)
    - [ ] Implement `BookingPolicy` class: all 9 fields with defaults matching schema
- [ ] Task: Create `SocialLink` model
    - [ ] Write tests for `SocialLink.fromJson`/`toJson` (known platform, unknown, empty)
    - [ ] Implement `SocialLink` class: `platform` (String), `url` (String)
    - [ ] Add `SocialLink.knownPlatforms` const set: `{facebook, instagram, snapchat, tiktok}`
    - [ ] Add `SocialLink.iconForPlatform()` helper
- [ ] Task: Create `ReservationConfig` model
    - [ ] Write tests for `ReservationConfig.fromJson`/`toJson` (defaults, all fields)
    - [ ] Implement `ReservationConfig` class: all 10 fields with defaults matching schema
- [ ] Task: Rename `BusinessType` → `EstablishmentType` enum
    - [ ] Rename enum + update `store` → `shop`
    - [ ] Update `fromString` to parse `shop`/`restaurant`/`venue`
    - [ ] Update all references across BP codebase (model, providers, edit view, etc.)
- [ ] Task: Extend `Establishment` model with new fields
    - [ ] Write integration tests: round-trip new fields to SurrealDB and back
    - [ ] Add fields: `openingSchedule`, `timezone`, `bookingPolicy`, `socialLinks`, `reservationConfig`
    - [ ] Update `fromJson` to parse all new embedded objects
    - [ ] Update `toJson` to serialize (omit null/empty per SurrealDB SCHEMAFULL rules)
    - [ ] Update `copyWith` with all new fields

### 1.3 Update Discovery Sync

- [ ] Task: Update `ListingSyncService` for terminology rename
    - [ ] Update any `store_type` references → `establishment_type` in discovery sync code
    - [ ] Verify BP publish still works after rename

---

## Phase 2: BP Edit UI — Type Selector + Opening Hours + Social Links

Three new/updated UI sections. Quick-win visuals — the sections the user interacts with most.

### 2.1 Establishment Type Selector

- [ ] Task: Refactor type selector in Generelt section
    - [ ] Write widget tests for type selector rendering + change callback
    - [ ] Replace current `BusinessType` dropdown with styled `EstablishmentType` segment/card selector
    - [ ] Wire type changes to conditionally show/hide sections (reservation config for restaurant)

### 2.2 Opening Hours Editor

- [ ] Task: Build `OpeningHoursSection` widget
    - [ ] Write widget tests: renders 7 days, toggle disables time pickers, copy-to-all
    - [ ] Implement 7-day compact row layout: day label + is_open toggle + open/close time pickers
    - [ ] Add "Kopier til alle" action button per row
    - [ ] Wire to `Establishment.openingSchedule` via `copyWith`
- [ ] Task: Add scrollspy section to `EstablishmentEditView`
    - [ ] Add `_apningstiderKey` GlobalKey
    - [ ] Register "Åpningstider" in scrollspy navigation
    - [ ] Place between Kontakt and Innstillinger

### 2.3 Social Links Editor

- [ ] Task: Build `SocialLinksSection` widget
    - [ ] Write widget tests: add link, remove link, platform dropdown, URL validation
    - [ ] Implement dynamic list: platform dropdown + URL text field per entry
    - [ ] Known platforms show brand icon in dropdown
    - [ ] "Legg til lenke" (Add link) button at bottom
    - [ ] Wire to `Establishment.socialLinks` via `copyWith`
- [ ] Task: Add scrollspy section to `EstablishmentEditView`
    - [ ] Add `_sosialeKey` GlobalKey
    - [ ] Register "Sosiale medier" in scrollspy navigation
    - [ ] Place after Kontakt

---

## Phase 3: BP Edit UI — Booking Policy + Reservation Config

The heavier config sections. Booking policy is universal; reservation config is restaurant-conditional.

### 3.1 Booking Policy Editor

- [ ] Task: Build `BookingPolicySection` widget
    - [ ] Write widget tests: renders 3 groups, toggle interactions, slider, defaults
    - [ ] Implement "Planlegging" group: future days (number input), notice minutes (number input), slot interval (dropdown: 5/10/15/30/60)
    - [ ] Implement "Avbestilling" group: cancel toggle + notice hours, reschedule toggle + notice hours
    - [ ] Implement "Ekstra" group: confirmation message (text area), no-show fee (slider 0–100 with Vipps warning)
    - [ ] Wire to `Establishment.bookingPolicy` via `copyWith`
- [ ] Task: Add scrollspy section to `EstablishmentEditView`
    - [ ] Add `_bestillingsreglerKey` GlobalKey
    - [ ] Register "Bestillingsregler" in scrollspy navigation
    - [ ] Place after Åpningstider

### 3.2 Reservation Config Editor

- [ ] Task: Build `ReservationConfigSection` widget
    - [ ] Write widget tests: renders only for restaurant, field interactions, conditional fields
    - [ ] Implement all 10 fields with appropriate controls
    - [ ] `large_party_contact` shown only when `large_party_handling != disabled`
    - [ ] `total_capacity` shown only when `capacity_mode != pool`
    - [ ] Wire to `Establishment.reservationConfig` via `copyWith`
- [ ] Task: Add conditional scrollspy section to `EstablishmentEditView`
    - [ ] Add `_bordreservasjonKey` GlobalKey
    - [ ] Register "Bordreservasjon" in scrollspy navigation (conditional on type == restaurant)
    - [ ] Place after Bestillingsregler

---

## Phase 4: Marketplace Display + Verification + Deploy

Consumer-facing integration and full-stack verification.

### 4.1 Marketplace Opening Hours Display

- [ ] Task: Implement opening hours derivation
    - [ ] Write unit tests: isOpen logic for various times/days/timezones, closed days, edge cases
    - [ ] Implement `OpeningScheduleHelper.isOpenNow(schedule, timezone)` → `bool`
    - [ ] Implement `OpeningScheduleHelper.statusText(schedule, timezone)` → `String` ("Åpent til 18:00" / "Stengt i dag" / "Åpner kl. 09:00")
    - [ ] Wire into `EstablishmentData.isOpen` and `EstablishmentData.openingStatus` (replace TODOs)

### 4.2 Marketplace Social Links Display

- [ ] Task: Build social link icons row on EstablishmentPage
    - [ ] Write widget tests: known platform icons, unknown platform generic icon, tap opens URL
    - [ ] Implement horizontal icon row below establishment info
    - [ ] Known platforms → brand-colored icon, unknown → generic link icon
    - [ ] Tap → `url_launcher` to open URL

### 4.3 Verification + Deploy

- [ ] Task: Integration tests
    - [ ] BP: create/edit establishment with all new config fields, verify persistence
    - [ ] BP: verify type-conditional section visibility
    - [ ] Marketplace: verify opening hours display + social links
- [ ] Task: Deploy + E2E verify
    - [ ] Run BP integration tests (Saturn DB)
    - [ ] Deploy BP to Saturn :8003
    - [ ] Deploy Marketplace to phone
    - [ ] E2E: set opening hours on Dream On AS → verify Marketplace shows correct status
    - [ ] E2E: add social links → verify icons appear on EstablishmentPage
