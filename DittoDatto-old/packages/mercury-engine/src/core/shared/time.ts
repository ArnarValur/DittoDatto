/**
 * Time utility functions for MercuryEngine
 * Pure functions, zero dependencies.
 */

/**
 * Get day name from ISO date string
 * @param dateStr - Date in YYYY-MM-DD format
 * @returns Day name as 'mon', 'tue', 'wed', etc.
 */
export const getDayName = (dateStr: string): string => {
  // Parse YYYY-MM-DD manually to avoid timezone interpretation issues.
  // new Date('2026-03-09') is UTC midnight; getDay() in local TZ could return wrong day.
  const [year, month, day] = dateStr.split('-').map(Number)
  const date = new Date(Date.UTC(year, month - 1, day))
  const days = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']
  return days[date.getUTCDay()]
}

/**
 * Convert ISO date string or Date to minutes from midnight in a specific timezone
 * @param input - ISO date string or Date object
 * @param timezone - IANA timezone string (default: 'Europe/Oslo')
 * @returns Minutes since midnight
 */
export const minutesFromMidnight = (input: string | Date, timezone: string = 'Europe/Oslo'): number => {
    const date = typeof input === 'string' ? new Date(input) : input

    const parts = new Intl.DateTimeFormat('en-GB', {
      timeZone: timezone, hour: '2-digit', minute: '2-digit', hour12: false,
    }).formatToParts(date)

    const h = Number(parts.find(p => p.type === 'hour')?.value || 0)
    const m = Number(parts.find(p => p.type === 'minute')?.value || 0)

    return h * 60 + m
}

/**
 * Convert minutes from midnight to time string
 * @param minutes - Minutes since midnight
 * @returns Time string in HH:MM format
 */
export const minutesToTime = (minutes: number): string => {
  const h = Math.floor(minutes / 60)
  const m = minutes % 60
  return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}`
}

/**
 * Parse time string to minutes from midnight
 * @param timeStr - Time string in HH:MM format
 * @returns Minutes since midnight
 */
export const parseTime = (timeStr: string): number => {
  const [h, m] = timeStr.split(':').map(Number)
  return h * 60 + m
}

// ============================================================================
// Timezone-aware time context (shared by both calculators)
// ============================================================================

export interface StoreTimeContext {
  /** Whether the requested date matches "today" in the store's local timezone */
  isToday: boolean
  /** Current time in the store's timezone, as minutes from midnight */
  storeNowMinutes: number
}

/**
 * Get timezone-aware "now" context for a store.
 * Used by both the appointment and reservation calculators.
 *
 * @param storeTimezone IANA timezone (e.g., 'Europe/Oslo')
 * @param requestDate  The date being requested, "YYYY-MM-DD"
 */
export const getStoreNow = (storeTimezone: string, requestDate: string): StoreTimeContext => {
  const tz = storeTimezone || 'Europe/Oslo'
  const now = new Date()

  // "Today" in the store's timezone (sv-SE locale gives YYYY-MM-DD)
  const storeToday = new Intl.DateTimeFormat('sv-SE', { timeZone: tz }).format(now)
  const isToday = storeToday === requestDate

  let storeNowMinutes = 0
  if (isToday) {
    const parts = new Intl.DateTimeFormat('en-GB', {
      timeZone: tz, hour: '2-digit', minute: '2-digit', hour12: false,
    }).formatToParts(now)
    const h = Number(parts.find(p => p.type === 'hour')?.value || 0)
    const m = Number(parts.find(p => p.type === 'minute')?.value || 0)
    storeNowMinutes = h * 60 + m
  }

  return { isToday, storeNowMinutes }
}

/**
 * Check if a slot (in minutes from midnight) is too close to "now".
 * Returns true if the slot should be EXCLUDED.
 *
 * @param slotMinutes       Slot start as minutes from midnight
 * @param ctx               StoreTimeContext from getStoreNow()
 * @param noticeCutoffMin   Minimum notice required (minutes)
 */
export const isSlotInPast = (
  slotMinutes: number,
  ctx: StoreTimeContext,
  noticeCutoffMin: number,
): boolean => {
  if (!ctx.isToday) return false
  return slotMinutes - ctx.storeNowMinutes < noticeCutoffMin
}
