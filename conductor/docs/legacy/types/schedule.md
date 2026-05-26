---
schema: OpeningScheduleSchema, DayScheduleSchema
domain_term: Opening Schedule
firestore_path: Embedded in Store (openingSchedule field)
status: active
version: v1.0
related: [store, shift]
noona_equivalent: Company opening hours
tags: [core, business-portal]
---

# Opening Schedule

Weekly business hours for a Store. Seven-day structure with per-day `isOpen` flag and open/close times. Embedded in the Store document. MercuryEngine uses this as the base layer for slot calculation — staff shifts further constrain availability.

## Fields (DaySchedule)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `isOpen` | `boolean` | ✅ | Whether the store is open this day |
| `open` | `string` | ✅ | Opening time `"HH:MM"` (e.g., `"09:00"`) |
| `close` | `string` | ✅ | Closing time `"HH:MM"` (e.g., `"17:00"`) |

## Structure (OpeningSchedule)

```
{ mon: DaySchedule, tue: DaySchedule, wed: DaySchedule,
  thu: DaySchedule, fri: DaySchedule, sat: DaySchedule, sun: DaySchedule }
```

## Relationships

- An **Opening Schedule** is embedded in exactly one **Store**
- **MercuryEngine** reads this schedule as the outer boundary for slot generation
- **Staff Shifts** (WeeklyShift) further constrain which slots are available per staff member
- **Norwegian Holidays** may override the schedule (store can opt in/out)

## Design Notes

- `open` and `close` are always present even when `isOpen === false`. This allows the UI to pre-fill times when toggling a day on.
- No break support at the store level — breaks are handled via staff shift blocks. A store is either open or closed for the entire window.
- Times are in the store's timezone (from `Store.timezone`, default `"Europe/Oslo"`).
