# Auth Service — Implementation Plan

> **Track:** `auth_service_20260624`
> **Workflow:** Strict (TDD)

---

## Phase 1: Research & Design

> Spike phase — no production code. Deliverable: design document with architecture decisions.

- [x] Task: Research SurrealDB multi-access patterns ✅
    - [x] Verify multiple `DEFINE ACCESS ... TYPE RECORD` on one database — **Works. Each gets own JWT signing key.**
    - [x] Test `$auth` scope isolation between access definitions — **Works. Table PERMISSIONS apply per-user.**
    - [x] Document any gotchas — **`bp_auth` needs role gate. No `$auth.AC` in SurrealQL.**

- [x] Task: Research RECORD ACCESS SIGNUP clause ✅
    - [x] Prototype `consumer_auth` with SIGNUP — **Works with SCHEMAFULL. argon2 hashing server-side.**
    - [x] Verify SIGNUP-created records respect SCHEMAFULL constraints — **Yes. Duplicate email caught by UNIQUE index.**
    - [x] Document the pattern for `ditto_auth` package — **See `conductor/docs/auth-service-research.md`**

- [x] Task: Research token lifecycle & session strategy ✅
    - [x] Test token refresh vs re-authentication on expiry — **`WITH REFRESH` supported! Returns access + refresh tokens.**
    - [x] Determine appropriate TTLs — **15m access token, 24h session (consumer), 8h session (business)**
    - [x] Document session persistence strategy — **Store access + refresh in FlutterSecureStorage. Auto-refresh on 401.**

- [x] Task: Research `bp_portal` security upgrade ✅
    - [x] Prototype PASSHASH provisioning — **Works. `DEFINE USER ... PASSHASH '$argon2id$...'`**
    - [x] Prototype unique password generation per tenant — **Use `crypto::argon2::generate()` in SurrealQL**
    - [x] Research secure credential delivery patterns — **Backend proxy for production, `--dart-define` for staging**

- [x] Task: Design `ditto_auth` package API ✅
    - [x] Define public API surface (signin, signup, signout, restore, switchCompany extension point)
    - [x] Define provider architecture (Riverpod integration)
    - [x] Define abstraction layer for future backend intermediary swap
    - [x] Write design doc in track folder (`design.md`)

---

## Phase 2: `ditto_auth` Package + Schema Definitions

> Implementation phase — TDD. Build the shared package and schema definitions.

- [x] Task: Formalize `bp_auth` RECORD ACCESS in `schemas/users.surql` ✅
    - [x] Added role gate: `AND role IN ['business', 'admin', 'super_admin']`
    - [x] Tightened durations: 15m token / 8h session
    - [x] `WITH REFRESH` deferred — Dart surrealdb SDK compat issue

- [x] Task: Create `packages/ditto_auth/` package scaffold ✅
    - [x] `pubspec.yaml` with dependencies (surrealdb, flutter_secure_storage)
    - [x] 12 source files, barrel export, workspace registered
    - [x] Clean static analysis (0 issues)

- [x] Task: Implement business auth flows ✅
    - [x] `SurrealAuthBackend` — two-phase auth behind `AuthBackend` interface
    - [x] `TenantConnection` — dual-connection wrapper (companies + users)
    - [x] `DittoAuth.businessSignin()` — orchestrates backend + token store + role check
    - [x] 11 integration tests green

- [x] Task: Implement token storage & session persistence ✅
    - [x] `TokenStore` — web + native persistence
    - [x] `DittoAuth.tryRestoreBusiness()` — session restore from stored tokens
    - [x] `DittoAuth.signOut()` — clear connections + tokens

- [x] Task: Implement role checking ✅
    - [x] DB-level role gate in `bp_auth` SIGNIN clause
    - [x] Dart-level `InsufficientRole` exception in `businessSignin()`
    - [x] Updated BP test to expect DB-level rejection for customer users

- [x] Task: Define `consumer_auth` RECORD ACCESS ✅
    - [x] SIGNUP clause with role='customer', argon2 hashing, all SCHEMAFULL fields
    - [x] SIGNIN clause with role gate (`AND role = 'customer'`)
    - [x] DURATION FOR TOKEN 24h, FOR SESSION 24h (WITH REFRESH deferred)
- [x] Task: Implement consumer auth flows ✅
    - [x] `consumerSignin()`, `consumerSignup()`, `tryRestoreConsumer()` — all implemented
    - [x] 13 integration tests green (signup, signin, restore, signout, role isolation)
- [ ] Task: Update `bp_portal` provisioning for security _(deferred — production hardening)_

---

## Phase 3: Business Portal Migration

> Migration phase — replace bespoke BP auth with `ditto_auth`. Zero behavior change.

- [x] Task: Replace BP `auth_provider.dart` with `ditto_auth` ✅
    - [x] Add `ditto_auth` dependency to BP `pubspec.yaml`
    - [x] Rewrite `auth_provider.dart` — `DittoAuth` + `SurrealAuthBackend`
    - [x] Rewire `establishment_providers.dart` — `TenantConnection`
    - [x] Rewire `portal_shell.dart` — `tenantConnectionProvider`
    - [x] Clean static analysis (0 issues)

- [x] Task: Verify BP integration tests ✅
    - [x] All 21 existing BP integration tests pass
    - [x] Updated 1 test: customer role gate now DB-level (expected behavior change)

- [ ] Task: Deploy & verify BP
    - [ ] Deploy gate: run integration tests
    - [ ] Build + deploy to Saturn
    - [ ] Manual E2E: login → establishments → verify tenant isolation

---

## Phase 4: Marketplace Consumer Auth

> New functionality — wire consumer auth into the Public Marketplace app.

- [x] Task: Wire `consumer_auth` into Marketplace ✅ _(done in Marketplace Foundation track)_
- [x] Task: Build signup page ✅ _(done in Marketplace Foundation track)_
- [x] Task: Build login page ✅ _(done in Marketplace Foundation track)_

- [ ] Task: Integration tests for Marketplace app
    - [ ] Write widget/integration tests for marketplace auth flows
    - [x] Package-level integration tests: 13 tests in `ditto_auth` (signup, signin, restore, role isolation)

- [ ] Task: Deploy & verify Marketplace
    - [ ] Deploy gate: run integration tests
    - [ ] Build + deploy to Saturn
    - [ ] Manual E2E: signup → login → verify session persistence
