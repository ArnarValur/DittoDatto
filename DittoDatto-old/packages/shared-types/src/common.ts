import { z } from "zod";

export const IdSchema = z.string().min(1);
/**
 * Universal DateTime schema.
 * Accepts: JS Date, Firestore Timestamp, ISO string.
 * Always outputs: JS Date.
 *
 * Use this for ALL timestamp fields across ALL schemas.
 */
export const DateTimeSchema = z.union([
  z.date(),
  z.object({ seconds: z.number(), nanoseconds: z.number() })
    .transform(t => new Date(t.seconds * 1000 + t.nanoseconds / 1_000_000)),
  z.string().transform(s => new Date(s)),
]).pipe(z.date());

export const PriceSchema = z.number().min(0).nonnegative();
export const CurrencySchema = z.enum(["NOK", "SEK", "DKK", "EUR", "ISK"]).default("NOK");

/** Aggregate Rating */
export const AggregateRatingSchema = z.object({
  average: z.number().min(0).max(5),
  count: z.number().int().nonnegative(),
});
export type AggregateRating = z.infer<typeof AggregateRatingSchema>;

/** Period */
export const PeriodSchema = z.object({
  days: z.number().int().min(1).max(365),
  period: z.enum(["hourly", "daily", "weekly", "monthly", "yearly"]),
});
export type Period = z.infer<typeof PeriodSchema>;

/** Range */
export const RangeSchema = z.object({
  start: DateTimeSchema,
  end: DateTimeSchema,
});
export type Range = z.infer<typeof RangeSchema>;
