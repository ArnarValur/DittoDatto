import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

/**
 * Activity Hub Types
 * Smart card-based notification/activity system
 */

// Card types for the Activity Hub
export const ActivityTypeSchema = z.enum([
  "booking_reminder",    // Appointment today
  "booking_change",      // Store needs to reschedule (actionable)
  "broadcast",           // Promo from favorited store
  "staff_invite",        // Invited to join a company
  "staff_claimed",       // Staff invite was claimed by user
  "staff_reply",         // Response from store/support
  "feedback",            // User-initiated platform feedback
  "support",             // User-initiated support request
  "event_upcoming",      // Event reminder
  "system_alert",        // Platform announcements
]);
export type ActivityType = z.infer<typeof ActivityTypeSchema>;

// Who sent the message
export const SenderTypeSchema = z.enum(["user", "staff", "admin", "datto"]);
export type SenderType = z.infer<typeof SenderTypeSchema>;

// Who responded (for AI tracking)
export const ResponderTypeSchema = z.enum(["human", "datto", "system"]);
export type ResponderType = z.infer<typeof ResponderTypeSchema>;

/**
 * Activity Card Schema
 * The main cards visible in the user's Activity Hub
 */
export const ActivitySchema = z.object({
  id: IdSchema,
  recipientId: IdSchema,           // User who sees this card
  type: ActivityTypeSchema,

  // Display
  title: z.string().min(1).max(200),
  body: z.string().max(1000),
  icon: z.string().optional(),     // e.g., 'i-lucide-calendar'

  // Context linking
  context: z.object({
    companyId: IdSchema.optional(),
    storeId: IdSchema.optional(),
    bookingId: IdSchema.optional(),
    eventId: IdSchema.optional(),
    threadId: IdSchema.optional(), // Links to messages collection
  }).optional(),

  // State
  isRead: z.boolean().default(false),
  isArchived: z.boolean().default(false),
  requiresAction: z.boolean().default(false),

  // AI readiness
  respondedBy: ResponderTypeSchema.optional(),

  createdAt: DateTimeSchema,
  expiresAt: DateTimeSchema.optional(),
});
export type Activity = z.infer<typeof ActivitySchema>;

/**
 * Message Schema
 * For threaded content (feedback, support, staff conversations)
 */
export const MessageSchema = z.object({
  id: IdSchema,
  threadId: IdSchema,              // Groups messages in a thread
  senderId: IdSchema,
  senderType: SenderTypeSchema,

  content: z.string().min(1).max(2000),
  attachments: z.array(z.string().url()).optional(),

  createdAt: DateTimeSchema,
  editedAt: DateTimeSchema.optional(),
});
export type Message = z.infer<typeof MessageSchema>;

/**
 * Thread Mode — Controls who responds in a conversation
 * - agent: Ditto/Datto handles all responses
 * - human: Staff responds manually
 * - hybrid: Agent responds first, escalates to human
 * - disabled: Thread is read-only / closed for responses
 */
export const ThreadModeSchema = z.enum(["agent", "human", "hybrid", "disabled"]);
export type ThreadMode = z.infer<typeof ThreadModeSchema>;

/**
 * Thread Schema
 * Metadata for a conversation thread (agent-ready)
 */
export const ThreadSchema = z.object({
  id: IdSchema,
  type: z.enum(["booking_comment", "inquiry", "support", "feedback"]),

  // Agent mode — controls who responds
  mode: ThreadModeSchema.default("human"),

  // Participants
  participantIds: z.array(IdSchema),

  // Context linking
  companyId: IdSchema.optional(),
  storeId: IdSchema.optional(),
  bookingId: IdSchema.optional(),

  // Display
  subject: z.string().max(200).optional(),
  lastMessagePreview: z.string().max(100).optional(),

  // Per-user unread counts: { [userId]: number }
  unreadByUser: z.record(z.string(), z.number()).optional(),

  // State
  status: z.enum(["open", "closed", "archived"]).default("open"),
  lastMessageAt: DateTimeSchema,
  lastMessageBy: IdSchema,

  createdAt: DateTimeSchema,
});
export type Thread = z.infer<typeof ThreadSchema>;

/**
 * Broadcast Schema
 * Company → Favorited Users promotions
 */
export const BroadcastSchema = z.object({
  id: IdSchema,
  companyId: IdSchema,
  storeIds: z.array(IdSchema).optional(), // Specific stores or all

  title: z.string().min(1).max(200),
  body: z.string().max(1000),
  imageUrl: z.string().url().optional(),

  // Targeting
  targetAudience: z.enum(["all_favorites", "store_favorites"]),

  // Stats
  recipientCount: z.number().int().nonnegative().default(0),

  createdAt: DateTimeSchema,
  scheduledFor: DateTimeSchema.optional(),
});
export type Broadcast = z.infer<typeof BroadcastSchema>;

/**
 * Create Activity DTO (for Cloud Functions)
 */
export const CreateActivitySchema = ActivitySchema.omit({
  id: true,
  createdAt: true,
  isRead: true,
  isArchived: true,
});
export type CreateActivity = z.infer<typeof CreateActivitySchema>;

/**
 * Send Message DTO
 */
export const SendMessageSchema = z.object({
  threadId: IdSchema,
  content: z.string().min(1).max(2000),
  attachments: z.array(z.string().url()).optional(),
});
export type SendMessage = z.infer<typeof SendMessageSchema>;
