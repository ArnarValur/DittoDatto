/**
 * Booking Panel — Shared Utilities
 *
 * Pure helper functions used across booking flow components.
 * Extracted from StandardBookingFlow and ReservationBookingFlow
 * to eliminate duplication.
 */

import type { OpeningSchedule } from './booking.types'

// ── Date Helpers ──────────────────────────────────────────────

export function isSameDay(a: Date, b: Date): boolean {
  return (
    a.getDate() === b.getDate() &&
    a.getMonth() === b.getMonth() &&
    a.getFullYear() === b.getFullYear()
  )
}

export function isToday(date: Date): boolean {
  return isSameDay(date, new Date())
}

export function formatDateShort(date: Date): string {
  return date.toLocaleDateString('en-US', { weekday: 'short' })
}

export function formatDateNum(date: Date): number {
  return date.getDate()
}

export function formatFullDate(date: Date): string {
  return date.toLocaleDateString('nb-NO', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

/**
 * Check if a given date falls on a closed day per the opening schedule.
 */
export function isDayClosed(date: Date, schedule?: OpeningSchedule): boolean {
  if (!schedule) return false
  const dayMap: Record<number, keyof OpeningSchedule> = {
    0: 'sun',
    1: 'mon',
    2: 'tue',
    3: 'wed',
    4: 'thu',
    5: 'fri',
    6: 'sat',
  }
  const dayKey = dayMap[date.getDay()]
  const day = schedule[dayKey]
  return !day?.isOpen
}

/**
 * Generate an array of the next N days starting from a base date.
 */
export function generateDateRange(baseDate: Date, days: number = 14): Date[] {
  const dates: Date[] = []
  const start = new Date(baseDate)
  for (let i = 0; i < days; i++) {
    const d = new Date(start)
    d.setDate(start.getDate() + i)
    dates.push(d)
  }
  return dates
}

// ── Format Helpers ────────────────────────────────────────────

export function formatDuration(minutes?: number): string {
  if (!minutes) return ''
  if (minutes < 60) return `${minutes} min`
  const h = Math.floor(minutes / 60)
  const m = minutes % 60
  return m > 0 ? `${h}h ${m}m` : `${h}h`
}

export function formatPrice(price?: number, currency?: string): string {
  if (price === undefined || price === null) return ''
  if (price === 0) return 'Free'
  return (
    new Intl.NumberFormat('nb-NO', {
      style: 'decimal',
      minimumFractionDigits: 2,
    }).format(price) +
    ' ' +
    (currency || 'NOK')
  )
}

export function formatPriceCurrency(price?: number, currency?: string): string {
  if (!price) return ''
  return new Intl.NumberFormat('nb-NO', {
    style: 'currency',
    currency: currency || 'NOK',
  }).format(price)
}
