import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

/**
 * Feedback System Types
 *
 * Flat, AI-friendly schema for feedback/support submissions.
 * Stored at: feedback/{feedbackId}
 *
 * Sources:
 * - public_contact: Public marketplace contact form (may be anonymous)
 * - public_feedback: Logged-in marketplace user sends feedback
 * - portal_feedback: Business portal user sends feedback/feature request
 * - portal_support: Business portal user requests support
 * - business_inquiry: Business application / inquiry from for-business page
 */

export const FeedbackSourceSchema = z.enum([
  "public_contact",
  "public_feedback",
  "portal_feedback",
  "portal_support",
  "business_inquiry",
]);
export type FeedbackSource = z.infer<typeof FeedbackSourceSchema>;

export const FeedbackCategorySchema = z.enum([
  "general",
  "bug",
  "feature_request",
  "ux_issue",
  "compliment",
  "question",
]);
export type FeedbackCategory = z.infer<typeof FeedbackCategorySchema>;

export const FeedbackStatusSchema = z.enum([
  "new",
  "read",
  "in_progress",
  "resolved",
  "archived",
]);
export type FeedbackStatus = z.infer<typeof FeedbackStatusSchema>;

export const FeedbackPrioritySchema = z.enum(["low", "medium", "high"]);
export type FeedbackPriority = z.infer<typeof FeedbackPrioritySchema>;

/**
 * Full Feedback Document Schema (Firestore)
 */
export const FeedbackSchema = z.object({
  id: IdSchema,

  // Sender
  senderId: IdSchema.optional(),          // userId if logged in
  senderEmail: z.string().email(),
  senderName: z.string().min(1).max(200),

  // Classification
  source: FeedbackSourceSchema,
  category: FeedbackCategorySchema.default("general"),

  // Content
  subject: z.string().max(200).optional(),
  body: z.string().min(1).max(2000),

  // Context (auto-captured for bug reports)
  metadata: z.object({
    url: z.string().optional(),
    userAgent: z.string().optional(),
    viewport: z.string().optional(),
    appVersion: z.string().optional(),
  }).optional(),

  // Admin management
  status: FeedbackStatusSchema.default("new"),
  priority: FeedbackPrioritySchema.optional(),
  tags: z.array(z.string()).optional(),
  adminNotes: z.string().max(2000).optional(),

  // Timestamps
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema.optional(),
});
export type Feedback = z.infer<typeof FeedbackSchema>;

/**
 * Submit Feedback DTO (from client)
 */
export const SubmitFeedbackSchema = z.object({
  senderName: z.string().min(1).max(200),
  senderEmail: z.string().email(),
  source: FeedbackSourceSchema,
  category: FeedbackCategorySchema.optional(),
  subject: z.string().max(200).optional(),
  body: z.string().min(1).max(2000),
  metadata: z.object({
    url: z.string().optional(),
    userAgent: z.string().optional(),
    viewport: z.string().optional(),
  }).optional(),
});
export type SubmitFeedback = z.infer<typeof SubmitFeedbackSchema>;
