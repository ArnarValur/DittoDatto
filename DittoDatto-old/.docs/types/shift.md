---
schema: WeeklyShiftSchema, DayShiftSchema, ShiftBlockSchema, DateOverrideSchema
domain_term: Shift / Date Override
firestore_path: Embedded in StaffMember (weeklyShifts, dateOverrides fields)
status: active
version: v1.0
related: [staff-member, schedule, store]
noona_equivalent: Employee schedule
tags: [core, business-portal]
---

# Shift System

Staff-level scheduling: recurring weekly shifts and date-specific overrides. Embedded in the StaffMember document. MercuryEngine uses shifts to determine per-staff availability within the store's opening hours.

## Shift Block

A single contiguous working period within a day. Multiple blocks enable break gaps.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `start` | `string` | ✅ | Start time `"HH:MM"` |
| `end` | `string` | ✅ | End time `"HH:MM"` |
| `label` | `string` | ❌ | UI label: "Morning", "Afternoon" |

Example: `[{ start: "09:00", end: "13:00" }, { start: "14:00", end: "18:00" }]` = working with a 1-hour lunch break.

## Day Shift

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `isWorking` | `boolean` | ✅ | Whether working this day |
| `blocks` | `ShiftBlock[]` | ✅ | Working periods. Default: `[]` |

## Weekly Shift

Same structure as Opening Schedule: `{ mon, tue, wed, thu, fri, sat, sun }` — each is a DayShift.

## Date Override

Date-specific schedule exception that takes precedence over the weekly pattern.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `date` | `string` | ✅ | ISO date `"YYYY-MM-DD"` |
| `type` | `enum: off, sick, custom` | ✅ | Override type |
| `reason` | `string` | ❌ | "Annual leave", "Doctor appointment" |
| `blocks` | `ShiftBlock[]` | ❌ | Custom working periods (only for `"custom"` type) |

## Relationships

- **Shifts** are embedded in a **Staff Member** document
- **MercuryEngine** reads shifts to constrain slot availability per staff
- **Date Overrides** take precedence over the **Weekly Shift** pattern
- The **Store's Opening Schedule** is the outer boundary — staff shifts can only narrow it, not expand it

## Design Notes

- Buffer time between bookings belongs on the **Service** (`bufferTime`), not on shifts. Shifts only define when the staff member is *available* to work.
- `dateOverrides` stored as array on StaffMember for simplicity. If a staff member accumulates years of history, migrate to sub-collection: `companies/{id}/staff/{id}/schedules/{date}`.
- `type: "off"` and `type: "sick"` are effectively the same (no work), but differentiated for reporting/analytics.
- `type: "custom"` with `blocks` allows "working half-day" or "special hours" overrides.
