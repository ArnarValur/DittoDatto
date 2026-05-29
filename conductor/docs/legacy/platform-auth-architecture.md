# Platform Auth Architecture — Discovery Notes

> **Date:** 2026-05-28
> **Context:** Session discussing admin panel access model → surfaced a foundational architectural question.
> **Status:** Unresolved — requires grilling before further implementation.
> **Participants:** Arnar Valur, Hermes (Conductor)

---

## The Question

> Should platform authentication be handled by MercuryEngine, which is our booking engine?

This question arose while discussing how Arnar and Höddi would access the admin panel. The current ADR-0004 states "MercuryEngine issues JWTs" — but first-principles analysis suggests this coupling is wrong.

---

## The Insight

**Platform auth is a cross-cutting concern. It does not belong in the booking engine.**

MercuryEngine's reason to exist is booking, discovery, and CRUD. Auth is consumed by every surface:

| Surface | Needs auth? | Needs booking? |
|---------|-------------|----------------|
| Admin Panel | ✅ | ❌ |
| Business Portal | ✅ | ✅ |
| Public Marketplace (`dittodatto.no`) | ✅ | ✅ |
| Future agent services (Ditto/Datto) | ✅ | ✅ |

Auth and booking have **different consumers, different change frequencies, and different failure domains.** If MercuryEngine goes down, the admin panel — the very tool you'd use to diagnose the problem — becomes inaccessible because it can't authenticate.

---

## ADR-0004 Flaw

ADR-0004 ("Auth & Identity Model") states:

> "MercuryEngine issues JWTs."

This conflates two responsibilities:

1. **Token issuance** (identity) — "who is this person?"
2. **Token validation** (authorization middleware) — "can this person do this action?"

MercuryEngine should **validate** tokens (its 5-tier middleware: `public` / `require_auth` / `require_operator` / `require_admin` / `require_super_admin`). But it should not be the authority that **issues** them.

### What should issue tokens?

SurrealDB already has native identity management:

- `DEFINE ACCESS ... TYPE RECORD` — defines authentication rules per table
- `SIGNIN` / `SIGNUP` — native auth endpoints
- Built-in bcrypt password hashing
- Native JWT issuance with configurable claims and expiry
- Record-level access control (row-level security)

The platform database is already the source of truth for user records. Having it also handle identity verification is architecturally clean — no unnecessary middleman.

### The separation

| Concern | Owner | Notes |
|---------|-------|-------|
| **Identity store** (user records, passwords) | SurrealDB | Already the case — `users/profiles` namespace |
| **Token issuance** (SIGNIN → JWT) | SurrealDB native auth (or a thin auth gateway if needed for BankID/Vipps OIDC) | Not MercuryEngine |
| **Token validation** (middleware) | Each service validates JWTs independently | MercuryEngine validates for booking routes. Admin panel validates for admin routes. Each surface owns its own guard. |
| **External identity providers** (BankID, Vipps OIDC) | Dedicated auth gateway / service (future) | Needs its own grill — BankID/Vipps can't route through SurrealDB natively |

---

## Implications

### For the Admin Panel (immediate)

- Admin panel authenticating **directly against SurrealDB** is not a hack — it may be the correct permanent architecture.
- A 2-user breaker box behind Tailscale, talking to the platform DB for identity. Clean, simple, no middlemen.
- The repository interface pattern in `mercury_client` means the auth implementation can be swapped cleanly regardless of what the grill concludes.

### For MercuryEngine (grill input)

- MercuryEngine's scope may need to shrink: it **validates** JWTs but does not **issue** them.
- The 377 existing tests include auth middleware tests — these validate tokens, not issue them, so they likely survive this change.
- The `devLogin` endpoint in MercuryEngine is the one thing that would move elsewhere.
- **This must be resolved before the MercuryEngine grill.** It defines the engine's boundary.

### For BankID/Vipps OIDC (future)

- BankID/Vipps integration is an external identity provider concern.
- It probably needs a thin auth gateway service that:
  1. Handles OIDC flows with BankID/Vipps
  2. Maps external identities to SurrealDB user records
  3. Issues platform JWTs (or delegates to SurrealDB)
- This is a separate bounded context from both booking and admin.

---

## ADR Candidates

These should surface during the MercuryEngine grill:

1. **ADR-00XX: Platform Auth Separation** — Auth issuance is a platform concern, not a MercuryEngine concern. Supersedes the "MercuryEngine issues JWTs" clause in ADR-0004. MercuryEngine retains token validation middleware.

2. **ADR-00XX: SurrealDB-Native Identity for Internal Tools** — Internal tools (admin panel, future ops tooling) authenticate directly against SurrealDB. No booking engine dependency for identity.

3. **ADR-00XX: Auth Gateway for External Identity Providers** — BankID/Vipps OIDC handled by a dedicated auth gateway, separate from MercuryEngine and the admin panel.

---

## Decision: Pause and Grill

**The admin panel track (`admin_panel_20260527`) is paused at the auth boundary.** Phases 1–5 are implemented with mock data. Wiring to real auth requires the platform auth architecture to be settled first.

**Next steps (Arnar's direction):**

1. Initiate MercuryEngine codebase as a new project
2. Grill the booking engine — with auth boundary as a primary input
3. Resolve the platform auth architecture (ADR candidates above)
4. Then return to admin panel: wire real auth, fix SurrealDB on Saturn, deploy

> "This is traffic-infrastructure that needs to get sorted out from all directions before coding anything further." — Arnar, 2026-05-28
