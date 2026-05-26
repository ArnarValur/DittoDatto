---
schema: N/A (utility functions)
domain_term: Norwegian Holidays
firestore_path: N/A (computed at runtime)
status: active
version: v1.0
related: [schedule, shift]
noona_equivalent: Holidays
tags: [core, mercury-engine, norway]
---

# Norwegian Holidays

Pure utility module for computing Norwegian public holidays. No Firestore storage — holidays are calculated at runtime for any given year. Used by MercuryEngine to exclude slots on public holidays (unless the store explicitly opts in).

## Functions

| Function | Description |
|----------|-------------|
| `getNorwegianHolidays(year)` | Returns all public holidays for the given year |
| `isNorwegianHoliday(dateStr)` | Checks if a `"YYYY-MM-DD"` string is a public holiday |

## Fixed Holidays

| Date | Norwegian | English |
|------|-----------|---------|
| Jan 1 | Første nyttårsdag | New Year's Day |
| May 1 | Arbeidernes dag | Labour Day |
| May 17 | Grunnlovsdag | Constitution Day |
| Dec 25 | Første juledag | Christmas Day |
| Dec 26 | Andre juledag | St. Stephen's Day |

## Easter-Based (Moveable)

Skjærtorsdag, Langfredag, Første påskedag, Andre påskedag, Kristi himmelfartsdag, Første pinsedag, Andre pinsedag — calculated from Easter Sunday using the Anonymous Gregorian algorithm.

## Design Notes

- No external API dependency — all holidays computed in pure TypeScript.
- Easter calculation is deterministic (algorithm, not lookup table).
- MercuryEngine calls `isNorwegianHoliday(date)` during slot generation. If the date is a holiday and the store doesn't have a date override marking it as open, slots are excluded.
- When expanding to Sweden (Höddi partnership), a similar `getSwedishHolidays(year)` module will be needed.
