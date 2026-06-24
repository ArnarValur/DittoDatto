# Pulse — Current Project State

**Last Updated:** 2026-06-24 16:17
**Session Focus:** Auth Service track creation + Phase 1 research (4/5 tasks complete)

## 🚀 Active Tracks

- **Auth Service** (`auth_service_20260624`) — In-progress. Track created with full spec + plan. Phase 1 research 4/5 tasks complete: multi-access patterns, SIGNUP, `WITH REFRESH` token lifecycle, PASSHASH provisioning all verified on SurrealDB 3.0.5. Task 5 (package API design) pending. Research doc at `conductor/docs/auth-service-research.md`.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Awaiting clean E2E (blocked on Auth Service landing).
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed on Saturn.

## ✅ Recently Completed

- **2026-06-24 16:17** — Auth Service track: created `auth_service_20260624` with spec interview (5 questions), plan (4 phases), and 4/5 Phase 1 research tasks. ADR-0019 (SurrealDB-native auth architecture). Key discoveries: `WITH REFRESH` for token lifecycle, PASSHASH for `bp_portal`, `bp_auth` needs role gate fix. Blueprint symlink (ADR-0018) confirmed done.
- **2026-06-24 15:12** — Grill session: ADR-0017 (Company DB Provisioning Architecture), ADR-0018 (Blueprint Bundling via Symlink). Fixed stale terminology across 4 docs. BP auth_provider now catches and logs AuthenticationException. Saturn DB wiped clean, schemas re-applied, NS admin users created.
- **2026-06-24 09:31** — Fixed two deployment-only bugs: blueprint asset path + password mismatch. Both apps rebuilt + deployed.
- **2026-06-23 20:21** — Deploy gate passed (50 admin + 21 BP tests green). Deployed both apps.
- **2026-06-23 20:07** — Company provisioning implemented. 11 new integration tests. 50 total admin tests green.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🔴 **Clean E2E blocked.** Admin Panel → create user → create company → verify BP login. Depends on Auth Service track landing — current auth is fragile and scattered.
- 🟡 **`bp_auth` has no role gate.** Any user with valid `password_hash` can authenticate through `bp_auth`. Must add `AND role IN ['business', 'admin', 'super_admin']` to SIGNIN clause. Will be fixed in Phase 2 of Auth Service track.
- 🟡 **No post-deploy verification.** Deploy gate tests logic against local DB, not the deployed product.

## 🧠 Session Memory

- **Auth Service track created:** `conductor/tracks/auth-service/auth_service_20260624/`
- **Research doc:** `conductor/docs/auth-service-research.md` — living document with all Phase 1 findings
- **ADR-0019:** SurrealDB-native auth architecture (no backend, intermediary escape hatch)
- **SurrealDB version on test:** 3.0.5
- **Key research findings:**
  - Two RECORD ACCESS on one DB: works, each gets own JWT signing key
  - SIGNUP clause: works with SCHEMAFULL, argon2 server-side, returns JWT immediately
  - `WITH REFRESH`: supported! 15m access + refresh token. Game-changer for `ditto_auth`.
  - PASSHASH: works for `bp_portal`. Generate hash with `crypto::argon2::generate()`, provision with `DEFINE USER ... PASSHASH`.
  - `bp_auth` security gap: no role gate on SIGNIN clause. Consumer users can authenticate through `bp_auth`.
- **Token strategy decided:** 15m access token + refresh + 24h session (consumer), 8h session (business)
- **Blueprint symlink (ADR-0018):** Confirmed done by user.
- **Vipps/BankID:** Out of scope. Vipps is future-planned (consumer-facing only). BankID mentioned in context of Vipps only. No API access, no Norwegian company registration.
- **Multi-company:** Out of scope for now. Architecture supports it. `works_at` graph edge already in blueprint. `company_memberships` array already on user schema. Natural trigger for backend intermediary.
- **Admin Panel deployed:** `http://dittodatto:8002`
- **Business Portal:** `http://dittodatto:8003`
- **Saturn DB state:** CLEAN. Schemas applied. No companies, no user records. Only NS admin user exists.
- **Port reservations:** :8001 SurrealDB, :8002 Admin, :8003 BP, :8004 Marketplace, :8005 Booking Engine.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔴 **Complete Phase 1 Task 5: `ditto_auth` package API design.** All prerequisite research is done. Write `design.md` with public API surface, Riverpod providers, abstraction layer.
2. 🔴 **Start Phase 2: Build `ditto_auth` package.** Define `consumer_auth` + fix `bp_auth` in schemas. Scaffold package. Implement auth flows with `WITH REFRESH`.
3. 🟡 **Clean E2E** after Auth Service Phases 2-3 land.
4. 🟡 **Glossary update:** Add `ditto_auth`, `consumer_auth` terms to `conductor/context.md`.
