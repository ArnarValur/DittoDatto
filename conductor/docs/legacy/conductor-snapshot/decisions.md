# Decision Log

Architectural and design decisions made during sessions. For full ADRs, see `.docs/adr/`.

**Last Updated:** 2026-05-05

---

## 2026-05-05 — Post-S16.5 Grill: Flutter Admin Panel

**ADR:** [ADR-0011](../.docs/adr/0011-flutter-admin-panel.md)

| # | Decision | Outcome |
|---|----------|---------|
| 1 | App identity | Platform super-admin tool (Captain / Merkurial Studio) |
| 2 | Scope | Login, Dashboard, Users, Companies, Categories, Inbox (stub). 5 screens. |
| 3 | Monorepo location | `apps/admin/` — clean break from web era |
| 4 | Platform target | Android-first (LineageOS tablet), desktop + web as freebies |
| 5 | API connection | Runtime config with presets. SSID auto-detect deferred to v1.1 |
| 6 | State management | Riverpod |
| 7 | Auth flow | Extend dev-login with `ADMIN`/`SUPER_ADMIN` roles. Biometric re-auth via `local_auth`. |
| 8 | UI toolkit | Material 3 dark + data table package. `#6f71cc` Moody Blue primary. |
| 9 | Package architecture | `packages/mercury_client/` shared Dart package from day one. All 3 Flutter apps consume it. |
| 10 | Execution strategy | Engine admin routes first (S18), then Flutter scaffold + shared package (S19), then screens (S20). No mock data. |

---

## 2026-05-05 — Session 16.5: Auth Wiring + Dogfooding Strategy

**Dogfooding decision (Captain + Höddi):** Saturn staging will run **two real companies** — Merkurial Studio (`merkurial-studio`) and DittoDatto (`dittodatto`) — as full tenant simulations. Everything offered in production must first be battle-tested internally on Saturn. Dev seed user: `arnar@merkurial-studio.com` / `merkurial-studio`.

---

## 2026-05-05 — Session 14 Part 1: Auth Architecture Grill

**ADR:** [ADR-0010](../.docs/adr/0010-auth-architecture.md)

| # | Decision | Outcome | Rationale |
|---|----------|---------|-----------|
| 1 | JWT ownership | MercuryEngine as issuer | Single owner of auth logic. Vipps OIDC exchange requires app layer. No split-brain. |
| 2 | Identity tiers | Operators = BankID, Consumers = guest, Agents = JWT | Three-tier model. Less is more for v1.0. |
| 3 | NIN storage | Don't store | Minimal PII. `vipps_sub` sufficient. Less GDPR liability. |
| 4 | Agent auth | JWT with `role: agent` claim | Same middleware pipeline for all actors. |
| 5 | Company context | Path parameter + JWT validation | RESTful, debuggable, Swagger-friendly. `db.use()` per request. |
| 6 | JWT claims | Operators + agents only. Guests = no JWT. | Clean pipeline: token present = authenticated. |
| 7 | Middleware tiers | `public` / `require_auth` / `require_operator` | Three flat tiers + `company_access` guard. |
| 8 | Portal auth | Vipps OIDC + dev-only bypass | One integration. Dev bypass gated by environment flag. |

---

## 2026-05-05 — Session 11: Python Migration Grill

**Walkthrough:** [`.docs/walkthroughs/session-11-python-migration-grill.md`](../.docs/walkthroughs/session-11-python-migration-grill.md)

| Decision | Outcome |
|----------|---------|
| Platform language | Python (TypeScript OUT) |
| Web framework | FastAPI |
| Validation | Pydantic v2 |
| Database | SurrealDB (sole DB) |
| Package manager | uv |

---
