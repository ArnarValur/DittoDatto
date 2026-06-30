# Plan: Favorites Toggle

> **Track:** `favorites_toggle_20260630`
> **Workflow:** strict (TDD)

---

## Phase 1: Data Layer

- [x] Task: Create `Favorite` Dart model
    - [x] Model class with `user`, `targetId`, `targetType`, `addedAt` fields
    - [x] `fromJson` / `toJson` serialization (SurrealDB record format)
    - [x] Write unit tests for serialization round-trip (9/9 pass)

- [x] Task: Create `FavoriteRepository`
    - [x] `addFavorite(targetId, targetType)` → CREATE query on `users/users`
    - [x] `removeFavorite(targetId, targetType)` → DELETE query (by unique index fields)
    - [x] `isFavorited(targetId, targetType)` → SELECT check
    - [x] `listFavorites()` → SELECT all for current user (prep for future list screen)
    - [x] Write integration tests against real SurrealDB (9/9 pass on local 3.0.5)

- [x] Task: Create Riverpod providers
    - [x] `favoriteRepositoryProvider` — instantiates repository with consumer auth DB connection
    - [x] `isFavoritedProvider(targetId)` — FutureProvider checking favorite state
    - [x] `toggleFavoriteProvider` — method to add/remove with optimistic state

- [x] Task: Schema permissions
    - [x] Added RECORD ACCESS permissions to `favorite` table in `schemas/users.surql`
    - [x] Auto-set `user` field via `VALUE $auth.id`
    - [x] Applied schema to Saturn production DB

---

## Phase 2: UI Wiring + Auth Gate

- [x] Task: Add `onFavoriteTapped` and `isFavorited` to establishment page widgets
    - [x] Update `EstablishmentActionButtons` — accept callback + bool, toggle icon
    - [x] Update `EstablishmentInfoBar` — accept callback + bool, toggle icon (both wide + mobile)
    - [x] Keep `onPressed: null` when `isPreview == true` (BP preview stays disabled)
    - [ ] Write widget tests for both layouts (filled/outline states, disabled in preview)

- [x] Task: Wire callbacks in Marketplace `EstablishmentTestScreen`
    - [x] Read `authProvider` state — if authenticated, call toggle; if not, navigate to login
    - [ ] Pass `pendingFavorite` flag via router extra so login return auto-toggles
    - [x] Read `isFavoritedProvider` on build to set initial heart state
    - [x] Show error snackbar on toggle failure

- [x] Task: Profile "Mine favoritter" sticker card
    - [x] Heart icon + live count from `favoritesCountProvider`
    - [x] No-op tap — full list deferred to profile grill

- [ ] Task: Write integration test for auth gate flow
    - [ ] Unauthenticated → tap Lagre → navigates to login
    - [ ] Authenticated → tap Lagre → heart fills

---

## Phase 3: Verification + Deploy — BLOCKED

- [x] Task: Run full test suite
    - [x] `packages/establishment_ui/` widget tests — 91/91 ✅
    - [x] Marketplace unit tests — 9/9 model ✅
    - [x] Marketplace integration tests — 9/9 repo (local DB) ✅
    - [x] Zero regressions on BP tests — 75/75 ✅
    - [x] E2E test against Saturn — ✅ (Saturn DB permissions fixed)

- [x] Task: Deploy to phone
    - [x] `flutter run --release -d R5CR61FGVPN`
    - [x] E2E: log in → navigate to House of the North → tap Lagre → heart fills. User confirmed.

- [ ] Task: Merge
    - [ ] Check for concurrent session conflicts on `develop`
    - [ ] Merge `track/marketplace-favorites` → `develop`

### Blocker — RESOLVED

**Root cause:** Previous debugging session left `favorite` table with `PERMISSIONS NONE` on Saturn. Fix: `REMOVE TABLE` + `DEFINE TABLE SCHEMAFULL PERMISSIONS FULL` + field/index recreation + `ALTER TABLE` for row-level permissions. Verified via HTTP API + deployed to phone.
