# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

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
