# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

---

## 2026-05-26 22:38 (`/grill admin-panel` complete)

- **Session:** `/grill admin-panel` domain refinement (Hermes on Antigravity, Claude Opus 4.6 Thinking).
- **Tracks touched:** None (no tracks exist yet — `/new-track admin-panel` is the next step).
- **Status:** **Admin Panel grill complete.** PRD v1.0 locked. ADR-0013 written. Glossary updated (6 terms). All ADR-0005 open questions resolved.
- **Key outcomes:**
  - Admin Panel = **"breaker box"** — 2-user private tool (Arnar + Höddi only). Not multi-role.
  - Platform targets: Android + Linux desktop + Web (same Flutter codebase). No iOS.
  - Login: lock icon + email + password + Sign In. No branding text. No error feedback. Maximum opacity.
  - Scope: 5 screens (Dashboard, Users, Companies, Categories, Inbox). Explicitly excludes establishments/bookings/services (→ Business Portal).
  - Business Portal = where Merkurial Studio manages its own business relationships. Admin Panel = infrastructure breaker box.
  - Responsive shell from day one (LayoutBuilder + Material 3 adaptive nav). Old 240px fixed sidebar is replaced.
  - Migration: fresh `flutter create` at `apps/admin/`, port from `DittoDatto-old/`. Version bump to Flutter 3.44 / Dart 3.12.
  - Inbox = within-platform messaging (human precursor to MasterDatto). System Alerts → future Inbox feature.
  - SearchAnalytics (`predict.dittodatto.no`) stays separate; merge decision deferred.
- **Decisions:** 1 ADR — 0013 (admin panel scope & access model). 0 unhandled decisions at checkpoint.
- **Artifacts:** PRD v1.0 at `conductor/prd.md`.
- **Next:** `/new-track admin-panel` in a fresh session. The spec is the PRD. Dart MCP server + Flutter 3.44 dev environment are ready on PlutoII.

---

## 2026-05-26 21:35 (PlutoII Flutter dev ready)

- **Session:** PlutoII Flutter dev environment setup (Hermes on Antigravity, Opus 4.6 Thinking).
- **Tracks touched:** None (no tracks exist yet).
- **Status:** **PlutoII is Flutter-dev-ready.** Flutter 3.44.0 / Dart 3.12.0 / JDK 21 / Android SDK 36.1.0 / Linux desktop toolchain all green on `flutter doctor -v`. PATH wired in `~/.zshrc`. System symlinks at `/usr/local/bin/{dart,flutter}`. Dart MCP server configured for Antigravity with absolute path. Chrome (Flatpak) wired via `CHROME_EXECUTABLE`.
- **Decisions:** None (0 ADRs — all operational, classified at checkpoint).
- **Artifacts:** `setup-flutter-dev.sh` at workspace root — disposable, can be trashed.
- **Next:** `/grill admin-panel` (user is opening a new window for this). Dev environment is fully unblocked for Flutter builds.

---

## 2026-05-26 20:49 (Saturn Hub deployed)

- **Session:** Conductor resume + Saturn DittoDatto Hub deployment (Hermes on Antigravity, Opus 4.6 Thinking).
- **Tracks touched:** None (no tracks exist yet).
- **Status:** **Saturn Hub live.** SurrealDB 3.0 running on Saturn at `100.87.99.59:8001` (Docker container `dittodatto-hub`, network `dittodatto-net`, RocksDB engine). Remote smoke test from PlutoII: 200 OK via `saturn:8001`. Hub intentionally empty — schemas deferred to MercuryEngine migration track.
- **Infrastructure done this session:**
  - SSH key auth PlutoII → Saturn established (`~/.ssh/config` host `saturn`, user `arnar`).
  - Tailscale Service `dittodatto` defined in admin console (ports `tcp:8001-8005`).
  - Saturn tagged `tag:dittodatto-hub` in Tailscale ACL.
  - `saturn-setup-runbook.md` cleaned up: 6 stale references patched (ADR-XXXX → 0003, titan/enceladus → companies/users, "to be written" → settled).
  - SurrealDB root credentials in Bitwarden (entry: "DittoDatto Hub — SurrealDB root, Saturn").
- **Decisions:** None (0 ADRs — all operational, classified at checkpoint).
- **Blocker cleared:** "DittoDatto Hub not running on Saturn" is resolved. Staging-environment verification is now unblocked for all surfaces.
- **Next:** `/grill admin-panel` (user is opening a new window for this). Then `/grill business-portal`, `/grill public-marketplace` per strategy.

---

## 2026-05-26 16:12 (close of `/grill foundation`)

- **Session:** Conductor v2.1 — foundation grill, post-workstation-disruption refocus.
- **Status:** **Foundation locked.** 12 canonical ADRs written (`conductor/adr/0001`–`0012`). `context.md` consolidated. `project-context.md` synced at user invitation. `saturn-setup-runbook.md` produced for the SSH-capable adjacent agent. `/conductor`, `/checkpoint`, `/new-track` skill wrappers added to `.cursor/skills/` so Cursor recognizes them.
- **Two commits this session:**
  - `354280e` — `grill: foundation — Saturn staging + surface inventory + namespace rename (13 glossary updates, 12 ADRs, prd: no)`
  - `09fdb7a` — `conductor(sync): fold /grill foundation 2026-05-26 decisions into project-context.md`
- **Key decisions to NOT re-litigate next session (settled in canonical ADRs):**
  - SurrealDB is the sole platform DB (0001). Namespaces are `companies` + `users` — `titan` / `enceladus` codenames are dead (0002).
  - Saturn is staging only; Cloud Run is the sole production target (0003). Saturn is never production.
  - All client surfaces are Flutter (0007). `dittodatto.no` is the only Nuxt surface — public marketing/landing only, NOT a co-equal product. Polished post-Flutter completeness.
  - Auth: MercuryEngine issues JWTs; 3 base tiers (`public`/`require_auth`/`require_operator`) per 0004, 2 platform tiers (`require_admin`/`require_super_admin`) per 0005. NIN never stored.
  - DittoBar discovery lives in MercuryEngine V2; TheOracle was never a real concept (the legacy ADR-0007 file in `conductor/docs/legacy/adr-source/` is a historical misunderstanding).
- **Pending external work (user's parallel session):**
  - Tailscale Service `dittodatto` mid-configuration in the merkurial-studio admin panel. Recommended ports: `tcp:8001-8005`. Service still needs to be advertised from Saturn (admin panel "Advertised by" assignment, or `sudo tailscale set --advertise-services=dittodatto` on Saturn).
  - DittoDatto Hub setup pending — `saturn-setup-runbook.md` is hand-off-ready for the SSH-capable adjacent agent. Docker network name aligned with user's umbrella convention: `dittodatto-net`.
- **Open questions deferred to per-surface grills** (per `context.md` "Notes / Open Questions" section, plus ADR-0005 open block):
  - `/grill admin-panel`: BankID re-auth for super-admin? Device restrictions? Impersonation pattern? Audit depth? Inbox / MasterDatto scope?
  - `/grill business-portal`: greenfield PRD, migration timing, operator-side UX.
  - `/grill public-marketplace`: refresh stale v1 PRD, Flutter consumer PRD, DittoBar interaction model.
  - Future `/grill mercury-engine`: Pydantic v2 datetime conventions (canonical replacement for the dropped legacy 0003), 377-test review.
- **Next session entry point:**
  - Resume with `/conductor` (the skill is now registered — should autocomplete in Cursor). It will run the standard resume protocol (load context, reconcile index, present status).
  - Then either `/grill admin-panel` (paper design proceeds in parallel with Saturn Hub coming up) OR wait for the Hub then verify end-to-end.

---

## 2026-05-26 10:13

- **Session:** Conductor v2.1 init (brownfield-by-import from `DittoDatto-old/`).
- **Status:** Fresh `conductor/` scaffolded. Identity-first `project-context.md` locked. Brownfield `context.md` seeded from MercuryEngine V2 models + SurrealDB schemas + `.docs/types/` + legacy `CONTEXT.md`. Legacy reference material migrated into `conductor/docs/legacy/`.
- **Key calls made at init:**
  - Workflow mode = **Strict** (TDD culture, 377 tests, real product).
  - Style guides = Python + Dart + general.
  - Schemas left in `DittoDatto-old/schemas/` (code migration deferred to later tracks).
  - Skipped per user direction: `WAYMAP.md` (20 sessions stale), `agent-profile.md` (S16-era, references 249 tests instead of 377), `todos-idea-list.md`, old `pulse.md`, `archive/`.
  - Admin Panel canonicalized as **Flutter** (`apps/admin/`) — fixes the legacy `CONTEXT.md` / `vision.md` claim that it was "Nuxt web, no migration planned."
  - Public Marketplace canonicalized as **dual surface** — Flutter native app **+** Nuxt 4 webapp (the legacy "Web Shell" framing is retired pending grill confirmation).
  - `conductor/adr/` and `conductor/prd.md` intentionally left empty/lazy — to be born from the upcoming grills, not pre-populated with stale content.
- **Next:**
  1. `/grill foundation` — triage the 11 legacy ADRs (`conductor/docs/legacy/adr-source/`), refine the seed `context.md` into the canonical glossary, lock the surface inventory, resolve the contradictions flagged in `context.md` → "Notes / Open Questions for the Foundation Grill."
  2. `/grill admin-panel` — refine the Admin Panel domain on top of foundation.
  3. `/grill business-portal` — define Business Portal from scratch (no PRD exists yet) + Flutter migration decision.
  4. `/grill public-marketplace` — refresh the stale marketplace PRD; lock the dual Flutter + Nuxt surface story.
