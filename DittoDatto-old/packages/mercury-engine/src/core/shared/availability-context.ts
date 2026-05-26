/**
 * MercuryEngine — Availability Context Builder
 * 
 * Pure function that transforms raw Firestore data into a computed context
 * used by both calculator.ts (slot generation) and hold.ts (hold validation).
 * 
 * Previously, both files duplicated 30+ lines of identical logic for:
 * - Staff normalization (missing weeklyShifts → store hours fallback)
 * - Staff-service assignment filtering (assignedStaff[] intersection)
 * - Resource group extraction + deduplication
 * - Policy derivation (notice cutoff from services, slot interval from services)
 * - Occupancy map building (per-staff, store-level, per-resource)
 * 
 * This module is PURE — zero Firestore, zero side effects → trivially testable.
 */

import { BookingPolicySchema } from "@dittodatto/shared-types";
import type { Store, Booking, Hold, Service, StaffMember, Resource, ResourceGroup } from "@dittodatto/shared-types";
import { getDayName, minutesFromMidnight, getStoreNow, parseTime } from "./time.js";

// ============================================================================
// Types
// ============================================================================

/** Raw data as returned by fetchAvailabilityData() */
export interface AvailabilityData {
  store: Store;
  bookings: Booking[];
  holds: Hold[];
  services: Service[];
  staff: StaffMember[];
  resources: Resource[];
  resourceGroups: ResourceGroup[];
}

/** Computed values ready for slot calculation and hold validation */
export interface AvailabilityContext {
  // Schedule
  schedule: { isOpen: boolean; open: string; close: string } | null;
  openTime: number;   // minutes from midnight
  closeTime: number;  // minutes from midnight
  dayName: string;

  // Duration & policy
  totalDuration: number;
  slotInterval: number;
  noticeCutoffMinutes: number;
  policy: ReturnType<typeof BookingPolicySchema.parse>;
  timeCtx: ReturnType<typeof getStoreNow>;

  // Staff
  normalizedStaff: StaffMember[];
  eligibleStaff: StaffMember[];
  hasBookableStaff: boolean;

  // Occupancy maps
  staffOccupancy: Map<string, { start: number; end: number }[]>;
  storeOccupied: { start: number; end: number }[];
  resourceOccupied: { start: number; end: number; resourceId?: string }[];

  // Resources
  uniqueRequiredGroupIds: string[];
  hasResourceRequirements: boolean;
  resources: Resource[];
  resourceGroups: ResourceGroup[];

  // Pass-through
  date: string;  // Original YYYY-MM-DD request date
  store: Store;
  bookings: Booking[];
  holds: Hold[];
  services: Service[];
}

// ============================================================================
// Builder
// ============================================================================

/**
 * Build a fully computed availability context from raw Firestore data.
 * 
 * @param data - Raw data from fetchAvailabilityData()
 * @param date - Request date in "YYYY-MM-DD" format
 * @param staffId - Optional: filter to a specific staff member
 * @returns Computed context ready for slot loop or hold allocation
 */
export function buildAvailabilityContext(
  data: AvailabilityData,
  date: string,
  staffId?: string,
): AvailabilityContext {
  const { store, bookings, holds, services, staff, resources, resourceGroups } = data;

  // ---- Policy derivation ----
  // Notice: most restrictive (max) across services
  // Interval: smallest (min) across services
  const noticeCutoffMinutes = Math.max(
    ...services.map((s: any) => s.minBookingNoticeMinutes ?? 0),
  );
  const slotInterval = Math.min(
    ...services.map((s: any) => s.slotInterval ?? 15),
  );

  // Date window: store-level concern (maxBookableFutureDays)
  const policy = BookingPolicySchema.parse(store.bookingPolicy ?? {});

  // Time context (timezone-aware "now")
  const timeCtx = getStoreNow(store.timezone || "Europe/Oslo", date);

  // ---- Schedule ----
  const totalDuration = services.reduce((sum: number, s: any) => sum + s.duration, 0);
  const dayName = getDayName(date);
  const schedule = (store.openingSchedule as any)?.[dayName] ?? null;
  const openTime = schedule?.isOpen ? parseTime(schedule.open) : 0;
  const closeTime = schedule?.isOpen ? parseTime(schedule.close) : 0;

  // ---- Staff normalization ----
  // If a staff member is isBookable but has no weeklyShifts configured,
  // inject a default shift that mirrors the store's opening hours.
  const normalizedStaff: StaffMember[] = staff.map((s) => {
    if (s.isBookable && !s.weeklyShifts && schedule?.isOpen) {
      return {
        ...s,
        weeklyShifts: {
          mon: { isWorking: true, blocks: [{ start: schedule.open, end: schedule.close }] },
          tue: { isWorking: true, blocks: [{ start: schedule.open, end: schedule.close }] },
          wed: { isWorking: true, blocks: [{ start: schedule.open, end: schedule.close }] },
          thu: { isWorking: true, blocks: [{ start: schedule.open, end: schedule.close }] },
          fri: { isWorking: true, blocks: [{ start: schedule.open, end: schedule.close }] },
          sat: { isWorking: false, blocks: [] },
          sun: { isWorking: false, blocks: [] },
        },
      };
    }
    return s;
  });

  // ---- Staff-service assignment filtering ----
  // For multi-service bookings, use INTERSECTION — staff must be eligible for ALL services.
  // Empty assignedStaff[] = universal service (anyone can do it).
  const restrictedServices = services.filter((s: any) => (s.assignedStaff?.length || 0) > 0);
  let eligibleStaff = normalizedStaff;

  if (restrictedServices.length > 0) {
    eligibleStaff = normalizedStaff.filter((s) =>
      restrictedServices.every((svc: any) => svc.assignedStaff.includes(s.id)),
    );
  }

  // If user picked a specific staff member, narrow further
  if (staffId) {
    eligibleStaff = eligibleStaff.filter((s) => s.id === staffId);
  }

  const hasBookableStaff = eligibleStaff.length > 0;

  // ---- Resource group extraction ----
  const requiredResourceGroupIds = services.flatMap(
    (s: any) => (s as any).requiredResourceGroupIds || [],
  );
  const uniqueRequiredGroupIds = [...new Set(requiredResourceGroupIds)];
  const hasResourceRequirements = uniqueRequiredGroupIds.length > 0;

  // ---- Occupancy maps ----

  // Per-staff occupancy
  const staffOccupancy = new Map<string, { start: number; end: number }[]>();
  if (hasBookableStaff) {
    eligibleStaff.forEach((s) => staffOccupancy.set(s.id, []));

    bookings.forEach((b: any) => {
      if (b.staffId && staffOccupancy.has(b.staffId)) {
        staffOccupancy.get(b.staffId)!.push({
          start: minutesFromMidnight(b.startTime, store.timezone),
          end: minutesFromMidnight(b.endTime, store.timezone),
        });
      }
    });

    holds.forEach((h: any) => {
      if (h.staffId && staffOccupancy.has(h.staffId)) {
        const start = parseTime(h.slotTime);
        staffOccupancy.get(h.staffId)!.push({
          start,
          end: start + h.duration,
        });
      }
    });
  }

  // Store-level fallback (for stores with NO staff and NO resources)
  const storeOccupied = [
    ...bookings.map((b: any) => ({
      start: minutesFromMidnight(b.startTime, store.timezone),
      end: minutesFromMidnight(b.endTime, store.timezone),
    })),
    ...holds.map((h: any) => {
      const start = parseTime(h.slotTime);
      return { start, end: start + h.duration };
    }),
  ].sort((a, b) => a.start - b.start);

  // Resource-level occupancy (bookings/holds that reference specific resources)
  const resourceOccupied = [
    ...bookings.map((b: any) => ({
      start: minutesFromMidnight(b.startTime, store.timezone),
      end: minutesFromMidnight(b.endTime, store.timezone),
      resourceId: (b as any).resourceId as string | undefined,
    })),
    ...holds.map((h: any) => {
      const start = parseTime(h.slotTime);
      return {
        start,
        end: start + h.duration,
        resourceId: (h as any).resourceId as string | undefined,
      };
    }),
  ];

  return {
    schedule,
    openTime,
    closeTime,
    dayName,
    totalDuration,
    slotInterval,
    noticeCutoffMinutes,
    policy,
    timeCtx,
    normalizedStaff,
    eligibleStaff,
    hasBookableStaff,
    staffOccupancy,
    storeOccupied,
    resourceOccupied,
    uniqueRequiredGroupIds,
    hasResourceRequirements,
    resources,
    resourceGroups,
    date,
    store,
    bookings,
    holds,
    services,
  };
}
