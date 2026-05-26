// packages/functions/src/utils/time.ts
// Utility functions for time manipulation in MercuryEngine

/**
 * Get day name from ISO date string
 * @param dateStr - Date in YYYY-MM-DD format
 * @returns Day name as 'mon', 'tue', 'wed', etc.
 */
export const getDayName = (dateStr: string): string => {
  const date = new Date(dateStr);
  const days = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
  return days[date.getDay()];
};

/**
 * Convert ISO date string to minutes from midnight
 * @param isoStr - ISO date string
 * @returns Minutes since midnight
 */
export const minutesFromMidnight = (isoStr: string): number => {
  const date = new Date(isoStr);
  return date.getHours() * 60 + date.getMinutes();
};

/**
 * Convert minutes from midnight to time string
 * @param minutes - Minutes since midnight
 * @returns Time string in HH:MM format
 */
export const minutesToTime = (minutes: number): string => {
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  return `${h.toString().padStart(2, "0")}:${m.toString().padStart(2, "0")}`;
};

/**
 * Parse time string to minutes from midnight
 * @param timeStr - Time string in HH:MM format
 * @returns Minutes since midnight
 */
export const parseTime = (timeStr: string): number => {
  const [h, m] = timeStr.split(":").map(Number);
  return h * 60 + m;
};
