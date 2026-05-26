
import { 
  Store, 
  Reservation, 
  Resource,
} from "@dittodatto/shared-types";
import { addMinutes, format, parse, isBefore, isAfter } from "date-fns";
import { getStoreNow, isSlotInPast, parseTime } from "../shared/time.js";

/**
 * Generates time slots between start and end time with given interval.
 * Filters out past slots when the requested date is today (store-local TZ).
 * @param startTime "HH:mm"
 * @param endTime "HH:mm"
 * @param intervalMinutes number
 * @param options.storeTimezone IANA timezone for past-time filter (default: 'Europe/Oslo')
 * @param options.requestDate "YYYY-MM-DD" — date being requested, used to detect "today"
 * @param options.noticeCutoffMinutes minutes of notice required (default: 0)
 */
export function generateTimeSlots(
  startTime: string, 
  endTime: string, 
  intervalMinutes: number,
  options?: {
    storeTimezone?: string;
    requestDate?: string;
    noticeCutoffMinutes?: number;
  }
): string[] {
  const slots: string[] = [];
  const referenceDate = new Date();
  
  let current = parse(startTime, "HH:mm", referenceDate);
  const end = parse(endTime, "HH:mm", referenceDate);

  // Use shared timezone-aware time context
  const timeCtx = getStoreNow(
    options?.storeTimezone || 'Europe/Oslo',
    options?.requestDate || '',
  );
  const noticeCutoff = options?.noticeCutoffMinutes || 0;

  while (isBefore(current, end)) {
    const timeStr = format(current, "HH:mm");

    // Filter past slots using shared utility
    const slotMinutes = parseTime(timeStr);
    if (isSlotInPast(slotMinutes, timeCtx, noticeCutoff)) {
      current = addMinutes(current, intervalMinutes);
      continue;
    }

    slots.push(timeStr);
    current = addMinutes(current, intervalMinutes);
  }

  return slots;
}

// ---------------------------------------------------------------------------
// Overlap helper — shared between pool check and per-table check
// ---------------------------------------------------------------------------

/**
 * Returns active reservations that overlap with [slotTime, slotTime + duration).
 * Filters out cancelled and no_show reservations.
 */
export function getOverlappingReservations(
  existingReservations: Reservation[],
  date: Date,
  slotTime: string,
  durationMinutes: number,
): Reservation[] {
  const slotStart = parse(slotTime, "HH:mm", date);
  const slotEnd = addMinutes(slotStart, durationMinutes);

  return existingReservations.filter(res => {
    if (res.status === "cancelled" || res.status === "no_show") return false;
    const resStart = parse(res.time, "HH:mm", date);
    const resEnd = addMinutes(resStart, res.duration);
    return isBefore(resStart, slotEnd) && isAfter(resEnd, slotStart);
  });
}

// ---------------------------------------------------------------------------
// Table auto-assignment — best-fit algorithm
// ---------------------------------------------------------------------------

/**
 * Priority numeric mapping (higher = preferred first).
 */
const PRIORITY_ORDER: Record<string, number> = { high: 3, normal: 2, low: 1 };

/**
 * Find the best available table for a party.
 *
 * Algorithm:
 *  1. Filter tables by capacity: minCapacity ≤ partySize ≤ maxCapacity
 *  2. Exclude tables that already have an overlapping reservation
 *  3. Sort by: priority DESC → maxCapacity ASC (smallest suitable table first)
 *  4. Return the first match or null
 */
export function findBestTable(
  tables: Resource[],
  existingReservations: Reservation[],
  date: Date,
  slotTime: string,
  durationMinutes: number,
  partySize: number,
): Resource | null {
  const overlapping = getOverlappingReservations(
    existingReservations, date, slotTime, durationMinutes,
  );

  // Set of tableIds that are occupied in this time window
  const occupiedTableIds = new Set(
    overlapping
      .map(r => r.tableId)
      .filter((id): id is string => !!id),
  );

  // Candidate tables: fits capacity AND not occupied
  const candidates = tables.filter(t => {
    if (!t.isBookable) return false;
    if (t.minCapacity > partySize || t.maxCapacity < partySize) return false;
    if (occupiedTableIds.has(t.id)) return false;
    return true;
  });

  if (candidates.length === 0) return null;

  // Sort: highest priority first, then smallest maxCapacity (best-fit)
  candidates.sort((a, b) => {
    const pa = PRIORITY_ORDER[a.priority] ?? 2;
    const pb = PRIORITY_ORDER[b.priority] ?? 2;
    if (pa !== pb) return pb - pa;        // highest priority first
    return a.maxCapacity - b.maxCapacity;  // smallest table first
  });

  return candidates[0];
}

// ---------------------------------------------------------------------------
// Slot availability — auto-detects pool vs table mode
// ---------------------------------------------------------------------------

/**
 * Checks if a specific slot has capacity.
 *
 * Mode detection:
 *  - If `tableResources` is provided and non-empty → per-table mode.
 *    Available only if findBestTable() finds a suitable table.
 *  - Otherwise → pool mode (sum guests vs totalCapacity).
 */
export function calculateSlotAvailability(
  store: Store,
  date: Date,
  slotTime: string,
  durationMinutes: number,
  partySize: number,
  existingReservations: Reservation[],
  tableResources?: Resource[],
): { available: boolean; remainingCapacity: number; reason?: string; tableId?: string } {
  const config = store.reservationConfig;

  // ---- Table mode (auto-detected: store has table resources) ----
  if (tableResources && tableResources.length > 0) {
    const bestTable = findBestTable(
      tableResources, existingReservations, date, slotTime, durationMinutes, partySize,
    );

    if (bestTable) {
      // remainingCapacity = number of *other* tables that could still seat this party
      const overlapping = getOverlappingReservations(existingReservations, date, slotTime, durationMinutes);
      const occupiedIds = new Set(overlapping.map(r => r.tableId).filter(Boolean));
      const freeTablesForParty = tableResources.filter(
        t => t.isBookable && t.minCapacity <= partySize && t.maxCapacity >= partySize && !occupiedIds.has(t.id),
      ).length;

      return {
        available: true,
        remainingCapacity: freeTablesForParty, // how many tables still fit this party size
        tableId: bestTable.id,
      };
    }

    return {
      available: false,
      remainingCapacity: 0,
      reason: "No suitable table available for this party size and time",
    };
  }

  // ---- Pool mode (original behavior) ----
  if (!config || !config.totalCapacity) {
    return { available: false, remainingCapacity: 0, reason: "No capacity configuration" };
  }

  const overlapping = getOverlappingReservations(existingReservations, date, slotTime, durationMinutes);
  const currentGuests = overlapping.reduce((sum, res) => sum + res.guestCount, 0);
  const remaining = config.totalCapacity - currentGuests;
  
  if (remaining >= partySize) {
    return { available: true, remainingCapacity: remaining };
  } else {
    return { available: false, remainingCapacity: remaining, reason: "Capacity exceeded" };
  }
}

