# Legacy Reference — DittoDatto Chapter 1 → Chapter 2 Snapshot

> **Imported by `/conductor-init` on 2026-05-26** from `DittoDatto-old/.docs/` and `DittoDatto-old/conductor/`.
>
> **Purpose:** Input material for the upcoming foundation + per-domain grill sessions. **Not** the active source of truth — the active source is `conductor/project-context.md`, `conductor/context.md`, and (after the grills) `conductor/adr/` + `conductor/prd.md`.

---

## What's here

| Subfolder | Contents | Grill use |
|---|---|---|
| `adr-source/` | 11 legacy ADRs (0001–0011) | **Foundation grill triages** — accept / revise / supersede → new ADRs land in `conductor/adr/` |
| `types/` | 32 Pydantic-era type specs (`booking.md`, `service.md`, `staff-member.md`, …) + `_deprecated/person.md` | **Foundation grill** — glossary seed material (the `context.md` Entities list was seeded from these + the SurrealDB schemas) |
| `engine/` | 10 MercuryEngine architecture docs (`architecture.md`, `time-tetris.md`, `booking-flow.md`, `api-contract.md`, `known-issues.md`, vertical docs, `verdict.md`) | **Stable reference** — engine architecture rarely needs regrilling. Will be promoted/refined into `conductor/docs/` as needed. |
| `postit/` | 7 brainstorm docs (Saturn local stack, BankID/Vipps auth, DittoBar UX, Python migration, SurrealDB POC, connection pool, prediction department) | **Foundation grill input** — informed past decisions; some may become formal ADRs. |
| `walkthroughs/` | 8 grill session transcripts (S7–S20) | **Historical record** — why we decided X. Keep for context, not for active workflow. |
| `conductor-snapshot/` | The v2.0 conductor's `product.md`, `vision.md`, `tech-stack.md`, `decisions.md`, `tracks.md`, `BOOKING_ENGINE.md`, `product-guidelines.md`, `workflow.md` | **Foundation grill input** — pre-regrill source-of-truth snapshot; the v2.1 `project-context.md` consolidates this with corrections (Admin Panel = Flutter, dual marketplace surfaces). |
| `CONTEXT.md` | The legacy domain glossary | **Foundation grill input** — sharpened into the new `conductor/context.md`. |
| `prd-public-marketplace-v1-STALE.md` | The legacy marketplace PRD | **Public Marketplace grill input** — partially stale (references Hono/TypeScript/156 tests); to be rewritten into `conductor/prd.md`. Filename intentionally flagged with `-STALE`. |

---

## What was deliberately skipped

Per the conductor-init session decisions:

- **`WAYMAP.md`** — 20 sessions behind reality (showed S12–S15 as "not started" when they were all done). Excluded to prevent confusing the brownfield scanner. Replaced by the new conductor's session tracking.
- **`agent-profile.md`** — S16-era, references 249 tests (now 377). Excluded.
- **`todos-idea-list.md`** — stale ideas backlog. Excluded.
- **Old `pulse.md`** — superseded by the fresh `conductor/pulse.md`.
- **`archive/`** (Chapter 1 deep archive) — too deep, not needed.
- **Old `code_styleguides/`** — replaced with fresh TheOracle v2.1 templates in `conductor/code_styleguides/`.

---

## What's NOT migrated (still in `DittoDatto-old/`)

Actual code, schemas, and assets remain in `DittoDatto-old/` and will be migrated track-by-track in later sessions:

- `services/mercury-engine/` — FastAPI Python codebase + 377 tests.
- `apps/admin/` — Flutter Admin Panel (S19–S20).
- `apps/marketplace/` — Flutter Public Marketplace scaffold.
- `apps/web/admin-panel/`, `apps/web/business-portal/` — frozen Nuxt webapps (Chapter 1).
- `apps/web/public-marketplace/` — Nuxt 4 webapp (active, will continue as the consumer web surface).
- `packages/mercury_client/`, `packages/mercury-engine/` (V1 frozen), `packages/shared-types/` (Zod frozen), `packages/ui/`, `packages/functions/`.
- `schemas/*.surql` — SurrealDB schema blueprints (5 files).
- `scripts/` — operational scripts.

---

## Pointers for the foundation grill

Start here:
1. Read `CONTEXT.md` (legacy glossary) alongside `conductor/context.md` (v2.1 seed).
2. Read `conductor-snapshot/decisions.md` for the most recent decision log entries.
3. Read `conductor-snapshot/tracks.md` for the operational state (most current of the legacy docs).
4. Walk `adr-source/` 0001 → 0011 and triage.
5. Use `types/README.md` (if present) + the SurrealDB schemas in `DittoDatto-old/schemas/` for entity verification.

Open contradictions to resolve are listed in `conductor/context.md` → "Notes / Open Questions for the Foundation Grill."
