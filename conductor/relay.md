# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

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
