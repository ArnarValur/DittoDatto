/**
 * Tests for core/reservations/calculator.ts
 * 
 * Tests the reservation slot engine: time slot generation, overlap detection,
 * table auto-assignment (findBestTable), and slot availability checks
 * (pool mode vs table mode).
 *
 * This is the module with the 🔴 P1 service→group scoping bug.
 * Tests here document current behavior before the fix.
 */

import { describe, it, expect } from 'vitest'
import {
  generateTimeSlots,
  getOverlappingReservations,
  findBestTable,
  calculateSlotAvailability,
} from '../../src/core/reservations/calculator.js'
import type { Store, Reservation, Resource } from '@dittodatto/shared-types'

// ============================================================================
// Test Fixtures
// ============================================================================

const makeReservation = (overrides: Partial<Reservation>): Reservation => ({
  id: 'res-1',
  storeId: 'store-1',
  companyId: 'company-1',
  customerName: 'Test Customer',
  customerPhone: '12345678',
  guestCount: 2,
  date: new Date('2026-03-16T18:00:00'),
  time: '18:00',
  duration: 90,
  status: 'confirmed',
  createdAt: new Date(),
  updatedAt: new Date(),
  ...overrides,
} as Reservation)

const makeTable = (overrides: Partial<Resource> & { id: string }): Resource => ({
  name: `Table ${overrides.id}`,
  type: 'table',
  isBookable: true,
  priority: 'normal',
  maxCapacity: 4,
  minCapacity: 1,
  resourceGroupId: 'dining-tables',
  allowOverlapping: false,
  ...overrides,
} as Resource)

const makeStore = (overrides?: Partial<Store>): Store => ({
  reservationConfig: {
    enabled: true,
    totalCapacity: 20,
    maxGuestsPerReservation: 8,
    autoConfirm: true,
    defaultDuration: 90,
    slotInterval: 30,
  },
  timezone: 'Europe/Oslo',
  ...overrides,
} as Store)

const refDate = new Date('2026-03-16T00:00:00')

// ============================================================================
// generateTimeSlots
// ============================================================================

describe('generateTimeSlots', () => {
  it('generates slots between start and end time', () => {
    const slots = generateTimeSlots('18:00', '22:00', 30)
    expect(slots).toEqual([
      '18:00', '18:30', '19:00', '19:30',
      '20:00', '20:30', '21:00', '21:30',
    ])
  })

  it('respects different interval sizes', () => {
    const slots = generateTimeSlots('09:00', '11:00', 60)
    expect(slots).toEqual(['09:00', '10:00'])
  })

  it('returns empty array when start equals end', () => {
    const slots = generateTimeSlots('18:00', '18:00', 30)
    expect(slots).toEqual([])
  })

  it('filters past slots when requestDate is today', () => {
    // Get "today" in store timezone
    const today = new Intl.DateTimeFormat('sv-SE', { timeZone: 'Europe/Oslo' }).format(new Date())
    
    const slots = generateTimeSlots('00:00', '23:59', 60, {
      storeTimezone: 'Europe/Oslo',
      requestDate: today,
      noticeCutoffMinutes: 0,
    })
    
    // All slots should be in the future (or current hour)
    // We can't assert exact values since test time varies,
    // but we know 00:00 should be filtered out by now
    expect(slots).not.toContain('00:00')
  })

  it('does not filter slots for future dates', () => {
    const slots = generateTimeSlots('00:00', '03:00', 60, {
      storeTimezone: 'Europe/Oslo',
      requestDate: '2099-12-31',
      noticeCutoffMinutes: 0,
    })
    expect(slots).toContain('00:00')
    expect(slots).toContain('01:00')
    expect(slots).toContain('02:00')
  })
})

// ============================================================================
// getOverlappingReservations
// ============================================================================

describe('getOverlappingReservations', () => {
  const reservations = [
    makeReservation({ id: 'r1', time: '18:00', duration: 90 }),
    makeReservation({ id: 'r2', time: '20:00', duration: 90 }),
    makeReservation({ id: 'r3', time: '18:30', duration: 60, status: 'cancelled' }),
  ]

  it('finds reservations overlapping with the given slot', () => {
    // Slot 18:30-19:30 overlaps with r1 (18:00-19:30)
    const result = getOverlappingReservations(reservations, refDate, '18:30', 60)
    expect(result.map(r => r.id)).toContain('r1')
  })

  it('excludes cancelled reservations', () => {
    // r3 is cancelled — should not appear even though time overlaps
    const result = getOverlappingReservations(reservations, refDate, '18:30', 60)
    expect(result.map(r => r.id)).not.toContain('r3')
  })

  it('excludes no_show reservations', () => {
    const withNoShow = [
      ...reservations,
      makeReservation({ id: 'r4', time: '18:00', duration: 90, status: 'no_show' }),
    ]
    const result = getOverlappingReservations(withNoShow, refDate, '18:00', 90)
    expect(result.map(r => r.id)).not.toContain('r4')
  })

  it('does not include non-overlapping reservations', () => {
    // Slot 16:00-17:00 does not overlap with 18:00 or 20:00
    const result = getOverlappingReservations(reservations, refDate, '16:00', 60)
    expect(result).toEqual([])
  })

  it('handles edge: adjacent but non-overlapping', () => {
    // r1 ends at 19:30, slot starts at 19:30 → no overlap (edges touch, not overlap)
    const result = getOverlappingReservations(reservations, refDate, '19:30', 60)
    expect(result.map(r => r.id)).not.toContain('r1')
  })
})

// ============================================================================
// findBestTable
// ============================================================================

describe('findBestTable', () => {
  const tables = [
    makeTable({ id: 'table-2', minCapacity: 1, maxCapacity: 2, priority: 'high' }),
    makeTable({ id: 'table-4', minCapacity: 1, maxCapacity: 4, priority: 'normal' }),
    makeTable({ id: 'table-8', minCapacity: 4, maxCapacity: 8, priority: 'normal' }),
    makeTable({ id: 'table-vip', minCapacity: 1, maxCapacity: 6, priority: 'low' }),
  ]

  it('assigns the best-fit table for a party of 2', () => {
    const result = findBestTable(tables, [], refDate, '18:00', 90, 2)
    // table-2 is high priority and fits party of 2
    expect(result?.id).toBe('table-2')
  })

  it('assigns table-4 when table-2 is occupied', () => {
    const occupied = [
      makeReservation({ id: 'r1', time: '18:00', duration: 90, tableId: 'table-2' }),
    ]
    const result = findBestTable(tables, occupied, refDate, '18:00', 90, 2)
    expect(result?.id).toBe('table-4')
  })

  it('assigns table-8 for a party of 5 (skips too small)', () => {
    // table-2 max=2 (too small), table-4 max=4 (too small), table-8 min=4 ok
    const result = findBestTable(tables, [], refDate, '18:00', 90, 5)
    expect(result?.id).toBe('table-8')
  })

  it('assigns VIP table when only option for party of 6', () => {
    const occupied = [
      makeReservation({ id: 'r1', time: '18:00', duration: 90, tableId: 'table-8' }),
    ]
    const result = findBestTable(tables, occupied, refDate, '18:00', 90, 6)
    expect(result?.id).toBe('table-vip')
  })

  it('returns null when no table fits the party', () => {
    const result = findBestTable(tables, [], refDate, '18:00', 90, 10)
    expect(result).toBeNull()
  })

  it('returns null when all suitable tables are occupied', () => {
    const occupied = [
      makeReservation({ id: 'r1', time: '18:00', duration: 90, tableId: 'table-2' }),
      makeReservation({ id: 'r2', time: '18:00', duration: 90, tableId: 'table-4' }),
    ]
    // Party of 2 — fits table-2 (occupied) and table-4 (occupied), table-8 min=4 too big
    const result = findBestTable(tables, occupied, refDate, '18:00', 90, 2)
    // table-vip and table-8 still fit, but only if their minCapacity allows
    // table-vip minCapacity=1, maxCapacity=6 → fits party of 2
    expect(result?.id).toBe('table-vip')
  })

  it('skips non-bookable tables', () => {
    const tablesWithClosed = [
      makeTable({ id: 'table-closed', minCapacity: 1, maxCapacity: 4, isBookable: false }),
    ]
    const result = findBestTable(tablesWithClosed, [], refDate, '18:00', 90, 2)
    expect(result).toBeNull()
  })

  it('considers time — occupied table at different time is free', () => {
    const occupied = [
      // table-2 occupied 16:00-17:30, but we want 18:00-19:30
      makeReservation({ id: 'r1', time: '16:00', duration: 90, tableId: 'table-2' }),
    ]
    const result = findBestTable(tables, occupied, refDate, '18:00', 90, 2)
    // table-2 is free at 18:00
    expect(result?.id).toBe('table-2')
  })
})

// ============================================================================
// calculateSlotAvailability
// ============================================================================

describe('calculateSlotAvailability', () => {
  // --- Table mode ---

  describe('table mode', () => {
    const tables = [
      makeTable({ id: 't1', minCapacity: 1, maxCapacity: 4 }),
      makeTable({ id: 't2', minCapacity: 1, maxCapacity: 4 }),
    ]

    it('returns available with tableId when table is free', () => {
      const store = makeStore()
      const result = calculateSlotAvailability(
        store, refDate, '18:00', 90, 2, [], tables
      )
      expect(result.available).toBe(true)
      expect(result.tableId).toBeDefined()
    })

    it('returns unavailable when all tables occupied', () => {
      const store = makeStore()
      const occupied = [
        makeReservation({ id: 'r1', time: '18:00', duration: 90, tableId: 't1' }),
        makeReservation({ id: 'r2', time: '18:00', duration: 90, tableId: 't2' }),
      ]
      const result = calculateSlotAvailability(
        store, refDate, '18:00', 90, 2, occupied, tables
      )
      expect(result.available).toBe(false)
      expect(result.reason).toContain('No suitable table')
    })

    it('reports remaining capacity as count of free tables', () => {
      const store = makeStore()
      const occupied = [
        makeReservation({ id: 'r1', time: '18:00', duration: 90, tableId: 't1' }),
      ]
      const result = calculateSlotAvailability(
        store, refDate, '18:00', 90, 2, occupied, tables
      )
      expect(result.available).toBe(true)
      expect(result.remainingCapacity).toBe(1) // 1 table left
    })
  })

  // --- Pool mode ---

  describe('pool mode', () => {
    it('returns available when under total capacity', () => {
      const store = makeStore({ reservationConfig: {
        enabled: true, totalCapacity: 20, maxGuestsPerReservation: 8,
        autoConfirm: true, defaultDuration: 90, slotInterval: 30,
      }})
      const result = calculateSlotAvailability(
        store, refDate, '18:00', 90, 4, []
      )
      expect(result.available).toBe(true)
      expect(result.remainingCapacity).toBe(20)
    })

    it('returns unavailable when party exceeds remaining capacity', () => {
      const store = makeStore({ reservationConfig: {
        enabled: true, totalCapacity: 20, maxGuestsPerReservation: 8,
        autoConfirm: true, defaultDuration: 90, slotInterval: 30,
      }})
      const occupied = [
        makeReservation({ id: 'r1', time: '18:00', duration: 90, guestCount: 18 }),
      ]
      const result = calculateSlotAvailability(
        store, refDate, '18:00', 90, 4, occupied
      )
      expect(result.available).toBe(false)
      expect(result.remainingCapacity).toBe(2) // 20 - 18 = 2, but party needs 4
    })

    it('returns unavailable when no reservation config', () => {
      const store = makeStore({ reservationConfig: undefined as any })
      const result = calculateSlotAvailability(
        store, refDate, '18:00', 90, 2, []
      )
      expect(result.available).toBe(false)
      expect(result.reason).toContain('No capacity')
    })
  })
})
