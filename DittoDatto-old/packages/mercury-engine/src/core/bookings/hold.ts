// packages/functions/src/MercuryEngine/hold.ts
// Core Domain: Booking Context - Create Hold
// Atomic hold creation with 10-minute TTL
// Policy-aware: validates against BookingPolicySchema before locking slot.
// Auto-allocates the highest priority Resource (e.g. Table) at hold time!

import { db } from "../../config/firebase.js";
import { Hold } from "@dittodatto/shared-types";
import { fetchAvailabilityData } from "../shared/data.js";
import { getAvailableResourcesForSlot } from "../shared/resource-availability.js";
import { getAvailableStaffForSlot } from "../shared/staff-availability.js";
import { parseTime, minutesFromMidnight, isSlotInPast } from "../shared/time.js";
import { buildAvailabilityContext } from "../shared/availability-context.js";
import type { AvailabilityContext } from "../shared/availability-context.js";

import { HttpsError } from "../shared/errors.js";

// ============================================================================
// Types
// ============================================================================

export interface HoldAllocation {
  finalStaffId?: string;
  assignedResourceId?: string;
  holdId: string;
  totalDuration: number;
}

// ============================================================================
// Pure Function: Resolve Hold Allocation
// ============================================================================

/**
 * Given a precomputed AvailabilityContext, determine:
 * - Which staff member gets the hold (if staff-aware)
 * - Which resource gets auto-assigned (if resource-aware)
 * - The composite hold ID
 * 
 * This is PURE — zero Firestore, zero side effects → testable.
 * Throws HttpsError if the slot is unavailable.
 * 
 * @param ctx - Precomputed availability context
 * @param slotTime - The time slot being held (e.g., "09:00")
 * @param userId - The user creating the hold
 * @param staffId - Optional: pre-selected staff member
 */
export function resolveHoldAllocation(
  ctx: AvailabilityContext,
  storeId: string,
  slotTime: string,
  userId: string,
  staffId?: string,
): HoldAllocation {
  const {
    services, eligibleStaff, hasBookableStaff,
    uniqueRequiredGroupIds, hasResourceRequirements,
    resources, resourceGroups, totalDuration, store, date,
  } = ctx;

  // Guard against literal "undefined" string over network
  if (staffId === "undefined" || staffId === "null") {
    staffId = undefined;
  }

  const resolvedStaffId = staffId || services.find((s: any) => s.staffId)?.staffId;

  const slotStart = parseTime(slotTime);
  const slotEnd = slotStart + totalDuration;

  // ---- Staff concurrency ----
  let finalStaffId = resolvedStaffId;

  if (hasBookableStaff) {
    let candidates = eligibleStaff;
    if (finalStaffId) {
      candidates = eligibleStaff.filter((s) => s.id === finalStaffId);
      if (candidates.length === 0) {
        throw new HttpsError(
          "failed-precondition",
          "Requested staff member cannot perform all selected services.",
        );
      }
    }

    // Filter by shift schedules
    const scheduledStaffIds = getAvailableStaffForSlot(candidates, date, slotStart, slotEnd);
    if (scheduledStaffIds.length === 0) {
      throw new HttpsError(
        "failed-precondition",
        "No staff members are scheduled for this time slot.",
      );
    }

    // Filter by occupied (no clashing holds/bookings for that specific staff member)
    let availableStaffId: string | undefined = undefined;
    const { bookings, holds } = ctx;

    for (const sId of scheduledStaffIds) {
      const staffOccupied = [
        ...bookings
          .filter((b: any) => b.staffId === sId)
          .map((b: any) => ({
            start: minutesFromMidnight(b.startTime, store.timezone),
            end: minutesFromMidnight(b.endTime, store.timezone),
          })),
        ...holds
          .filter((h: any) => h.staffId === sId)
          .map((h: any) => {
            const start = parseTime(h.slotTime);
            return { start, end: start + h.duration };
          }),
      ];

      const isStaffClashing = staffOccupied.some(
        (occ) => slotStart < occ.end && slotEnd > occ.start,
      );
      if (!isStaffClashing) {
        availableStaffId = sId;
        break;
      }
    }

    if (!availableStaffId) {
      throw new HttpsError(
        "failed-precondition",
        "This time slot is no longer available.",
      );
    }

    finalStaffId = availableStaffId;
  } else if (!hasResourceRequirements) {
    // NO STAFF and NO RESOURCES → Global store-level concurrency (only 1 booking at a time)
    const { storeOccupied } = ctx;
    const isClashing = storeOccupied.some(
      (occ) => slotStart < occ.end && slotEnd > occ.start,
    );
    if (isClashing) {
      throw new HttpsError(
        "failed-precondition",
        "This time slot is no longer available.",
      );
    }
  }

  // ---- Resource allocation ----
  let assignedResourceId: string | undefined;

  if (hasResourceRequirements) {
    const resourceResult = getAvailableResourcesForSlot(
      resources,
      resourceGroups,
      uniqueRequiredGroupIds,
      slotStart,
      slotEnd,
      ctx.resourceOccupied,
    );

    if (!resourceResult.available || resourceResult.assignedResources.length === 0) {
      throw new HttpsError(
        "failed-precondition",
        "No resources available for this time slot.",
      );
    }

    // First resource in the assigned array is the highest priority table
    assignedResourceId = resourceResult.assignedResources[0].id;
  }

  // ---- Composite hold ID ----
  const differentiator = assignedResourceId || finalStaffId || userId;
  const holdId = `${storeId}_${date}_${slotTime}_${differentiator}`;

  return {
    finalStaffId,
    assignedResourceId,
    holdId,
    totalDuration,
  };
}

// ============================================================================
// Orchestrator: Create Hold (Firestore Transaction)
// ============================================================================

/**
 * MercuryEngine - Create Hold
 * Atomically locks a time slot for 10 minutes.
 * Uses composite key for idempotency AND concurrency.
 * Validates booking policy (date window, notice time) before creating.
 * Auto-allocates necessary resources based on priority.
 */
export const createHold = async (
  userId: string,
  companyId: string,
  storeId: string,
  serviceIds: string[],
  date: string,
  slotTime: string,
  staffId?: string,
) => {
  const storeRef = db.doc(`companies/${companyId}/stores/${storeId}`);

  return await db.runTransaction(async (transaction) => {
    // 1. Establish transaction read block for serialization
    const storeSnap = await transaction.get(storeRef);
    if (!storeSnap.exists) {
      throw new HttpsError("not-found", "Store not found");
    }

    // 2. Fetch ALL data needed to verify the slot
    const data = await fetchAvailabilityData(companyId, storeId, date, serviceIds, staffId);

    // 3. Build context (pure)
    const ctx = buildAvailabilityContext(data, date);

    // 4. Date window check
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const maxDate = new Date(today);
    maxDate.setDate(maxDate.getDate() + ctx.policy.maxBookableFutureDays);
    if (new Date(date + "T00:00:00") > maxDate) {
      throw new HttpsError(
        "failed-precondition",
        `Cannot book more than ${ctx.policy.maxBookableFutureDays} days in advance`,
      );
    }

    // 5. Notice time check
    const slotMinutes = parseTime(slotTime);
    if (isSlotInPast(slotMinutes, ctx.timeCtx, ctx.noticeCutoffMinutes)) {
      throw new HttpsError(
        "failed-precondition",
        `Must book at least ${ctx.noticeCutoffMinutes} minutes in advance`,
      );
    }

    // 6. Validate services
    if (ctx.services.length !== serviceIds.length) {
      throw new HttpsError("not-found", "One or more services not found");
    }

    if (!ctx.hasBookableStaff && !staffId) {
      // ok — no staff required
    } else if (ctx.hasBookableStaff && ctx.eligibleStaff.length === 0 && !staffId) {
      throw new HttpsError(
        "failed-precondition",
        "No staff members are eligible for all selected services.",
      );
    }

    // 7. Resolve allocation (pure)
    const allocation = resolveHoldAllocation(ctx, storeId, slotTime, userId, staffId);

    // 8. Write hold document
    const holdRef = db.collection("holds").doc(allocation.holdId);
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000);

    const holdData: Hold = {
      id: allocation.holdId,
      userId,
      companyId,
      storeId,
      serviceIds,
      ...(allocation.finalStaffId ? { staffId: allocation.finalStaffId } : {}),
      ...(allocation.assignedResourceId ? { resourceId: allocation.assignedResourceId } : {}),
      date,
      slotTime,
      duration: allocation.totalDuration,
      expiresAt: expiresAt as unknown as Date,
      createdAt: new Date() as unknown as Date,
    };

    // Check for existing hold (idempotency + expired hold overwrite)
    const existingHold = await transaction.get(holdRef);
    if (existingHold.exists) {
      const existing = existingHold.data() as Hold;
      if (existing.expiresAt && new Date(existing.expiresAt).getTime() < Date.now()) {
        transaction.set(holdRef, holdData);
      } else {
        throw new HttpsError(
          "already-exists",
          "This time slot is already held by another user",
        );
      }
    } else {
      transaction.set(holdRef, holdData);
    }

    // FIX PHANTOM READS (GRANULAR):
    // Serialize on the most specific entity to avoid store-wide bottleneck.
    // Staff doc → resource doc → store doc (fallback for no-staff-no-resource stores).
    // This multiplies throughput by number of bookable entities.
    const trackerTimestamp = new Date().getTime();

    if (allocation.finalStaffId) {
      // Lock at staff level — Alice's bookings won't block Bob's
      const staffRef = db.doc(`companies/${companyId}/stores/${storeId}/staff/${allocation.finalStaffId}`);
      transaction.set(staffRef, { _lastHoldTracker: trackerTimestamp }, { merge: true });
    } else if (allocation.assignedResourceId) {
      // Lock at resource level — Table 1 won't block Table 2
      const resourceRef = db.doc(`companies/${companyId}/stores/${storeId}/resources/${allocation.assignedResourceId}`);
      transaction.set(resourceRef, { _lastHoldTracker: trackerTimestamp }, { merge: true });
    } else {
      // Fallback: no staff, no resources → store-level (1 global slot stores)
      transaction.set(storeRef, { _lastHoldTracker: trackerTimestamp }, { merge: true });
    }

    return {
      success: true,
      holdId: allocation.holdId,
      expiresAt: expiresAt.toISOString(),
    };
  });
};
