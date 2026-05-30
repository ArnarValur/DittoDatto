# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

## 2026-05-30 14:49 — Admin Panel audit + conductor cleanup

- **Tracks:** `admin_panel_20260527` (in progress)
- Full audit: 3 subagents audited auth, CRUD/data layer, SurrealDB infrastructure
- Audit artifact produced with truth table of what's real vs mock vs fiction
- Purged "breaker box" / "2-user private tool" from 8 files
- Trimmed context.md glossary to one-line definitions
- Rewrote relay.md to bullet-point facts
- Removed all legacy references from context.md
- Removed "B2B sales" framing from Shadow Demand / Zero-Result Signal entries
- Fixed metadata.json description to reflect actual state
- 0 ADRs
- **Next:** User regrilling project context this afternoon, then Admin Panel implementation

---

## 2026-05-30 13:35 — Conductor standardization + Admin Panel revert

- **Tracks:** `admin_panel_20260527` (in progress)
- Standardized `.agents/workflows/` with v2.1 templates
- Removed redundant `conductor-init.md` from workspace
- Reverted `metadata.json` status to `in_progress` — track completion was never approved
- 0 ADRs
- **Next:** `/grill admin-panel` to align scope and verify progress

---

## 2026-05-29 18:30 — Admin Panel connectivity verification

- **Tracks:** `admin_panel_20260527` (in progress)
- Fixed SurrealDB distroless Docker healthcheck (`is-ready`)
- Restructured `adminRepositoryProvider` to watch `authProvider` reactively
- Recompiled web target, deployed via `rsync`
- Restrained all ports to `127.0.0.1` on Saturn for Tailscale-only access
- Verified Surrealist connection via Tailscale FQDN/IP
- 0 ADRs
- **Next:** Verify live CRUD operations, continue Admin Panel polish

---

## 2026-05-29 17:45 — ADR purge + conductor cleanup

- **Tracks:** `admin_panel_20260527` (Phase 5 in progress)
- Purged stale ADRs, consolidated to 6 core active ADRs
- Cleaned `prd.md` to align with direct-to-database architecture
- Aligned `project-context.md` tech stack and auth sections
- Synchronized `plan.md` for Phases 3–5
- 0 new ADRs (re-recorded 6 existing)
- **Next:** Browser-verify Saturn deployment

---

## 2026-05-29 15:51 — Saturn deployment sprint

- **Tracks:** `admin_panel_20260527` (Phase 4 in progress)
- SurrealDB bootstrapped: 2 namespaces, 3 databases, 23 seed records, 2 namespace users
- `SurrealAuthService` + `SurrealAdminRepository` implemented with dual-namespace WebSocket connections
- Caddy container added — serves Flutter web at `:8002`, reverse proxies `/rpc` to SurrealDB
- Accessible at `http://saturn:8002`
- 1 ADR (0015 — admin panel direct SurrealDB data path)
- **Next:** Browser-verify login + CRUD. HTTPS resolution. CI/CD pipeline.

---

## 2026-05-29 14:15 — Aborted (overengineered plan)

- **Tracks:** None (no implementation)
- Attempted to plan Saturn deployment, aborted — plan mixed booking engine and auth concerns into what should have been simple deployment
- Scrubbed "MercuryEngine V2" → "MercuryEngine" from all 13 conductor files
- Started Grapher for DittoDatto Core
- **Lesson:** Keep deployment plans simple. Auth boundary was already resolved by child conductor.
- **Next:** Grill parent conductor to clean stale assumptions

---

## 2026-05-29 13:17 — Emulator setup + Phase 1–2 complete

- **Tracks:** `admin_panel_20260527` (Phase 1 & 2 completed)
- Created 3 emulators (`pixel_7_api_35`, `pixel_tablet_api_35`, `generic_tablet_api_35`)
- Widget test suite written (100% green) with synchronous `FakeAuthService`
- 0 ADRs
- **Next:** Sanitize mock data into JSON asset, proceed to Phase 3

---

## 2026-05-27 15:28 — `/new-track admin-panel` created

- **Tracks:** `admin_panel_20260527` (created)
- Spec anchored to PRD v1.1 + ADR-0006/0013/0014
- 5-phase TDD plan, mock-first API strategy
- All dependency versions verified
- 0 ADRs
- **Next:** Phase 1 implementation

---

## 2026-05-26 22:49 — Flutter design system grill

- **Tracks:** None
- Identified shared design system prerequisite (`ditto_design`)
- `flutter_adaptive_scaffold` confirmed discontinued — use core Material 3
- Melos 7.7.0 confirmed as monorepo orchestrator
- 0 ADRs (ADR-0014 candidate pending grill)
- **Next:** `/grill-me` with design system briefing → ADR-0014

---

## 2026-05-26 22:38 — `/grill admin-panel` complete

- **Tracks:** None (no tracks yet)
- PRD v1.0 locked. ADR-0013 written. Glossary updated (6 terms).
- Scope: 5 screens. Android + Linux desktop + Web. No iOS.
- Login: lock icon + email + password. No error feedback.
- Excludes establishments/bookings/services (→ Business Portal)
- 1 ADR (0013 — admin scope & access model)
- **Next:** `/new-track admin-panel`

---

## 2026-05-26 21:35 — PlutoII Flutter dev ready

- Flutter 3.44.0 / Dart 3.12.0 / JDK 21 / Android SDK 36.1.0 all green
- PATH wired in `~/.zshrc`, system symlinks at `/usr/local/bin/`
- Dart MCP server configured for Antigravity
- 0 ADRs
- **Next:** `/grill admin-panel`

---

## 2026-05-26 20:49 — Saturn Hub deployed

- SurrealDB 3.0 running on Saturn at `100.87.99.59:8001` (Docker, RocksDB)
- SSH key auth PlutoII → Saturn established
- Tailscale Service `dittodatto` defined (ports `tcp:8001-8005`)
- `saturn-setup-runbook.md` cleaned up
- Root credentials in Bitwarden
- 0 ADRs
- **Next:** `/grill admin-panel`

---

## 2026-05-26 16:12 — `/grill foundation` complete

- 12 canonical ADRs written (0001–0012)
- `context.md` consolidated, `project-context.md` synced
- `saturn-setup-runbook.md` produced
- Commits: `354280e` (foundation grill), `09fdb7a` (project-context sync)
- Key settled decisions: SurrealDB sole DB, `companies`/`users` namespaces, Saturn staging only, all client surfaces Flutter, `dittodatto.no` is marketing only
- **Next:** Resume with `/conductor`, then per-surface grills

---

## 2026-05-26 10:13 — Conductor v2.1 init

- Fresh `conductor/` scaffolded (brownfield import from `DittoDatto-old/`)
- Workflow: Strict (TDD). Style guides: Python + Dart + general.
- Admin Panel canonicalized as Flutter. Public Marketplace as dual surface.
- `adr/` and `prd.md` left empty for grills
- **Next:** `/grill foundation`
