# Pulse — Current Project State

**Last Updated:** 2026-05-26
**Session Focus:** Conductor v2.1 initialization (brownfield-by-import)

## 🚀 Active Tracks

_No tracks yet. Create the first one with `/new-track` after the foundation grill consolidates decisions._

## ✅ Recently Completed

- **2026-05-26** — Conductor v2.1 scaffolded at workspace root. Identity-first `project-context.md` written. Brownfield `context.md` seeded with ~50 domain entities + conceptual terms from MercuryEngine V2 models, SurrealDB schemas, and legacy `.docs/types/`. Legacy reference material migrated to `conductor/docs/legacy/` (11 ADRs, 32 type specs, 10 engine docs, 7 postits, 8 walkthroughs, 8-file old-conductor snapshot, CONTEXT.md, stale marketplace PRD). Workflow set to **Strict**. Style guides: Python + Dart + general.

## ⚠️ Blockers

_None at the conductor level. The foundation grill needs to resolve open questions surfaced in `context.md` → "Notes / Open Questions for the Foundation Grill."_

## 🧠 Session Memory

- **Project name:** DittoDatto (`dittodatto.no`) — The Agentic Commerce Platform for Norway. Drammen-first, fylke-by-fylke expansion, Scandinavia horizon.
- **Stack:** Python 3.11+ / FastAPI / Pydantic v2 / uv (MercuryEngine V2) · Dart / Flutter / Riverpod / GoRouter (Admin + Marketplace + future Portal) · TypeScript / Vue 3 / Nuxt 4 (Public Marketplace web) · SurrealDB 3.0 (sole platform DB).
- **Test status at init (legacy):** 377 tests in MercuryEngine V2 — 197 unit + 73 admin + 50 auth + 32 integration + 25 token.
- **Surface inventory (canonical at init):**
  - Admin Panel = **Flutter** (`apps/admin/`) — in-progress migration; Dashboard / Users / Companies / Categories shipped (S19–S20).
  - Business Portal = **Flutter, planned** — full replacement of legacy Nuxt webapp.
  - Public Marketplace = **Flutter (native) + Nuxt (web)** — dual surfaces, both real products.
  - Legacy Nuxt admin-panel + business-portal = frozen, retired once Flutter ships.
- **What is NOT migrated yet:** Actual code (MercuryEngine FastAPI, Flutter Admin, packages, schemas) all still in `DittoDatto-old/`. Migration belongs to later track sessions.
- **`conductor/adr/` and `conductor/prd.md` are intentionally lazy** — they will be born from the foundation + per-surface grills.
- **Saturn (GX10) hardware** is incoming — Day-1 blueprint in `conductor/docs/legacy/postit/saturn-local-stack.md`.
- **Dogfooding plan:** Saturn staging runs `merkurial-studio` and `dittodatto` companies as real tenant simulations.
- **Per user instruction:** Skipped `WAYMAP.md` (20 sessions stale), `agent-profile.md` (S16-era), `todos-idea-list.md`, old `pulse.md`, Chapter 1 `archive/`.

## 📋 Next Session Suggestions

1. **`/grill foundation`** — the meatiest session. Triage the 11 legacy ADRs in `conductor/docs/legacy/adr-source/`, refine `context.md`, lock the surface inventory, resolve contradictions flagged in `context.md` → "Notes / Open Questions for the Foundation Grill." Budget: heavy.
2. **`/grill admin-panel`** — refine Admin Panel domain on top of foundation. Budget: light-to-moderate.
3. **`/grill business-portal`** — define from scratch; lock Flutter migration. Budget: moderate.
4. **`/grill public-marketplace`** — refresh stale marketplace PRD; lock the dual Flutter+Nuxt surface story. Budget: moderate.

Strategy reference: see `grill_strategy.md` at workspace root for sequencing rationale.
