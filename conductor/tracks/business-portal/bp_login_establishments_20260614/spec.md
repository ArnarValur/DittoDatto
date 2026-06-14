# Spec: Business Portal — Login + Establishments

> **Track:** `bp_login_establishments_20260614`
> **Domain:** business-portal | **Type:** feature | **Caution:** 🔴 Tread Carefully

---

## Overview

First vertical slice of the Business Portal Flutter app. Two deliverables:

1. **Login redesign** — replace the generic dark-mode login (copy of Admin Panel) with a premium light-theme login driven by the Stitch "Enterprise Slate" design system.
2. **Establishments CRUD** — list, create, and edit Establishments with 4 tabs (General, Location, Contact, Settings). Card-based list view. Dialog-based creation.

This track turns the Business Portal from a scaffold with stubs into a working merchant tool.

---

## Design Reference

- **Stitch export:** `conductor/docs/assets/stitch_enterprise_slate_login_prd/`
  - `high_contrast_enterprise/DESIGN.md` — design system tokens
  - `authentication_primary_light_mode/screen.png` — light mode render
  - `authentication_primary_dark_mode/screen.png` + `code.html` — dark mode + full color scheme
- **Nuxt reference screenshots:** `conductor/docs/screenshots/Business-Portal/Establishment/`

---

## Functional Requirements

### F1: Light Theme for `ditto_design`

- Add `DittoTheme.light()` alongside existing `DittoTheme.dark()`.
- Seed color: Moody Blue `#6F71CC`, brightness: `Brightness.light`.
- Typography: **Outfit** for headlines, **Manrope** for body — per Stitch DESIGN.md.
  - Admin Panel keeps Inter/dark. Business Portal gets Outfit+Manrope/light.
- Extract light-mode `ColorScheme` from Stitch's Tailwind config (exact hex values in `code.html`).
- Add `DittoElevation` tokens for tonal layering (Level 0/1/2) per DESIGN.md.
- Add "Moody Blue glow" focus state token (`accent_glow`: `rgba(111, 113, 204, 0.15)`).

### F2: Login Screen Redesign

Based on Stitch light-mode design:

- **Storefront icon** in Moody Blue container (replaces lock icon)
- **"Logg inn på DittoDatto"** heading (Norwegian bokmål)
- **"Velkommen tilbake. Skriv inn dine påloggingsdetaljer."** subtitle
- **E-post** field with placeholder `navn@bedrift.no`
- **Passord** field with visibility toggle (eye icon)
- **"Logg inn →"** primary button (Moody Blue, full width)
- Loading state: spinner replaces button text
- **No error feedback** on auth failure (per PRD — silent fail)
- **Remove from Stitch design (not v1):** Forgot password, Remember device, SSO, Create account, Footer
- **Add:** "Kontakt administrator for tilgang" text below form

### F3: Establishments List Screen

- Card-based layout (not table rows)
- Each card: business type icon, name, address, type badge, status badge (Live/Draft)
- Tab filters by business type ("Alle", "Butikk", "Restaurant", "Spillested")
- **"+ Legg til virksomhet"** button (top right)
- Empty state when no establishments exist
- Tap card → navigate to tabbed edit view

### F4: Establishment Create Dialog

- Dialog/modal triggered by "+ Legg til virksomhet"
- Fields: Virksomhetstype (rich dropdown), Navn, Adresse, By, Postnummer
- "Avbryt" / "Lagre" buttons
- On save: create in SurrealDB → redirect to tabbed edit view

### F5: Establishment Edit View (4 Tabs)

#### Tab 1: Generelt (General)
- Name, Business Type (dropdown), Category (dropdown), About/Description (textarea)

#### Tab 2: Lokasjon (Location)
- Street Address, City, Zip Code fields
- Map preview placeholder (map integration deferred)

#### Tab 3: Kontakt (Contact)
- Phone (`+47` prefix), Email, Website fields
- Logo selection deferred (depends on Media Management track)

#### Tab 4: Innstillinger (Settings)
- **Publiser virksomhet** toggle — "Gjør denne virksomheten synlig for kunder"
- **Kapasitet** (optional, shown for venues) — maximum capacity number
- **Ressurshåndtering** toggle — enable/disable resource management

### F6: Data Layer

- All CRUD via direct SurrealDB WebSocket queries (ADR-0006)
- Tenant-scoped: `USE NS companies DB company_{slug}` (ADR-0013)
- Riverpod providers for Establishment state
- Models in `mercury_client` or local to Business Portal (decide during implementation)

---

## Non-Functional Requirements

- **Norwegian bokmål only** — all UI text
- **Responsive** — web (primary), desktop, mobile
- **Light theme** — Business Portal uses `DittoTheme.light()`. Admin stays dark.
- **Silent auth failure** — per PRD
- **Caution level 🔴** — extra review on `ditto_design` changes

---

## Acceptance Criteria

- [ ] Login renders with Stitch light-mode design
- [ ] Login authenticates and navigates to dashboard on success
- [ ] Establishments list shows cards with badges and filters
- [ ] "+ Legg til virksomhet" opens create dialog and saves to SurrealDB
- [ ] Tapping card opens 4-tab edit view
- [ ] Edit saves changes to SurrealDB
- [ ] Settings tab Publish toggle works
- [ ] Admin Panel unaffected by `ditto_design` changes
- [ ] All tests pass (>80% coverage for new code)

---

## Edge Cases & Constraints

- **Admin Panel regression** — light theme must not break Admin dark theme
- **Typography divergence** — Admin keeps Inter, Portal uses Outfit+Manrope
- **Empty company** — friendly empty state for first-time merchants
- **SurrealDB schema** — Establishment schema must exist in `schemas/`

---

## Dependencies

- `ditto_design` package (shared — changes affect all Flutter apps)
- SurrealDB Establishment schema (`schemas/`)
- Business Portal scaffold track (complete: `eadc310`)
- Auth provider (exists)

---

## Out of Scope

| Item | Rationale |
|------|-----------|
| Hours tab | Complex UI + Schedule overlap — separate track + grill |
| Media tab + Media Manager | Full standalone feature |
| Preview Page | Marketplace domain |
| Social Links | Deprioritized |
| Nominatim autocomplete | Deferred — manual entry for v1 |
| Password reset | No flow exists |
| SSO / Vipps login | Native credentials (ADR-0006) |
| English i18n | Norwegian first |
| Dark mode toggle | Light only for now |
