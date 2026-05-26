// packages/functions/src/MercuryEngine/calculator.ts
// Core Domain: Booking Context - Time Tetris Algorithm
// Migrated from: .docs/project-context/BookingScripts/src/services/booking/business.ts

import { fetchAvailabilityData } from "../shared/data.js";
import { minutesToTime, isSlotInPast } from "../shared/time.js";
import { getAvailableStaffForSlot } from "../shared/staff-availability.js";
import { getAvailableResourcesForSlot } from "../shared/resource-availability.js";
import { buildAvailabilityContext } from "../shared/availability-context.js";
import type { AvailabilityContext } from "../shared/availability-context.js";

/**
 * MercuryEngine - Time Tetris Algorithm (Orchestrator)
 * 
 * Thin wrapper: fetch data → build context → calculate slots.
 * The actual logic is in calculateSlotsFromContext() (pure, testable).
 */
export const calculateSlots = async (
  companyId: string,
  storeId: string,
  date: string,
  serviceIds: string[],
  staffId?: string
) => {
  // 1. Fetch data (Firestore)
  const data = await fetchAvailabilityData(companyId, storeId, date, serviceIds, staffId);

  // 2. Build context (pure)
  const ctx = buildAvailabilityContext(data, date, staffId);

  // 3. Date window check — beyond bookable range?
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const maxDate = new Date(today);
  maxDate.setDate(maxDate.getDate() + ctx.policy.maxBookableFutureDays);
  const requestedDate = new Date(date + "T00:00:00");
  if (requestedDate > maxDate) {
    return [];
  }

  // 4. Calculate slots (pure)
  return calculateSlotsFromContext(ctx);
};

/**
 * MercuryEngine - Time Tetris Slot Loop (Pure Function)
 * 
 * Given a precomputed AvailabilityContext, generates all available time slots.
 * This function is PURE — zero side effects, zero Firestore.
 * 
 * @param ctx - Precomputed availability context from buildAvailabilityContext()
 * @returns Array of available time slots as strings (e.g., ["09:00", "09:15"])
 */
export const calculateSlotsFromContext = (ctx: AvailabilityContext): string[] => {
  const {
    schedule, openTime, closeTime, totalDuration, slotInterval,
    noticeCutoffMinutes, timeCtx, eligibleStaff, hasBookableStaff,
    staffOccupancy, storeOccupied, resourceOccupied,
    uniqueRequiredGroupIds, hasResourceRequirements,
    resources, resourceGroups,
  } = ctx;

  // Closed today — no slots
  if (!schedule || !schedule.isOpen) {
    return [];
  }

  // The Loop (Time Tetris)
  const slots: string[] = [];
  const step = slotInterval;
  let currentTime = openTime;

  while (currentTime + totalDuration <= closeTime) {
    const slotEnd = currentTime + totalDuration;

    // Notice check — skip slots too close to "now"
    if (isSlotInPast(currentTime, timeCtx, noticeCutoffMinutes)) {
      currentTime += step;
      continue;
    }

    let staffOk = true;

    if (hasBookableStaff) {
      // Get staff scheduled for this time
      const availableStaffIds = getAvailableStaffForSlot(
        eligibleStaff, ctx.date, currentTime, slotEnd,
      );

      // Are ANY of the scheduled staff free from conflicting bookings?
      let foundFreeStaff = false;
      for (const sId of availableStaffIds) {
        const occ = staffOccupancy.get(sId) || [];
        const isClashing = occ.some((o) => currentTime < o.end && slotEnd > o.start);

        if (!isClashing) {
          foundFreeStaff = true;
          break; // We only need 1 free staff member to offer the slot
        }
      }
      staffOk = foundFreeStaff;
    } else if (!hasResourceRequirements) {
      // No staff, no resources → Store-level capacity (1 global slot)
      const isClashing = storeOccupied.some(
        (occ) => currentTime < occ.end && slotEnd > occ.start,
      );
      staffOk = !isClashing;
    }

    // Resource check (additive)
    let resourceOk = true;
    if (staffOk && hasResourceRequirements) {
      const resourceResult = getAvailableResourcesForSlot(
        resources,
        resourceGroups,
        uniqueRequiredGroupIds,
        currentTime,
        slotEnd,
        resourceOccupied,
      );
      resourceOk = resourceResult.available;
    }

    if (staffOk && resourceOk) {
      slots.push(minutesToTime(currentTime));
    }

    currentTime += step;
  }

  return slots;
};
