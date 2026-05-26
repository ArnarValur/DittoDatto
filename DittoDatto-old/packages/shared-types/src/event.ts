import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

/**
 * Event Location Schema
 * Describes where the event takes place
 */
export const EventLocationSchema = z.object({
  name: z.string().optional(), // "Saga Kino", "Main Hall"
  address: z.string().min(1),
  city: z.string().min(1),
  country: z.string().min(2).max(255).default("NO"),
  coordinates: z
    .object({
      lat: z.number().min(-90).max(90),
      lng: z.number().min(-180).max(180),
    })
    .optional(),
});
export type EventLocation = z.infer<typeof EventLocationSchema>;

/**
 * Event Status Enum
 */
export const EventStatusSchema = z.enum([
  "draft",
  "published",
  "cancelled",
  "completed",
]);
export type EventStatus = z.infer<typeof EventStatusSchema>;

/**
 * Event Visibility Enum
 */
export const EventVisibilitySchema = z.enum(["public", "private"]);
export type EventVisibility = z.infer<typeof EventVisibilitySchema>;

/**
 * Event Schema
 * Represents an event created by a company, optionally linked to a store
 */
export const EventSchema = z.object({
  id: IdSchema,
  companyId: IdSchema,
  storeId: IdSchema.optional(), // null = company-level event

  // Core info
  title: z.string().min(1).max(255),
  description: z.string().optional(),

  // Date/Time
  startDateTime: DateTimeSchema,
  endDateTime: DateTimeSchema.optional(),
  timezone: z.string().default("Europe/Oslo"),

  // Location
  location: EventLocationSchema,

  // Media
  coverImageUrl: z.url().optional(),

  // Status
  status: EventStatusSchema.default("draft"),
  visibility: EventVisibilitySchema.default("public"),

  // Metadata
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
  createdBy: IdSchema,

  // Ticketing Integration
  ticketBundleId: IdSchema.optional(),      // Link to TicketBundle if ticketed
  hasTickets: z.boolean().default(false),   // Quick check for UI
  ticketingEnabled: z.boolean().default(false), // Is ticketing configured?

  // ╔══════════════════════════════════════════════════════════════╗
  // ║  🔄 TODO-PostIt: RECURRING EVENTS                            ║
  // ║──────────────────────────────────────────────────────────────║
  // ║  For monthly "Dream On the Full Moon" style events, add:     ║
  // ║  - recurrence: { frequency, interval, daysOfWeek, endDate }  ║
  // ║  - parentEventId: IdSchema.optional() (for instances)        ║
  // ║  - isRecurring: z.boolean().default(false)                   ║
  // ╚══════════════════════════════════════════════════════════════╝
});
export type Event = z.infer<typeof EventSchema>;

/**
 * Create Event Schema (without id, timestamps, and createdBy)
 * Accepts ISO strings for dates since they come from HTTP requests
 */
export const CreateEventSchema = EventSchema.omit({
  id: true,
  createdAt: true,
  updatedAt: true,
  createdBy: true,
}).extend({
  // Override date fields to accept both Date and string (ISO format)
  startDateTime: z.union([z.date(), z.string().transform((s) => new Date(s))]),
  endDateTime: z.union([z.date(), z.string().transform((s) => new Date(s))]).optional(),
  // Handle null values from frontend
  description: z.string().optional().nullable().transform(v => v ?? undefined),
  coverImageUrl: z.string().url().optional().nullable().transform(v => v ?? undefined),
});
export type CreateEvent = z.infer<typeof CreateEventSchema>;

/**
 * Update Event Schema (partial, without immutable fields)
 * Accepts ISO strings for dates since they come from HTTP requests
 */
export const UpdateEventSchema = EventSchema.omit({
  id: true,
  companyId: true,
  createdAt: true,
  createdBy: true,
}).extend({
  // Override date fields to accept both Date and string (ISO format)
  startDateTime: z.union([z.date(), z.string().transform((s) => new Date(s))]).optional(),
  endDateTime: z.union([z.date(), z.string().transform((s) => new Date(s))]).optional(),
  description: z.string().optional().nullable().transform(v => v ?? undefined),
}).partial();
export type UpdateEvent = z.infer<typeof UpdateEventSchema>;
