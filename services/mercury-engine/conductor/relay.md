# Relay — MercuryEngine Cross-Session Handoff

Timestamped entries for context continuity between sessions on the MercuryEngine microservice.

---

## 2026-05-28 14:52 (Child Conductor Scaffolding — Checkpoint)

- **Session:** Scaffolding the Linked Child Conductor for `services/mercury-engine/` (Hermes on Antigravity, Gemini 3.5 Flash).
- **Tracks touched:** None yet.
- **Status:** **Child conductor online and linked.**
  - Index links point to parent for dynamic access to canonical `context.md` (Glossary) and `adr/` (ADR Directory).
  - Scoped `project-context.md` locked to the Python/FastAPI/SurrealDB 3.0 tech stack.
  - Strict Python TDD `workflow.md` written, enforcing Ruff linting and Pytest coverage.
  - Copy-pasted `general.md` and `python.md` style guides from the parent's directory.
- **Decisions:** Pathway 3 chosen (Linked Federated Conductor model) to keep the backend self-contained and modular while avoiding glossary duplication and tool collisions.
- **Next:** Formulate and write the **MercuryEngine Migration** track (`mercury_migration_20260528`) containing detailed TDD vertical slice phases.

## 2026-05-28 15:44 (Child Conductor Infrastructure — Checkpoint)

- **Session:** Deploying child conductor workflows and agent-rules (Hermes on Antigravity, Claude Opus 4.6 Thinking).
- **Tracks touched:** None (infrastructure session).
- **Status:** **Child conductor fully operational.**
  - `.agents/workflows/` deployed with `conductor-child.md`, `checkpoint.md`, `new-track.md`.
  - Agent-rules installed: Clean Architecture, Refactoring, Release It!, DDD Distilled.
  - First child ADR recorded: `0001-child-conductor-workflow-routing.md`.
- **Decisions:** ADR 0001 — Child workflow routing via per-workspace `.agents/workflows/` for AG 2.0 resolution.
- **Note for TheOracle:** Document the child conductor pattern for future `conductor-init-child` protocol. The current implementation is a DittoDatto-specific edge case that generalizes well.
- **Next:** Grill session to sharpen ME identity, then begin Phase 1 of migration track.

## 2026-05-28 16:53 (Grill — Booking Engine Foundation)

- **Session:** `/grill` booking engine foundation and ecosystem relations (Hermes on Antigravity, Claude Opus 4.6 Thinking).
- **Tracks touched:** None (domain refinement session).
- **Status:** **MercuryEngine identity sharpened. PRD written. 2 child ADRs recorded.**

### Parent Glossary Updates (queue for `/grill` on parent)

| Term | Proposed Change |
|------|----------------|
| **MercuryEngine** | Remove "(V2)". Update definition: "The booking engine for DittoDatto — a focused FastAPI microservice handling hold-to-booking lifecycle across three verticals. Single API server for booking, availability, and JWT validation. Does NOT own entity CRUD, discovery, auth issuance, or platform admin." Versioning starts at 1.0.0. |
| **Company Management** | NEW entity. "Bounded context owning entity CRUD (establishments, services, staff, resources, schedules). Datto's domain. Operators and Datto write entity data; MercuryEngine and Discovery read it via shared kernel. SurrealDB is the integration point." |
| **AvailabilityProbe** | NEW entity. "A read-only exploratory availability query with zero state change. Supports agentic rescheduling — Ditto asks Datto 'what's open?' without creating a Hold. No slot lock, no timer, no commitment." |
| **PaymentGateway** | NEW entity. "Abstract payment processing interface consumed by the booking lifecycle. MockPaymentGateway for 1.0; VippsPaymentGateway for 1.3. Dependency Inversion — booking logic never touches payment implementation details." |

### Parent ADR Candidates (queue for parent conductor)

1. **Platform Auth Separation** — Auth issuance is a platform concern, not a MercuryEngine concern. SurrealDB native auth for internal tools (admin panel). Vipps OIDC only for public/portal surfaces (future, separate bounded context). Partially supersedes ADR-0004 §1 ("MercuryEngine issues JWTs"). MercuryEngine retains 5-tier JWT validation middleware.
2. **Company Management Extraction** — Entity CRUD (establishments, services, staff, resources, schedules) is a separate bounded context from booking. Datto is the Company Management agent. SurrealDB `companies/{slug}` is the shared integration point. No API coupling between contexts.
3. **Admin Panel Permanent Saturn Hosting** — Admin Panel lives on Saturn for both staging and production. Single container, Tailscale-gated, 2-user breaker box. No Cloud Run needed. Local dev = `flutter run` against Saturn's DB. Supersedes any assumption of Cloud Run hosting for the admin panel.

### Child Outputs

- PRD: `conductor/prd.md` — created (MercuryEngine 1.0 scope)
- ADR 0002: `conductor/adr/0002-mercury-engine-scope-booking-only.md` — booking-only scope
- ADR 0003: `conductor/adr/0003-clean-slate-tdd.md` — greenfield tests, no legacy porting

## 2026-05-28 19:15 (Phase 1 Greenfield TDD — Checkpoint)

- **Session:** Setting up environment, mapping dependencies, and completing FastAPI base with JWT role validation middleware under TDD.
- **Tracks touched:** `mercury_migration_20260528`
- **Status:** **Phase 1 complete.** 11/11 tests passed with 100% code coverage.
- **Decisions:** Fast-tracked FastAPI role authorization via Depends dependencies. Swapped local secret key to 32+ bytes to satisfy cryptographic recommended standards. Ignore Ruff B008 for Depends integration.
- **Next:** Proposing architectural ADR for FastAPI Dependency Injection access guards, then beginning Phase 2 (Core models, shared kernel projections).

## 2026-05-29 12:15 (Phases 2-5 & Core 1.0 Booking Engine Launch — Checkpoint)

- **Session:** Implementation of base models, Time Tetris calculators, SurrealDB 3.0 integrations, FastAPI booking/reschedule routes, payment gateways, and Forbrukstilsynet compliance.
- **Tracks touched:** `mercury_migration_20260528`
- **Status:** **Microservice 100% Completed & Verified.** 50/50 tests passed with 91% overall coverage (95% on slot/shift/hold calculators). Fully Ruff-clean and successfully built (`uv build`).
- **Decisions:**
  - **AvailabilityProbe**: Made a read-only query that performs fast in-memory calculations without mutational slot locks or database writing.
  - **SurrealDB Datetimes**: Used timezone-aware UTC datetime values directly as Surreal Datetime elements to enable fast querying.
  - **Self-Healing Event Loop Manager**: Included check in db client provider to refresh clients if pytest-asyncio switches event loops between tests.
  - **Norwegian Compliance**: Rescheduling performs Cancellation (reason: Rescheduled) + Rebooking, storing bidirectional links between old and new booking records.
- **Next:** Re-engage with the parent conductor to integrate the Admin Panel and synchronization tasks.
