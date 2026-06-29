# Spec: Favorites Toggle (Lagre Button)

> **Track:** `favorites_toggle_20260630`
> **Domain:** marketplace
> **Type:** feature
> **Recon:** `conductor/docs/marketplace/favorites-recon.md`

---

## Overview

The Lagre (Save/Favorite) button on the EstablishmentPage is currently a disabled placeholder (`onPressed: null`) in both mobile and wide layouts. This track wires it into a working toggle backed by the existing `favorite` table in `users/users`.

**Problem:** Users see a "Lagre" button they can't press. It signals broken UX.

**Solution:** Make it functional — tap to favorite, tap again to unfavorite, with auth gating per ADR-0020.

---

## Functional Requirements

1. **Authenticated user taps Lagre** → `favorite` record created in `users/users` namespace, heart icon fills solid (optimistic UI)
2. **Authenticated user taps Lagre again** → `favorite` record deleted, heart icon returns to outline (optimistic UI, revert on error)
3. **Unauthenticated user taps Lagre** → navigate to login page. After successful login, return to the same EstablishmentPage and auto-toggle the favorite
4. **Page load (authenticated)** → check if user has favorited this establishment, render correct heart state (filled or outline)
5. **Page load (unauthenticated)** → outline heart, no DB check

---

## Non-Functional Requirements

- **Optimistic UI** — heart state toggles instantly on tap; revert on DB error with a snackbar
- **No double-tap** — debounce or disable during in-flight toggle to prevent duplicate records
- **Offline tolerance** — if DB is unreachable, show error snackbar but don't crash

---

## Acceptance Criteria

- [ ] Lagre button is **enabled** (not greyed out) on both mobile and wide layouts
- [ ] Tapping Lagre while authenticated creates a `favorite` record and fills the heart
- [ ] Tapping Lagre again deletes the record and outlines the heart
- [ ] Tapping Lagre while unauthenticated navigates to login; after login, returns and auto-favorites
- [ ] Refreshing / navigating away and back preserves the correct heart state
- [ ] Unique index (`idx_favorite_unique`) prevents duplicate favorites
- [ ] Widget tests cover: toggle states, auth gate, error handling
- [ ] Integration tests cover: create/delete/check against real SurrealDB

---

## Edge Cases & Constraints

- **Cross-namespace** — `favorite` lives in `users/users`, establishment lives in `companies/{slug}`. No record links, only `target_id` as string
- **target_id format** — use the establishment's record ID string (e.g., `establishment:house-of-the-north`)
- **Race condition** — unique index handles duplicate creation; DELETE is idempotent
- **BP preview** — Lagre button in BP preview remains disabled (preview mode, no consumer auth)

---

## Dependencies

- **Auth Service** — consumer auth in marketplace (✅ built, Phases 1–3 complete)
- **`favorite` schema** — `schemas/users.surql` L87–95 (✅ exists)
- **EstablishmentPage** — `packages/establishment_ui/` (✅ exists, buttons are placeholders)

---

## Out of Scope

- **`favorites_count` counter sync** — deferred (cross-namespace writes, needs design decision)
- **Favorites list screen** — deferred to profile page polish track
- **Staff favorites** (`target_type: 'person'`) — deferred per domain glossary
- **Animated heart transition** — nice-to-have, not in this pass
