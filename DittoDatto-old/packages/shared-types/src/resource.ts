import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

/**
 * Resource & Resource Group Schemas
 *
 * Resources are physical assets required to perform a service:
 * rooms, tables, chairs, stations, equipment, etc.
 *
 * A Service may require one or more Resources (via requiredResourceGroupIds).
 * MercuryEngine slot calculation checks:
 *   staff available AND resource available → slot is bookable.
 *
 * Firestore path: companies/{companyId}/stores/{storeId}/resources/{resourceId}
 * Firestore path: companies/{companyId}/stores/{storeId}/resourceGroups/{groupId}
 *
 * Inspired by Noona HQ API Resources — adapted for DittoDatto's multi-store model.
 * NOTE: Schema only. Engine wiring deferred until table reservation implementation.
 */

// ---------------------
// Resource Type
// ---------------------

export const ResourceTypeSchema = z.enum([
  "room",       // Massage room, treatment room, meeting room
  "table",      // Restaurant table, bar seating
  "station",    // Hair station, nail station, workbench
  "equipment",  // Projector, laser machine, specific tool
  "addon",      // Add-on item: Beer Keg, Bartender, Laser lights (has price)
]);
export type ResourceType = z.infer<typeof ResourceTypeSchema>;

export const ResourcePrioritySchema = z.enum(["low", "normal", "high"]);
export type ResourcePriority = z.infer<typeof ResourcePrioritySchema>;

// ---------------------
// Resource Group
// ---------------------

/**
 * Logical grouping of resources.
 * Example: "Massage Rooms" (contains Room 1, Room 2, Room 3)
 *
 * When a Service requires a resource, it references a ResourceGroup.
 * The engine picks any available resource from that group.
 */
export const ResourceGroupSchema = z.object({
  id: IdSchema,
  storeId: IdSchema,
  companyId: IdSchema,

  name: z.string().min(1).max(100),        // "Massage Rooms", "Window Tables"
  description: z.string().max(1000).optional(),

  // Display
  sortOrder: z.number().int().default(0),
  /** When true, resources in this group are browsable on the public store page (e.g. halls, studios) */
  showOnStorefront: z.boolean().default(false),

  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
});
export type ResourceGroup = z.infer<typeof ResourceGroupSchema>;

// ---------------------
// Resource
// ---------------------

/**
 * A single physical asset.
 *
 * Key design decisions:
 * - min/maxCapacity enables table reservation logic ("Table for 2–4")
 * - isBookable lets owners temporarily disable a resource (maintenance, etc.)
 * - resourceGroupId is optional: ungrouped resources are standalone
 */
export const ResourceSchema = z.object({
  id: IdSchema,
  storeId: IdSchema,
  companyId: IdSchema,
  resourceGroupId: IdSchema.optional(),

  name: z.string().min(1).max(100),        // "Massage Room 1", "Table 5", "Beer Keg"
  description: z.string().max(1000).optional(),
  type: ResourceTypeSchema,

  // Capacity (for table reservation mode)
  minCapacity: z.number().int().min(1).default(1),    // Min guests this resource serves
  maxCapacity: z.number().int().min(1).default(1),    // Max guests this resource serves

  // Pricing (for add-on resources: "Beer Keg 1500 kr")
  price: z.number().min(0).optional(),
  currency: z.string().length(3).default("NOK"),

  // Media
  imageUrl: z.string().url().optional(),

  // Booking behavior
  isBookable: z.boolean().default(true),
  allowOverlapping: z.boolean().default(false),  // Allow multiple bookings at same time
  bookingInterval: z.number().int().min(5).optional(), // Override store-level interval (minutes)
  priority: ResourcePrioritySchema.default("normal"),  // Auto-assignment preference

  // Display
  sortOrder: z.number().int().default(0),

  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
});
export type Resource = z.infer<typeof ResourceSchema>;

// ---------------------
// Input Schemas
// ---------------------

export const CreateResourceGroupSchema = ResourceGroupSchema.omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});
export type CreateResourceGroup = z.infer<typeof CreateResourceGroupSchema>;

export const CreateResourceSchema = ResourceSchema.omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});
export type CreateResource = z.infer<typeof CreateResourceSchema>;
