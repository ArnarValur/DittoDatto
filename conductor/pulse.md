# Pulse — Current Project State

**Last Updated:** 2026-06-24 15:05
**Session Focus:** Grill assessment + ADR batch + Saturn DB reset for clean E2E

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. BP redeployed with `BP_PORTAL_PASS` dart-define + config error logging. Saturn DB wiped and re-provisioned (clean schemas, NS admin users). **Awaiting clean E2E through Admin Panel UI.**
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed on Saturn.
- **Auth Service** — Proposed in grill session. Dedicated auth service to decouple identity/auth from booking (MercuryEngine). Covers Vipps Login, BankID, session management. **Not yet created as a track.**

## ✅ Recently Completed

- **2026-06-24 15:05** — Grill session: ADR-0017 (Company DB Provisioning Architecture), ADR-0018 (Blueprint Bundling via Symlink). Fixed stale terminology across 4 docs (users/profiles→users/users, ghost ADR-0014, wrong ADR-0010 ref, BP "planned" marker). Added No CLI CRUD rule to AGENTS.md. BP auth_provider now catches and logs AuthenticationException. Saturn DB wiped clean, schemas re-applied, NS admin users created.
- **2026-06-24 09:31** — Fixed two deployment-only bugs: blueprint asset path + password mismatch. Both apps rebuilt + deployed.
- **2026-06-23 20:21** — Deploy gate passed (50 admin + 21 BP tests green). Deployed both apps.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🔴 **Clean E2E not yet done.** Saturn DB is wiped and ready. All data (users, companies) must be created through Admin Panel UI — no CLI. BP login depends on Admin Panel successfully provisioning a company.
- 🟡 **No post-deploy verification.** Deploy gate tests logic against local DB, not the deployed product. Need a smoke script.

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
- **Grill deferred items:** bp_portal password strategy (shared dart-define staging, MercuryEngine proxy production), code deduplication (6 instances), Auth Service bounded context split.
- **Auth Service decision:** Dedicated auth service, separate from MercuryEngine. Covers user identity, Vipps Login, BankID, session/token issuance. All apps authenticate through it. Motivated by "Building Event-Driven Microservices" (Adam Bellemare). User wants to start this track today.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔴 **Launch Auth Service track** (`/new-track`). User is motivated and wants a fresh start. This unblocks BP login, code dedup, and Vipps/BankID integration.
2. 🔴 **Clean E2E through Admin Panel.** Log into `dittodatto:8002` → create user → create company (triggers provisioning) → verify BP login at `dittodatto:8003`. No CLI.
3. 🟡 **Apply blueprint symlink** (ADR-0018). Replace `apps/admin/assets/company-blueprint.surql` copy with symlink to `../../schemas/company-blueprint.surql`.
4. 🟡 **Post-deploy smoke script.** Verify deployed product on Saturn.
