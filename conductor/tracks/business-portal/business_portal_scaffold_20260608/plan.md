# Plan — Business Portal Scaffold (`business_portal_scaffold_20260608`)

> **Workflow:** Strict (TDD)
> **Phases:** 3 (each is a checkpoint)
> **Estimated scope:** ~500 lines Dart

---

## Phase 1: Project Scaffolding

Set up the Flutter project inside the monorepo workspace and link shared dependencies.

- [ ] **Task 1.1:** Scaffold Flutter project at `apps/business-portal/`
    - [ ] Run `flutter create` with org `no.dittodatto` and platforms `web,android,ios`
    - [ ] Clean boilerplate files (`lib/main.dart`, test files)
- [ ] **Task 1.2:** Configure workspace dependencies
    - [ ] Update root `pubspec.yaml` to include `apps/business-portal/` in workspace
    - [ ] Update `apps/business-portal/pubspec.yaml` with workspace references to `ditto_design` and `mercury_client`
    - [ ] Add `flutter_riverpod` and `go_router` dependencies
    - [ ] Add workspace reference in `apps/business-portal/analysis_options.yaml`
    - [ ] Run `dart pub get` at root to verify resolution

---

## Phase 2: Router & Shell Setup

Establish route navigation, login gating, and responsive shell placeholders.

- [ ] **Task 2.1:** Implement Router Auth Guard (TDD)
    - [ ] Write unit tests verifying that unauthenticated sessions redirect to `/login`
    - [ ] Implement `GoRouter` configuration and auth state notifier to pass redirect tests
- [ ] **Task 2.2:** Create Login Screen (TDD)
    - [ ] Write widget tests verifying email, password fields and sign-in button presence
    - [ ] Implement `LoginScreen` widget using Moody Blue dark styling tokens
- [ ] **Task 2.3:** Integrate `DittoDashboardShell` Layout (TDD)
    - [ ] Write widget tests verifying that authenticated sessions render `DittoDashboardShell` nav panels
    - [ ] Implement navigation shell routing linking sidebar and drawer configurations
- [ ] **Task 2.4:** Stub Placeholder Screens
    - [ ] Create simple stateless view stubs: Dashboard, Establishments, Appointments, Table Reservations, Staff, Services, Inbox
    - [ ] Verify navigation toggles successfully update views

---

## Phase 3: Verification & Compilation

Final build and linting sanity checks.

- [ ] **Task 3.1:** Run static analysis checks
    - [ ] Verify `flutter analyze` returns zero warnings or errors
- [ ] **Task 3.2:** Verify Web compilation
    - [ ] Compile debug build: `flutter build web --debug`
- [ ] **Task 3.3:** Verify native compile stubs
    - [ ] Verify Android compilation: `flutter build apk --debug`
