# Pulse — Current Project State

**Last Updated:** 2026-05-26 22:38 (post `/grill admin-panel`)
**Session Focus:** `/grill admin-panel` — domain refinement, ADR-0013, PRD v1.0

## 🚀 Active Tracks

_No tracks yet. `/grill admin-panel` complete — PRD v1.0 locked. Next: `/new-track admin-panel` to create the implementation track._

## ✅ Recently Completed

- **2026-05-26 (late night)** — **`/grill admin-panel` complete.** Admin Panel reframed as "breaker box" (2-user private tool for Arnar + Höddi). ADR-0013 written (resolves all 4 ADR-0005 open questions, refines ADR-0006). PRD v1.0 created and versionized. 6 glossary updates: Admin Panel, Business Portal (dogfooding), Inbox, MasterDatto, SearchAnalytics. Scope locked: 5 screens + Inbox. Targets: Android + Linux + Web (no iOS). Login: maximum opacity (email + pass + sign in, no branding, no error feedback). Responsive shell from day one. Migration: fresh `flutter create` + port from old.
- **2026-05-26 (late evening)** — **PlutoII Flutter dev environment setup.** Flutter 3.44.0 / Dart 3.12.0 confirmed at `~/Flutter/flutter/`. JDK 21 (OpenJDK) installed. Android SDK 36.1.0 cmdline-tools installed + licenses accepted. Linux desktop toolchain (clang 18 + cmake 3.28 + ninja 1.11) installed. PATH wired in `~/.zshrc`. Chrome (Flatpak) wired via `CHROME_EXECUTABLE`. System symlinks at `/usr/local/bin/{dart,flutter}`. Dart MCP server configured for Antigravity (`~/.gemini/config/mcp_config.json`, absolute path). `flutter doctor -v` all green. Setup script at `setup-flutter-dev.sh` (disposable).
- **2026-05-26 (evening)** — **DittoDatto Hub deployed on Saturn.** SurrealDB 3.0 (RocksDB) running in Docker container `dittodatto-hub` on `dittodatto-net` network, bound to Tailnet IP `100.87.99.59:8001`. Remote smoke test from PlutoII: 200 OK via `saturn:8001`. OpenWebUI on `:8080` confirmed healthy. SSH key auth established PlutoII → Saturn. Tailscale Service `dittodatto` defined (ports `tcp:8001-8005`), Saturn tagged `tag:dittodatto-hub`. `saturn-setup-runbook.md` cleaned up (6 stale references: ADR-XXXX → ADR-0003, titan/enceladus → companies/users, "to be written" → settled). Hub intentionally empty — schemas deferred to MercuryEngine migration track.
- **2026-05-26 (pm)** — **`/grill foundation` complete.** 12 canonical ADRs written to `conductor/adr/`. Surface inventory locked. SurrealDB namespaces renamed `titan/enceladus` → `companies/users`. Saturn locked as staging. `context.md` consolidated; `project-context.md` synced. Runbook shipped at `saturn-setup-runbook.md`.
- **2026-05-26 (am)** — Conductor v2.1 scaffolded. Identity-first `project-context.md` written. Brownfield `context.md` seeded. Legacy reference material migrated to `conductor/docs/legacy/`. Workflow set to **Strict**.

## ⚠️ Blockers

_None._ Saturn Hub is live — staging-environment verification is unblocked.

## 🧠 Session Memory

- **Project name:** DittoDatto (`dittodatto.no`) — The Agentic Commerce Platform for Norway. Drammen-first, fylke-by-fylke expansion, Scandinavia horizon.
- **Stack:** Python 3.11+ / FastAPI / Pydantic v2 / uv (MercuryEngine V2) · Dart / Flutter / Riverpod / GoRouter (Admin + future Portal + Marketplace consumer) · TypeScript / Vue 3 / Nuxt 4 (`dittodatto.no` landing only) · SurrealDB 3.0 (sole platform DB).
- **Namespaces (renamed this session):** `companies` (was `titan`) hosts `{slug}` + `discovery` + `registry`; `users` (was `enceladus`) hosts `profiles`.
- **Surface inventory locked:**
  - Admin Panel = **Flutter "breaker box"** (`apps/admin/`) — 2-user private tool (Arnar + Höddi). Android + Linux desktop + Web (no iOS). 5 screens: Dashboard / Users / Companies / Categories / Inbox. Responsive shell. PRD v1.0 locked. ADR-0013 resolves all ADR-0005 open questions. Next: `/new-track admin-panel`.
  - Business Portal = **Flutter (planned)** — full replacement of legacy Nuxt webapp. Pre-grill state; `/grill business-portal` will produce the first PRD.
  - Public Marketplace consumer = **Flutter (iOS + Android)** — scaffold; tracer-bullet in `/grill public-marketplace`.
  - `dittodatto.no` = **Nuxt 4 marketing/landing only** — polished AFTER Flutter app reaches completeness; Cloud Run hosted; NOT a co-equal product surface.
  - Legacy Nuxt admin-panel + business-portal = frozen, bug-fix-only, retired on Flutter parity.
- **Deployment topology:**
  - **Dev:** This workstation (local Docker for SurrealDB + native processes).
  - **Staging:** Saturn (always-on, Tailscale-gated at `saturn.tailb251cd.ts.net` + `dittodatto.tailb251cd.ts.net`). Docker network `dittodatto-net`. Hub on `:8001`, MercuryEngine V2 on `:8002`, reserved `:8003–8005` for future Ditto/Datto/internal. OpenWebUI on `:8080` untouched.
  - **Production:** Cloud Run `europe-west1` only — sole production target. Saturn is **never** production.
- **Canonical ADRs (`conductor/adr/`):** 0001 SurrealDB sole DB · 0002 namespace architecture (companies/users) · 0003 Saturn staging · 0004 auth identity model + base tiers · 0005 admin tier expansion (open questions resolved by 0013) · 0006 Flutter Admin Panel (refined by 0013) · 0007 Flutter-only client strategy · 0008 DittoBar on MercuryEngine · 0009 hybrid collapsible map home · 0010 per-service booking modes · 0011 AaaS over SaaS · 0012 staff assignment modes · **0013 admin panel scope & access model** (NEW — `/grill admin-panel`).
- **Dropped from canonical:** Legacy 0003 (Zod DateTimeSchema — stack-defunct; Pydantic/SurrealDB solve datetime natively) and legacy 0007 (DittoBar on TheOracle — non-concept per user). Both files remain in `conductor/docs/legacy/adr-source/` as historical reference only.
- **Test status (legacy, pre-disruption):** 377 tests in MercuryEngine V2 (197 unit + 73 admin + 50 auth + 32 integration + 25 token). User is solo dev and hasn't reviewed them post-workstation-blowout; review deferred to a future MercuryEngine track.
- **Personal context:** Workstation blew out the day after Saturn arrived (~3–4 weeks ago); this session is the first sustained re-focus after that disruption. Solo developer (Arnar) + Höddi as second team member. Merkurial Studio. Today is Arnar's birthday. 🎂
- *2026-05-26* — Tailscale Service `dittodatto` defined with ports `tcp:8001-8005`; Saturn tagged `tag:dittodatto-hub` in Tailscale ACL _(operational)_
- *2026-05-26* — SurrealDB root credentials: user `dittodatto_root`, password stored in Bitwarden (entry: "DittoDatto Hub — SurrealDB root, Saturn") _(operational)_
- *2026-05-26* — SSH key auth PlutoII → Saturn established; config at `~/.ssh/config` host `saturn`, user `arnar` _(operational)_
- *2026-05-26* — PlutoII Flutter dev environment: Flutter 3.44.0 at `~/Flutter/flutter/`, JDK 21, Android SDK 36.1.0, Linux toolchain. PATH in `~/.zshrc`. Symlinks at `/usr/local/bin/{dart,flutter}`. Chrome via Flatpak (`CHROME_EXECUTABLE`). Dart MCP server in Antigravity uses absolute path _(operational)_

## 📋 Next Session Suggestions

1. **`/new-track admin-panel`** — create the implementation track. Fresh `flutter create` at `apps/admin/`, port `mercury_client` + feature-first architecture from `DittoDatto-old/`. Version bump to Flutter 3.44 / Dart 3.12. PRD v1.0 is the spec. Dart MCP server is configured and ready.
2. **`/grill business-portal`** — greenfield grill: full Flutter Portal PRD, migration strategy from frozen Nuxt, operator-side UX. Moderate-to-heavy budget.
3. **`/grill public-marketplace`** — refresh the stale `prd-public-marketplace-v1-STALE.md`, lock the Flutter consumer PRD (v1.0 tracer-bullet scope), validate ADR-0009 (Hybrid Map Home). Moderate budget.
4. **`/grill mercury-engine`** *(deferred)* — Pydantic v2 datetime conventions, migration of `DittoDatto-old/schemas/*.surql`, 377-test post-disruption review.
5. **Platform messaging/notification system** *(future `/grill`)* — human-readable + A2A messaging architecture. Impacts Inbox depth in Admin Panel.

Strategy reference: `grill_strategy.md` at workspace root.
