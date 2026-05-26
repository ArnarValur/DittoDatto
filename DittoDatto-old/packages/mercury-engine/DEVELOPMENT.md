# MercuryEngine — Isolated Development Spec

**Date:** 2026-03-14
**Status:** Ready for focused workspace development

---

## Concept

Open `packages/mercury-engine/` directly as the Antigravity workspace. The monorepo's `node_modules` symlinks remain intact, so `@dittodatto/shared-types` resolves without any extraction or submodule setup.

**Why:**

- Engine is the 🔴 Critical domain — it deserves focused, undistracted development
- Zero unit tests today — build them in isolation against mocked Firestore
- Contract-driven: known inputs → expected outputs → test with `vitest` + `curl`
- AI context narrows from ~entire monorepo to just the engine (~20 files)

---

## Architecture Overview

```
mercury-engine/
├── src/
│   ├── server.ts              ← Hono HTTP server (:5002)
│   ├── config/
│   │   ├── env.ts             ← Zod-validated env config
│   │   └── firebase.ts        ← Firebase Admin init
│   ├── middleware/
│   │   └── auth.ts            ← Firebase Auth verification
│   ├── routes/                ← HTTP layer (validation + error mapping)
│   │   ├── appointments.ts    ← Standard 1:1 booking (salons, garages)
│   │   ├── reservations.ts    ← Capacity 1:N booking (restaurants)
│   │   ├── ticketing.ts       ← Event ticketing
│   │   └── cleanup.ts         ← Hold expiry cleanup
│   └── core/                  ← Domain logic organized by booking type
│       ├── shared/            ← Cross-domain utilities
│       │   ├── errors.ts      ← HttpsError + domain error classes
│       │   ├── time.ts        ← Time utilities (pure functions)
│       │   ├── data.ts        ← Firestore data access layer
│       │   ├── staff-availability.ts
│       │   ├── resource-availability.ts
│       │   └── customer.ts    ← CRM upsert
│       ├── bookings/          ← Standard 1:1 booking domain
│       │   ├── calculator.ts  ← Slot calculation (Time Tetris)
│       │   ├── hold.ts        ← Hold creation + collision detection
│       │   ├── booking.ts     ← Hold→Booking conversion + cancellation
│       │   └── index.ts       ← Barrel re-exports
│       ├── reservations/      ← Capacity 1:N booking domain
│       │   ├── availability.ts
│       │   ├── booking.ts
│       │   └── calculator.ts
│       └── tickets/           ← Event ticketing domain (scaffold)
│           └── index.ts
├── package.json               ← v0.2.0, Hono + firebase-admin + vitest
├── tsconfig.json
└── esbuild.config.js
```

### External Dependencies

| Dependency                 | Type              | Notes                                             |
| -------------------------- | ----------------- | ------------------------------------------------- |
| `@dittodatto/shared-types` | Workspace package | Zod schemas — resolves via `node_modules` symlink |
| `firebase-admin`           | npm               | Firestore reads/writes via `config/firebase.ts`   |
| `hono`                     | npm               | HTTP framework                                    |
| `zod`                      | npm               | Request/config validation                         |

---

## API Surface

### Appointments (Standard 1:1 Booking)

| Method | Endpoint                            | Auth   | Purpose                          |
| ------ | ----------------------------------- | ------ | -------------------------------- |
| `GET`  | `/appointments/slots`               | Public | Calculate available slots        |
| `POST` | `/appointments/holds`               | 🔒     | Create a 10-min hold on a slot   |
| `POST` | `/appointments/bookings`            | 🔒     | Convert hold → confirmed booking |
| `POST` | `/appointments/bookings/:id/cancel` | 🔒     | Cancel a booking                 |

### Reservations (Capacity 1:N Booking)

| Method | Endpoint                     | Auth   | Purpose                    |
| ------ | ---------------------------- | ------ | -------------------------- |
| `GET`  | `/reservations/availability` | Public | Get available tables/slots |
| `POST` | `/reservations`              | 🔒     | Create a table reservation |

### Utility

| Method | Endpoint                 | Auth     | Purpose                |
| ------ | ------------------------ | -------- | ---------------------- |
| `GET`  | `/health`                | Public   | Cloud Run health check |
| `GET`  | `/`                      | Public   | Service info           |
| `POST` | `/cleanup/expired-holds` | Internal | Expire stale holds     |

---

## Development Workflow

### Running the Engine

```bash
# From packages/mercury-engine/
npm run dev          # tsx watch src/server.ts → localhost:5002
npm run test         # vitest run
npm run build        # esbuild → dist/
```

### Testing with curl

```bash
# Health check
curl http://localhost:5002/health

# Get available slots (public endpoint)
curl "http://localhost:5002/appointments/slots?companyId=X&storeId=Y&date=2026-03-15&serviceIds=svc1,svc2"

# Get reservation availability
curl "http://localhost:5002/reservations/availability?companyId=X&storeId=Y&date=2026-03-15&partySize=4"

# Protected endpoints need Firebase Auth token
TOKEN=$(firebase auth:export --format=json | ...)
curl -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"companyId":"X","storeId":"Y",...}' \
     http://localhost:5002/appointments/holds
```

### Testing with Firestore Emulator

```bash
# Start emulator (from monorepo root)
firebase emulators:start --only firestore

# Engine auto-connects when FIRESTORE_EMULATOR_HOST is set
FIRESTORE_EMULATOR_HOST=localhost:8080 npm run dev
```

---

## Unit Test Strategy

### Principle: Test the Core, Not the HTTP Layer

The `core/` modules contain all business logic. Routes are thin HTTP wrappers. Tests target core functions with mocked Firestore data.

### Priority Test Targets

| Module                       | What to Test                                                    | Complexity                                |
| ---------------------------- | --------------------------------------------------------------- | ----------------------------------------- |
| `calculator.ts`              | Slot calculation with various schedules, services, staff combos | High — most logic                         |
| `hold.ts`                    | Collision detection, booking notice enforcement, TTL            | High — correctness critical               |
| `booking.ts`                 | Hold→Booking conversion, cancellation policy enforcement        | Medium                                    |
| `time.ts`                    | Schedule parsing, overlap detection, time math                  | Low — pure functions                      |
| `staff-availability.ts`      | Staff filtering, schedule matching                              | Medium                                    |
| `resource-availability.ts`   | Resource conflict detection, best-fit sort                      | Medium                                    |
| `reservations/calculator.ts` | Table assignment, capacity checks                               | High — cross-group scoping bug lives here |

### Test Structure

```
tests/
├── core/
│   ├── calculator.test.ts       ← Slot engine tests
│   ├── hold.test.ts             ← Hold creation + collision tests
│   ├── booking.test.ts          ← Booking conversion + cancel tests
│   ├── time.test.ts             ← Pure time utility tests
│   └── reservations/
│       └── calculator.test.ts   ← Table assignment + scoping tests
├── routes/
│   ├── appointments.test.ts     ← HTTP layer integration tests
│   └── reservations.test.ts     ← HTTP layer integration tests
└── fixtures/
    ├── stores.ts                ← Mock store configs
    ├── services.ts              ← Mock service definitions
    ├── staff.ts                 ← Mock staff + schedules
    └── resources.ts             ← Mock tables/rooms
```

### Mock Strategy

```typescript
// Mock firebase-admin before importing core modules
vi.mock("../config/firebase.js", () => ({
  db: mockFirestore, // in-memory mock
}));
```

---

## Known Issues to Fix in This Workspace

| Issue                                                             | File                                                 | Priority |
| ----------------------------------------------------------------- | ---------------------------------------------------- | -------- |
| Service→ResourceGroup scoping (cross-group leak)                  | `core/reservations/calculator.ts`                    | 🔴 P1    |
| No centralized error classes                                      | across `core/`                                       | 🟡 P2    |
| Route error handling is inconsistent (string match vs error code) | `routes/reservations.ts` vs `routes/appointments.ts` | 🟡 P2    |
| Debug console.log in reservations route                           | `routes/reservations.ts:69`                          | 🟢 P3    |

---

## Ground Rules for Isolated Dev

1. **Never import outside `packages/mercury-engine/`** — if something is needed from the monorepo, it goes through `@dittodatto/shared-types`
2. **If you change shared-types**, go back to the main workspace to update the package
3. **Engine must be testable without any frontend** — all endpoints get curl examples
4. **Vitest runs in <5s** — fast feedback, no emulator dependency for unit tests
5. **Deploy is independent** — `npm run build` → Docker → Cloud Run

What to keep in mind:

Don't lose integration testing. Isolated dev is for building and unit-testing the engine. Before deploying, still verify through the portal with a real store. The curl + vitest loop catches logic bugs; the portal catches contract mismatches.

Shared-types changes require a context switch. If you need to modify a Zod schema, you'll need to do that in the main workspace since the engine workspace won't have write access to the package source (only the built output). Keep this in mind — it's a minor friction point.

The 2 weeks of March — the biggest risk isn't speed, it's scope. The engine's core flows (appointments + reservations) work. The remaining P1 is the service→group scoping fix, which is a surgical change in

reservations/calculator.ts
. With focused isolated dev + tests, that's a 1-session fix. Don't let the bug week create pressure to rush new features.
