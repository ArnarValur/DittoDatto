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

- [ ] Task: Design `ditto_auth` package API
    - [ ] Define public API surface (signin, signup, signout, restore, switchCompany extension point)
    - [ ] Define provider architecture (Riverpod integration)
    - [ ] Define abstraction layer for future backend intermediary swap
    - [ ] Write design doc in track folder (`design.md`)

---

## Phase 2: `ditto_auth` Package + Schema Definitions

> Implementation phase — TDD. Build the shared package and schema definitions.

- [ ] Task: Define `consumer_auth` RECORD ACCESS in `schemas/users.surql`
    - [ ] Write integration tests: consumer signin, signup, role assignment, token scoping
    - [ ] Implement SIGNIN + SIGNUP clause with argon2
    - [ ] Verify against real SurrealDB

- [ ] Task: Formalize `bp_auth` RECORD ACCESS in `schemas/users.surql`
    - [ ] Write integration tests: business signin, role gate, token scoping
    - [ ] Review and harden existing definition
    - [ ] Verify coexistence with `consumer_auth` on same DB

- [ ] Task: Create `packages/ditto_auth/` package scaffold
    - [ ] `pubspec.yaml` with dependencies (surrealdb, flutter_secure_storage)
    - [ ] Package structure: `src/`, `test/`, exports
    - [ ] README with usage examples

- [ ] Task: Implement consumer auth flows
    - [ ] Write tests for consumer signup (email + password → user record)
    - [ ] Write tests for consumer signin (email + password → JWT)
    - [ ] Implement `DittoAuth.consumerSignup()` and `DittoAuth.consumerSignin()`

- [ ] Task: Implement business auth flows
    - [ ] Write tests for business signin (email + password → JWT + role check)
    - [ ] Write tests for tenant routing (company_slug → bp_portal signin)
    - [ ] Implement `DittoAuth.businessSignin()` and `DittoAuth.routeToTenant()`

- [ ] Task: Implement token storage & session persistence
    - [ ] Write tests for token store/restore/clear
    - [ ] Implement FlutterSecureStorage integration
    - [ ] Implement `DittoAuth.tryRestore()` with expiry fallback

- [ ] Task: Implement role checking
    - [ ] Write tests for role validation (consumer, business, admin, super_admin)
    - [ ] Implement `DittoAuth.requireRole()` guard

- [ ] Task: Update `bp_portal` provisioning for security
    - [ ] Write integration tests: unique password per tenant, PASSHASH, DURATION
    - [ ] Update Admin Panel `createCompany` provisioning logic
    - [ ] Update Admin Panel `deleteCompany` deprovisioning logic
    - [ ] Verify provisioning round-trip against real SurrealDB

---

## Phase 3: Business Portal Migration

> Migration phase — replace bespoke BP auth with `ditto_auth`. Zero behavior change.

- [ ] Task: Replace BP `auth_provider.dart` with `ditto_auth`
    - [ ] Add `ditto_auth` dependency to BP `pubspec.yaml`
    - [ ] Rewrite `auth_provider.dart` to delegate to `ditto_auth`
    - [ ] Update login screen to use `ditto_auth` API
    - [ ] Update tenant routing to use `ditto_auth`

- [ ] Task: Verify BP integration tests
    - [ ] Run all 21 existing BP integration tests — must pass
    - [ ] Add migration-specific regression tests if gaps found
    - [ ] Verify auth flow on deployed app (Saturn)

- [ ] Task: Deploy & verify BP
    - [ ] Deploy gate: run integration tests
    - [ ] Build + deploy to Saturn
    - [ ] Manual E2E: login → establishments → verify tenant isolation

---

## Phase 4: Marketplace Consumer Auth

> New functionality — wire consumer auth into the Public Marketplace app.

- [ ] Task: Wire `consumer_auth` into Marketplace
    - [ ] Add `ditto_auth` dependency to Marketplace `pubspec.yaml`
    - [ ] Create auth provider using `ditto_auth`
    - [ ] Wire router guards (authenticated vs unauthenticated routes)

- [ ] Task: Build signup page
    - [ ] Write widget tests for signup form
    - [ ] Implement signup screen (email + password + confirm)
    - [ ] Wire to `DittoAuth.consumerSignup()`

- [ ] Task: Build login page
    - [ ] Write widget tests for login form
    - [ ] Implement login screen (email + password)
    - [ ] Wire to `DittoAuth.consumerSignin()`

- [ ] Task: Integration tests for Marketplace auth
    - [ ] Write integration tests: signup → login → session restore
    - [ ] Verify consumer token scoping (can't access business data)
    - [ ] Verify role isolation

- [ ] Task: Deploy & verify Marketplace
    - [ ] Deploy gate: run integration tests
    - [ ] Build + deploy to Saturn
    - [ ] Manual E2E: signup → login → verify session persistence
