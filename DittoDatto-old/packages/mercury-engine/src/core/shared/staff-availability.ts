// packages/mercury-engine/src/core/staff-availability.ts
// Core Domain: Booking Context - Staff Availability Logic
// Pure functions — no Firestore dependency, fully testable.
// Mirror of: packages/functions/src/MercuryEngine/staff-availability.ts

import type { StaffMember } from "@dittodatto/shared-types";

type DayKey = "mon" | "tue" | "wed" | "thu" | "fri" | "sat" | "sun";

const DAY_KEYS: DayKey[] = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];

/**
 * Parse "HH:MM" to minutes from midnight.
 */
const parseTime = (timeStr: string): number => {
  const [h, m] = timeStr.split(":").map(Number);
  return h * 60 + m;
};

/**
 * Get the day key (mon, tue, ...) for a given YYYY-MM-DD date string.
 */
export const getDayKey = (dateStr: string): DayKey => {
  const date = new Date(dateStr + "T12:00:00Z"); // noon UTC to avoid TZ edge
  return DAY_KEYS[date.getUTCDay()];
};

/**
 * Check if a specific staff member is available for a given time slot on a given date.
 *
 * Resolution order:
 *   1. dateOverrides (off/sick → unavailable, custom → check custom blocks)
 *   2. weeklyShifts (isWorking + blocks check)
 *   3. No schedule data → unavailable (fail-closed)
 */
export const isStaffAvailable = (
  staff: StaffMember,
  dateStr: string,
  slotStartMinutes: number,
  slotEndMinutes: number
): boolean => {
  if (!staff.isBookable || staff.status !== "active") return false;

  // 1. Check date overrides first (highest priority)
  const override = staff.dateOverrides?.find((o) => o.date === dateStr);
  if (override) {
    if (override.type === "off" || override.type === "sick") return false;
    if (override.type === "custom" && override.blocks) {
      return fitsWithinBlocks(override.blocks, slotStartMinutes, slotEndMinutes);
    }
    return false;
  }

  // 2. Check weekly shift pattern
  const dayKey = getDayKey(dateStr);
  const dayShift = staff.weeklyShifts?.[dayKey];

  if (!dayShift || !dayShift.isWorking) return false;
  if (!dayShift.blocks || dayShift.blocks.length === 0) return false;

  return fitsWithinBlocks(dayShift.blocks, slotStartMinutes, slotEndMinutes);
};

/**
 * Check if a time slot fits entirely within at least one shift block.
 */
const fitsWithinBlocks = (
  blocks: { start: string; end: string }[],
  slotStart: number,
  slotEnd: number
): boolean => {
  return blocks.some((block) => {
    const blockStart = parseTime(block.start);
    const blockEnd = parseTime(block.end);
    return slotStart >= blockStart && slotEnd <= blockEnd;
  });
};

/**
 * Filter staff to those available for a given slot.
 */
export const getAvailableStaffForSlot = (
  staff: StaffMember[],
  dateStr: string,
  slotStartMinutes: number,
  slotEndMinutes: number
): string[] => {
  return staff
    .filter((s) => isStaffAvailable(s, dateStr, slotStartMinutes, slotEndMinutes))
    .map((s) => s.id);
};
