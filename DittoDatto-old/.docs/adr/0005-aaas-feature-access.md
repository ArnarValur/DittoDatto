---
title: "ADR-0005: AaaS Over SaaS — Feature Access Philosophy"
type: "adr"
status: "accepted"
date: "2026-05-02"
session: 2
domain: "Platform"
tags:
  - "aaas"
  - "feature-flags"
  - "datto"
  - "vision"
---

# ADR-0005: AaaS Over SaaS — Feature Access Philosophy

## Problem

The current `Company.enabledFeatures` uses boolean gates:

```typescript
enabledFeatures: {
  tableReservation: z.boolean().default(false),
  aiAssistance: z.boolean().default(false),
  ticketSystem: z.boolean().default(false),
  eventSystem: z.boolean().default(false),
}
```

This is SaaS-era thinking:
- Features are **locked by default**, unlocked by admin
- Businesses must **request** access through opaque processes
- The admin panel is the **gatekeeper** for capabilities
- Tier-based plans ("Basic: appointments only, Premium: + events + tickets") force businesses into rigid buckets

DittoDatto is an **AaaS** (Agent-as-a-Service) platform. The agent (Datto) should mediate feature activation conversationally, not through boolean toggles.

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
- Prevents free-tier abuse (Firestore cost control)
- Admin Panel can manage them manually
- No user-facing "upgrade to unlock" friction — features just aren't surfaced until admin activates

### v1.5+ (target state)

```typescript
// Replaces enabledFeatures:
usagePolicy: {
  maxEventsPerMonth: z.number().int().default(2),
  maxTicketsPerEvent: z.number().int().default(100),
  maxServices: z.number().int().default(20),
  maxStaff: z.number().int().default(5),
  maxStores: z.number().int().default(1),
  meteringTier: z.enum(["free", "growth", "scale"]).default("free"),
}
```

Datto adjusts these limits dynamically based on business requests. Metering tracks actual usage and feeds billing.

### Admin Panel evolution

The Admin Panel transitions from **gatekeeper** to **read-only monitor**:

| Phase | Panel Role |
|---|---|
| v1.0 | Feature gates + company creation + user management |
| v1.5 | Monitoring dashboard + override controls (break-glass only) |
| v2.0 | Engine room window — logs, metrics, system health. Rarely touched. |

## Consequences

- **v1.0:** No code change. `enabledFeatures` is transitional, documented as such.
- **v1.5:** Replace `enabledFeatures` with `usagePolicy`. Build Datto-mediated activation flow.
- **Schema docs:** `Company.enabledFeatures` flagged as transitional in `.docs/types/company.md`
- **Cultural shift:** DittoDatto doesn't sell tiers. It sells capabilities on demand.

## Open Questions (parked for v1.5 track)

- Pricing model: flat + usage overage? Pure usage-based? Freemium with generous defaults?
- How does Datto communicate pricing to business owners? In-chat? Notification?
- What happens when a limit is exceeded mid-month? Hard stop or soft warning + grace period?
