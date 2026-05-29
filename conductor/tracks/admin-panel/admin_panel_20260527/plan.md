# Plan — Admin Panel (`admin_panel_20260527`)

> **Workflow:** Strict (TDD)
> **Phases:** 5 (each is a checkpoint)
> **Estimated scope:** ~4,000 lines Dart (3 packages)

---

## Phase 1: Monorepo + `ditto_design` + Shell Scaffold

Establish the Dart Workspaces monorepo, create `ditto_design` as the shared design system,
and scaffold the admin app with `DittoDashboardShell` rendering on all 3 targets.

- [x] **Task 1.1:** Create Dart Workspaces monorepo root
    - [x] Create root `pubspec.yaml` with `workspace:` resolution for `apps/admin/`, `packages/mercury_client/`, `packages/ditto_design/`
    - [x] Create root `analysis_options.yaml` (flutter lints)
    - [x] Verify `dart pub get` resolves all workspace members (107 deps resolved)

- [x] **Task 1.2:** Create `packages/ditto_design/` — design tokens
    - [x] Write tests for color palette generation (Moody Blue `#6F71CC` seed → dark surface grades `#0f1117` → `#1c1f2b`)
    - [x] Implement `DittoColors` — primary palette (50→950), dark surface grades, status colors (success, error, warning, premium, free)
    - [x] Write tests for spacing grid constants
    - [x] Implement `DittoSpacing` — 4/8/12/16/24/32px grid
    - [x] Implement `DittoBorderRadius` — 8/12/16/24px
    - [x] Implement `DittoAnimationDuration` — 150/300/500ms

- [x] **Task 1.3:** Create `packages/ditto_design/` — theme
    - [x] Write tests for `DittoTheme.dark` and `DittoTheme.light` (verify ColorScheme seed, surface colors, text theme)
    - [x] Implement `DittoTheme.dark` — extract from old `AppTheme.dark` (zero visual regression): `ColorScheme.fromSeed` + hand-tuned dark surfaces + Inter typography + component themes (Card, Input, Button, AppBar, NavigationDrawer, Snackbar)
    - [x] Implement `DittoTheme.light` — same seed, default light surfaces

- [x] **Task 1.4:** Create `packages/ditto_design/` — layout utilities
    - [x] Write tests for `DittoWindowClass` enum (compact <600, medium 600–839, expanded 840–1199, large ≥1200)
    - [x] Implement `DittoWindowClass` enum + `of(double width)` factory
    - [ ] Write tests for `DittoDashboardShell` widget (renders sidebar on wide, drawer on compact)
    - [x] Implement `DittoDashboardShell` — permanent sidebar (≥600px) / drawer (<600px), header/footer slots, AnimatedContainer nav items

- [x] **Task 1.5:** Create `packages/ditto_design/` — shared utility widgets
    - [x] Implement `DittoErrorView` — reusable error display (icon + message + retry action)
    - [x] Implement `DittoEmptyView` — reusable empty state (icon + message + optional action)
    - [x] Implement `DittoConfirmDialog` — generic confirmation dialog (title + message + confirm/cancel)
    - [x] Create barrel exports (`ditto_design.dart`)

- [x] **Task 1.6:** Scaffold `apps/admin/` — Flutter app shell
    - [x] `flutter create` at `apps/admin/` (org `no.dittodatto`, platforms: android, linux, web)
    - [x] Wire `ditto_design` + `mercury_client` as path dependencies
    - [x] Implement `main.dart` → `ProviderScope` → `AdminApp`
    - [x] Implement `AdminApp` with `MaterialApp.router`, `DittoTheme.dark`
    - [x] Implement initial `GoRouter` with shell route wrapping `DittoDashboardShell`
    - [x] Stub 5 placeholder screens (Dashboard, Users, Companies, Categories, Inbox) with screen titles
    - [x] Verify: `flutter build web --debug` ✓, `flutter build apk --debug` (in progress)
    - [ ] Verify: `flutter build linux` (blocked: libstdc++.so symlink missing on PlutoII — need `sudo`)

---

## Phase 2: Auth + Login

Implement the auth flow with mock backend and the maximum-opacity Login screen.

- [x] **Task 2.1:** Create `packages/mercury_client/` — foundation
    - [x] Create package with `pubspec.yaml` (dependencies: `http`, `flutter_secure_storage`, `json_annotation`; dev: `json_serializable`, `build_runner`)
    - [x] Implement `MercuryApi` — HTTP client with JWT injection, GET/POST/PUT/DELETE, timeout, platform-agnostic error handling (no `dart:io`)
    - [x] Implement `MercuryApiException` and `MercuryConnectionException` (no `SocketException` — use `ClientException` from `package:http`)
    - [x] Implement repository interface pattern: `AdminRepository` abstract class + `MockAdminRepository` + `HttpAdminRepository` (future)

- [x] **Task 2.2:** Create `mercury_client` — auth models & service
    - [x] Write tests for `TokenResponse` serialization (round-trip JSON)
    - [x] Implement `TokenResponse` model (`accessToken`, `tokenType`, `expiresIn`)
    - [x] Write tests for `AuthService` (login success, login failure, token restore, logout, expiry check with 30s buffer)
    - [x] Implement `AuthService` — JWT lifecycle with `FlutterSecureStorage`, expiry decode, 30s buffer
    - [x] Implement `AuthApi` — `devLogin(email, password)` endpoint wrapper
    - [x] Implement `MockAuthService` — returns fake token on known credentials, rejects unknown
    - [x] Create barrel exports (`mercury_client.dart`)

- [x] **Task 2.3:** Implement Login screen
    - [x] Implement sealed `AuthState` ADT: `Unauthenticated | Loading | Authenticated | Error`
    - [x] Implement `AuthNotifier` (Riverpod) — login, logout, tryRestore
    - [x] Implement `LoginScreen` UI per PRD: lock icon, email field, password field, Sign In button. Dark theme. No branding text. No error feedback on auth failure. Maximum opacity.
    - [x] Implement GoRouter auth redirect guard (unauthenticated → /login, authenticated → /dashboard)
    - [x] Verify: login flow works with mock credentials, redirect works, logout clears token

---

## Phase 3: Dashboard

Implement the Dashboard with 4 stat cards and pull-to-refresh.

- [ ] **Task 3.1:** Create `mercury_client` — admin stats model
    - [ ] Write tests for `AdminStats` serialization
    - [ ] Implement `AdminStats` model (`userCount`, `companyCount`, `categoryCount`, `engineHealthy`)
    - [ ] Add `getStats()` to `AdminRepository` interface + mock implementation (returns realistic fake stats)

- [ ] **Task 3.2:** Implement Dashboard screen
    - [ ] Implement `dashboardStatsProvider` (Riverpod `FutureProvider.autoDispose`)
    - [ ] Implement `StatCard` widget (colored icon circle + large value + label) — in `ditto_design` or app-local (evaluate reuse potential)
    - [ ] Implement `DashboardScreen` — 2×2 responsive grid of stat cards, `RefreshIndicator`, loading/error states using `DittoErrorView`
    - [ ] Verify: dashboard renders with mock data, pull-to-refresh re-fetches

---

## Phase 4: Users + Companies + Categories

Implement the three CRUD data table screens.

- [ ] **Task 4.1:** Create `mercury_client` — data models
    - [ ] Write tests for `ActorRole`, `CompanyTier`, `OnboardingStatus` enum serialization (wire values: `super_admin`, `business`, etc.)
    - [ ] Implement enums with manual `fromJson`/`toJson` (preserve wire format compatibility)
    - [ ] Write tests for `User` model serialization (round-trip, namespace: `users/profiles`)
    - [ ] Implement `User` model — id, vippsSub, name, email, phone, role, companySlug, timestamps
    - [ ] Write tests for `Company` model serialization (round-trip, nested objects: `EnabledFeatures`, `StorePolicy`, `CompanySocialLinks`)
    - [ ] Implement `Company` model (28 fields) + nested models
    - [ ] Write tests for `Category` model serialization
    - [ ] Implement `Category` model — id, name, slug, description, icon, count, timestamps
    - [ ] Write tests for `PaginatedResponse<T>` (generic with typed factory)
    - [ ] Implement `PaginatedResponse<T>`
    - [ ] Add CRUD methods to `AdminRepository` interface + mock implementations (fake data, pagination, create/update/delete)

- [ ] **Task 4.2:** Implement shared badge widgets
    - [ ] Implement `RoleBadge` — pill-shaped colored badge for `ActorRole` enum (switch expression)
    - [ ] Implement `TierBadge` — for `CompanyTier` enum
    - [ ] Implement `OnboardingBadge` — for `OnboardingStatus` enum
    - [ ] Implement shared `formatDate()` utility (extract duplicated pattern)

- [ ] **Task 4.3:** Implement Users screen
    - [ ] Implement `UsersNotifier` (Riverpod) — paginated fetch, role update
    - [ ] Implement `UsersScreen` — DataTable with 6 columns, pagination bar, role badges, inline role editing via `PopupMenuButton`
    - [ ] Verify: pagination works, role editing updates list

- [ ] **Task 4.4:** Implement Companies screen
    - [ ] Implement `CompaniesNotifier` (Riverpod) — paginated fetch, create, update
    - [ ] Implement `CompanyDialog` — create/edit form split into composable sections (Core, Contact, Address, Tier & Status, Features, Store Policy, Social Links). Auto-slug from name.
    - [ ] Implement `CompaniesScreen` — horizontally scrollable DataTable with 7 columns, pagination bar, tier/onboarding badges, create/edit actions
    - [ ] Verify: pagination, create, edit all work

- [ ] **Task 4.5:** Implement Categories screen
    - [ ] Implement `CategoriesNotifier` (Riverpod) — full CRUD (fetch, create, update, delete with `invalidateSelf()`)
    - [ ] Implement `CategoryDialog` — create/edit form with auto-slug generation + manual override detection
    - [ ] Implement `CategoriesScreen` — DataTable with 5 columns, create/edit/delete actions, delete confirmation via `DittoConfirmDialog`
    - [ ] Verify: full CRUD cycle works

---

## Phase 5: Inbox + Polish

Implement the Inbox screen and final polish pass.

- [ ] **Task 5.1:** Implement Inbox screen
    - [ ] Design minimal Inbox data model (MessageThread, Message) — app-local for now, not in mercury_client until messaging system is grilled
    - [ ] Implement `InboxScreen` — message list with sender, subject, timestamp + detail view with message body
    - [ ] Populate with mock messages (system alerts, sample support messages)
    - [ ] Verify: list navigation, detail view rendering

- [ ] **Task 5.2:** Cross-platform verification
    - [ ] Build and test on Android (emulator or device)
    - [ ] Build and test on Linux desktop
    - [ ] Build and test on Chrome (web)
    - [ ] Verify responsive behavior at all `DittoWindowClass` breakpoints (resize test)

- [ ] **Task 5.3:** Polish pass
    - [ ] Review all screens against PRD acceptance criteria
    - [ ] Verify WCAG 2.1 AA: contrast ratios, touch targets, semantics labels
    - [ ] Verify no `dart:io` imports in platform-agnostic code
    - [ ] Run `dart analyze` — zero warnings
    - [ ] Run all tests — green
    - [ ] Final cleanup: remove dead code, ensure barrel exports are complete

---

## Notes

- **Mock data should be realistic** — use Norwegian names, Drammen-area companies, real-looking category names (Frisør, Restaurant, Trening, etc.) to make the admin panel feel alive during development.
- **`StatCard` placement** — evaluate during Phase 3 whether it belongs in `ditto_design` (if Business Portal will reuse dashboard cards) or stays app-local. Default: app-local, graduate later.
- **Badge widgets** — likely graduate to `ditto_design` when Business Portal needs them. For now, keep in `apps/admin/lib/features/shared/`.
- **Inbox** — intentionally minimal. The messaging system grill (future) will define the real architecture. This is a placeholder that proves the screen exists and navigation works.
