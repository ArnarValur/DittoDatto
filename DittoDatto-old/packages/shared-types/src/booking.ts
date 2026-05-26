import { z } from "zod";
import { IdSchema, DateTimeSchema, PriceSchema, CurrencySchema } from "./common";

export const BookingStatusSchema = z.enum([
  "confirmed",
  "completed",
  "cancelled",
  "no-show",
  "pending",
]);
export type BookingStatus = z.infer<typeof BookingStatusSchema>;

/**
 * The Booking Schema
 */
export const BookingSchema = z.object({
  // IDENTITY & RELATIONSHIPS
  id: IdSchema,
  userId: IdSchema,
  companyId: IdSchema,
  storeId: IdSchema,
  serviceId: IdSchema,
  staffId: IdSchema.optional(), // Staff assignment
  resourceId: IdSchema.optional(), // Assigned resource (table, room, station)
  addonResourceIds: z.array(IdSchema).default([]), // Add-on resources (Beer Keg, Bartender)

  // STATUS & TIME
  status: BookingStatusSchema,
  startTime: DateTimeSchema, // "2025-12-01T14:00:00Z"
  endTime: DateTimeSchema, // "2025-12-01T14:45:00Z"
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema.optional(),

  // FISCAL SNAPSHOT (From New Law - Critical for Receipts)
  // We save these at the moment of booking so price hikes don't affect old bookings.
  serviceTitle: z.string(),
  duration: z.number().int().positive(), // in minutes
  priceAtTimeOfBooking: PriceSchema,
  currency: CurrencySchema,

  // USER SNAPSHOT (From New Law - In case user deletes account later)
  userName: z.string(),
  userEmail: z.string().email(),
  userPhone: z.string().optional(),
  items: z.array(
    z.object({
      serviceId: IdSchema,
      title: z.string(),
      price: PriceSchema,
      duration: z.number().int().positive(),
      staffId: IdSchema.optional(),
      storeId: IdSchema,
      companyId: IdSchema,
    })
  ),

  // AI & GROUP FEATURES (From Old Law - The "Deep Dive")
  channel: z.enum(["app", "web", "voice_agent", "portal", "phone"]).default("app"), // Track booking source
  attendeeCount: z.number().int().min(1).default(1), // "Table for 4" logic
  notes: z.string().optional(),
  cancellationReason: z.string().optional(),

  // PAYMENT LINK (The Bridge to Phase 3)
  paymentId: z.string().optional(), // "pi_stripe_123" or "vipps_order_456"
});

export type Booking = z.infer<typeof BookingSchema>;
