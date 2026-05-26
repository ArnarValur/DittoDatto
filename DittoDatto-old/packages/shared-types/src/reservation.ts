import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

// ============================================================================
// Reservation Configuration (embedded in Store features)
// ============================================================================

export const LargePartyHandlingSchema = z.enum([
  "email", // "Please email us"
  "call", // "Please call us"
  "datto", // Datto handles special requests (future)
  "disabled", // Can't book more than max
]);
export type LargePartyHandling = z.infer<typeof LargePartyHandlingSchema>;

export const CapacityModeSchema = z.enum([
  "pool", // Total seats, no individual tables
  "tables", // Physical table management
  "hybrid", // Both
]);
export type CapacityMode = z.infer<typeof CapacityModeSchema>;

export const ReservationConfigSchema = z.object({
  maxGuestsPerReservation: z.number().int().min(1).default(8),
  largePartyHandling: LargePartyHandlingSchema.default("email"),
  largePartyContact: z.string().optional(), // email or phone for large parties
  defaultDuration: z.number().int().min(15).default(90), // minutes
  slotInterval: z.number().int().min(15).default(30), // minutes
  bufferBetweenSlots: z.number().int().default(0), // minutes
  capacityMode: CapacityModeSchema.default("pool"),
  totalCapacity: z.number().int().optional(), // for pool mode
  autoConfirm: z.boolean().default(true), // auto-confirm or require manual approval
});
export type ReservationConfig = z.infer<typeof ReservationConfigSchema>;

// ============================================================================
// Experience — DEPRECATED (Noona legacy)
// Replaced by Services with bookingMode: 'tableReservation' (ADR-0004).
// Remove in future cleanup session. Engine falls back to store hours when
// no experiences exist, which is the correct path.
// ============================================================================

export const OperatingWindowSchema = z.object({
  startTime: z.string().regex(/^\d{2}:\d{2}$/), // "17:30"
  endTime: z.string().regex(/^\d{2}:\d{2}$/), // "22:00"
});
export type OperatingWindow = z.infer<typeof OperatingWindowSchema>;

export const ExperienceSchema = z.object({
  id: IdSchema,
  storeId: IdSchema,
  companyId: IdSchema,

  name: z.string().min(1), // "Dinner", "Lunch", "Brunch"
  description: z.string().optional(),
  image: z.string().url().optional(),

  operatingWindow: OperatingWindowSchema,
  duration: z.number().int().optional(), // override store default
  daysAvailable: z.array(z.number().int().min(0).max(6)).default([0, 1, 2, 3, 4, 5, 6]), // 0=Sun
  isActive: z.boolean().default(true),
  order: z.number().int().default(0), // display order

  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
});
export type Experience = z.infer<typeof ExperienceSchema>;

// ============================================================================
// Reservation (individual booking for a table/party)
// ============================================================================

export const ReservationStatusSchema = z.enum([
  "pending", // awaiting confirmation (if autoConfirm=false)
  "confirmed", // reservation confirmed
  "seated", // party has arrived and seated
  "completed", // dining completed
  "cancelled", // cancelled by customer or business
  "no_show", // customer didn't show up
]);
export type ReservationStatus = z.infer<typeof ReservationStatusSchema>;

export const ReservationSchema = z.object({
  id: IdSchema,
  storeId: IdSchema,
  companyId: IdSchema,
  experienceId: IdSchema.optional(), // which experience (Dinner, Lunch, etc.)

  // Customer info
  customerId: IdSchema.optional(), // if registered user
  customerName: z.string().min(1),
  customerEmail: z.string().email().optional(),
  customerPhone: z.string().min(1),

  // Reservation details
  guestCount: z.number().int().min(1),
  date: DateTimeSchema, // reservation date
  time: z.string().regex(/^\d{2}:\d{2}$/), // "18:30"
  duration: z.number().int().positive(), // minutes
  tableId: IdSchema.optional(), // if assigned to specific table

  // Status
  status: ReservationStatusSchema.default("confirmed"),
  notes: z.string().optional(), // special requests
  internalNotes: z.string().optional(), // staff notes

  // Metadata
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
  confirmedAt: DateTimeSchema.optional(),
  cancelledAt: DateTimeSchema.optional(),
  cancelReason: z.string().optional(),
});
export type Reservation = z.infer<typeof ReservationSchema>;
