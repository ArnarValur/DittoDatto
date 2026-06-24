# Pulse — Current Project State

**Last Updated:** 2026-06-24 09:31
**Session Focus:** Fix BP login (again) — two deployment-only bugs invisible to tests

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–5 complete. Two deployment bugs fixed (asset path + password mismatch). Company provisioned on Saturn via API. **BP login not yet user-verified.**
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete. 50/50 integration tests green. Redeployed to Saturn with asset path fix.

## ✅ Recently Completed

- **2026-06-24 09:31** — Fixed two deployment-only bugs: (1) blueprint asset path `../../schemas/` escaped web root → Caddy returned index.html, (2) password mismatch Admin `bp-portal-default-pass` vs BP `test-portal-pass`. Copied blueprint to `apps/admin/assets/`, updated pubspec + providers. Both apps rebuilt + deployed. Containers restarted. Blueprint verified serving correctly via HTTP. Full auth chain verified via API.
- **2026-06-23 20:21** — Deploy gate passed (50 admin + 21 BP tests green). Deployed both apps. **But deployed code had two bugs invisible to tests.**
- **2026-06-23** — 🔴 Company provisioning built. Blueprint bundled as Flutter asset — but with broken `../../` path.
- **2026-06-23** — Stabilization: Schema Gate, E2E Means E2E rules added. **Rules were violated in same session.**

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🔴 **User trust at zero.** A month of "tests green → deploy → broken" has exhausted the founder. BP login has not been user-verified yet this session.
- 🟡 **No post-deploy verification.** Deploy gate tests logic against local DB, not the deployed product. Need a smoke script.

## 🧠 Session Memory

- **Admin Panel deployed:** `http://dittodatto:8002`
- **Business Portal:** `http://dittodatto:8003`
- **Admin deploy:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/` (NOTE: must be `/web/` subdir — Docker bind mount)
- **BP deploy:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/`
- **Container restart required** after deploy: `ssh saturn 'docker restart dittodatto-caddy dittodatto-portal-caddy'`
- **SurrealDB root creds:** stored in `conductor/docs/keys/saturn-db-root.env` (gitignored)
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both namespaces, password `admin123`)
- **BP auth model (ADR-0016):** RECORD ACCESS `bp_auth` on `users/users` → argon2 password_hash. Service user `bp_portal` (EDITOR) on each `company_{slug}` DB.
- **Schemas source of truth:** `schemas/` at project root. **Blueprint copy** at `apps/admin/assets/company-blueprint.surql` — must stay in sync.
- **Test DB:** `./scripts/test-db-up.sh` → port 18000. `flutter test --tags integration`. `./scripts/test-db-down.sh`.
- **Port reservations:** :8001 SurrealDB, :8002 Admin, :8003 BP, :8004 Marketplace, :8005 Booking Engine.
- **Deploy gate:** `.agents/AGENTS.md` — tests must pass before deploy.
- **Integration tests:** 50 admin + 21 BP tagged integration (92 BP total including widget). `dart_test.yaml` enforces `concurrency: 1`.
- **Workflow guardrails:** Schema Gate (step 3), E2E Means E2E (principle 5).
- **Agent rules:** 4 in `conductor/agent-rules/`.
- **Bug pattern (2026-06-24):** `rootBundle.loadString('../../schemas/...')` worked in dev but escaped web root in release build. Tests load from `File()` so never caught it. Password hardcoded as `bp-portal-default-pass` but BP built with `test-portal-pass`. Both invisible to integration tests.
- **Saturn DB state (2026-06-24):** 1 company in registry (House of the North, provisioned via API). Demo Business user password reset to `admin123`. Company DB `company_house-of-the-north` provisioned with blueprint + bp_portal.
- **TODO:** Post-deploy smoke script. `bp_portal` password still hardcoded. Blueprint file sync (source of truth in `schemas/`, copy in `apps/admin/assets/`).

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔴 **User-verify BP login.** `arnarvalurjonsson@gmail.com` / `admin123` at `http://dittodatto:8003`. This is the #1 priority — nothing else matters until this works.
2. 🔴 **Write post-deploy smoke script.** Hits deployed URLs, verifies blueprint asset, tests auth chain, tests bp_portal signin. Add to deploy gate.
3. 🟢 **Test Admin Panel form.** Delete the API-provisioned company, create one through the form to verify the asset fix works end-to-end.
4. 🟡 **BP E2E:** Login → list establishments → create establishment.
5. 🟡 **Secure `bp_portal` password.**
