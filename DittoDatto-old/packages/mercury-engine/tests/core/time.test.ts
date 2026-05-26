/**
 * Tests for core/shared/time.ts
 * 
 * Pure functions — zero dependencies, zero mocking needed.
 * These are the foundation of the engine's time handling.
 */

import { describe, it, expect } from 'vitest'
import {
  getDayName,
  minutesFromMidnight,
  minutesToTime,
  parseTime,
  getStoreNow,
  isSlotInPast,
} from '../../src/core/shared/time.js'

// ============================================================================
// getDayName
// ============================================================================

describe('getDayName', () => {
  it('returns correct day for known dates', () => {
    // 2026-03-14 is a Saturday
    expect(getDayName('2026-03-14')).toBe('sat')
    // 2026-03-15 is a Sunday
    expect(getDayName('2026-03-15')).toBe('sun')
    // 2026-03-16 is a Monday
    expect(getDayName('2026-03-16')).toBe('mon')
  })

  it('handles month boundaries correctly', () => {
    // 2026-02-28 is a Saturday
    expect(getDayName('2026-02-28')).toBe('sat')
    // 2026-03-01 is a Sunday
    expect(getDayName('2026-03-01')).toBe('sun')
  })

  it('handles year boundaries correctly', () => {
    // 2025-12-31 is a Wednesday
    expect(getDayName('2025-12-31')).toBe('wed')
    // 2026-01-01 is a Thursday
    expect(getDayName('2026-01-01')).toBe('thu')
  })

  it('uses UTC to avoid timezone day-shift', () => {
    // Key scenario: midnight UTC dates should not shift to prev/next day.
    // The implementation uses Date.UTC + getUTCDay specifically to avoid this.
    expect(getDayName('2026-03-09')).toBe('mon')
  })
})

// ============================================================================
// parseTime
// ============================================================================

describe('parseTime', () => {
  it('parses HH:MM to minutes from midnight', () => {
    expect(parseTime('00:00')).toBe(0)
    expect(parseTime('09:00')).toBe(540)
    expect(parseTime('09:15')).toBe(555)
    expect(parseTime('12:00')).toBe(720)
    expect(parseTime('23:59')).toBe(1439)
  })

  it('handles single-digit hours', () => {
    // parseTime splits on ":", so "9:00" works too
    expect(parseTime('9:00')).toBe(540)
  })
})

// ============================================================================
// minutesToTime
// ============================================================================

describe('minutesToTime', () => {
  it('converts minutes to HH:MM format', () => {
    expect(minutesToTime(0)).toBe('00:00')
    expect(minutesToTime(540)).toBe('09:00')
    expect(minutesToTime(555)).toBe('09:15')
    expect(minutesToTime(720)).toBe('12:00')
    expect(minutesToTime(1439)).toBe('23:59')
  })

  it('is the inverse of parseTime', () => {
    const times = ['00:00', '09:00', '09:15', '12:30', '18:45', '23:59']
    for (const time of times) {
      expect(minutesToTime(parseTime(time))).toBe(time)
    }
  })
})

// ============================================================================
// minutesFromMidnight
// ============================================================================

describe('minutesFromMidnight', () => {
  it('converts timezone-naive local time string to minutes', () => {
    // "2026-03-14T09:00:00" in Europe/Oslo should be 09:00 = 540 minutes
    // Note: this is timezone-sensitive — will use Intl.DateTimeFormat
    const result = minutesFromMidnight('2026-03-14T09:00:00', 'Europe/Oslo')
    expect(result).toBe(540)
  })

  it('converts midnight correctly', () => {
    const result = minutesFromMidnight('2026-03-14T00:00:00', 'Europe/Oslo')
    expect(result).toBe(0)
  })

  it('defaults to Europe/Oslo timezone', () => {
    const withExplicit = minutesFromMidnight('2026-03-14T12:00:00', 'Europe/Oslo')
    const withDefault = minutesFromMidnight('2026-03-14T12:00:00')
    expect(withExplicit).toBe(withDefault)
  })
})

// ============================================================================
// getStoreNow
// ============================================================================

describe('getStoreNow', () => {
  it('returns isToday=false for future dates', () => {
    const ctx = getStoreNow('Europe/Oslo', '2099-12-31')
    expect(ctx.isToday).toBe(false)
    expect(ctx.storeNowMinutes).toBe(0) // not today → 0
  })

  it('returns isToday=false for past dates', () => {
    const ctx = getStoreNow('Europe/Oslo', '2020-01-01')
    expect(ctx.isToday).toBe(false)
    expect(ctx.storeNowMinutes).toBe(0)
  })

  it('returns isToday=true for today', () => {
    // Get today's date in Europe/Oslo timezone
    const today = new Intl.DateTimeFormat('sv-SE', { timeZone: 'Europe/Oslo' }).format(new Date())
    const ctx = getStoreNow('Europe/Oslo', today)
    expect(ctx.isToday).toBe(true)
    expect(ctx.storeNowMinutes).toBeGreaterThan(0) // unless running at midnight
  })

  it('defaults to Europe/Oslo when empty string', () => {
    const ctx = getStoreNow('', '2099-12-31')
    expect(ctx.isToday).toBe(false) // just verifying it doesn't crash
  })
})

// ============================================================================
// isSlotInPast
// ============================================================================

describe('isSlotInPast', () => {
  it('returns false when not today', () => {
    const ctx = { isToday: false, storeNowMinutes: 600 }
    // Even if slot is at 09:00 (540) and "now" is 10:00 (600), not today → not past
    expect(isSlotInPast(540, ctx, 0)).toBe(false)
  })

  it('returns true when slot is before now (no notice)', () => {
    const ctx = { isToday: true, storeNowMinutes: 600 } // 10:00
    // Slot at 09:00 (540) with 0 notice → 540 - 600 = -60 < 0 → past
    expect(isSlotInPast(540, ctx, 0)).toBe(true)
  })

  it('returns false when slot is after now (no notice)', () => {
    const ctx = { isToday: true, storeNowMinutes: 600 } // 10:00
    // Slot at 11:00 (660) with 0 notice → 660 - 600 = 60 >= 0 → not past
    expect(isSlotInPast(660, ctx, 0)).toBe(false)
  })

  it('enforces notice cutoff', () => {
    const ctx = { isToday: true, storeNowMinutes: 600 } // 10:00
    // Slot at 10:30 (630) with 60 min notice → 630 - 600 = 30 < 60 → past
    expect(isSlotInPast(630, ctx, 60)).toBe(true)
    // Slot at 11:15 (675) with 60 min notice → 675 - 600 = 75 >= 60 → ok
    expect(isSlotInPast(675, ctx, 60)).toBe(false)
  })

  it('handles edge case: slot exactly at notice boundary', () => {
    const ctx = { isToday: true, storeNowMinutes: 600 } // 10:00
    // Slot at 11:00 (660) with 60 min notice → 660 - 600 = 60, NOT < 60 → not past
    expect(isSlotInPast(660, ctx, 60)).toBe(false)
  })
})
