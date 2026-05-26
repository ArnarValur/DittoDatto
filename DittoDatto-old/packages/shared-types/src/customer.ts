import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

/**
 * Customer Status
 * - new: Just created, no visits yet
 * - active: Has visited within the last 90 days
 * - inactive: No visit in 90+ days
 */
export const CustomerStatusSchema = z.enum(["new", "active", "inactive"]);
export type CustomerStatus = z.infer<typeof CustomerStatusSchema>;

/**
 * The Customer Schema
 * Represents a client of a Business (Company).
 * Has multi-store support via `storeIds` for filtering in the Business Portal.
 * 
 * Inspired by Noona HQ's customer model:
 * - event_count → totalVisits
 * - previous_event → lastBookingId
 * - employee_ids → staffIds
 */
export const CustomerSchema = z.object({
  id: IdSchema,
  companyId: IdSchema,
  storeIds: z.array(IdSchema).default([]), // For multi-store filtering

  // Optional link to a registered Public Marketplace user
  userId: IdSchema.optional(),

  // Profile Details
  name: z.string().min(1).max(255),
  firstName: z.string().optional(),
  lastName: z.string().optional(),
  email: z.string().email().optional().or(z.literal("")),
  phone: z.string().optional(),
  phoneCountryCode: z.string().optional(),
  
  // CRM Data
  notes: z.string().optional(),
  status: CustomerStatusSchema.default("new"),
  staffIds: z.array(IdSchema).default([]), // Staff who have served this customer
  channel: z.enum(["app", "web", "portal", "import"]).default("app"), // Acquisition channel

  // Booking References (Noona pattern: previous_event / next_event)
  lastBookingId: IdSchema.optional(),
  
  // Metrics (incremented by MercuryEngine on booking creation)
  totalVisits: z.number().default(0),
  totalSpent: z.number().default(0), // Cumulative spend in default currency
  firstVisitAt: DateTimeSchema.optional(),
  lastVisitAt: DateTimeSchema.optional(),

  // Metadata
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
});

export type Customer = z.infer<typeof CustomerSchema>;

