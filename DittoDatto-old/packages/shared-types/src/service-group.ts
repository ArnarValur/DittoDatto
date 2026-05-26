import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

/**
 * Service Group — Organizational only.
 * Groups services for display and selection — carries NO config defaults.
 * 
 * Design decision (2026-03-03, Noona analysis):
 *   Groups should never be a config layer. Duration, buffer, capacity,
 *   and availability belong on Service or Resource exclusively.
 * 
 * Collection path: companies/{companyId}/stores/{storeId}/serviceGroups
 */
export const ServiceGroupSchema = z.object({
  id: IdSchema,
  storeId: IdSchema,
  
  name: z.string().min(1),
  description: z.string().optional(),
  
  /** Staff member IDs assigned to this service group. References `companies/{companyId}/staff/{staffId}`. */
  staffIds: z.array(IdSchema).optional(),
  
  // Display
  sortOrder: z.number().int().default(0),
  /** Whether this group and its services appear on the public booking panel */
  showOnBookingPanel: z.boolean().default(true),
  /** When true, customers can select multiple services from this group in one booking */
  multiSelect: z.boolean().optional().default(false),
  
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
});
export type ServiceGroup = z.infer<typeof ServiceGroupSchema>;

// Input schema for creating a service group (without auto-generated fields)
export const CreateServiceGroupInputSchema = ServiceGroupSchema.omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});
export type CreateServiceGroupInput = z.infer<typeof CreateServiceGroupInputSchema>;

// Input schema for updating a service group
export const UpdateServiceGroupInputSchema = ServiceGroupSchema.partial().required({ id: true });
export type UpdateServiceGroupInput = z.infer<typeof UpdateServiceGroupInputSchema>;
