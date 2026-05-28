# Grill Strategy: DittoDatto Fresh Start

> Hermes's recommendation for sequencing `/conductor-init` + `/grill` sessions.

---

## TL;DR — Go with Option 2 (Foundation-First)

Your instinct about Option 2 is correct. Here's why:

| Approach | Risk |
|---|---|
| ❌ Option 1: Init → Grill Admin → Grill Business → Grill Marketplace | Surface-level grills without shared foundation. Each session reinvents shared concepts (auth tiers, MercuryEngine boundaries, SurrealDB namespace model). Glossary drift between sessions. |
| ✅ **Option 2: Init → Grill Foundation → Grill per-surface** | Foundation grill locks the shared domain model, then each surface grill is scoped and fast. ADRs from foundation carry into surface sessions. |

---

## The Disruption Problem

Your old conductor is **v2.0-era** with a solid but 3-week-stale state. Key things that need re-grilling:

1. **Hardware shift** — Saturn arrived (or is arriving). The infra story changed.
2. **Platform maturity** — MercuryEngine V2 has 377 tests, admin panel is functional. You're past "scaffold" and into "real product decisions."
3. **Chapter 1 → Chapter 2 boundary** — The old conductor still references Chapter 1 Nuxt apps as "frozen." A fresh init should treat them as **archived context**, not active tracks.
4. **ADR currency** — 11 ADRs exist but some may need revision (especially 0010-auth and 0011-flutter-admin given 3 weeks of evolution).

### Doc Health Audit (from deep dive)

| Document | Status | Issue |
|---|---|---|
| [CONTEXT.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/.docs/CONTEXT.md) | 🟢 **Most authoritative** | Best glossary discipline. Still says Admin Panel = "Nuxt web, no migration planned" — **contradicts reality** (it's Flutter now). |
| [tracks.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/tracks.md) | 🟢 **Current** | Accurately reflects S20 state. 377 tests. Best operational doc. |
| [tech-stack.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/tech-stack.md) | 🟡 **Mostly current** | Post-migration, but still lists Admin Panel under "Web Frontend (Legacy)" when it's actually Flutter now. |
| [product.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/product.md) | 🟢 **Solid** | Concise, aligned with Chapter 2. |
| [vision.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/vision.md) | 🟡 **Stale on surfaces** | Says Admin Panel = "Nuxt web" — it's Flutter. Business Portal listed as "Flutter if demand" — needs decision. |
| [prd-public-marketplace-v1.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/.docs/prd-public-marketplace-v1.md) | 🟠 **Partially stale** | Still references Hono/TypeScript backend and 156 tests. Good structure but backend sections need refresh. |
| [WAYMAP.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/.docs/WAYMAP.md) | 🔴 **20 sessions behind** | Shows S12-S15 as "not started" when they're all done. Missing ADRs 0010-0011. Bookshelf index is stale. |
| [agent-profile.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/agent-profile.md) | 🟡 **Slightly stale** | References 249 tests (now 377). Last session logged is S16. |
| [decisions.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/decisions.md) | 🟡 **Index only** | Doesn't cover S18-S20 decisions inline. |

> [!CAUTION]
> **Critical contradiction**: vision.md and CONTEXT.md both say Admin Panel = "Nuxt web, no migration planned." But `apps/admin/` is a **fully built Flutter app** (Dashboard, Users, Companies, Categories screens — all done in S19-S20). The foundation grill **must** resolve this — update the canonical docs to match reality.

---

## Recommended Session Order

### Session 0: Preparation (Before Cursor)

Copy the following docs from `DittoDatto-old/` to wherever you want the new project root. These are your **input material**:

**Tier 1 — Must bring (core identity + domain model):**

| Source | Purpose |
|---|---|
| [conductor/product.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/product.md) | Product definition |
| [conductor/vision.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/vision.md) | Vision & thesis |
| [conductor/tech-stack.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/tech-stack.md) | Tech decisions |
| [conductor/tracks.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/tracks.md) | Progress history (most current doc) |
| [conductor/decisions.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/decisions.md) | Decision log |
| [.docs/CONTEXT.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/.docs/CONTEXT.md) | Domain glossary (most authoritative doc) |
| `.docs/adr/` (all 11 files) | Architectural decisions |
| `schemas/*.surql` (4 files) | SurrealDB schema definitions |

**Tier 2 — Should bring (reference material):**

| Source | Purpose |
|---|---|
| [.docs/prd-public-marketplace-v1.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/.docs/prd-public-marketplace-v1.md) | PRD for marketplace (partially stale — references Hono/TS backend) |
| [conductor/BOOKING_ENGINE.md](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/conductor/BOOKING_ENGINE.md) | Engine deep-dive |
| `.docs/types/` (32 type specs) | Domain type reference — `booking.md`, `service.md`, `staff-member.md`, etc. |
| `.docs/engine/` (10 files) | MercuryEngine architecture, booking flow, time-tetris, verticals |

**Tier 3 — Nice-to-have (concepts & history):**

| Source | Purpose |
|---|---|
| `.docs/postit/saturn-local-stack.md` | Saturn Day-1 Docker Compose blueprint |
| `.docs/postit/bankid-vipps-auth.md` | BankID/Vipps OIDC architecture notes |
| `.docs/postit/dittobar-ux.md` | DittoBar A2UI concept |
| `.docs/walkthroughs/` (8 session docs) | Grill session transcripts (S7-S20) |

> [!TIP]
> Place these in a `.docs/legacy/` or `.docs/input/` folder in the new project root so conductor-init's brownfield scan can discover them.

> [!WARNING]
> **Do NOT bring WAYMAP.md** — it's 20 sessions behind reality and will confuse the brownfield scanner. Let the new conductor build its own session map from the actual ADRs and tracks.

---

### Session 1: `/conductor-init` (Brownfield)

**Goal:** Scaffold v2.1 conductor with the new project identity.

**Key inputs to provide during the interactive grill:**
- **Project identity:** DittoDatto — Agentic Commerce Platform for Norway
- **Brownfield:** Yes — point it at the docs you copied
- **Tech stack:** Flutter (Dart) + Python (FastAPI/Pydantic) + SurrealDB 3.0
- **Workflow mode:** Your preference (likely `track-based` given the multi-surface structure)

**Expected output:** Fresh `conductor/` with `project-context.md`, `context.md` (pre-populated from brownfield scan), `tech-stack.md`, `code_styleguides/`, and lazy `adr/` + `docs/` directories.

**Estimated quota cost:** Moderate — mostly interactive Q&A.

---

### Session 2: `/grill` — Foundation Domain

**Goal:** Lock the shared domain model that ALL surfaces depend on.

**Focus areas for this grill:**

1. **Resolve contradictions first** (these are concrete, not abstract):
   - Admin Panel is Flutter (`apps/admin/`) in reality but "Nuxt web, no migration planned" in vision.md and CONTEXT.md → **update docs to match code**
   - Marketplace PRD references Hono/TypeScript/156 tests → backend is now Python/FastAPI/377 tests → **refresh or flag as stale**
   - WAYMAP is 20 sessions behind → **kill it or rebuild it**

2. **Domain glossary refinement:**
   - Establishment vs. Company vs. Business (inconsistent in old docs)
   - Booking vs. Reservation vs. Ticket (MercuryEngine's three modes)
   - Ditto (consumer agent) vs. Datto (business agent) — clear boundary
   - DittoBar (search UI) vs. Discovery (engine concept)
   - Use the 32 type specs in `.docs/types/` as glossary seed material

3. **Architecture decisions to re-validate:**
   - Auth model: Firebase Auth "on probation" vs. SurrealDB native auth — what's the current stance?
   - SurrealDB namespace model (titan/enceladus) — still correct?
   - MercuryEngine V2 API boundary — what's internal vs. public?
   - Saturn deployment model — Docker Compose? Dome? Cloud Run? (postit `saturn-local-stack.md` has a blueprint)

4. **ADR triage:**
   - Which of the 11 ADRs are still valid?
   - Which need revision? (ADR-0011 likely needs update — Flutter admin is now built, not planned)
   - Any new ADRs needed? (e.g., "Flutter-only mobile strategy", "Saturn deployment architecture")

5. **Surface inventory — nail the current truth:**

| Surface | Chapter 1 (Frozen) | Chapter 2 (Active) | PRD exists? |
|---|---|---|---|
| Admin Panel | `apps/web/admin-panel/` (Nuxt) | `apps/admin/` (Flutter) ✅ Built | ❌ No (only ADR-0011) |
| Business Portal | `apps/web/business-portal/` (Nuxt) | None yet | ❌ No |
| Public Marketplace | `apps/web/public-marketplace/` (Nuxt) | `apps/marketplace/` (Flutter, scaffold only) | ✅ Yes (stale) |
| MercuryEngine | `packages/mercury-engine/` (Hono/TS) | `services/mercury-engine/` (FastAPI/Python) ✅ Built | N/A (engine docs in `.docs/engine/`) |

**Expected output:** Sharpened glossary, batch of ADR proposals (accept/revise/supersede), surface inventory locked, PRD gap analysis.

**Estimated quota cost:** Heavy — this is the meatiest session. Budget ~40-50% of your remaining quota here.

---

### Session 3: `/grill` — Admin Panel

**Goal:** Refine the admin panel domain now that the foundation is locked.

**Focus areas:**
- Screen inventory: Dashboard, Users, Companies, Categories — what's next?
- Role model: ADMIN vs. SUPER_ADMIN — sufficient or needs refinement?
- Platform operations: What does the admin actually need to DO day-to-day?
- Monitoring & observability: Booking health, demand signals, system status

**Expected output:** ADR proposals for admin-specific decisions, possibly a lightweight PRD.

**Estimated quota cost:** Light-to-moderate.

---

### Session 4: `/grill` — Public Marketplace

**Goal:** Validate and sharpen the marketplace PRD.

**Focus areas:**
- v1.0 tracer bullet scope — still the right cut?
- Auth flow (BankID/Vipps OIDC) — any updates?
- Home + Map + DittoBar — interaction model
- Booking flow UX — Slots → Hold → Confirm
- Profile & history — what's in v1.0 vs. v1.1?

**Expected output:** Revised PRD, ADR proposals for marketplace-specific decisions.

**Estimated quota cost:** Moderate.

---

### Session 5 (Optional): `/grill` — Business Portal

**Goal:** Define the business portal from scratch (no PRD exists yet).

> [!WARNING]
> The old vision says Business Portal was "Nuxt web (Chapter 1 frozen)" with "Flutter if demand" later. This needs a clear decision: **Is Business Portal being rebuilt in Flutter, staying as Nuxt, or going web-first with a different framework?** This is a grill-worthy question.

**Expected output:** First PRD draft, architecture decisions.

**Estimated quota cost:** Moderate-to-heavy (greenfield definition).

---

## Quota Budget Estimate

| Session | Estimated Cost | Priority |
|---|---|---|
| Session 1: conductor-init | 15% | Must-have |
| Session 2: Foundation grill | 40% | Must-have |
| Session 3: Admin panel grill | 15% | Should-have |
| Session 4: Marketplace grill | 20% | Should-have |
| Session 5: Business portal grill | 10% | Nice-to-have |

> [!IMPORTANT]
> If quota gets tight, **skip Session 5** (Business Portal). It's the least urgent since there's no active development there yet. You can grill it later in Antigravity when you come back.

---

## Pro Tips for the Cursor Sessions

1. **Start each grill by pasting the relevant old docs** as context. Don't assume the agent remembers.
2. **Name your sessions** clearly: "Foundation Grill", "Admin Panel Grill", etc.
3. **At the end of each grill**, ask the agent to summarize all ADR proposals and glossary changes in a single commit-ready batch.
4. **Save the raw grill transcripts** — they're valuable domain knowledge even if the ADRs capture the decisions.
5. **Don't re-grill what's settled** — the 11 existing ADRs represent hard-won decisions. Validate them, don't re-debate them unless something actually changed.
6. **Feed contradictions explicitly** — Tell the agent: "CONTEXT.md says Admin Panel is Nuxt. It's actually Flutter now. Fix the glossary." Don't let it discover this on its own.
7. **Carry the `.docs/types/` directory** — Those 32 type specs are goldmine seed material for the glossary. Point the grill at them.
8. **Kill the WAYMAP** — It's 20 sessions behind. Don't try to update it. Let the new conductor's session tracking replace it.

---

## When You Come Back to Antigravity

Once the grill sessions are done in Cursor and the new conductor is scaffolded, bring it back here and I'll:
- Review the new `conductor/` for consistency
- Validate ADR coherence
- Help set up tracks for the next sprint
- Run any brownfield scans you didn't have time for
