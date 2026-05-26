---
schema: IdSchema, DateTimeSchema, PriceSchema, CurrencySchema, AggregateRatingSchema, PeriodSchema, RangeSchema
domain_term: Common Primitives
firestore_path: N/A (shared building blocks)
status: active
version: v1.0
related: []
noona_equivalent: N/A
tags: [core, foundation]
---

# Common Primitives

Shared building-block schemas used by all other domain schemas. These define the fundamental types for IDs, timestamps, prices, and reusable structures.

## Schemas

| Schema | Type | Description |
|--------|------|-------------|
| `IdSchema` | `z.string().min(1)` | Non-empty string ID — used for all Firestore document IDs and foreign key references |
| `DateTimeSchema` | `z.union(…).pipe(z.date())` | **Universal timestamp** (ADR-0003). Accepts JS Date, Firestore Timestamp `{ seconds, nanoseconds }`, or ISO string. Always normalizes to `Date`. |
| `PriceSchema` | `z.number().min(0).nonnegative()` | Non-negative number for prices |
| `CurrencySchema` | `z.enum(["NOK", "SEK", "DKK", "EUR", "ISK"]).default("NOK")` | Nordic currencies. NOK 🇳🇴, SEK 🇸🇪, DKK 🇩🇰, EUR 🇫🇮, ISK 🇮🇸. Default: NOK. |
| `AggregateRatingSchema` | `{ average: 0–5, count: int }` | Star rating aggregate for establishment cards |
| `PeriodSchema` | `{ days: 1–365, period: enum }` | Duration period — used by BookingPolicy for cancellation/lead time windows |
| `RangeSchema` | `{ start: DateTime, end: DateTime }` | Date/time range — used by shifts, holds, and availability queries |

## Design Notes

- `DateTimeSchema` is the **only** timestamp type. All schemas use it (ADR-0003). The old `IsoDateSchema` and `TimestampSchema` have been removed.
- `PriceSchema` is intentionally a bare number, not a `{ amount, currency }` object. Currency is set at the Store or Company level, not per-field. This simplifies arithmetic but means cross-currency comparisons aren't possible — acceptable for a Norway-first platform.
- `IdSchema` is `z.string().min(1)`, not UUID. Firestore auto-generates document IDs which are 20-char alphanumeric strings.
