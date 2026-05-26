import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

/**
 * Search Analytics Types
 * Captures DittoBar (and future DattoBar/Discover) search events
 * for intelligence gathering and marketing insights.
 */

export const SearchEventSourceSchema = z.enum([
  "dittobar",   // Consumer-facing search bar
  "discover",   // Browse/filter on discover page
  "dattobar",   // Business portal (future)
]);
export type SearchEventSource = z.infer<typeof SearchEventSourceSchema>;

/**
 * Search Event — stored in Firestore `searchEvents` collection
 */
export const SearchEventSchema = z.object({
  id: IdSchema,
  query: z.string().min(1).max(500),
  rawQuery: z.string().min(1).max(500),
  resultCount: z.number().int().nonnegative(),

  // What the user clicked on (null = bounce / no selection)
  selectedResult: z
    .object({
      type: z.enum(["store", "category"]),
      id: z.string(),
      name: z.string(),
    })
    .optional(),

  userId: IdSchema.optional(), // null if anonymous
  sessionId: z.string().min(1), // anonymous tracking (UUID per session)
  source: SearchEventSourceSchema,

  createdAt: DateTimeSchema,
});
export type SearchEvent = z.infer<typeof SearchEventSchema>;

/**
 * Log Search Event Request DTO (client → Cloud Function)
 * Server enriches with auth.uid and serverTimestamp.
 */
export const LogSearchEventRequestSchema = z.object({
  query: z.string().min(1).max(500),
  resultCount: z.number().int().nonnegative(),
  selectedResult: z
    .object({
      type: z.enum(["store", "category"]),
      id: z.string(),
      name: z.string(),
    })
    .optional(),
  sessionId: z.string().min(1),
  source: SearchEventSourceSchema,
});
export type LogSearchEventRequest = z.infer<
  typeof LogSearchEventRequestSchema
>;
