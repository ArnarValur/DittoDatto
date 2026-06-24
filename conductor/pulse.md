# Pulse — Current Project State

**Last Updated:** 2026-06-24 15:12
**Session Focus:** Grill assessment + ADR batch + Saturn DB reset + Auth Service track decision

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. BP redeployed with `BP_PORTAL_PASS` dart-define + config error logging. Saturn DB wiped and re-provisioned (clean schemas, NS admin users). **Awaiting clean E2E through Admin Panel UI.**
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed on Saturn.
- **Auth Service** — Proposed in grill session. A new standalone service that owns user identity, authentication, and session/token issuance. Auth was never in MercuryEngine — ME is booking-only. The Auth Service exists because auth is currently scattered: Admin Panel does NS-level auth, BP does RECORD ACCESS, and future apps would each re-implement their own. One service, one auth flow. Vipps Login and BankID were *mentioned* as future possibilities but are NOT planned — no Vipps API, no registered Norwegian company. **Not yet created as a track — next session.**

## ✅ Recently Completed

- **2026-06-24 15:12** — Grill session: ADR-0017 (Company DB Provisioning Architecture), ADR-0018 (Blueprint Bundling via Symlink). Fixed stale terminology across 4 docs (users/profiles→users/users, ghost ADR-0014, wrong ADR-0010 ref, BP "planned" marker). Added No CLI CRUD rule to AGENTS.md. BP auth_provider now catches and logs AuthenticationException. Saturn DB wiped clean, schemas re-applied, NS admin users created. Auth Service track proposed — user wants to start in next session.
- **2026-06-24 09:31** — Fixed two deployment-only bugs: blueprint asset path + password mismatch. Both apps rebuilt + deployed.
- **2026-06-23 20:21** — Deploy gate passed (50 admin + 21 BP tests green). Deployed both apps.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🔴 **Clean E2E blocked.** Admin Panel → create user → create company → verify BP login. This flow depends on the Auth Service track landing — the current auth is fragile and scattered. Saturn DB is clean and ready.
- 🟡 **No post-deploy verification.** Deploy gate tests logic against local DB, not the deployed product.

## 🧠 Session Memory

- **Admin Panel deployed:** `http://dittodatto:8002`
- **Business Portal:** `http://dittodatto:8003`
- **Admin deploy:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **BP deploy:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/` — built with `--dart-define=BP_PORTAL_PASS=test-portal-pass`
- **Container restart required** after deploy: `ssh saturn 'docker restart dittodatto-caddy dittodatto-portal-caddy'`
- **SurrealDB root creds:** stored in `conductor/docs/keys/saturn-db-root.env` (gitignored)
- **Namespace users:** `arnarvalur` (ROLES OWNER on both namespaces, password `admin123`)
- **Saturn DB state (2026-06-24 15:05):** CLEAN. Schemas applied (init + users + platform + discovery). No companies, no user records. Only NS admin user exists.
- **BP auth model (ADR-0016):** RECORD ACCESS `bp_auth` on `users/users` → argon2 password_hash. Service user `bp_portal` (EDITOR) on each `company_{slug}` DB.
- **Provisioning architecture (ADR-0017):** Admin Panel auto-provisions on company creation: DEFINE DATABASE → apply blueprint → create bp_portal. DB-per-tenant.
- **Blueprint (ADR-0018):** Source of truth at `schemas/company-blueprint.surql`. Currently copied to `apps/admin/assets/` — symlink not yet applied (ADR approved, implementation pending).
- **Port reservations:** :8001 SurrealDB, :8002 Admin, :8003 BP, :8004 Marketplace, :8005 Booking Engine.
- **Deploy gate:** `.agents/AGENTS.md` — tests must pass before deploy. **No CLI CRUD rule** added.
- **Integration tests:** 50 admin + 21 BP tagged integration.
- **Grill deferred items:** bp_portal password strategy (shared dart-define staging, backend proxy production), code deduplication (6 instances across Admin + BP).
- **Auth Service decision:** A NEW standalone service that owns user identity, authentication, and session/token issuance. Auth was never in MercuryEngine and should not be. Currently auth is scattered: Admin does NS-level, BP does RECORD ACCESS, future apps would each re-implement. Vipps Login and BankID were *mentioned* as future possibilities but are NOT planned features — no API access, no Norwegian company registration. Inspired by "Building Event-Driven Microservices" (Adam Bellemare). User wants to start this track next session.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔴 **Launch Auth Service track** (`/new-track`). User is motivated and wants a fresh start. Auth is currently scattered across apps — consolidate into one service.
2. 🔴 **Clean E2E through Admin Panel.** Log into `dittodatto:8002` → create user → create company (triggers provisioning) → verify BP login at `dittodatto:8003`. No CLI.
3. 🟡 **Apply blueprint symlink** (ADR-0018). Replace `apps/admin/assets/company-blueprint.surql` copy with symlink.
4. 🟡 **Post-deploy smoke script.**
