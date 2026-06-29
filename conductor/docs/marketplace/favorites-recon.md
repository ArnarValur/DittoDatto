# Favorites ("Lagre") — Recon Report

> **Date:** 2026-06-29
> **Scope:** Marketplace EstablishmentPage → Lagre button
> **Status:** Recon only — no track created yet

---

## Current State

Both "Lagre" buttons (mobile + wide layout) have `onPressed: null` — greyed out, no callback. Tapping does nothing regardless of auth state.

### What Exists

| Layer | Status | Location |
|-------|--------|----------|
| DB schema (`favorite` table in `users/users`) | ✅ Done | `schemas/users.surql` L87–95 |
| Counter fields (`favorites_count`) | ✅ Defined (no updater) | `schemas/company-blueprint.surql` L109, `schemas/discovery.surql` L87 |
| UI button (mobile) | ⚠️ Placeholder | `packages/establishment_ui/lib/src/sections/establishment_action_buttons.dart` L51–56 |
| UI button (wide) | ⚠️ Placeholder | `packages/establishment_ui/lib/src/sections/establishment_info_bar.dart` L179–184 |
| Auth provider | ✅ Built | `apps/marketplace/lib/core/auth_provider.dart` |
| ADR coverage | ✅ ADR-0020 | Auth required for favorites (Anonymous Browsing by Default) |

### What's Missing

| Layer | Notes |
|-------|-------|
| Dart model for `Favorite` | 4 fields: `user`, `target_id`, `target_type`, `added_at` |
| Repository (`FavoriteRepository`) | CRUD queries against `users/users` namespace |
| Riverpod provider | `isFavoritedProvider(establishmentId)` + toggle notifier |
| UI wiring | Callback, filled/outline heart toggle, auth gate on tap |
| Counter sync | Increment/decrement `favorites_count` (cross-namespace — explicit, not DB event) |
| Favorites list screen | View saved places (natural home: Profile tab) |

---

## Schema Detail

```sql
-- schemas/users.surql L87-95
DEFINE TABLE favorite SCHEMAFULL;
DEFINE FIELD user       ON favorite TYPE record<user>;
DEFINE FIELD target_id  ON favorite TYPE string;
DEFINE FIELD target_type ON favorite TYPE string DEFAULT 'store'
  ASSERT $value IN ['store', 'person'];
DEFINE FIELD added_at   ON favorite TYPE datetime VALUE $value OR time::now();

DEFINE INDEX idx_favorite_user ON favorite FIELDS user;
DEFINE INDEX idx_favorite_unique ON favorite FIELDS user, target_id, target_type UNIQUE;
```

> **Design note:** `target_id` is a string (not a record link) because favorites live in `users/users` namespace and can't cross-link to `companies/{slug}` records. The unique index prevents duplicates.

> **`target_type`** supports `'store'` (establishment) and `'person'` (staff — deferred).

---

## Ideal UX Flow

1. **Unauthenticated user taps Lagre** → redirect to login, return to page after auth
2. **Authenticated user taps Lagre** → create `favorite` record, fill heart icon, increment `favorites_count`
3. **Tap again** → delete record, outline heart, decrement counter
4. **On page load (authenticated)** → check if favorited, show correct heart state
5. **On page load (unauthenticated)** → outline heart, no check needed

---

## Cross-Namespace Counter Challenge

The `favorites_count` field lives on `establishment` (in `companies/{slug}`) and `establishment_listing` (in `companies/discovery`). The `favorite` record lives in `users/users`. SurrealDB can't do cross-namespace writes via events.

**Options:**
1. **MercuryEngine endpoint** — API call that writes to both namespaces (cleanest, matches booking pattern)
2. **Marketplace direct** — two separate DB connections (already has `users/users` for auth), update counter explicitly
3. **Eventual consistency** — periodic count sync job (simpler but laggy)

---

## Estimated Scope

Small-to-medium track, ~2–3 phases:

1. **Data layer** — Dart model, repository, provider, basic toggle
2. **UI wiring** — Auth gate, heart toggle, optimistic UI
3. **Counter sync + favorites list** — Cross-namespace counter, Profile tab list

---

## References

- **ADR-0020:** Anonymous Browsing by Default — "Auth required only for booking, favorites, and profile"
- **Domain glossary:** `conductor/context.md` L39 — "Favorite: A User's saved Establishment (or Staff, deferred). Stored in `users/users`."
- **Recon report:** `conductor/docs/recon_report.md` L228 — "Favorites/rebooking | ❌ Not built"
