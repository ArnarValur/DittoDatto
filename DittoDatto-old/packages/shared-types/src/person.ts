import { z } from "zod";
import { IdSchema } from "./common";
import { OpeningScheduleSchema } from "./schedule";

/**
 * @deprecated Use `StaffMember` from `./staff.ts` for staff management.
 * Person is retained for backward compatibility with existing booking data.
 * Migration: `personId` → `staffId` completed (Session 3, 2026-05-02). All schemas and MercuryEngine now use `staffId`.
 */
export const PersonSchema = z.object({
  id: IdSchema,
  storeId: IdSchema,

  //Auth link
  userId: IdSchema.optional(),

  // Prófile
  name: z.string().min(1),
  role: z.string().optional(),
  groups: z.array(z.string()).optional(),
  imageUrl: z.string().url().optional(),

  isBookable: z.boolean().default(true),
  schedule: OpeningScheduleSchema.optional(), // Overrides store hours
});
export type Person = z.infer<typeof PersonSchema>;
