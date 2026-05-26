import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";
import { WeeklyShiftSchema, DateOverrideSchema } from "./shift";

// ---------------------
// Staff Capabilities
// ---------------------

/**
 * Capability-based permissions for staff members.
 * Used with `defaultCapabilities` and per-store `storeCapabilities` overrides.
 *
 * @see Phase 3 (RBAC Enforcement) for usage in composables and Firestore rules.
 */
export const StaffCapabilitySchema = z.enum([
  "can_manage_bookings",
  "can_view_all_bookings",
  "can_manage_schedule",
  "can_manage_services",
  "can_manage_staff",
  "can_view_financials",
  "can_manage_media",
  "can_manage_events",
  "can_manage_settings",
]);
export type StaffCapability = z.infer<typeof StaffCapabilitySchema>;

/** All available capabilities — useful for UI toggles and "grant all" logic. */
export const ALL_STAFF_CAPABILITIES = StaffCapabilitySchema.options;

// ---------------------
// Staff Status
// ---------------------

/**
 * Lifecycle status of a staff member.
 *
 * Flow: invited → active → suspended → removed
 *
 * - `invited`: Email-based invite sent, no userId linked yet
 * - `active`: User signed in and auto-linked via Firebase trigger
 * - `suspended`: Temporarily disabled (can be re-activated)
 * - `removed`: Soft-deleted (retained for audit/booking history)
 */
export const StaffStatusSchema = z.enum([
  "invited",
  "active",
  "suspended",
  "removed",
]);
export type StaffStatus = z.infer<typeof StaffStatusSchema>;

// ---------------------
// Staff Member
// ---------------------

/**
 * Full staff member document.
 *
 * Firestore path: `companies/{companyId}/staff/{staffId}`
 *
 * Replaces the deprecated `Person` schema for staff management.
 * Staff can be assigned to multiple stores via `storeIds`.
 * Capabilities can be set globally (`defaultCapabilities`) or
 * per-store (`storeCapabilities`).
 */
export const StaffMemberSchema = z.object({
  id: IdSchema,
  companyId: IdSchema,

  // Auth link — set when invited user signs in
  userId: IdSchema.optional(),
  email: z.string().email(),
  displayName: z.string().min(1),
  avatarUrl: z.string().url().optional(),

  // Store assignment (multi-store)
  storeIds: z.array(IdSchema).default([]),

  // Position label — free text, e.g. "Barista", "Senior Stylist", "Manager"
  position: z.string().optional(),

  // Capabilities
  defaultCapabilities: z.array(StaffCapabilitySchema).default([]),
  storeCapabilities: z
    .record(IdSchema, z.array(StaffCapabilitySchema))
    .default({}),

  isBookable: z.boolean().default(false),
  showOnStorefront: z.boolean().default(false),
  weeklyShifts: WeeklyShiftSchema.optional(),
  dateOverrides: z.array(DateOverrideSchema).default([]),

  // Lifecycle
  status: StaffStatusSchema.default("invited"),
  invitedAt: DateTimeSchema.optional(),
  joinedAt: DateTimeSchema.optional(),
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
});
export type StaffMember = z.infer<typeof StaffMemberSchema>;

// ---------------------
// Input Schemas
// ---------------------

/**
 * Validation schema for creating (inviting) a staff member.
 * Server-side fields (id, companyId, userId, timestamps) are omitted.
 */
export const CreateStaffMemberSchema = StaffMemberSchema.omit({
  id: true,
  companyId: true,
  userId: true,
  joinedAt: true,
  createdAt: true,
  updatedAt: true,
});
export type CreateStaffMember = z.infer<typeof CreateStaffMemberSchema>;

/**
 * Validation schema for updating a staff member.
 * All fields optional except `id` (required to identify target).
 */
export const UpdateStaffMemberSchema = StaffMemberSchema.partial().required({
  id: true,
});
export type UpdateStaffMember = z.infer<typeof UpdateStaffMemberSchema>;
