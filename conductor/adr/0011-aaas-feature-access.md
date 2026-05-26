# AaaS Over SaaS — Feature Access Philosophy

> **Recorded:** 2026-05-26 (promoted from legacy ADR-0005 Session 2; Firestore cost reference replaced with SurrealDB)
> **Status:** accepted

## Context

The current `Company.enabledFeatures` uses boolean gates:

```python
enabled_features: {
    "tableReservation": bool,
    "aiAssistance": bool,
    "ticketSystem": bool,
    "eventSystem": bool,
}
```

This is SaaS-era thinking:
- Features are **locked by default**, unlocked by admin.
- Businesses **request** access through opaque processes.
- The admin panel is the **gatekeeper** for capabilities.
- Tier-based plans force businesses into rigid buckets.

DittoDatto is an **AaaS** (Agent-as-a-Service) platform. The agent (Datto) mediates feature activation conversationally, not through boolean toggles.

## Decision

### Philosophy: Nothing is locked. Everything has a limit.

No business capability is binary. Instead, capabilities have **usage limits** that scale with the business's needs and metering:

| SaaS (old) | AaaS (new) |
|---|---|
| `ticketSystem: false` — you can't use this | `maxTicketsPerEvent: 100` — you can, with guardrails |
| "Upgrade to Premium to unlock events" | "Sure, I'll set up your event. First 2/month are included." |
| Admin flips toggle in Panel | Datto adjusts limits conversationally |
| Rigid tier boundaries | Pay-per-use scaling |

### v1.0 (transitional)

`enabledFeatures` stays as-is but is explicitly marked as **transitional scaffolding**. It will be replaced by `usagePolicy` when Datto ships (v1.5).

For v1.0, the gates are pragmatic:
- Prevents free-tier abuse (SurrealDB instance cost control).
- Admin Panel can manage them manually (ADR-0006).
- No user-facing "upgrade to unlock" friction — features just aren't surfaced until admin activates.

### v1.5+ (target state)

```python
# Replaces enabled_features:
usage_policy: {
    "maxEventsPerMonth": 2,
    "maxTicketsPerEvent": 100,
    "maxServices": 20,
    "maxStaff": 5,
    "maxStores": 1,
    "meteringTier": "free" | "growth" | "scale",
}
```

Datto adjusts these limits dynamically based on business requests. Metering tracks actual usage and feeds billing.

### Admin Panel Evolution

The Admin Panel transitions from **gatekeeper** to **read-only monitor**:

| Phase | Panel Role |
|---|---|
| v1.0 | Feature gates + company creation + user management |
| v1.5 | Monitoring dashboard + override controls (break-glass only) |
| v2.0 | Engine room window — logs, metrics, system health. Rarely touched. |

## Consequences

- **v1.0:** No code change. `enabledFeatures` is transitional, documented as such.
- **v1.5:** Replace `enabledFeatures` with `usagePolicy`. Build Datto-mediated activation flow.
- **Schema docs:** `Company.enabledFeatures` flagged as transitional in `services/mercury-engine/src/mercury_core/models/company.py`.
- **Cultural shift:** DittoDatto doesn't sell tiers. It sells capabilities on demand.

## Open Questions (parked for v1.5 track)

- Pricing model: flat + usage overage? Pure usage-based? Freemium with generous defaults?
- How does Datto communicate pricing to business owners? In-chat? Notification?
- What happens when a limit is exceeded mid-month? Hard stop or soft warning + grace period?

---

*Origin: Session 2 Grill. Promoted into canonical conductor/adr/ during /grill foundation 2026-05-26 — Firestore cost reference replaced with SurrealDB.*
