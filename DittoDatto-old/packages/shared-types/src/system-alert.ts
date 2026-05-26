/**
 * System Alerts — Zero-Fan-Out Broadcasts
 *
 * Admin writes ONE document → all matching users see it.
 * No per-user writes, no fan-out. Client-side composable
 * queries for active alerts matching the user's audience.
 *
 * Collection: systemAlerts/{alertId}
 *
 * @module shared-types/system-alert
 */
import { z } from "zod";
import { DateTimeSchema } from "./common";

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

export const AlertSeveritySchema = z.enum([
  "info",       // General announcement, feature update
  "warning",    // Planned maintenance, degraded service
  "critical",   // Urgent downtime, security issue
]);

export const AlertAudienceSchema = z.enum([
  "all",        // Everyone — public + portal users
  "business",   // Portal / business users only
  "customers",  // Public marketplace users only
  "admin",      // Admin panel only (internal)
]);

// ---------------------------------------------------------------------------
// Main Schema
// ---------------------------------------------------------------------------

export const SystemAlertSchema = z.object({
  id: z.string(),
  title: z.string().min(1).max(200),
  body: z.string().max(1000),
  severity: AlertSeveritySchema,
  targetAudience: AlertAudienceSchema,
  isActive: z.boolean().default(true),

  // Optional: auto-show/hide window
  startsAt: DateTimeSchema.optional(),
  expiresAt: DateTimeSchema.optional(),

  // Optional: link user to more details
  actionUrl: z.string().url().optional(),
  actionLabel: z.string().max(50).optional(),

  // Admin metadata
  createdBy: z.string().optional(), // admin UID
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema.optional(),
});

// DTO for creating from admin panel
export const CreateSystemAlertSchema = SystemAlertSchema.omit({
  id: true,
  createdAt: true,
  updatedAt: true,
  createdBy: true,
});

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

export type SystemAlert = z.infer<typeof SystemAlertSchema>;
export type CreateSystemAlert = z.infer<typeof CreateSystemAlertSchema>;
export type AlertSeverity = z.infer<typeof AlertSeveritySchema>;
export type AlertAudience = z.infer<typeof AlertAudienceSchema>;
