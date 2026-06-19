# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

## 2026-06-19 20:42 — Infra Prep + Phase 5 Design Planning

- **Session:** Rebuilt Admin Panel + deployed to Saturn. Applied company-blueprint to `company_house-of-the-north` (18 tables + 3 relations). Stored DB root creds in gitignored `conductor/docs/keys/saturn-db-root.env`. Researched professional portal UX patterns and Flutter theming architecture. Designed Phase 5 plan: sidebar identity (company top, full name bottom), login cleanup (email+password only), tabs → scrollable card sections with scrollspy, sticky top bar. Theme switching explicitly deferred to Phase 6.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Phase 5 implementation plan approved. Ready for implementation in new session.
- **Decisions:** None (design decisions recorded in Pulse session memory, no ADRs)
- **Next:** Implement Phase 5 (reference `implementation_plan.md` artifact from conversation `96918de2-7254-451b-96f1-2a81bef1a195`). Then Phase 6 theme session.

---

- **Session:** Enforced global maintenance redirect both server-side and client-side on the public landing page. Revamped the Norwegian coming-soon page to fix browser emoji clipping and removed the Merkurial Studio footer. Built the container locally and deployed to Cloud Run.
- **Tracks touched:** None
- **Status:** Deployed and verified live at dittodatto.no.
- **Decisions:** None
- **Next:** Rebuild Admin Panel. Apply company-blueprint to `company_house-of-the-north`. Phase 5 of BP track.

---

## 2026-06-19 17:09 — BP Auth Email Validation + Permissions Fix

- **Session:** Fixed email validation hole (username prefix → full email matching in `bp_auth` SIGNIN). Fixed SCHEMAFULL RECORD ACCESS permissions (table needs explicit `PERMISSIONS FOR select WHERE id = $auth.id`). All 46 tests green before deployment.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Deployed and user-verified on Saturn. BP login works E2E.
- **Decisions:** None
- **Next:** Rebuild Admin Panel. Apply company-blueprint to `company_house-of-the-north`. Phase 5.

---

## 2026-06-19 15:38 — BP Auth Full-Stack Fix

- **Session:** Fixed the fundamental auth plumbing end-to-end. DB consolidation (`users/profiles` → `users/users`), argon2 password hashing in Admin Panel, password fields in Create/Edit User dialogs, Saturn DB migration (3 users with password_hash + DEFINE ACCESS bp_auth + bp_portal service users on 2 company DBs). BP rebuilt with `BP_PORTAL_PASS=test-portal-pass`.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Code-complete. Build staged on Saturn at `/tmp/bp-web-deploy/`. Needs `sudo rsync` to deploy. Admin Panel also needs rebuild+redeploy.
- **Decisions:** None (ADR-0016 already covers this architecture)
- **Next:** Deploy BP → E2E login as Demo Dude → verify correct company loads. Rebuild Admin Panel. Apply company-blueprint schema to `company_house-of-the-north`.

---

- **Session:** Purged stale auth narrative from pulse and relay. The broken namespace-level auth (ADR-0013) is dead. ADR-0016 (RECORD ACCESS) is the settled decision.
- **Status:** BP auth code was rewritten in earlier session but NOT verified (no compile, no tests). Conductor docs cleaned. Implementation audit needed.
- **Next:** Verify BP Dart code actually implements ADR-0016 correctly. Compile. Test. Provision Saturn. Deploy. Login.

---

## 2026-06-14 15:30 — BP Login + Establishments Phases 1–4

- **Session:** Implemented Stitch Enterprise Slate light theme, Norwegian login redesign, Establishments list screen with card grid + tab filters, create dialog, and 4-tab edit view.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Phases 1–4 complete. 94 tests green. 7 commits on `track/bp-login-establishments`.
- **Next:** Auth verification, Phase 5 integration, deploy to Saturn.

---

## 2026-06-09 16:30 — Business Portal E2E Steel Thread & Saturn Deployment

- **Session:** Verified Business Portal login E2E against Saturn SurrealDB. Built and deployed to Saturn port 8003.
- **Status:** Login works. Portal live at `http://dittodatto:8003`.
- **Next:** Establishments CRUD track.

---

> 📦 Pre-portal relay history: `conductor/pulse-archive/2026-06-09-pre-portal.md`
