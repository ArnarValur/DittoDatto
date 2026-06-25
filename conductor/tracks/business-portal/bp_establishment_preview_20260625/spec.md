# Specification — BP Establishment Page Preview

> **Track:** `bp_establishment_preview_20260625`
> **Domain:** business-portal (🔴 Tread Carefully)
> **Type:** feature
> **Created:** 2026-06-25

---

## Overview

Build a shared `EstablishmentPage` widget that renders an establishment's public-facing storefront view. The widget lives in `packages/establishment_ui/` and is consumed by two apps:

1. **Business Portal** — preview mode triggered by a "Forhåndsvisning" button in the edit screen AppBar (next to "Lagre"). The BP sidebar stays visible; only the main content area swaps between edit form and preview.
2. **Public Marketplace** — customer-facing page (future, not this track).

The page is a **single vertically scrollable layout** — no horizontal tab transitions. All sections stack top-to-bottom like a menu page.

### Reference

The legacy Nuxt implementation (`DittoDatto-old/packages/ui/components/establishment/EstablishmentPage.vue`) serves as visual reference. The Flutter version simplifies the initial scope to match what BP can currently edit.

---

## Functional Requirements

### Shared Package (`packages/establishment_ui/`)

1. **`EstablishmentData`** — a simple data class that holds the fields the preview needs. Decoupled from the BP `Establishment` model (which is tied to SurrealDB serialization). Fields for v1:
   - `name`, `businessType`, `category`, `about`
   - `address`, `city`, `zip`, `country`
   - `phone`, `email`, `website`
   - `isPublished`

2. **`EstablishmentPage`** — the main widget. Single scrollable page with these sections (top to bottom):
   - **Gallery placeholder** — empty state with "Bilder kommer snart" or similar. No image upload logic in this track.
   - **InfoBar** — establishment name, business type badge (Butikk/Restaurant/Spillested), address line, category if present.
   - **AboutGrid** — about text rendered in a clean card/section. Renamed from legacy "AboutSection" per user direction.
   - **ContactSection** — phone, email, website displayed as tappable items (tel:, mailto:, https:).
   - **Published status indicator** — visual cue showing draft vs published state.

3. Sub-widgets should be individual files in the package for composability.

### Business Portal Integration

1. **"Forhåndsvisning" button** — placed in the AppBar next to the existing "Lagre" button. Toggles between edit form and preview.
2. **Toggle behavior** — pressing the button swaps the main content area. Sidebar and AppBar remain. Button label/icon changes to indicate current mode (e.g., eye icon → pencil icon).
3. **Data flow** — the preview reads from the current form state (not from DB). If the user has unsaved edits, the preview shows those edits. This gives true WYSIWYG behavior.
4. **Mobile** — on narrow viewports, the preview button still works but takes the full content area (no sidebar, consistent with existing responsive behavior).

---

## Non-Functional Requirements

- The `EstablishmentPage` widget must render at 60fps on mid-range Android devices (Samsung Galaxy S21 is the test device).
- The shared package must have zero dependency on BP or Marketplace — it consumes `ditto_design` tokens only.
- Norwegian labels throughout (consistent with existing UI language).

---

## Acceptance Criteria

1. `packages/establishment_ui/` exists as a Dart package in the pub workspace.
2. `EstablishmentPage` renders all v1 sections (gallery placeholder, info bar, about grid, contact section).
3. BP edit screen has a "Forhåndsvisning" toggle button next to "Lagre".
4. Pressing the button swaps the main content to show `EstablishmentPage` with current form data.
5. Pressing again returns to the edit form with all data preserved.
6. BP sidebar remains visible during preview on desktop viewports.
7. Widget tests cover all sections of `EstablishmentPage`.
8. Widget tests cover the BP preview toggle behavior.

---

## Edge Cases & Constraints

- **Empty fields** — preview should gracefully handle null/empty optional fields (phone, email, website, about, category). Don't show empty sections.
- **Unsaved edits** — preview reflects current form state, not last-saved DB state. This is intentional.
- **No images yet** — gallery section shows a clean placeholder, not a broken image state.
- **BusinessType display** — must map enum values to Norwegian labels (Butikk, Restaurant, Spillested).

---

## Dependencies

- `packages/ditto_design/` — design tokens, theme, shared widgets
- `apps/business-portal/` — existing establishment edit screen (`EstablishmentEditView`)
- BP `Establishment` model — needs a `.toEstablishmentData()` mapper

---

## Out of Scope

- Image upload or gallery management
- Service/staff/event sections (future tracks)
- Marketplace consumption of the widget (separate track)
- Opening hours display (BP can't edit schedules yet)
- Map integration (deferred — BP has placeholder)
- Booking CTA / favorites button (marketplace-only, future)
- "Page builder" editing of section order/visibility (future evolution)
