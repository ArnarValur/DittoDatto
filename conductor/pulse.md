# Pulse — Current Project State

**Last Updated:** 2026-05-26 (post `/grill foundation`)
**Session Focus:** Conductor v2.1 — foundation grill complete; Saturn staging architecture defined

## 🚀 Active Tracks

_No tracks yet. The foundation grill cleared the path; per-surface tracks land via `/new-track` after `/grill admin-panel` (first up)._

## ✅ Recently Completed

- **2026-05-26 (pm)** — **`/grill foundation` complete.** 12 canonical ADRs written to `conductor/adr/` (7 new + 5 promoted from legacy with namespace rename + content updates). Surface inventory locked: Flutter is the only client stack (Admin + Portal + Marketplace consumer); `dittodatto.no` Nuxt is the public marketing layer only. SurrealDB namespaces renamed `titan/enceladus` → `companies/users` (with `companies/{slug}`, `companies/discovery`, `companies/registry`, `users/profiles`). TheOracle scrubbed as a non-concept. Saturn locked as the staging environment (Tailscale-gated, Cloud Run remains the sole production target). `context.md` consolidated; `project-context.md` synced. Runbook for the SSH-capable adjacent agent shipped at `saturn-setup-runbook.md`. `/conductor`, `/checkpoint`, `/new-track` skill wrappers added so Cursor recognizes them.
- **2026-05-26 (am)** — Conductor v2.1 scaffolded at workspace root. Identity-first `project-context.md` written. Brownfield `context.md` seeded with ~50 domain entities + conceptual terms from MercuryEngine V2 models, SurrealDB schemas, and legacy `.docs/types/`. Legacy reference material migrated to `conductor/docs/legacy/`. Workflow set to **Strict**. Style guides: Python + Dart + general.

## ⚠️ Blockers

_None at the conductor level._

**External blocker (parallel work in flight):** The DittoDatto Hub is not yet running on Saturn. Setup is hand-off-ready (`saturn-setup-runbook.md`) and the user has the Tailscale Service `dittodatto` mid-configuration. Until the Hub is live, `/grill admin-panel` can proceed (paper design) but staging-environment verification of any Flutter-against-real-engine work is blocked.

## 🧠 Session Memory

- **Project name:** DittoDatto (`dittodatto.no`) — The Agentic Commerce Platform for Norway. Drammen-first, fylke-by-fylke expansion, Scandinavia horizon.
- **Stack:** Python 3.11+ / FastAPI / Pydantic v2 / uv (MercuryEngine V2) · Dart / Flutter / Riverpod / GoRouter (Admin + future Portal + Marketplace consumer) · TypeScript / Vue 3 / Nuxt 4 (`dittodatto.no` landing only) · SurrealDB 3.0 (sole platform DB).
- **Namespaces (renamed this session):** `companies` (was `titan`) hosts `{slug}` + `discovery` + `registry`; `users` (was `enceladus`) hosts `profiles`.
- **Surface inventory locked:**
  - Admin Panel = **Flutter cross-platform** (`apps/admin/`) — Android-first framing dropped; tablet is a test surface, not a design constraint. S19–S20 shipped 4 screens.
  - Business Portal = **Flutter (planned)** — full replacement of legacy Nuxt webapp. Pre-grill state; `/grill business-portal` will produce the first PRD.
  - Public Marketplace consumer = **Flutter (iOS + Android)** — scaffold; tracer-bullet in `/grill public-marketplace`.
  - `dittodatto.no` = **Nuxt 4 marketing/landing only** — polished AFTER Flutter app reaches completeness; Cloud Run hosted; NOT a co-equal product surface.
  - Legacy Nuxt admin-panel + business-portal = frozen, bug-fix-only, retired on Flutter parity.
- **Deployment topology:**
  - **Dev:** This workstation (local Docker for SurrealDB + native processes).
  - **Staging:** Saturn (always-on, Tailscale-gated at `saturn.tailb251cd.ts.net` + `dittodatto.tailb251cd.ts.net`). Docker network `dittodatto-net`. Hub on `:8001`, MercuryEngine V2 on `:8002`, reserved `:8003–8005` for future Ditto/Datto/internal. OpenWebUI on `:8080` untouched.
  - **Production:** Cloud Run `europe-west1` only — sole production target. Saturn is **never** production.
- **Canonical ADRs (`conductor/adr/`):** 0001 SurrealDB sole DB · 0002 namespace architecture (companies/users) · 0003 Saturn staging · 0004 auth identity model + base tiers · 0005 admin tier expansion (stub — open questions for `/grill admin-panel`) · 0006 Flutter Admin Panel · 0007 Flutter-only client strategy · 0008 DittoBar on MercuryEngine · 0009 hybrid collapsible map home · 0010 per-service booking modes · 0011 AaaS over SaaS · 0012 staff assignment modes.
- **Dropped from canonical:** Legacy 0003 (Zod DateTimeSchema — stack-defunct; Pydantic/SurrealDB solve datetime natively) and legacy 0007 (DittoBar on TheOracle — non-concept per user). Both files remain in `conductor/docs/legacy/adr-source/` as historical reference only.
- **Test status (legacy, pre-disruption):** 377 tests in MercuryEngine V2 (197 unit + 73 admin + 50 auth + 32 integration + 25 token). User is solo dev and hasn't reviewed them post-workstation-blowout; review deferred to a future MercuryEngine track.
- **Personal context:** Workstation blew out the day after Saturn arrived (~3–4 weeks ago); this session is the first sustained re-focus after that disruption. Solo developer (Arnar) + Höddi as second team member. Merkurial Studio.

## 📋 Next Session Suggestions

1. **Forward `saturn-setup-runbook.md`** to the adjacent SSH-capable agent so the DittoDatto Hub comes up. Concurrently: finish the Tailscale Service `dittodatto` config in the admin UI (ports `tcp:8001-8005`) and advertise it from Saturn.
2. **`/grill admin-panel`** — refines ADR-0005 open questions (BankID re-auth for super-admin? Device restrictions? Impersonation pattern? Audit log depth?), Inbox stub scope (MasterDatto), and the next post-S20 screen wave. Light-to-moderate budget. Can run in parallel with Saturn coming up — paper design.
3. **`/grill business-portal`** — greenfield grill: full Flutter Portal PRD, migration strategy from frozen Nuxt, operator-side UX. Moderate-to-heavy budget.
4. **`/grill public-marketplace`** — refresh the stale `prd-public-marketplace-v1-STALE.md`, lock the Flutter consumer PRD (v1.0 tracer-bullet scope), validate ADR-0009 (Hybrid Map Home). Moderate budget.
5. **`/grill mercury-engine`** *(deferred)* — Pydantic v2 datetime conventions (the canonical replacement for the legacy Zod 0003), migration of `DittoDatto-old/schemas/*.surql`, 377-test post-disruption review.

Strategy reference: `grill_strategy.md` at workspace root.
