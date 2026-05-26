import { z } from "zod";
import { IdSchema, PriceSchema, CurrencySchema } from "./common";

export const BookingModeSchema = z.enum([
  "standard", // 1:1 appointments (haircut, massage, etc.)
  "tableReservation", // Capacity-based (restaurants, group therapy)
  "ticketSystem", // Inventory-based (events, classes, workshops)
]);
export type BookingMode = z.infer<typeof BookingModeSchema>;

export const ServiceSchema = z.object({
  id: IdSchema,
  storeId: IdSchema,
  groupId: IdSchema.optional(), // Link to ServiceGroup for config inheritance
  staffId: IdSchema.optional(), // Legacy: single staff. TODO: migrate to assignedStaff[] (see ADR-0006)
  /** Staff UIDs who can perform this service. Replaces staffId for many-to-many. */
  assignedStaff: z.array(IdSchema).default([]),

  /**
   * Resource groups required to perform this service.
   * Empty = no resource needed (current behavior, most services).
   * When set, MercuryEngine checks: staff available AND resource available.
   * References: companies/{companyId}/stores/{storeId}/resourceGroups/{groupId}
   */
  requiredResourceGroupIds: z.array(IdSchema).default([]),

  title: z.string().min(1),
  description: z.string().optional(),

  // Booking Mode: determines how customers book this service
  // - standard: 1:1 time-based appointments
  // - tableReservation: capacity-based (group bookings)
  // - ticketSystem: inventory-based (event tickets)
  bookingMode: BookingModeSchema.default("standard"),

  // Media
  coverImage: z.string().optional(),
  gallery: z.array(z.string()).optional(),

  serviceType: z.array(z.string().min(1)),
  subcategory: z.string().optional(),

  keywords: z.array(z.string().min(1)), // AI Tags <- This one I think should be required, because it is used for AI
  aiDescription: z.string().optional(),
  _embedding: z.array(z.number()).optional(),

  // Time & Pricing
  duration: z.number().int().positive(),
  price: PriceSchema,
  bufferTime: z.number().int().default(0),
  currency: CurrencySchema,

  /**
   * Over-capacity policy (Noona: overbookable enum).
   * - reject: hard limit, "Sorry, no availability" (default)
   * - request: submit as pending_approval, notify business
   * - allow: always accept even if over capacity
   */
  overCapacityPolicy: z.enum(["reject", "request", "allow"]).default("reject"),

  /** Minimum advance notice required to book this service (in minutes). 0 = no minimum. */
  minBookingNoticeMinutes: z.number().int().min(0).max(43200).default(0),
  /** Slot interval for generating bookable time slots (in minutes). Default 15 = :00, :15, :30, :45. */
  slotInterval: z.number().int().min(5).max(120).default(15),

  isActive: z.boolean().default(true),
});
export type Service = z.infer<typeof ServiceSchema>;
