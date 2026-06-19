# Plan: Business Portal — Login + Establishments

> **Track:** `bp_login_establishments_20260614`
> **Workflow:** Strict (TDD) — Red → Green → Refactor on every task

---

## Phase 1: Design System — Light Theme

- [x] Task: Add light `ColorScheme` to `ditto_design`
    - [x] Write tests verifying `DittoTheme.light()` returns a valid `ThemeData` with `Brightness.light` and Moody Blue primary
    - [x] Implement `DittoTheme.light()` using Stitch color tokens from `code.html`
    - [x] Verify `DittoTheme.dark()` is unchanged (regression test)

- [x] Task: Add Outfit + Manrope typography option
    - [x] Write tests verifying `DittoTheme.light()` uses Outfit for headlines and Manrope for body
    - [x] Add Google Fonts dependencies (`google_fonts` package or font assets)
    - [x] Implement configurable `TextTheme` in `DittoTheme`

- [x] Task: Add elevation/focus tokens
    - [x] Write tests for `DittoElevation` tonal layering constants (Level 0/1/2 colors)
    - [x] Implement `DittoElevation` class with light/dark variants
    - [x] Add `accentGlow` BoxDecoration token for Moody Blue focus states

---

## Phase 2: Login Redesign

- [x] Task: Rebuild `LoginScreen` with Stitch light-mode design
    - [x] Write widget tests: storefront icon renders, form fields present, Norwegian labels correct
    - [x] Implement new `LoginScreen` layout per Stitch `authentication_primary_light_mode/screen.png`
    - [x] Wire visibility toggle on password field
    - [x] Add "Kontakt administrator for tilgang" text

- [x] Task: Apply light theme to Business Portal `main.dart`
    - [x] Write test verifying `MaterialApp` uses `DittoTheme.light()`
    - [x] Update `main.dart` theme from `DittoTheme.dark()` to `DittoTheme.light()`
    - [x] Verify login renders correctly with light theme

- [x] Task: Verify Admin Panel is unaffected
    - [x] Run existing Admin Panel tests — all must pass
    - [x] Verify Admin `main.dart` still uses `DittoTheme.dark()`

---

## Phase 3: Establishments List

- [x] Task: Create `Establishment` model
    - [x] Write tests for model serialization/deserialization (from SurrealDB JSON)
    - [x] Implement `Establishment` model class with fields: id, name, businessType, category, address, city, zipCode, phone, email, website, description, isPublished, maxCapacity, resourceManagement, coordinates
    - [x] Add `BusinessType` enum (store, restaurant, venue)

- [x] Task: Create Establishment Riverpod providers
    - [x] Write tests for `establishmentListProvider` (mock SurrealDB)
    - [x] Implement `EstablishmentListNotifier` with CRUD operations
    - [x] Wire to SurrealDB WebSocket queries (tenant-scoped)

- [x] Task: Build `EstablishmentsScreen` list view
    - [x] Write widget tests: cards render with name/address/badges, filter tabs work
    - [x] Implement card-based list with `DittoNavItem`-style type badges
    - [x] Add tab filters ("Alle", "Butikk", "Restaurant", "Spillested")
    - [x] Add empty state widget
    - [x] Add "+ Legg til virksomhet" button

---

## Phase 4: Establishment Create + Edit

- [x] Task: Build create dialog
    - [x] Write widget tests: dialog opens, fields validate, form submits
    - [x] Implement `CreateEstablishmentDialog` with: Virksomhetstype, Navn, Adresse, By, Postnummer
    - [x] Wire to `EstablishmentListNotifier.create()`
    - [x] Navigate to edit view on success

- [x] Task: Build tabbed edit view — Generelt tab
    - [x] Write widget tests for General tab fields and save
    - [x] Implement tab with: Name, Business Type, Category, Description
    - [x] Wire save to `EstablishmentListNotifier.update()`

- [x] Task: Build tabbed edit view — Lokasjon tab
    - [x] Write widget tests for Location tab fields
    - [x] Implement tab with: Street Address, City, Zip Code
    - [x] Add coordinates display (read-only, for future map integration)

- [x] Task: Build tabbed edit view — Kontakt tab
    - [x] Write widget tests for Contact tab fields
    - [x] Implement tab with: Phone, Email, Website

- [x] Task: Build tabbed edit view — Innstillinger tab
    - [x] Write widget tests for Settings tab toggles
    - [x] Implement: Publish toggle, Capacity field (conditional on venue type), Resource Management toggle

- [x] Task: Wire GoRouter routes for edit view
    - [x] Write tests for route navigation (list → edit → back)
    - [x] Add `/establishments/:id` route to `PortalRouter`
    - [x] Wire tab persistence (remember selected tab on back-navigate)

---

## Phase 5: Integration & Polish

- [/] Task: End-to-end login → list → create → edit flow
    - [/] Write integration test for the full merchant journey
    - [ ] Fix any navigation or state issues discovered

- [/] Task: Responsive layout verification
    - [/] Test on mobile viewport (< 600px)
    - [/] Test on tablet viewport (600–1200px)
    - [/] Test on desktop viewport (> 1200px)
    - [ ] Fix any layout breakages

- [/] Task: Coverage gate & cleanup
    - [x] Run full test suite with coverage
    - [x] Ensure >80% coverage for all new files
    - [x] Remove any dead code or unused imports
