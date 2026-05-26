/**
 * Tests for core/shared/availability-context.ts
 *
 * Pure function — tests the data preparation logic that was previously
 * duplicated between calculator.ts and hold.ts.
 */

import { describe, it, expect } from 'vitest'
import { buildAvailabilityContext } from '../../src/core/shared/availability-context.js'
import type { AvailabilityData } from '../../src/core/shared/availability-context.js'
import type { Store, Service, StaffMember, Booking, Hold, Resource, ResourceGroup } from '@dittodatto/shared-types'

// ============================================================================
// Fixtures
// ============================================================================

const makeStore = (overrides?: Partial<Store>): Store => ({
  openingSchedule: {
    mon: { isOpen: true, open: '09:00', close: '17:00' },
    tue: { isOpen: true, open: '09:00', close: '17:00' },
    wed: { isOpen: true, open: '09:00', close: '17:00' },
    thu: { isOpen: true, open: '09:00', close: '17:00' },
    fri: { isOpen: true, open: '09:00', close: '17:00' },
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
  slotInterval: 15,
  ...overrides,
} as Service)

const makeStaff = (overrides?: Partial<StaffMember>): StaffMember => ({
  id: 'staff-1',
  displayName: 'Alice',
  isBookable: true,
  status: 'active',
  storeIds: ['store-1'],
  ...overrides,
} as StaffMember)

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

// A Monday date for consistent testing
const MONDAY = '2026-03-16'

// ============================================================================
// Staff Normalization
// ============================================================================

describe('buildAvailabilityContext — staff normalization', () => {
  it('fills missing weeklyShifts from store opening hours', () => {
    const staff = makeStaff({ weeklyShifts: undefined })
    const ctx = buildAvailabilityContext(
      emptyData({ staff: [staff] }),
      MONDAY,
    )

    // Staff should have weeklyShifts injected
    const normalized = ctx.normalizedStaff[0]
    expect(normalized.weeklyShifts).toBeDefined()
    expect(normalized.weeklyShifts!.mon).toEqual({
      isWorking: true,
      blocks: [{ start: '09:00', end: '17:00' }],
    })
    // Weekends default to off
    expect(normalized.weeklyShifts!.sat.isWorking).toBe(false)
  })

  it('does not modify staff that already have weeklyShifts', () => {
    const shifts = {
      mon: { isWorking: true, blocks: [{ start: '10:00', end: '14:00' }] },
      tue: { isWorking: false, blocks: [] },
      wed: { isWorking: false, blocks: [] },
      thu: { isWorking: false, blocks: [] },
      fri: { isWorking: false, blocks: [] },
      sat: { isWorking: false, blocks: [] },
      sun: { isWorking: false, blocks: [] },
    }
    const staff = makeStaff({ weeklyShifts: shifts })
    const ctx = buildAvailabilityContext(
      emptyData({ staff: [staff] }),
      MONDAY,
    )

    expect(ctx.normalizedStaff[0].weeklyShifts!.mon.blocks).toEqual([
      { start: '10:00', end: '14:00' },
    ])
  })
})

// ============================================================================
// Staff-Service Assignment Filtering
// ============================================================================

describe('buildAvailabilityContext — staff-service filtering', () => {
  it('keeps all staff when services have no assignedStaff', () => {
    const staff = [
      makeStaff({ id: 's1' }),
      makeStaff({ id: 's2' }),
    ]
    const ctx = buildAvailabilityContext(
      emptyData({ staff }),
      MONDAY,
    )
    expect(ctx.eligibleStaff.map(s => s.id)).toEqual(['s1', 's2'])
  })

  it('filters to intersection when services have assignedStaff', () => {
    const staff = [
      makeStaff({ id: 's1' }),
      makeStaff({ id: 's2' }),
      makeStaff({ id: 's3' }),
    ]
    const services = [
      makeService({ id: 'svc-1', assignedStaff: ['s1', 's2'] as any }),
      makeService({ id: 'svc-2', assignedStaff: ['s2', 's3'] as any }),
    ]
    const ctx = buildAvailabilityContext(
      emptyData({ staff, services }),
      MONDAY,
    )
    // Only s2 is eligible for BOTH services
    expect(ctx.eligibleStaff.map(s => s.id)).toEqual(['s2'])
  })

  it('narrows to specific staffId when provided', () => {
    const staff = [
      makeStaff({ id: 's1' }),
      makeStaff({ id: 's2' }),
    ]
    const ctx = buildAvailabilityContext(
      emptyData({ staff }),
      MONDAY,
      's1', // staffId filter
    )
    expect(ctx.eligibleStaff.map(s => s.id)).toEqual(['s1'])
  })
})

// ============================================================================
// Policy Derivation
// ============================================================================

describe('buildAvailabilityContext — policy derivation', () => {
  it('uses max notice across services', () => {
    const services = [
      makeService({ id: 'svc-1', minBookingNoticeMinutes: 30 } as any),
      makeService({ id: 'svc-2', minBookingNoticeMinutes: 60 } as any),
    ]
    const ctx = buildAvailabilityContext(
      emptyData({ services }),
      MONDAY,
    )
    expect(ctx.noticeCutoffMinutes).toBe(60)
  })

  it('uses min slot interval across services', () => {
    const services = [
      makeService({ id: 'svc-1', slotInterval: 30 } as any),
      makeService({ id: 'svc-2', slotInterval: 15 } as any),
    ]
    const ctx = buildAvailabilityContext(
      emptyData({ services }),
      MONDAY,
    )
    expect(ctx.slotInterval).toBe(15)
  })

  it('sums total duration from all services', () => {
    const services = [
      makeService({ id: 'svc-1', duration: 30 }),
      makeService({ id: 'svc-2', duration: 45 }),
    ]
    const ctx = buildAvailabilityContext(
      emptyData({ services }),
      MONDAY,
    )
    expect(ctx.totalDuration).toBe(75)
  })
})

// ============================================================================
// Resource Group Extraction
// ============================================================================

describe('buildAvailabilityContext — resource groups', () => {
  it('extracts and deduplicates required resource group IDs', () => {
    const services = [
      makeService({ id: 'svc-1', requiredResourceGroupIds: ['rg-1', 'rg-2'] } as any),
      makeService({ id: 'svc-2', requiredResourceGroupIds: ['rg-2', 'rg-3'] } as any),
    ]
    const ctx = buildAvailabilityContext(
      emptyData({ services }),
      MONDAY,
    )
    expect(ctx.uniqueRequiredGroupIds.sort()).toEqual(['rg-1', 'rg-2', 'rg-3'])
    expect(ctx.hasResourceRequirements).toBe(true)
  })

  it('sets hasResourceRequirements false when no groups required', () => {
    const ctx = buildAvailabilityContext(emptyData(), MONDAY)
    expect(ctx.hasResourceRequirements).toBe(false)
    expect(ctx.uniqueRequiredGroupIds).toEqual([])
  })
})

// ============================================================================
// Schedule
// ============================================================================

describe('buildAvailabilityContext — schedule', () => {
  it('parses open/close times for the day', () => {
    const ctx = buildAvailabilityContext(emptyData(), MONDAY)
    expect(ctx.openTime).toBe(540)  // 09:00
    expect(ctx.closeTime).toBe(1020) // 17:00
    expect(ctx.schedule?.isOpen).toBe(true)
  })

  it('returns null schedule for closed days', () => {
    // Saturday = closed in our fixture
    const ctx = buildAvailabilityContext(emptyData(), '2026-03-21') // Saturday
    expect(ctx.schedule?.isOpen).toBe(false)
  })
})

// ============================================================================
// Occupancy Maps
// ============================================================================

describe('buildAvailabilityContext — occupancy', () => {
  it('builds store-level occupied intervals', () => {
    const bookings = [{
      startTime: '2026-03-16T10:00:00',
      endTime: '2026-03-16T11:00:00',
      status: 'confirmed',
    }] as Booking[]

    const ctx = buildAvailabilityContext(
      emptyData({ bookings }),
      MONDAY,
    )
    expect(ctx.storeOccupied).toHaveLength(1)
    expect(ctx.storeOccupied[0].start).toBe(600) // 10:00
    expect(ctx.storeOccupied[0].end).toBe(660)   // 11:00
  })

  it('builds per-staff occupancy when staff exist', () => {
    const staff = [makeStaff({ id: 'staff-1' })]
    const bookings = [{
      staffId: 'staff-1',
      startTime: '2026-03-16T14:00:00',
      endTime: '2026-03-16T15:00:00',
      status: 'confirmed',
    }] as Booking[]

    const ctx = buildAvailabilityContext(
      emptyData({ staff, bookings }),
      MONDAY,
    )
    expect(ctx.staffOccupancy.get('staff-1')).toHaveLength(1)
    expect(ctx.staffOccupancy.get('staff-1')![0].start).toBe(840) // 14:00
  })
})
