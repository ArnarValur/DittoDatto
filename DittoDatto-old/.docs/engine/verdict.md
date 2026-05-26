---
title: "MercuryEngine — Commander's Verdict"
type: "reference"
status: "complete"
date: "2026-05-02"
session: 3
domain: "MercuryEngine"
tags:
  - "audit"
  - "verdict"
  - "noona-comparison"
---

# MercuryEngine — Commander's Verdict

## Overall Assessment: ✅ Sound

MercuryEngine is a well-built, well-tested booking spine. After auditing every module, route, schema, and test — my verdict is that it's architecturally sound for its intended scope.

## What It Gets Right

### 1. Pure Core / Thin Shell
The most important architectural decision. Business logic (`core/`) is isolated from HTTP concerns (`routes/`). This means:
- Calculator, hold allocation, and booking logic are testable without HTTP
- Routes are thin dispatchers — they validate input, call core, format output
- The same core logic works regardless of transport (REST today, gRPC tomorrow, agent function calls next week)

### 2. Concurrency Model
The three-level concurrency model (staff → resource → store) is unusually sophisticated for a young engine. The granular Firestore transaction locking — where Table 1's reservation doesn't block Table 2 — is exactly right. Most booking engines lock at the store level and create needless contention.

### 3. Snapshot Pattern (Fiscal Compliance)
Copying price, duration, and customer data at booking time is critical for Norwegian fiscal compliance. Price changes never affect historical bookings. This is something many booking engines get wrong and have to fix in production.

### 4. Composite Hold Key
`{storeId}_{date}_{slotTime}_{staffId|resourceId|userId}` — elegant. Provides both idempotency and parallel booking capability in one design.

### 5. Test Coverage
156 tests in <1 second. Every path through the calculator, hold, booking, and availability logic is covered. The test fixtures are realistic, not toy data.

### 6. Three Booking Verticals
Standard (1:1), Reservations (1:N), Tickets (N:1) — covering the full spectrum. The fact that they share utility modules (`time.ts`, `errors.ts`, `availability-context.ts`) while having distinct core logic is the right balance.

## What Noona Has That We Could Learn From

After auditing Noona's API (40+ resource categories), here are the features worth considering — **ordered by agentic value** (how much they help Ditto/Datto):

### 🟢 Worth Stealing (v1.x roadmap)

| Feature | Noona's Approach | Our Opportunity | Agentic Value |
|---------|-----------------|-----------------|---------------|
| **Waitlists** | CRUD on waitlist entries per company | When a slot is full, Ditto says "I'll watch for cancellations and book you in automatically" | 🔥 HIGH — this is a Ditto killer feature |
| **Booking Offers** | System suggests slots to users | Engine proposes "here are 3 times that work for you + your preferred staff" | 🔥 HIGH — Ditto can proactively offer |
| **Blocked Times** | CRUD on staff unavailability blocks | Staff marks lunch break, vacation, personal time → engine excludes from availability | ✅ MEDIUM — essential for real scheduling |
| **Webhooks** | Event-driven notifications on booking CRUD | When a booking changes → notify Datto → Datto notifies staff | ✅ MEDIUM — agent orchestration backbone |
| **Reminders** | Push + SMS reminders before appointments | Ditto reminds customer, Datto reminds staff | ✅ MEDIUM — reduces no-shows |

### 🟡 Nice But Not Now (v2+)

| Feature | Notes |
|---------|-------|
| **Recurring Appointments** | Series booking (weekly haircut). Useful but complex — need cancelation propagation |
| **Vouchers / Gift Cards** | Promotional system. Business value but not core engine |
| **Product Catalog** | Retail add-on sales (shampoo at checkout). Portal feature, not engine |
| **Goals / Metrics** | Business analytics dashboard. Portal + Datto territory |
| **Rule Sets** | Automation rules ("if booking cancelled, send SMS"). Nice but n8n can do this |
| **Settlements / Fiscalization** | Payment reconciliation. Depends on Vipps integration |

### 🔴 Not Needed (We Do It Better)

| Feature | Why We Skip |
|---------|-------------|
| **Experiences** | ✅ Already deprecated — Services with bookingMode replace this |
| **Spaces** | Noona's concept of bookable rooms — we have Resources (more general) |
| **Event Type Category Groups → Event Type Categories → Event Types** | Noona's 3-level hierarchy is over-engineered. Our Services + ServiceGroups is simpler |
| **Custom Properties** | Schemaless extension fields. We use Zod schemas with explicit typing |
| **App Store / OAuth Applications** | Platform play for third-party integrations. Not our model |

## The Gap Analysis — What's Missing

After this full audit, here are the actual gaps in MercuryEngine:

### 1. Blocked Times (P1 for real usage)
Staff can't currently mark themselves as unavailable mid-day. The engine checks shifts from `openingSchedule`, but there's no concept of "lunch break 12-13" or "vacation next week." This will surface immediately when real businesses use the system.

**Recommendation:** Add `blockedTimes` subcollection under staff. The availability calculator already checks shifts — add a secondary exclusion pass.

### 2. Waitlist (P1 for agentic)
When a slot is unavailable, the customer gets a dead end. With a waitlist, Ditto can say: *"That slot's booked, but I'll grab it if someone cancels."* This is the highest-value agent feature.

**Recommendation:** `POST /appointments/waitlist` → create entry. Webhook fires on cancellation → Ditto auto-books from waitlist.

### 3. Booking Offers / Smart Suggestions (P2)
Noona's "Booking Offers" concept is interesting — the system suggests slots to the user. For us, this maps to: *Ditto analyzes your preferences (preferred staff, usual time, typical service) and proactively suggests bookings.*

**Recommendation:** This is TheOracle territory, not MercuryEngine. The Oracle knows demand patterns; the engine just executes.

### 4. Webhooks / Event Bus (P2)
No outbound notifications when bookings change. Critical for agent orchestration — Datto needs to know when bookings are created/cancelled to update the business owner.

**Recommendation:** Firestore triggers (Cloud Functions) that emit events to an event bus. Or: MercuryEngine emits events directly after successful transactions.

## Final Verdict

**MercuryEngine is a sound booking spine.** It handles the hard problems correctly (concurrency, fiscal compliance, multi-vertical support) and avoids Noona's over-engineering (3-level type hierarchies, Experience concept).

The two items I'd prioritize before Saturn testing:
1. **Blocked Times** — without this, real schedule testing will fail immediately
2. **Waitlist skeleton** — even just the data model, so the agent integration has a target

Everything else can be built incrementally as the agentic system demands it.

🖖
