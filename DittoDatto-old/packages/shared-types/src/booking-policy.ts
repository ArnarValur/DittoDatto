import { z } from "zod";

/**
 * Booking Policy Schema
 * Controls how customers can book, cancel, and reschedule at a store.
 *
 * Embedded in StoreSchema as `bookingPolicy`.
 * Enforced by MercuryEngine (getSlots, createHold) and client-side cancel/reschedule flows.
 *
 * Inspired by Noona HQ API company.profile fields — adapted for DittoDatto's
 * multi-store architecture (policy is per-store, not per-company).
 */

// --- Booking Window ---

export const BookingPolicySchema = z.object({
  /**
   * How far into the future customers can book (in days from today).
   * Default 60 = ~2 months ahead.
   * MercuryEngine: getSlots filters out dates beyond this window.
   */
  maxBookableFutureDays: z.number().int().min(1).max(365).default(60),

  /**
   * Minimum advance notice required to book (in minutes from now).
   * Default 60 = must book at least 1 hour ahead.
   * Prevents "I want a haircut in 5 minutes" situations.
   * MercuryEngine: getSlots filters out slots within this window.
   */
  minBookingNoticeMinutes: z.number().int().min(0).max(43200).default(60),

  /**
   * Slot interval for generating bookable time slots (in minutes).
   * Default 15 = slots at :00, :15, :30, :45.
   * Can be 15, 30, or 60 depending on business type.
   */
  slotInterval: z.number().int().min(5).max(120).default(15),

  // --- Cancellation Policy ---

  /**
   * Whether customers can cancel their own bookings.
   * If false, only staff/admin can cancel.
   */
  clientCancelEnabled: z.boolean().default(true),

  /**
   * Minimum notice required for free cancellation (in hours before appointment).
   * Default 24 = must cancel at least 24h before.
   * If cancelled later, the no-show fee may apply (when payment is integrated).
   */
  minCancelNoticeHours: z.number().int().min(0).max(168).default(24),

  // --- Reschedule Policy ---

  /**
   * Whether customers can reschedule their own bookings.
   * If false, must contact the business to reschedule.
   */
  clientRescheduleEnabled: z.boolean().default(true),

  /**
   * Minimum notice required for rescheduling (in hours before appointment).
   * Default 24 = must reschedule at least 24h before.
   */
  minRescheduleNoticeHours: z.number().int().min(0).max(168).default(24),

  // --- UX Messaging ---

  /**
   * Custom confirmation message shown after successful booking.
   * If empty, a default message is used.
   * Noona equivalent: `booking_success_message`.
   */
  bookingConfirmationMessage: z.string().max(500).optional(),

  // --- No-Show Fee (Future: requires Vipps integration) ---

  /**
   * Percentage of service price charged as no-show fee.
   * 0 = no fee. 100 = full price.
   * Only enforced when payment integration is live.
   */
  noShowFeePercent: z.number().int().min(0).max(100).default(0),
});
export type BookingPolicy = z.infer<typeof BookingPolicySchema>;
