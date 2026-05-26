/**
 * Tests for calculateSlotsFromContext (core/bookings/calculator.ts)
 *
 * Tests the pure slot loop extracted from calculateSlots().
 * No Firestore — context is built manually.
 */

import { describe, it, expect } from 'vitest'
import { calculateSlotsFromContext } from '../../src/core/bookings/calculator.js'
import { buildAvailabilityContext } from '../../src/core/shared/availability-context.js'
import type { AvailabilityData } from '../../src/core/shared/availability-context.js'
import type { Store, Service, StaffMember } from '@dittodatto/shared-types'

// ============================================================================
// Fixtures
// ============================================================================

const makeStore = (overrides?: Partial<Store>): Store => ({
  openingSchedule: {
    mon: { isOpen: true, open: '09:00', close: '12:00' },
    tue: { isOpen: true, open: '09:00', close: '12:00' },
    wed: { isOpen: true, open: '09:00', close: '12:00' },
    thu: { isOpen: true, open: '09:00', close: '12:00' },
    fri: { isOpen: true, open: '09:00', close: '12:00' },
    sat: { isOpen: false, open: '', close: '' },
    sun: { isOpen: false, open: '', close: '' },
  },
  timezone: 'Europe/Oslo',
  bookingPolicy: {},
  ...overrides,
} as Store)

const makeService = (overrides?: Partial<Service>): Service => ({
  id: 'svc-1',
  title: 'Haircut',
  duration: 60,
  price: 500,
  currency: 'NOK',
  minBookingNoticeMinutes: 0,
  slotInterval: 30,
  ...overrides,
} as Service)

const emptyData = (overrides?: Partial<AvailabilityData>): AvailabilityData => ({
  store: makeStore(),
  bookings: [],
  holds: [],
  services: [makeService()],
  staff: [],
  resources: [],
  resourceGroups: [],
  ...overrides,
})

// Far-future date so notice checks never filter
const FUTURE_MONDAY = '2099-03-16'

// ============================================================================
// Basic Slot Generation
// ============================================================================

describe('calculateSlotsFromContext — basic', () => {
  it('generates slots for an open day with no bookings', () => {
    const ctx = buildAvailabilityContext(emptyData(), FUTURE_MONDAY)
    const slots = calculateSlotsFromContext(ctx)

    // Store open 09:00-12:00, service is 60min, interval 30min
    // Possible starts: 09:00, 09:30, 10:00, 10:30, 11:00
    // (11:30 + 60 = 12:30 > 12:00, so no)
    expect(slots).toEqual(['09:00', '09:30', '10:00', '10:30', '11:00'])
  })

  it('returns empty for a closed day', () => {
    // Saturday is closed in our fixture
    const ctx = buildAvailabilityContext(emptyData(), '2099-03-22') // a Saturday
    const slots = calculateSlotsFromContext(ctx)

    expect(slots).toEqual([])
  })

  it('respects different slot intervals', () => {
    const data = emptyData({
      services: [makeService({ slotInterval: 60 } as any)],
    })
    const ctx = buildAvailabilityContext(data, FUTURE_MONDAY)
    const slots = calculateSlotsFromContext(ctx)

    // 60-min interval: 09:00, 10:00, 11:00
    expect(slots).toEqual(['09:00', '10:00', '11:00'])
  })
})

// ============================================================================
// Store-Level Concurrency (no staff, no resources)
// ============================================================================

describe('calculateSlotsFromContext — store-level fallback', () => {
  it('blocks slots with existing bookings', () => {
    const data = emptyData({
      bookings: [{
        startTime: '2099-03-16T10:00:00',
        endTime: '2099-03-16T11:00:00',
        status: 'confirmed',
      }] as any[],
    })
    const ctx = buildAvailabilityContext(data, FUTURE_MONDAY)
    const slots = calculateSlotsFromContext(ctx)

    // Booking at 10:00-11:00 blocks: 09:30 (end 10:30 overlaps), 10:00 (direct), 10:30 (start inside)
    expect(slots).not.toContain('10:00')
    // 09:00 should be available (09:00-10:00, no overlap with 10:00-11:00)
    expect(slots).toContain('09:00')
    // 11:00 should be available (11:00-12:00, starts at booking end)
    expect(slots).toContain('11:00')
  })

  it('blocks slots with active holds', () => {
    const data = emptyData({
      holds: [{
        slotTime: '09:00',
        duration: 60,
        date: '2099-03-16',
        storeId: 'store-1',
        expiresAt: new Date(Date.now() + 60000), // still active
      }] as any[],
    })
    const ctx = buildAvailabilityContext(data, FUTURE_MONDAY)
    const slots = calculateSlotsFromContext(ctx)

    expect(slots).not.toContain('09:00')
  })
})

// ============================================================================
// Staff-Aware Slots
// ============================================================================

describe('calculateSlotsFromContext — staff-aware', () => {
  const staffWithShifts: StaffMember = {
    id: 'staff-1',
    displayName: 'Alice',
    isBookable: true,
    status: 'active',
    storeIds: ['store-1'],
    weeklyShifts: {
      mon: { isWorking: true, blocks: [{ start: '09:00', end: '12:00' }] },
      tue: { isWorking: false, blocks: [] },
      wed: { isWorking: false, blocks: [] },
      thu: { isWorking: false, blocks: [] },
      fri: { isWorking: false, blocks: [] },
      sat: { isWorking: false, blocks: [] },
      sun: { isWorking: false, blocks: [] },
    },
  } as StaffMember

  it('generates slots based on staff working hours', () => {
    const data = emptyData({ staff: [staffWithShifts] })
    const ctx = buildAvailabilityContext(data, FUTURE_MONDAY)
    const slots = calculateSlotsFromContext(ctx)

    // Staff works 09:00-12:00, service 60min, interval 30min
    expect(slots).toEqual(['09:00', '09:30', '10:00', '10:30', '11:00'])
  })

  it('blocks slot when staff has a booking', () => {
    const data = emptyData({
      staff: [staffWithShifts],
      bookings: [{
        staffId: 'staff-1',
        startTime: '2099-03-16T09:00:00',
        endTime: '2099-03-16T10:00:00',
        status: 'confirmed',
      }] as any[],
    })
    const ctx = buildAvailabilityContext(data, FUTURE_MONDAY)
    const slots = calculateSlotsFromContext(ctx)

    // 09:00 and 09:30 should be blocked (overlap with 09:00-10:00)
    expect(slots).not.toContain('09:00')
    expect(slots).not.toContain('09:30')
    // 10:00+ should be free
    expect(slots).toContain('10:00')
  })

  it('slots available if ANY staff member is free', () => {
    const staff2: StaffMember = {
      ...staffWithShifts,
      id: 'staff-2',
      displayName: 'Bob',
    }
    const data = emptyData({
      staff: [staffWithShifts, staff2],
      bookings: [{
        staffId: 'staff-1',
        startTime: '2099-03-16T09:00:00',
        endTime: '2099-03-16T10:00:00',
        status: 'confirmed',
      }] as any[],
    })
    const ctx = buildAvailabilityContext(data, FUTURE_MONDAY)
    const slots = calculateSlotsFromContext(ctx)

    // Staff-1 blocked at 09:00, but staff-2 is free → slot available
    expect(slots).toContain('09:00')
  })
})
