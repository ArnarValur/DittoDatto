import { z } from "zod";

/**
 * HH:mm time format validator, reused from schedule.ts pattern.
 */
const TimeSchema = z.string().regex(/^\d{2}:\d{2}$/);

// ---------------------
// Shift Block
// ---------------------

/**
 * A single contiguous working period within a day.
 * Multiple blocks per day enable break gaps (e.g., 09:00–13:00 + 14:00–18:00).
 *
 * Note: Buffer time between bookings belongs on the Service, not here.
 * This schema only defines when the staff member is *available* to work.
 */
export const ShiftBlockSchema = z.object({
  start: TimeSchema, // "09:00"
  end: TimeSchema, // "13:00"
  label: z.string().optional(), // "Morning", "Afternoon" — UI convenience
});
export type ShiftBlock = z.infer<typeof ShiftBlockSchema>;

// ---------------------
// Day Shift
// ---------------------

/**
 * A staff member's shift for a single day of the week.
 * When `isWorking` is false, `blocks` is ignored.
 */
export const DayShiftSchema = z.object({
  isWorking: z.boolean(),
  blocks: z.array(ShiftBlockSchema).default([]),
});
export type DayShift = z.infer<typeof DayShiftSchema>;

// ---------------------
// Weekly Shift Pattern
// ---------------------

/**
 * Recurring weekly schedule for a staff member.
 * Each day has independent working status and shift blocks.
 */
export const WeeklyShiftSchema = z.object({
  mon: DayShiftSchema,
  tue: DayShiftSchema,
  wed: DayShiftSchema,
  thu: DayShiftSchema,
  fri: DayShiftSchema,
  sat: DayShiftSchema,
  sun: DayShiftSchema,
});
export type WeeklyShift = z.infer<typeof WeeklyShiftSchema>;

// ---------------------
// Date Override
// ---------------------

/**
 * A date-specific schedule override (vacation, sick day, special hours).
 * Takes precedence over the weekly shift pattern for that date.
 *
 * MVP: Stored as array on StaffMember document.
 * FUTURE: If this array grows large (years of history), migrate to a
 * sub-collection: companies/{id}/staff/{id}/schedules/{date}
 * to keep the main StaffMember doc light for Engine reads.
 */
export const DateOverrideTypeSchema = z.enum(["off", "sick", "custom"]);
export type DateOverrideType = z.infer<typeof DateOverrideTypeSchema>;

export const DateOverrideSchema = z.object({
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/), // "2026-03-15" ISO date
  type: DateOverrideTypeSchema,
  reason: z.string().optional(), // "Annual leave", "Doctor appointment"
  blocks: z.array(ShiftBlockSchema).optional(), // Only for "custom" type
});
export type DateOverride = z.infer<typeof DateOverrideSchema>;
