# Implementation Plan — Marketplace Foundation

> **Track:** `marketplace_foundation_20260624`
> **Workflow:** Strict (TDD)

---

## Phase 1: Project Scaffold + Navigation Shell

- [ ] Task: Create Flutter project at `apps/marketplace/`
    - [ ] `flutter create --org no.dittodatto --project-name marketplace apps/marketplace`
    - [ ] Add workspace dependencies: `ditto_design`, `ditto_auth`
    - [ ] Add dependencies: `flutter_riverpod`, `go_router`, `google_fonts`
    - [ ] Configure `analysis_options.yaml` (match admin/BP lint rules)
    - [ ] Verify `flutter analyze` clean + `flutter test` passes
- [ ] Task: Implement three-tab bottom navigation shell
    - [ ] Write widget tests for bottom nav (3 tabs render, tap switches)
    - [ ] Create `MarketplaceShell` widget with `BottomNavigationBar`
    - [ ] Home tab: placeholder screen with "DittoDatto" title
    - [ ] Bookings tab: placeholder screen with "My Bookings" title
    - [ ] Profile tab: routes to auth-gated profile (placeholder for now)
- [ ] Task: Configure GoRouter with shell route
    - [ ] Write tests for route configuration (3 tab routes resolve)
    - [ ] Implement `AppRouter` with `ShellRoute` + 3 branches
    - [ ] Auth redirect: profile tab → login if unauthenticated
- [ ] Task: Apply consumer theme via `ditto_design`
    - [ ] Light theme with Moody Blue seed color + dark mode toggle
    - [ ] Inter font via Google Fonts
    - [ ] Verify Material 3 tokens render correctly

## Phase 2: Consumer Auth (depends on Auth Service defining consumer_auth)

- [ ] Task: Define `consumer_auth` RECORD ACCESS on `users/users` schema
    - [ ] Write integration tests for SIGNUP + SIGNIN against real SurrealDB
    - [ ] Add `consumer_auth` definition to `schemas/users.surql`
    - [ ] Verify argon2 hashing, role gating, WITH REFRESH tokens
- [ ] Task: Implement `consumerSignin` / `consumerSignup` / `tryRestoreConsumer` in `ditto_auth`
    - [ ] Write unit tests for consumer auth flow (signin, signup, restore, signout)
    - [ ] Implement consumer methods in `DittoAuth` (replace UnimplementedError stubs)
    - [ ] Implement `ConsumerAuthResult` with user profile data
    - [ ] Verify token storage + refresh lifecycle
- [ ] Task: Build signup screen
    - [ ] Write widget tests for signup form (validation, submission, error display)
    - [ ] Create `SignupScreen` with name, email, password, confirm password fields
    - [ ] Wire to `DittoAuth.consumerSignup()` via Riverpod provider
    - [ ] Client-side validation: email format, password min 8 chars, passwords match
    - [ ] Error handling: duplicate email, network errors
- [ ] Task: Build login screen
    - [ ] Write widget tests for login form (validation, submission, error display)
    - [ ] Create `LoginScreen` with email, password fields
    - [ ] Wire to `DittoAuth.consumerSignin()` via Riverpod provider
    - [ ] Generic "Invalid credentials" error (no information leakage)
    - [ ] "Don't have an account? Sign up" link
- [ ] Task: Wire auth state to router
    - [ ] Write tests for auth redirect logic
    - [ ] `authProvider` (AsyncNotifier) managing `AuthState`
    - [ ] `tryRestoreConsumer()` on app startup
    - [ ] Redirect: unauthenticated + profile tab → login screen
    - [ ] Redirect: authenticated + login/signup → profile tab

## Phase 3: Profile Page

- [ ] Task: Build profile display
    - [ ] Write widget tests for profile card (renders name, email, photo placeholder)
    - [ ] Create `ProfileScreen` showing user info from `ConsumerAuthResult`
    - [ ] Avatar with photo placeholder (initials-based)
    - [ ] Display: name, email, phone (if set), bio (if set)
    - [ ] Sign out button
- [ ] Task: Build profile edit
    - [ ] Write widget tests for edit form (pre-populated fields, save, cancel)
    - [ ] Edit button toggles inline form: name, phone, bio (email read-only)
    - [ ] Save → `UPDATE user SET ... WHERE id = $auth.id` via SurrealDB connection
    - [ ] Success feedback + return to read-only display
    - [ ] Cancel discards changes

## Phase 4: Integration Testing + Saturn Deploy

- [ ] Task: Integration test suite
    - [ ] Full consumer auth flow: signup → profile displayed → signout → signin → profile restored
    - [ ] Profile edit: change name → verify persistence
    - [ ] Session restore: authenticate → token stored → restore succeeds
    - [ ] Role isolation: consumer cannot access business/admin routes
- [ ] Task: Saturn deployment
    - [ ] `flutter build web --release`
    - [ ] Configure Caddy for `:8004` (Docker container on `dittodatto-net`)
    - [ ] `rsync` to Saturn
    - [ ] Verify: signup → login → profile → edit → signout works on deployed instance
