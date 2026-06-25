# Implementation Plan — Marketplace Foundation

> **Track:** `marketplace_foundation_20260624`
> **Workflow:** Strict (TDD)

---

## Phase 1: Project Scaffold + Navigation Shell ✅

- [x] Task: Create Flutter project at `apps/marketplace/`
    - [x] `flutter create --org no.dittodatto --project-name marketplace apps/marketplace`
    - [x] Add workspace dependencies: `ditto_design`, `ditto_auth`, `mercury_client`
    - [x] Add dependencies: `flutter_riverpod`, `go_router`, `google_fonts`, `intl`
    - [x] Verify `flutter analyze` clean
- [x] Task: Implement three-tab bottom navigation shell
    - [x] Create `MarketplaceShell` widget with `NavigationBar`
    - [x] Home tab: placeholder screen with "DittoDatto" title (Norwegian)
    - [x] Bookings tab: placeholder screen with "Bestillinger" title
    - [x] Profile tab: routes to auth-gated profile
- [x] Task: Configure GoRouter with shell route
    - [x] Implement `AppRouter` with `StatefulShellRoute.indexedStack` + 3 branches
    - [x] Auth redirect: profile tab → login if unauthenticated
    - [x] Authenticated + login/signup → redirect to profile
- [x] Task: Apply consumer theme via `ditto_design`
    - [x] Light theme default + dark mode toggle (NotifierProvider)
    - [x] Moody Blue seed color via DittoTheme.light / DittoTheme.dark
- [x] Task: Rename app label to "DittoDatto" (Android, iOS, web)
- [x] Task: Verify on Samsung Galaxy S21 (Android 15, API 35, arm64)

## Phase 2: Consumer Auth (partially complete)

- [ ] Task: Define `consumer_auth` RECORD ACCESS on `users/users` schema
    - [ ] Add `consumer_auth` definition to `schemas/users.surql`
    - [ ] Verify argon2 hashing, role='customer', signup/signin
- [x] Task: Implement `consumerSignin` / `consumerSignup` / `tryRestoreConsumer` in `ditto_auth`
    - [x] Implement consumer methods in `DittoAuth` (replaced UnimplementedError stubs)
    - [x] Implement `ConsumerAuthResult` with user profile data
    - [x] Add consumer session persistence to `TokenStore`
    - [x] Made `extractFirstRow` and `deriveWsUrl` public static on `SurrealAuthBackend`
- [x] Task: Build signup screen
    - [x] Create `SignupScreen` with name, email, password, confirm password fields
    - [x] Wire to `DittoAuth.consumerSignup()` via Riverpod provider
    - [x] Client-side validation: email format, password min 8 chars, passwords match
    - [x] Norwegian labels throughout
- [x] Task: Build login screen
    - [x] Create `LoginScreen` with email, password fields
    - [x] Wire to `DittoAuth.consumerSignin()` via Riverpod provider
    - [x] "Har du ikke konto? Opprett konto" link
- [x] Task: Wire auth state to router
    - [x] `authProvider` (AsyncNotifier) managing `AuthState`
    - [x] `tryRestoreConsumer()` on app startup
    - [x] Redirect: unauthenticated + profile → login
    - [x] Redirect: authenticated + login/signup → profile

## Phase 3: Profile Page ✅

- [x] Task: Build profile display
    - [x] "Hei, {firstName} 👋" greeting
    - [x] "I dag er {datetime}" in Norwegian (nb_NO locale)
    - [x] Avatar with initials-based placeholder
    - [x] Email display
    - [x] Sign out button
    - [x] Dark mode toggle in AppBar

## Phase 4: Integration Testing + Saturn Deploy

- [ ] Task: Integration test suite
    - [ ] Full consumer auth flow: signup → profile → signout → signin → profile
    - [ ] Session restore: authenticate → token stored → restore succeeds
- [ ] Task: Saturn deployment
    - [ ] Configure Caddy for `:8004`
    - [ ] `flutter build web --release` + rsync
    - [ ] Verify on deployed instance
