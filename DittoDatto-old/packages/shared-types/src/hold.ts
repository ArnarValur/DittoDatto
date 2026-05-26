import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

export const HoldSchema = z.object({
  // The composite key: "storeId_YYYY-MM-DD_HH:MM"
  id: z.string(),

  // Who and Where
  userId: IdSchema,
  companyId: IdSchema, // Added for multi-tenancy
  storeId: IdSchema,
  serviceId: IdSchema.optional(), // Legacy — single-service holds
  serviceIds: z.array(IdSchema),  // Multi-service support
  staffId: IdSchema.optional(), // Staff performing the service
  resourceId: IdSchema.optional(), // Resource locked during hold (table, room)

  // Time Details (Critical for the Tetris Logic)
  date: z.string(), // "2025-12-01" (Helper for efficient querying)
  slotTime: z.string(), // "14:00"
  duration: z.number().int(), // e.g., 45 minutes

  // The Ticking Clock
  expiresAt: DateTimeSchema,
  createdAt: DateTimeSchema,

  // Metadata
  paymentStatus: z.enum(["pending", "initiated", "failed"]).optional(),
  vippsOrderId: z.string().optional(),
});
export type Hold = z.infer<typeof HoldSchema>;
