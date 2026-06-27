# Implementation Plan — Marketplace Foundation

> **Track:** `marketplace_foundation_20260624`
> **Workflow:** Strict (TDD)

---

## Phase 1: Project Scaffold + Nav Shell

- [x] Create Flutter web project at `apps/marketplace/`
- [x] Add dependencies: `ditto_auth`, `ditto_design`, `flutter_riverpod`, `go_router`, etc.
- [x] Implement GoRouter with `StatefulShellRoute.indexedStack` (3 branches)
- [x] Create `MarketplaceShell` with 3-tab NavigationBar
- [x] Wire DittoTheme (light/dark) with `isDarkModeProvider`
- [x] Initialize nb_NO date formatting

## Phase 2: Consumer Auth

- [x] Create `AuthNotifier` (`AsyncNotifier<AuthState>`) with signup/login/logout/restore
- [x] Create `dittoAuthProvider` — `DittoAuth` with `SurrealAuthBackend` (consumer-only)
- [x] Implement `LoginScreen` — email + password form with Norwegian validation messages
- [x] Implement `SignupScreen` — name + email + password + confirm with validation
- [x] Configure router redirects per ADR-0020 (profile guarded, home/bookings public)

## Phase 3: Profile Page

- [x] Implement `ProfileScreen` — avatar, greeting, date, email, dark mode toggle, logout
- [x] Wire `isDarkModeProvider` toggle from AppBar
- [x] Add nb_NO date formatting for 'I dag er {date}' display

## Phase 4: Integration Testing + Saturn Deploy

- [x] Create `dart_test.yaml` with integration tag
- [x] Add `mock_secure_storage.dart` helper
- [x] Write `auth_notifier_test.dart` (integration, real SurrealDB)
- [x] Write `login_screen_test.dart` (widget)
- [x] Write `signup_screen_test.dart` (widget)
- [x] Write `profile_screen_test.dart` (widget)
- [x] Write `router_redirect_test.dart` (widget)
- [x] Deploy to Saturn (port 8004) — verified
- [x] Saturn SDB connectivity — verified
- [x] Manual E2E verification — verified
