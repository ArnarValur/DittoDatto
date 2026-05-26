import { z } from "zod";

export const DayScheduleSchema = z.object({
  isOpen: z.boolean(),
  open: z.string().regex(/^\d{2}:\d{2}$/), // "09:00"
  close: z.string().regex(/^\d{2}:\d{2}$/), // "17:00"
});
export type DaySchedule = z.infer<typeof DayScheduleSchema>;

export const OpeningScheduleSchema = z.object({
  mon: DayScheduleSchema,
  tue: DayScheduleSchema,
  wed: DayScheduleSchema,
  thu: DayScheduleSchema,
  fri: DayScheduleSchema,
  sat: DayScheduleSchema,
  sun: DayScheduleSchema,
});
export type OpeningSchedule = z.infer<typeof OpeningScheduleSchema>;
