---
title: "MercuryEngine — Known Issues & Tech Debt"
type: "reference"
status: "living"
date: "2026-05-02"
session: 3
domain: "MercuryEngine"
tags:
  - "bugs"
  - "tech-debt"
  - "issues"
---

# MercuryEngine — Known Issues & Tech Debt

> Active bugs, deferred improvements, and technical debt tracked from grill sessions.

## 🔴 P1 — Critical

| Issue | Location | Description | Status |
|-------|----------|-------------|--------|
| Service→ResourceGroup cross-group leak | `core/reservations/calculator.ts` | Reservation calculator may leak resources across service groups. Table from "Private Dining" could be assigned to "Main Dining" service. | Open — surgical fix needed |

## 🟡 P2 — Important

| Issue | Location | Description | Status |
|-------|----------|-------------|--------|
| ~~No centralized error classes~~ | `core/shared/errors.ts` | ~~Errors were scattered across modules~~ | ✅ Fixed — `HttpsError` class centralized |
| ~~Route error handling inconsistent~~ | `routes/` | ~~String match vs error code in different routes~~ | ✅ Fixed — global `errorHandler` middleware |
| Ticketing routes are stubs | `routes/ticketing.ts` | All 5 endpoints return placeholder responses. No core logic. | Deferred — v1.4+ |
| `personId` → `staffId` migration | shared-types + engine | Legacy field naming | ✅ **Completed** (Session 3, 2026-05-02) |
| `Experience` is legacy (Noona) | `reservation.ts`, `availability.ts` | Experience concept replaced by Services with `bookingMode: 'tableReservation'` (ADR-0004). Engine falls back to store hours when none exist. Remove `ExperienceSchema` + experience fetch in availability.ts | Open — cleanup session |

## 🟢 P3 — Cleanup

| Issue | Location | Description | Status |
|-------|----------|-------------|--------|
| ~~Debug console.log~~ | `routes/reservations.ts:69` | Leftover debug log | Verify — may have been cleaned |
| Bundle files stale | `src-bundle.txt`, `src-bundle-full.txt` | Generated text bundles contain pre-rename `personId` code. Regenerate after rename. | Open |
| `service.ts` legacy `staffId` field | `shared-types/src/service.ts` | The legacy single-staff field coexists with `assignedStaff[]`. Remove when Phase 4 migration is complete. | Deferred |

## 📋 Future Enhancements (from grill sessions)

| Feature | Priority | Notes |
|---------|----------|-------|
| DittoBar search endpoint | Session 3 | Server-side search for the demand harvester |
| BankID auth flow | Session 3 | Flutter-native BankID verification |
| Rebook endpoint | v1.0 | Atomic cancel-old + hold-new transaction |
| Waitlist | v1.5 | Notify waiting customers on cancellation |
| Multi-store bookings | Deferred | Currently enforced: single-store per booking |
| Agentic booking API | v1.5 | Saturn agent harness integration |

---

*Created: 2026-05-02 — Session 3 Grill*  
*Last updated: 2026-05-02*
