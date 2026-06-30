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
    - [ ] E2E test against Saturn — ❌ FAILS (CREATE returns empty)

- [ ] Task: Deploy to phone
    - [ ] `flutter run --release -d R5CR61FGVPN`
    - [ ] E2E: log in → navigate to House of the North → tap Lagre → heart fills → navigate away → return → heart still filled → tap again → heart outlines

- [ ] Task: Merge
    - [ ] Check for concurrent session conflicts on `develop`
    - [ ] Merge `track/marketplace-favorites` → `develop`

### Blocker Details

**SurrealDB 3.1.2 (Saturn) vs 3.0.5 (local test DB):**
- Consumer RECORD ACCESS users cannot CREATE records on ANY SCHEMAFULL table on Saturn
- Even `PERMISSIONS FULL` + `option<record<user>>` doesn't help
- Schemaless CREATE also returns empty
- `INFO FOR DB` shows `accesses: {}` despite working signup/signin
- Needs root-cause debugging — likely a behavior change in RECORD ACCESS between 3.0.x and 3.1.x
