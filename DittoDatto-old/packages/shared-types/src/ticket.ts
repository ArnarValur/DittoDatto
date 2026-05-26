import { z } from "zod";
import { IdSchema, DateTimeSchema, PriceSchema, CurrencySchema } from "./common";

/**
 * Ticket Status
 */
export const TicketStatusSchema = z.enum([
  "available",    // Not yet sold
  "held",         // Temporarily held during checkout
  "sold",         // Purchased
  "used",         // Scanned/checked-in at event
  "cancelled",    // Refunded or voided
  "transferred",  // Ownership changed
]);
export type TicketStatus = z.infer<typeof TicketStatusSchema>;

/**
 * Ticket Bundle Status
 */
export const TicketBundleStatusSchema = z.enum([
  "draft",        // Configuration in progress
  "scheduled",    // Sales not yet open
  "active",       // Sales open
  "paused",       // Sales temporarily stopped
  "soldOut",      // No capacity remaining
  "closed",       // Sales ended
]);
export type TicketBundleStatus = z.infer<typeof TicketBundleStatusSchema>;

/**
 * Ticket Group (embedded in TicketBundle)
 * Represents a pricing tier (VIP, General, Early Bird, etc.)
 */
export const TicketGroupSchema = z.object({
  id: IdSchema,
  name: z.string().min(1).max(100),         // "VIP", "General Admission", "Early Bird"
  description: z.string().max(500).optional(),
  
  // Capacity
  capacity: z.number().int().min(1),        // Total tickets in this tier
  soldCount: z.number().int().min(0).default(0),
  heldCount: z.number().int().min(0).default(0),
  
  // Pricing
  price: PriceSchema,                       // In øre (cents) for precision
  currency: CurrencySchema,
  
  // Display order
  sortOrder: z.number().int().min(0).default(0),
  
  // Buffer group flag (overflow protection)
  isBuffer: z.boolean().default(false),
});
export type TicketGroup = z.infer<typeof TicketGroupSchema>;

/**
 * Ticket Bundle
 * Container for all tickets of an event (one bundle per event)
 */
export const TicketBundleSchema = z.object({
  id: IdSchema,
  eventId: IdSchema,                        // REQUIRED - always tied to an event
  companyId: IdSchema,
  
  // Capacity
  totalCapacity: z.number().int().min(1),   // Sum of all group capacities
  bufferCapacity: z.number().int().min(0).default(0), // Overflow protection
  
  // Sales info
  totalSold: z.number().int().min(0).default(0),
  totalRevenue: z.number().min(0).default(0), // In øre
  
  // Limits
  maxPerPurchase: z.number().int().min(1).max(100).default(10),
  ageRequirement: z.number().int().min(0).max(99).optional(),
  
  // Scheduling
  salesStart: DateTimeSchema.optional(),     // When sales open
  salesEnd: DateTimeSchema.optional(),       // When sales close
  
  // Status
  status: TicketBundleStatusSchema.default("draft"),
  
  // Ticket Groups (embedded)
  groups: z.array(TicketGroupSchema).min(1),
  
  // Metadata
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
  createdBy: IdSchema,
  
  // ╔══════════════════════════════════════════════════════════════╗
  // ║  💳 TODO-PostIt: PAYMENT INTEGRATION (Q1 2026)               ║
  // ║──────────────────────────────────────────────────────────────║
  // ║  When payment is implemented, add:                           ║
  // ║  - paymentProvider: z.enum(['vipps', 'stripe']).optional()   ║
  // ║  - merchantId: IdSchema.optional()                           ║
  // ╚══════════════════════════════════════════════════════════════╝
});
export type TicketBundle = z.infer<typeof TicketBundleSchema>;

/**
 * Ticket
 * Individual ticket instance (created on purchase)
 */
export const TicketSchema = z.object({
  id: IdSchema,
  bundleId: IdSchema,
  eventId: IdSchema,
  groupId: IdSchema,                        // Which tier this ticket is from
  
  // Ownership
  purchaserId: IdSchema,                    // Who bought it
  holderId: IdSchema,                       // Current holder (may differ after transfer)
  holderName: z.string().max(255).optional(),
  holderEmail: z.string().email().optional(),
  
  // QR/Verification
  qrCode: z.string().optional(),            // Unique code for scanning
  
  // Status
  status: TicketStatusSchema.default("available"),
  
  // Timestamps
  holdExpiresAt: DateTimeSchema.optional(),  // For held tickets
  purchasedAt: DateTimeSchema.optional(),
  usedAt: DateTimeSchema.optional(),
  transferredAt: DateTimeSchema.optional(),
  
  // Payment (reference only)
  paymentRef: z.string().optional(),
  pricePaid: PriceSchema.optional(),
  
  // Metadata
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
  
  // ╔══════════════════════════════════════════════════════════════╗
  // ║  📱 TODO-PostIt: QR VERIFICATION                             ║
  // ║──────────────────────────────────────────────────────────────║
  // ║  When QR scanning is implemented:                            ║
  // ║  - Generate qrCode on purchase confirmation                  ║
  // ║  - Add scannedBy: IdSchema for door staff tracking           ║
  // ║  - Add scanLocation: string for multi-entrance venues        ║
  // ╚══════════════════════════════════════════════════════════════╝
});
export type Ticket = z.infer<typeof TicketSchema>;

/**
 * Create Ticket Bundle Schema
 */
export const CreateTicketBundleSchema = TicketBundleSchema.omit({
  id: true,
  totalSold: true,
  totalRevenue: true,
  createdAt: true,
  updatedAt: true,
});
export type CreateTicketBundle = z.infer<typeof CreateTicketBundleSchema>;

/**
 * Update Ticket Bundle Schema
 */
export const UpdateTicketBundleSchema = TicketBundleSchema.omit({
  id: true,
  eventId: true,
  companyId: true,
  createdAt: true,
  createdBy: true,
}).partial();
export type UpdateTicketBundle = z.infer<typeof UpdateTicketBundleSchema>;

/**
 * Ticket Purchase Request
 */
export const TicketPurchaseRequestSchema = z.object({
  eventId: IdSchema,
  groupId: IdSchema,
  quantity: z.number().int().min(1).max(100),
  holderName: z.string().max(255).optional(),
  holderEmail: z.string().email().optional(),
});
export type TicketPurchaseRequest = z.infer<typeof TicketPurchaseRequestSchema>;

/**
 * Ticket Hold Response
 */
export const TicketHoldResponseSchema = z.object({
  holdId: IdSchema,
  expiresAt: DateTimeSchema,
  tickets: z.array(z.object({
    ticketId: IdSchema,
    groupName: z.string(),
    price: PriceSchema,
  })),
  totalPrice: PriceSchema,
});
export type TicketHoldResponse = z.infer<typeof TicketHoldResponseSchema>;
