# Plan: Favorites Toggle

> **Track:** `favorites_toggle_20260630`
> **Workflow:** strict (TDD)

---

## Phase 1: Data Layer

- [ ] Task: Create `Favorite` Dart model
    - [ ] Model class with `user`, `targetId`, `targetType`, `addedAt` fields
    - [ ] `fromJson` / `toJson` serialization (SurrealDB record format)
    - [ ] Write unit tests for serialization round-trip

- [ ] Task: Create `FavoriteRepository`
    - [ ] `addFavorite(targetId, targetType)` → CREATE query on `users/users`
    - [ ] `removeFavorite(targetId, targetType)` → DELETE query (by unique index fields)
    - [ ] `isFavorited(targetId, targetType)` → SELECT check
    - [ ] `listFavorites()` → SELECT all for current user (prep for future list screen)
    - [ ] Write integration tests against real SurrealDB (create, delete, check, unique constraint)

- [ ] Task: Create Riverpod providers
    - [ ] `favoriteRepositoryProvider` — instantiates repository with consumer auth DB connection
    - [ ] `isFavoritedProvider(targetId)` — FutureProvider checking favorite state
    - [ ] `toggleFavoriteProvider` — method to add/remove with optimistic state

---

## Phase 2: UI Wiring + Auth Gate

- [ ] Task: Add `onFavoriteTapped` and `isFavorited` to establishment page widgets
    - [ ] Update `EstablishmentActionButtons` — accept callback + bool, toggle icon
    - [ ] Update `EstablishmentInfoBar` — accept callback + bool, toggle icon
    - [ ] Keep `onPressed: null` when `isPreview == true` (BP preview stays disabled)
    - [ ] Write widget tests for both layouts (filled/outline states, disabled in preview)

- [ ] Task: Wire callbacks in Marketplace `EstablishmentTestScreen`
    - [ ] Read `authProvider` state — if authenticated, call toggle; if not, navigate to login
    - [ ] Pass `pendingFavorite` flag via router extra so login return auto-toggles
    - [ ] Read `isFavoritedProvider` on build to set initial heart state
    - [ ] Show error snackbar on toggle failure

- [ ] Task: Write integration test for auth gate flow
    - [ ] Unauthenticated → tap Lagre → navigates to login
    - [ ] Authenticated → tap Lagre → heart fills

---

## Phase 3: Verification + Deploy

- [ ] Task: Run full test suite
    - [ ] `packages/establishment_ui/` widget tests (existing + new)
    - [ ] Marketplace integration tests
    - [ ] Zero regressions on BP tests (shared package change)

- [ ] Task: Deploy to phone
    - [ ] `flutter run --release -d R5CR61FGVPN`
    - [ ] E2E: log in → navigate to House of the North → tap Lagre → heart fills → navigate away → return → heart still filled → tap again → heart outlines

- [ ] Task: Merge
    - [ ] Check for concurrent session conflicts on `develop`
    - [ ] Merge `track/marketplace-favorites` → `develop`
