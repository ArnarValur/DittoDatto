# Admin & Super-Admin Middleware Tier Expansion

> **Recorded:** 2026-05-26 (new — /grill foundation, stub form)
> **Status:** accepted

## Context

Canonical ADR-0004 defines three base middleware tiers: `public`, `require_auth`, `require_operator`. The Admin Panel (ADR-0006, originally legacy 0011) and the engine admin routes shipped during S15–S20 required two additional tiers — `require_admin` and `require_super_admin` — to gate platform-level operations distinct from company-operator actions.

The 5-tier model is referenced in `project-context.md` §3 (auth pipeline) and exercised by 73 admin tests + 50 auth tests in MercuryEngine, but was never formally captured in an ADR.

## Decision

Extend ADR-0004's middleware tier set with two platform-level tiers:

| Tier | Checks | Typical Endpoints |
|---|---|---|
| `require_admin` | `require_auth` + `role in {"admin", "super_admin"}` | `GET /admin/stats`, `GET /admin/users`, `PUT /admin/users/{id}/role`, category CRUD |
| `require_super_admin` | `require_auth` + `role == "super_admin"` | Company provisioning (`POST /admin/companies` — creates `companies/{slug}` DB + applies blueprint), platform-wide destructive operations, system alert broadcast |

Roles persist in the user record (`users/profiles.role TYPE string` with assertion `['customer', 'business', 'admin', 'super_admin']`). They are claim-mapped during JWT mint.

The Admin Panel (ADR-0006) is the primary client of these tiers. Future tooling (operator-side, agent-side) MAY consume them but should be considered case-by-case.

## Considered Options

| Option | Rejected because |
|---|---|
| Single `require_admin` tier (no super-admin distinction) | Company provisioning is destructive enough that an extra confirmation tier is justified; super-admin gates the orchestration. |
| Role-based ACL on a per-route basis (no middleware) | Inconsistent with the rest of MercuryEngine; middleware tiers are the existing pattern. |
| Defer admin tiers entirely until /grill admin-panel | The tiers already exist in code; an ADR backing them is overdue. The /grill admin-panel session can refine, not invent. |

## Open Questions (deferred to /grill admin-panel)

1. **BankID re-auth for super-admin actions?** — Destructive operations (company provisioning, role escalation, tenant deletion) may warrant a second BankID challenge per session or per action. Currently they don't; deferred to admin-panel grill.
2. **Device restrictions for super-admin?** — Should super-admin sessions be restricted to specific authenticated devices, or is JWT-only sufficient? Currently JWT-only.
3. **Super-admin → operator impersonation?** — Useful for support; risky for audit trail. Deferred.
4. **Audit log requirements for admin/super-admin actions** — currently logs via the `audit_log` table in `companies/registry`. Sufficient depth? Defer.

## Consequences

- The 5-tier middleware set in `project-context.md` §3 is now canonical.
- The Admin Panel (ADR-0006) has a canonical ADR backing its role expansion to `admin` + `super_admin`.
- `/grill admin-panel` will refine the open questions above (re-auth, device restrictions, impersonation, audit).
- ADR-0004's request flow extends:

```
Admin:        Request → require_auth → require_admin → handler → db.use(companies, registry-or-target)
Super-Admin:  Request → require_auth → require_super_admin → handler → orchestrated DB ops
```

---

*Origin: Inferred from project-context.md §3 + ADR-0011 §7 + MercuryEngine test counts (S15–S20 evolution). Captured as a slim stub during /grill foundation 2026-05-26 with deeper grilling deferred to /grill admin-panel.*
