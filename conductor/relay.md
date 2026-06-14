# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

## 2026-06-14 18:17 — BP Phase 4b: Tenant-Scoped Login Wiring

- **Session:** Wired ADR-0013 3-step login flow: NS auth → role/slug verification via `users/profiles` → tenant routing to `company_{slug}`. Discovered NS username ↔ user record link (username field, not email). Login confirmed working from server logs. Session restore (page refresh) hangs — blocked.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Login flow works (verified). Session restore broken (blank screen on refresh). Existing tests pass (48) but only test mocks, not real DB. Needs integration tests before this can be considered production-ready.
- **Decisions:** None (4 pulse-bucket operational notes)
- **Next:** Investigate session restore hang (compare Admin Panel pattern). Write DB integration tests. Deploy once verified.

---

## 2026-06-14 15:30 — BP Login + Establishments Phases 1–4

- **Session:** Implemented Stitch Enterprise Slate light theme, Norwegian login redesign, Establishments list screen with card grid + tab filters, create dialog, and 4-tab edit view. Verified on Pluto dev server with Saturn SurrealDB.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Phases 1–4 complete. 94 tests green (39 ditto_design + 48 BP + 7 admin). Login works against Saturn SDB. Establishments screen renders but needs `USE DB company_{slug}` wiring. 7 commits on `track/bp-login-establishments`.
- **Decisions:** None (6 pulse-bucket operational notes)
- **Next:** Wire DB selection after login, Phase 5 integration, deploy to Saturn, create deploy skill.

---

## 2026-06-09 16:30 — Business Portal E2E Steel Thread & Saturn Deployment

- **Session:** Verified Business Portal login E2E against Saturn SurrealDB. Built and deployed to Saturn port 8005 with dedicated Caddy container.
- **Tracks touched:** None (E2E verification, no track changes)
- **Status:** Login works. Portal live at `http://dittodatto:8005`. `saropa_lints` bumped to ^13.0.0 to resolve workspace dep conflict.
- **Decisions:** None (2 pulse-bucket operational notes)
- **Next:** Design grill for login screen aesthetics. Start Establishments CRUD track.

---

> 📦 Pre-portal relay history: `conductor/pulse-archive/2026-06-09-pre-portal.md`
