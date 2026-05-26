---
title: "MercuryEngine — Bookshelf"
type: "reference"
status: "living"
date: "2026-05-02"
domain: "MercuryEngine"
tags:
  - "engine"
  - "bookshelf"
  - "index"
---

# 🚀 MercuryEngine — Bookshelf

> The booking engine microservice for DittoDatto. This bookshelf is the single source of truth for understanding, developing, and operating MercuryEngine.

**Version:** 0.2.0  
**Runtime:** Node.js ≥22, Hono HTTP framework  
**Deployment:** Cloud Run (Docker)  
**Port:** 5002  
**Package:** `@dittodatto/mercury-engine`

## 📚 Bookshelf Index

| Document | Purpose |
|----------|---------|
| [Architecture](./architecture.md) | System design, module map, mermaid diagrams |
| [API Contract](./api-contract.md) | Every endpoint, payload, auth requirement |
| [Booking Flow](./booking-flow.md) | The 5-phase lifecycle: Search → Hold → Pay → Confirm → Cancel |
| [Time Tetris](./time-tetris.md) | Slot calculation algorithm deep-dive |
| [Known Issues](./known-issues.md) | Active bugs and technical debt |

### Booking Verticals

| Document | Pattern | Status |
|----------|---------|--------|
| [Standard Bookings](./vertical-standard.md) | 1:1 — one customer, one slot | ✅ Production |
| [Table Reservations](./vertical-reservations.md) | 1:N — one table, many guests | ✅ Production |
| [Event Ticketing](./vertical-tickets.md) | N:1 — many customers, one event | 🟡 Scaffold |

### Reviews & Analysis

| Document | Purpose |
|----------|---------|
| [Engine Verdict](./verdict.md) | Session 3 audit — strengths, Noona comparison, gap analysis, recommendations |

## Quick Links

- **Source:** [`packages/mercury-engine/src/`](file:///media/addinator/Mercury/Projects/DittoDatto/packages/mercury-engine/src)
- **Tests:** [`packages/mercury-engine/tests/`](file:///media/addinator/Mercury/Projects/DittoDatto/packages/mercury-engine/tests) (156 tests, <1s)
- **Dev Guide:** [`packages/mercury-engine/DEVELOPMENT.md`](file:///media/addinator/Mercury/Projects/DittoDatto/packages/mercury-engine/DEVELOPMENT.md)
- **Shared Types:** [`packages/shared-types/src/`](file:///media/addinator/Mercury/Projects/DittoDatto/packages/shared-types/src)
- **ADRs:** [`.docs/adr/`](file:///media/addinator/Mercury/Projects/DittoDatto/.docs/adr)

## Commands

```bash
# From packages/mercury-engine/
npm run dev          # tsx watch → localhost:5002
npm run test         # vitest run (156 tests, <1s)
npm run build        # esbuild → dist/
npm run start        # production server
```

---

*Created: 2026-05-02 — Session 3 Grill*
