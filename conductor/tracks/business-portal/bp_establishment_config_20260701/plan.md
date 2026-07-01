# Plan: BP Establishment Configuration

> **Track:** `bp_establishment_config_20260701`
> **Workflow:** strict (TDD)
> **Phases:** 4

---

## Phase 1: Schema Migration + Dart Model Layer

Foundation phase — all data plumbing before any UI work.

### 1.1 Schema Migration

- [x] Task: Rename `store_type` → `establishment_type` in `schemas/company-blueprint.surql`
    - [x] Rename field definition, update ASSERT values: `shop`/`restaurant`/`venue` (default `shop`)
    - [x] Remove `booking_form_type` field entirely
    - [x] Update `large_party_handling` ASSERT: `notify`/`email`/`call`/`form`/`disabled` (default `notify`)
    - [x] Redefine `social_links` as `TYPE option<array<object>>` with `platform` (string) + `url` (string) subfields
- [x] Task: Update `schemas/discovery.surql`
    - [x] Rename `store_type` → `establishment_type` on `establishment_listing`
- [x] Task: Write migration script for existing data on staging
    - [x] Rename `store_type` → `establishment_type` value `store` → `shop` on all existing establishments
    - [x] Migrate `social_links` from object `{fb, ig, x}` to array format `[{platform, url}]`
    - [x] Remove `booking_form_type` values from existing records
    - [x] Apply to all company DBs on Saturn (Dream On AS, DittoDatto AS, Merkurial Studio)

### 1.2 Dart Model Classes

- [x] Task: Create `OpeningDay` model
    - [x] Write tests for `OpeningDay.fromJson`/`toJson` (open day, closed day, edge cases)
    - [x] Implement `OpeningDay` class: `isOpen` (bool), `open` (String), `close` (String)
    - [x] Create `OpeningSchedule` typedef/helper for `Map<String, OpeningDay>` (mon–sun)
- [x] Task: Create `BookingPolicy` model
    - [x] Write tests for `BookingPolicy.fromJson`/`toJson` (defaults, all fields, partial)
    - [x] Implement `BookingPolicy` class: all 9 fields with defaults matching schema
- [x] Task: Create `SocialLink` model
    - [x] Write tests for `SocialLink.fromJson`/`toJson` (known platform, unknown, empty)
    - [x] Implement `SocialLink` class: `platform` (String), `url` (String)
    - [x] Add `SocialLink.knownPlatforms` const set: `{facebook, instagram, snapchat, tiktok}`
    - [x] Add `SocialLink.iconForPlatform()` helper
- [x] Task: Create `ReservationConfig` model
    - [x] Write tests for `ReservationConfig.fromJson`/`toJson` (defaults, all fields)
    - [x] Implement `ReservationConfig` class: all 10 fields with defaults matching schema
- [x] Task: Rename `BusinessType` → `EstablishmentType` enum
    - [x] Rename enum + update `store` → `shop`
    - [x] Update `fromString` to parse `shop`/`restaurant`/`venue`
    - [x] Update all references across BP codebase (model, providers, edit view, etc.)
- [x] Task: Extend `Establishment` model with new fields
    - [x] Write integration tests: round-trip new fields to SurrealDB and back
    - [x] Add fields: `openingSchedule`, `timezone`, `bookingPolicy`, `socialLinks`, `reservationConfig`
    - [x] Update `fromJson` to parse all new embedded objects
    - [x] Update `toJson` to serialize (omit null/empty per SurrealDB SCHEMAFULL rules)
    - [x] Update `copyWith` with all new fields

### 1.3 Update Discovery Sync

- [x] Task: Update `ListingSyncService` for terminology rename
    - [x] Update any `store_type` references → `establishment_type` in discovery sync code
    - [x] Verify BP publish still works after rename

---

## Phase 2: BP Edit UI — Type Selector + Opening Hours + Social Links

Three new/updated UI sections. Quick-win visuals — the sections the user interacts with most.

### 2.1 Establishment Type Selector

- [x] Task: Refactor type selector in Generelt section
    - [x] Write widget tests for type selector rendering + change callback
    - [x] Replace current `BusinessType` dropdown with styled `EstablishmentType` segment/card selector
    - [x] Wire type changes to conditionally show/hide sections (reservation config for restaurant)

### 2.2 Opening Hours Editor

- [x] Task: Build `OpeningHoursSection` widget
    - [x] Write widget tests: renders 7 days, toggle disables time pickers, copy-to-all
    - [x] Implement 7-day compact row layout: day label + is_open toggle + open/close time pickers
    - [x] Add "Kopier til alle" action button per row
    - [x] Wire to `Establishment.openingSchedule` via `copyWith`
- [x] Task: Add scrollspy section to `EstablishmentEditView`
    - [x] Add `_apningstiderKey` GlobalKey
    - [x] Register "Åpningstider" in scrollspy navigation
    - [x] Place between Kontakt and Innstillinger

### 2.3 Social Links Editor

- [x] Task: Build `SocialLinksSection` widget
    - [x] Write widget tests: add link, remove link, platform dropdown, URL validation
    - [x] Implement dynamic list: platform dropdown + URL text field per entry
    - [x] Known platforms show brand icon in dropdown
    - [x] "Legg til lenke" (Add link) button at bottom
    - [x] Wire to `Establishment.socialLinks` via `copyWith`
- [x] Task: Add scrollspy section to `EstablishmentEditView`
    - [x] Add `_sosialeKey` GlobalKey
    - [x] Register "Sosiale medier" in scrollspy navigation
    - [x] Place after Kontakt

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

- [x] Task: Integration tests
    - [x] BP: create/edit establishment with all new config fields, verify persistence
    - [ ] BP: verify type-conditional section visibility
    - [ ] Marketplace: verify opening hours display + social links
- [x] Task: Deploy + E2E verify
    - [x] Run BP integration tests (Saturn DB)
    - [x] Deploy BP to Saturn :8003
    - [x] Deploy Marketplace to phone
    - [ ] E2E: set opening hours on Dream On AS → verify Marketplace shows correct status
    - [ ] E2E: add social links → verify icons appear on EstablishmentPage
