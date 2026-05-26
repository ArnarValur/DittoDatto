---
title: "MercuryEngine — API Contract"
type: "reference"
status: "current"
date: "2026-05-02"
session: 3
domain: "MercuryEngine"
tags:
  - "api"
  - "endpoints"
  - "contract"
---

# MercuryEngine — API Contract

> Complete reference for every endpoint. This is the contract between Flutter and the engine.

## Authentication

| Method | Header | Notes |
|--------|--------|-------|
| Firebase Auth | `Authorization: Bearer <ID_TOKEN>` | Standard for customer-facing endpoints |
| Internal API Key | `X-Internal-API-Key: <KEY>` | System endpoints (cron, cleanup) |
| Test Bypass | `X-Test-Bypass: true` | Dev only — sets `userId = 'local_test_user'` |

---

## Appointments — Standard 1:1 Booking

### `GET /appointments/slots` — Search available slots

**Auth:** 🔓 Public

```
GET /appointments/slots?companyId=X&storeId=Y&date=2026-03-15&serviceIds=svc1,svc2&staffId=staff1
```

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `companyId` | string | ✅ | Company ID |
| `storeId` | string | ✅ | Store/Establishment ID |
| `date` | string | ✅ | Date in `YYYY-MM-DD` format |
| `serviceIds` | string | ✅ | Comma-separated service IDs |
| `staffId` | string | ❌ | Filter to specific staff member |

**Response:**
```json
{
  "date": "2026-03-15",
  "availableSlots": ["09:00", "09:15", "09:30", "10:00"]
}
```

---

### `POST /appointments/holds` — Create a slot hold (10-min TTL)

**Auth:** 🔒 Firebase Auth

```json
{
  "companyId": "comp1",
  "storeId": "store1",
  "serviceIds": ["svc1", "svc2"],
  "date": "2026-03-15",
  "slotTime": "10:00",
  "staffId": "staff1"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `companyId` | string | ✅ | Company ID |
| `storeId` | string | ✅ | Store ID |
| `serviceIds` | string[] | ✅ | Services to book |
| `date` | string | ✅ | Date `YYYY-MM-DD` |
| `slotTime` | string | ✅ | Time slot `HH:MM` |
| `staffId` | string | ❌ | Pre-selected staff member |

**Response:**
```json
{
  "success": true,
  "holdId": "store1_2026-03-15_10:00_staff1",
  "expiresAt": "2026-03-15T10:10:00.000Z"
}
```

**Error codes:** `failed-precondition` (slot taken, notice cutoff, date range), `not-found` (store/services), `already-exists` (hold exists)

---

### `POST /appointments/bookings` — Convert hold → confirmed booking

**Auth:** 🔒 Firebase Auth

```json
{
  "holdId": "store1_2026-03-15_10:00_staff1",
  "paymentId": "pay_abc123"
}
```

> **Note:** Flutter may send extra fields (`companyId`, `customerDetails`, `notes`). The engine ignores them — it reads everything from the hold document.

**Response:**
```json
{
  "success": true,
  "bookingId": "pay_abc123"
}
```

---

### `POST /appointments/bookings/:bookingId/cancel` — Cancel a booking

**Auth:** 🔒 Firebase Auth (customer OR company admin)

```json
{
  "reason": "Schedule change"
}
```

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `bookingId` | path param | ✅ | Booking ID |
| `reason` | body string | ❌ | Cancellation reason |

**Authorization rules:**
- Customer who made the booking → allowed (subject to cancellation policy)
- Company admin/member → always allowed (bypasses policy)
- Super admin → always allowed

**Response:**
```json
{ "success": true }
```

---

## Reservations — Capacity 1:N Booking

### `GET /reservations/availability` — Get available tables/slots

**Auth:** 🔓 Public

```
GET /reservations/availability?companyId=X&storeId=Y&date=2026-03-15&partySize=4&serviceId=svc1
```

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `companyId` | string | ✅ | Company ID |
| `storeId` | string | ✅ | Store ID |
| `date` | string | ✅ | Date `YYYY-MM-DD` |
| `partySize` | number | ❌ | Number of guests |
| `serviceId` | string | ❌ | Scope to service's resource groups |

---

### `POST /reservations` — Create a reservation

**Auth:** 🔒 Firebase Auth

```json
{
  "companyId": "comp1",
  "storeId": "store1",
  "date": "2026-03-15",
  "time": "18:00",
  "partySize": 4,
  "customerName": "Arnar V.",
  "customerPhone": "12345678",
  "notes": "Window seat",
  "serviceId": "dinner-service"
}
```

> **Note:** `partySize` accepts both `number` and `string` (engine does `parseInt()`).

---

## Tickets — Event Ticketing (Scaffold)

> ⚠️ All ticket endpoints return stub responses. No core logic is wired yet.

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `GET` | `/tickets/availability?eventId=X` | Ticket availability |
| `POST` | `/tickets/holds` | Create ticket hold (5-min) |
| `POST` | `/tickets/purchase` | Confirm purchase |
| `POST` | `/tickets/verify` | Door scan verification |
| `POST` | `/tickets/transfer` | Transfer to another user |

---

## System Endpoints

### `GET /health` — Health check (Cloud Run)

**Auth:** 🔓 Public

```json
{
  "status": "ok",
  "service": "mercury-engine",
  "version": "0.2.0",
  "timestamp": "2026-03-15T10:00:00.000Z"
}
```

### `GET /` — Service info

**Auth:** 🔓 Public — Returns endpoint listing.

### `DELETE /cleanup/holds/expired` — Expire stale holds

**Auth:** 🔐 Internal API Key — Intended for Cloud Scheduler.

### `GET /cleanup/stats` — Hold statistics

**Auth:** 🔓 Public

```json
{
  "totalHolds": 12,
  "expiredHolds": 3,
  "timestamp": "2026-03-15T10:00:00.000Z"
}
```

---

## Error Response Format

All domain errors use `HttpsError` which maps to HTTP status codes:

```json
{
  "error": "This time slot is no longer available."
}
```

| Error Code | HTTP Status | When |
|------------|-------------|------|
| `not-found` | 404 | Store/service/booking not found |
| `already-exists` | 409 | Hold already taken |
| `failed-precondition` | 400 | Slot taken, notice cutoff, date range, policy violation |
| `permission-denied` | 403 | Not authorized to cancel |
| `unauthenticated` | 401 | Missing/invalid auth token |
| `invalid-argument` | 400 | Malformed input |

---

## CORS Policy

Allowed origins:
- `http://localhost:3000` / `3001` / `3002` (dev)
- `https://*.dittodatto.no` (production)

---

*Created: 2026-05-02 — Session 3 Grill*
