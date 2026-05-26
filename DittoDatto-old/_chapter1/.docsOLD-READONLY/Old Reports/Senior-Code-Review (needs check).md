# DittoDatto: Senior Code Review & Recommendations

**Reviewer**: Senior System Design Perspective  
**Date**: 2026-02-07  
**Scope**: Architecture, code quality, production readiness

---

## Overall Assessment: 7/10 ⭐

Your codebase is **better structured than most solo founder projects** I've seen. Clear separation of concerns, good use of TypeScript, proper monorepo setup. But there are areas that will bite you in production.

---

## What You're Doing Well ✅

### 1. Monorepo Structure
Your `packages/` + `apps/` split is textbook correct. Turborepo orchestration means you won't have the "which order do I build" problem.

### 2. Shared Types Package
Having `@dittodatto/shared-types` is excellent. Many teams don't do this and end up with type drift between frontend and backend.

### 3. Snapshot Pattern in Bookings
```typescript
// booking.ts - This is correct
priceAtTimeOfBooking: service.price,
serviceTitle: service.title,
```
You captured price at booking time. This prevents "I was charged €50 but receipt shows €30" disputes. Professional move.

[[4. Atomic Transactions]]

### 5. i18n From Day One
I see `en.json`, `nb.json`, `nn.json` in each app. Adding localization later is painful. Good foresight for Norwegian market + future expansion.

---

## Critical Issues to Fix 🚨

### 1. Hardcoded User Data in Production Code

```typescript
// booking.ts lines 77-78
userName: "Arnar Valur",    // ← MOCKED FOR MVP
userEmail: "arnar@dittodatto.no", // ← MOCKED FOR MVP
```

**Risk**: Every booking has your personal data. GDPR nightmare if you forget.

**Fix**: 
```typescript
// Fetch from Firebase Auth
const userRecord = await auth.getUser(hold.userId);
userName: userRecord.displayName || "Guest",
userEmail: userRecord.email || "",
```

### 2. No Hold Expiration Cleanup

```typescript
// index.ts line 131
// TODO: Add scheduler for cleaning expired holds
```

**Risk**: Holds accumulate forever. After a month, you'll have thousands of "ghost holds" blocking legitimate bookings.

**Fix** (High priority for MVP):
```typescript
export const mercury_cleanExpiredHolds = onSchedule("every 15 minutes", async () => {
  const now = new Date().toISOString();
  const expiredHolds = await db.collection("holds")
    .where("expiresAt", "<", now)
    .get();
  
  const batch = db.batch();
  expiredHolds.docs.forEach(doc => batch.delete(doc.ref));
  await batch.commit();
  
  logger.info(`Cleaned ${expiredHolds.size} expired holds`);
});
```

### 3. Missing Firestore Indexes

Your `data.ts` does compound queries:
```typescript
.where("storeId", "==", storeId)
.where("startTime", ">=", startOfDay)
.where("startTime", "<=", endOfDay)
.where("status", "in", ["confirmed", "pending"])
```

**Risk**: This will fail in production without a composite index.

**Fix**: Add to `firestore.indexes.json`:
```json
{
  "collectionGroup": "bookings",
  "queryScope": "COLLECTION",
  "fields": [
    { "fieldPath": "storeId", "order": "ASCENDING" },
    { "fieldPath": "startTime", "order": "ASCENDING" },
    { "fieldPath": "status", "order": "ASCENDING" }
  ]
}
```

### 4. No Rate Limiting

Anyone can spam `mercury_createHold` and lock up your entire booking system.

**Fix**: Add rate limiting in Cloud Run or use Firebase App Check:
```typescript
export const mercury_createHold = onCall({
  enforceAppCheck: true,  // ← Blocks automated abuse
  // ...
});
```

---

## Medium Priority Improvements ⚠️

### 1. collectionGroup Query is Slow

```typescript
// hold.ts line 39
const servicesSnap = await db
  .collectionGroup("services")
  .where("id", "in", serviceIds)
  .get();
```

**Issue**: `collectionGroup` scans ALL services across ALL stores. Fine with 100 services, painful with 10,000.

**Better**: Pass `companyId` and `storeId`, query the specific collection:
```typescript
const servicesRef = db.collection(`companies/${companyId}/stores/${storeId}/services`);
const servicesSnap = await servicesRef.where("id", "in", serviceIds).get();
```

### 2. No Logging Context

```typescript
logger.error("MercuryEngine.getSlots Error:", error);
```

**Issue**: In production, you won't know WHICH store, WHICH date.

**Better**:
```typescript
logger.error("MercuryEngine.getSlots Error", {
  companyId,
  storeId,
  date,
  serviceIds,
  error: error.message,
  stack: error.stack,
});
```

### 3. PowerShell Script in Linux Environment

```json
// package.json
"emulators": "pwsh -ExecutionPolicy Bypass -File ./scripts/start-emulator.ps1"
```

**Issue**: This won't work on Pop! OS without PowerShell installed.

**Fix**: Replace with bash script or npm script:
```json
"emulators": "firebase emulators:start --import=./firebase/emulator-data --export-on-exit"
```

### 4. Service Account JSON in Git

I see `service-account.json` in multiple directories. If this is committed to git, that's a security incident.

**Check**: Run `git log --all --full-history -- '**/service-account.json'`

**Fix**: Add to `.gitignore` and use Secret Manager or env vars.

---

## Future-Proofing Recommendations 🔮

### 1. Event Sourcing for Bookings

Currently, you only store the final state. For a booking system, you want an audit trail:

```
booking_created → payment_received → confirmed → cancelled → refunded
```

Future pattern:
```typescript
// Instead of updating status in-place
db.collection(`bookings/${bookingId}/events`).add({
  type: "BOOKING_CONFIRMED",
  timestamp: new Date(),
  actor: userId,
  metadata: { holdId, paymentId }
});
```

### 2. Idempotency Keys for All Writes

You do this for bookings (`paymentId` as document ID), but not for holds.

**Issue**: Network retry can create duplicate holds.

**Pattern**: Accept `idempotencyKey` from client for all POST operations.

### 3. Observability Stack

Before going live, add:
- **Structured logging** (you have `firebase/logger`, good)
- **Error tracking** (Sentry, Bugsnag)
- **APM** (Cloud Trace is free with GCP)
- **Alerting** (PagerDuty/Opsgenie for booking failures)

### 4. Feature Flags

Before you add more booking types, add a feature flag system:
```typescript
if (await featureFlags.isEnabled("reservations", { companyId })) {
  // Show table reservation UI
}
```

This lets you ship incomplete features behind flags.

---

## Quick Wins (Do This Week) 🎯

| Task | Time | Impact |
|------|------|--------|
| Implement expired hold cleanup | 30 min | High |
| Add Firestore indexes | 15 min | High |
| Remove hardcoded user data | 20 min | High |
| ~~Replace PowerShell → bash~~ | 10 min | Medium |
| ~~Add `.gitignore` for service accounts~~ | 5 min | Critical |
| Add structured logging context | 1 hour | Medium |

---

## Final Thoughts

You're building a multi-tenant booking platform as a solo founder. That's ambitious. Your code quality is solid for the stage you're at.

**My honest advice**: 
1. Get the Pop! OS environment running (current plan)
2. Fix the critical issues above before any customer demo
3. Extract MercuryEngine when you're ready to add your second booking domain
4. Don't over-engineer until you have 10 paying customers

You're on the right track. The fact that you asked for criticism shows founder maturity. Most first-time founders don't want to hear it.

Ship it. 🚀
