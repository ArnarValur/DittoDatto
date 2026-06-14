# Plan: Business Portal — Login + Establishments

> **Track:** `bp_login_establishments_20260614`
> **Workflow:** Strict (TDD) — Red → Green → Refactor on every task

---

## Phase 1: Design System — Light Theme

- [ ] Task: Add light `ColorScheme` to `ditto_design`
    - [ ] Write tests verifying `DittoTheme.light()` returns a valid `ThemeData` with `Brightness.light` and Moody Blue primary
    - [ ] Implement `DittoTheme.light()` using Stitch color tokens from `code.html`
    - [ ] Verify `DittoTheme.dark()` is unchanged (regression test)

- [ ] Task: Add Outfit + Manrope typography option
    - [ ] Write tests verifying `DittoTheme.light()` uses Outfit for headlines and Manrope for body
    - [ ] Add Google Fonts dependencies (`google_fonts` package or font assets)
    - [ ] Implement configurable `TextTheme` in `DittoTheme`

- [ ] Task: Add elevation/focus tokens
    - [ ] Write tests for `DittoElevation` tonal layering constants (Level 0/1/2 colors)
    - [ ] Implement `DittoElevation` class with light/dark variants
    - [ ] Add `accentGlow` BoxDecoration token for Moody Blue focus states

---

## Phase 2: Login Redesign

- [ ] Task: Rebuild `LoginScreen` with Stitch light-mode design
    - [ ] Write widget tests: storefront icon renders, form fields present, Norwegian labels correct
    - [ ] Implement new `LoginScreen` layout per Stitch `authentication_primary_light_mode/screen.png`
    - [ ] Wire visibility toggle on password field
    - [ ] Add "Kontakt administrator for tilgang" text

- [ ] Task: Apply light theme to Business Portal `main.dart`
    - [ ] Write test verifying `MaterialApp` uses `DittoTheme.light()`
    - [ ] Update `main.dart` theme from `DittoTheme.dark()` to `DittoTheme.light()`
    - [ ] Verify login renders correctly with light theme

- [ ] Task: Verify Admin Panel is unaffected
    - [ ] Run existing Admin Panel tests — all must pass
    - [ ] Verify Admin `main.dart` still uses `DittoTheme.dark()`

---

## Phase 3: Establishments List

- [ ] Task: Create `Establishment` model
    - [ ] Write tests for model serialization/deserialization (from SurrealDB JSON)
    - [ ] Implement `Establishment` model class with fields: id, name, businessType, category, address, city, zipCode, phone, email, website, description, isPublished, maxCapacity, resourceManagement, coordinates
    - [ ] Add `BusinessType` enum (store, restaurant, venue)

- [ ] Task: Create Establishment Riverpod providers
    - [ ] Write tests for `establishmentListProvider` (mock SurrealDB)
    - [ ] Implement `EstablishmentListNotifier` with CRUD operations
    - [ ] Wire to SurrealDB WebSocket queries (tenant-scoped)

- [ ] Task: Build `EstablishmentsScreen` list view
    - [ ] Write widget tests: cards render with name/address/badges, filter tabs work
    - [ ] Implement card-based list with `DittoNavItem`-style type badges
    - [ ] Add tab filters ("Alle", "Butikk", "Restaurant", "Spillested")
    - [ ] Add empty state widget
    - [ ] Add "+ Legg til virksomhet" button

---

## Phase 4: Establishment Create + Edit

- [ ] Task: Build create dialog
    - [ ] Write widget tests: dialog opens, fields validate, form submits
    - [ ] Implement `CreateEstablishmentDialog` with: Virksomhetstype, Navn, Adresse, By, Postnummer
    - [ ] Wire to `EstablishmentListNotifier.create()`
    - [ ] Navigate to edit view on success

- [ ] Task: Build tabbed edit view — Generelt tab
    - [ ] Write widget tests for General tab fields and save
    - [ ] Implement tab with: Name, Business Type, Category, Description
    - [ ] Wire save to `EstablishmentListNotifier.update()`

- [ ] Task: Build tabbed edit view — Lokasjon tab
    - [ ] Write widget tests for Location tab fields
    - [ ] Implement tab with: Street Address, City, Zip Code
    - [ ] Add coordinates display (read-only, for future map integration)

- [ ] Task: Build tabbed edit view — Kontakt tab
    - [ ] Write widget tests for Contact tab fields
    - [ ] Implement tab with: Phone, Email, Website

- [ ] Task: Build tabbed edit view — Innstillinger tab
    - [ ] Write widget tests for Settings tab toggles
    - [ ] Implement: Publish toggle, Capacity field (conditional on venue type), Resource Management toggle

- [ ] Task: Wire GoRouter routes for edit view
    - [ ] Write tests for route navigation (list → edit → back)
    - [ ] Add `/establishments/:id` route to `PortalRouter`
    - [ ] Wire tab persistence (remember selected tab on back-navigate)

---

## Phase 5: Integration & Polish

- [ ] Task: End-to-end login → list → create → edit flow
    - [ ] Write integration test for the full merchant journey
    - [ ] Fix any navigation or state issues discovered

- [ ] Task: Responsive layout verification
    - [ ] Test on mobile viewport (< 600px)
    - [ ] Test on tablet viewport (600–1200px)
    - [ ] Test on desktop viewport (> 1200px)
    - [ ] Fix any layout breakages

- [ ] Task: Coverage gate & cleanup
    - [ ] Run full test suite with coverage
    - [ ] Ensure >80% coverage for all new files
    - [ ] Remove any dead code or unused imports
