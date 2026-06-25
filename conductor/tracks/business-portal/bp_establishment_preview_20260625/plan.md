# Implementation Plan — BP Establishment Page Preview

> **Track:** `bp_establishment_preview_20260625`
> **Workflow:** Strict (TDD)

---

## Phase 1: Shared Package Scaffold

### Task 1.1: Create `packages/establishment_ui/`
- [ ] Scaffold Dart package with `pubspec.yaml` (depends on `ditto_design`)
- [ ] Add to pub workspace in root `pubspec.yaml`
- [ ] Create barrel file `lib/establishment_ui.dart`
- [ ] Run `flutter pub get` from workspace root

### Task 1.2: `EstablishmentData` model
- [ ] Write tests for `EstablishmentData` (construction, equality, copyWith, null-field handling)
- [ ] Implement `EstablishmentData` — immutable data class with fields: `name`, `businessType`, `category`, `about`, `address`, `city`, `zip`, `country`, `phone`, `email`, `website`, `isPublished`
- [ ] `BusinessType` enum with Norwegian labels (Butikk, Restaurant, Spillested) — shared, not imported from BP

---

## Phase 2: EstablishmentPage Widget

Build the main scrollable page using `CustomScrollView` + slivers. All sections are individual widget files.

### Task 2.1: `EstablishmentPage` scaffold
- [ ] Write test: page renders without crashing given minimal `EstablishmentData`
- [ ] Implement `EstablishmentPage` — `CustomScrollView` with sliver sections, accepts `EstablishmentData` + `isPreview` flag

### Task 2.2: Gallery placeholder section
- [ ] Write test: gallery placeholder renders with "Bilder kommer snart" text
- [ ] Implement `EstablishmentGalleryPlaceholder` — `SliverToBoxAdapter` with styled empty state (icon + text). Reserved for future image gallery.

### Task 2.3: InfoBar section
- [ ] Write test: name, business type badge, address renders correctly
- [ ] Write test: category shows when present, hidden when null
- [ ] Implement `EstablishmentInfoBar` — `SliverToBoxAdapter` with: establishment name (headlineMedium), business type chip/badge, address line (city + zip), category if present

### Task 2.4: AboutGrid section
- [ ] Write test: about text renders when present, section hidden when null
- [ ] Implement `EstablishmentAboutGrid` — `SliverToBoxAdapter` with about text in a clean outlined card. Hidden when `about` is null/empty.

### Task 2.5: Contact section
- [ ] Write test: phone, email, website render as ListTiles with correct icons
- [ ] Write test: section hidden when all contact fields are null
- [ ] Implement `EstablishmentContactSection` — `SliverToBoxAdapter` with `ListTile`s for phone (📞), email (✉️), website (🌐). Each only shown if non-null. Entire section hidden if all are null.

### Task 2.6: Published status indicator
- [ ] Write test: draft indicator shows when `isPublished == false`
- [ ] Write test: no indicator when `isPublished == true`
- [ ] Implement — subtle banner/chip at top of page showing "Utkast" (Draft) when unpublished. Only visible when `isPreview == true`.

---

## Phase 3: BP Integration

### Task 3.1: `toEstablishmentData()` mapper
- [ ] Write test: BP `Establishment` model maps correctly to `EstablishmentData`
- [ ] Implement extension method on BP `Establishment` model

### Task 3.2: Preview toggle in edit screen
- [ ] Write widget test: "Forhåndsvisning" button appears in AppBar next to "Lagre"
- [ ] Write widget test: tapping toggles between edit form and preview
- [ ] Write widget test: preview shows `EstablishmentPage` with current form data
- [ ] Write widget test: toggling back preserves form state
- [ ] Implement preview toggle state + button in `EstablishmentEditView`
- [ ] Swap main content area based on toggle (edit form ↔ `EstablishmentPage`)
- [ ] Pass current form field values (not saved DB state) to `EstablishmentData`

### Task 3.3: AppBar button UX
- [ ] Implement icon swap: eye icon (👁️) when in edit mode → pencil icon (✏️) when in preview mode
- [ ] Tooltip: "Forhåndsvisning" / "Tilbake til redigering"

---

## Phase 4: Verification

### Task 4.1: Integration tests
- [ ] Write integration test: navigate to establishment → tap preview → verify page renders → tap back → verify form intact
- [ ] Run full BP test suite — all existing tests must stay green

### Task 4.2: Visual verification
- [ ] Run on desktop viewport — verify sidebar stays visible during preview
- [ ] Run on mobile viewport — verify preview takes full content area
- [ ] Verify dark mode rendering

---

## Verification Plan

### Automated Tests
```bash
cd packages/establishment_ui && flutter test
cd apps/business-portal && flutter test
cd apps/business-portal && flutter test --tags integration
```

### Manual Verification
- Deploy to Saturn, verify preview toggle works E2E with real establishment data
- Test on Samsung Galaxy S21 (if BP supports mobile viewport)
