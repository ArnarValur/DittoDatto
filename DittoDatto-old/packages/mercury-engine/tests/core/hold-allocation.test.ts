/**
 * Tests for resolveHoldAllocation (core/bookings/hold.ts)
 *
 * Pure function — validates staff concurrency, resource allocation,
 * and holdId composite key without touching Firestore.
 */

import { describe, it, expect } from 'vitest'
import { resolveHoldAllocation } from '../../src/core/bookings/hold.js'
import { buildAvailabilityContext } from '../../src/core/shared/availability-context.js'
import type { AvailabilityData } from '../../src/core/shared/availability-context.js'
import type { Store, Service, StaffMember, Resource, ResourceGroup } from '@dittodatto/shared-types'

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
  weeklyShifts: {
    mon: { isWorking: true, blocks: [{ start: '09:00', end: '17:00' }] },
    tue: { isWorking: true, blocks: [{ start: '09:00', end: '17:00' }] },
    wed: { isWorking: true, blocks: [{ start: '09:00', end: '17:00' }] },
    thu: { isWorking: true, blocks: [{ start: '09:00', end: '17:00' }] },
    fri: { isWorking: true, blocks: [{ start: '09:00', end: '17:00' }] },
    sat: { isWorking: false, blocks: [] },
    sun: { isWorking: false, blocks: [] },
  },
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

const MONDAY = '2099-03-16'

// ============================================================================
// Hold ID Composite Key
// ============================================================================

describe('resolveHoldAllocation — holdId', () => {
  it('generates holdId with storeId_date_time_userId when no staff/resources', () => {
    const ctx = buildAvailabilityContext(emptyData(), MONDAY)
    const result = resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123')

    expect(result.holdId).toBe('store-1_2099-03-16_10:00_user-123')
  })

  it('uses staffId as differentiator when staff is assigned', () => {
    const data = emptyData({ staff: [makeStaff()] })
    const ctx = buildAvailabilityContext(data, MONDAY)
    const result = resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123')

    expect(result.holdId).toBe('store-1_2099-03-16_10:00_staff-1')
    expect(result.finalStaffId).toBe('staff-1')
  })

  it('uses resourceId as differentiator when resource is assigned', () => {
    const resources: Resource[] = [{
      id: 'table-1',
      name: 'Table 1',
      type: 'table',
      resourceGroupId: 'rg-1',
      capacity: 4,
      isBookable: true,
      status: 'active',
    } as Resource]
    const resourceGroups: ResourceGroup[] = [{
      id: 'rg-1',
      name: 'Main Dining',
    } as ResourceGroup]
    const services = [makeService({ requiredResourceGroupIds: ['rg-1'] } as any)]

    const data = emptyData({ resources, resourceGroups, services })
    const ctx = buildAvailabilityContext(data, MONDAY)
    const result = resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123')

    expect(result.holdId).toBe('store-1_2099-03-16_10:00_table-1')
    expect(result.assignedResourceId).toBe('table-1')
  })
})

// ============================================================================
// Staff Concurrency
// ============================================================================

describe('resolveHoldAllocation — staff concurrency', () => {
  it('assigns the only available staff when one is busy', () => {
    const staff = [
      makeStaff({ id: 'alice' }),
      makeStaff({ id: 'bob' }),
    ]
    const bookings = [{
      staffId: 'alice',
      startTime: '2099-03-16T10:00:00',
      endTime: '2099-03-16T11:00:00',
      status: 'confirmed',
    }] as any[]

    const ctx = buildAvailabilityContext(
      emptyData({ staff, bookings }),
      MONDAY,
    )
    const result = resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123')

    // Alice busy at 10:00 → bob gets assigned
    expect(result.finalStaffId).toBe('bob')
  })

  it('throws when ALL staff are busy at requested time', () => {
    const staff = [makeStaff({ id: 'alice' })]
    const bookings = [{
      staffId: 'alice',
      startTime: '2099-03-16T10:00:00',
      endTime: '2099-03-16T11:00:00',
      status: 'confirmed',
    }] as any[]

    const ctx = buildAvailabilityContext(
      emptyData({ staff, bookings }),
      MONDAY,
    )

    expect(() =>
      resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123'),
    ).toThrow('This time slot is no longer available')
  })

  it('throws when requested specific staff is not eligible', () => {
    const staff = [makeStaff({ id: 'alice' })]
    const ctx = buildAvailabilityContext(
      emptyData({ staff }),
      MONDAY,
    )

    // Request staff 'bob' who doesn't exist in eligible list
    expect(() =>
      resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123', 'bob'),
    ).toThrow('Requested staff member cannot perform all selected services')
  })

  it('respects holds as occupied (not just bookings)', () => {
    const staff = [makeStaff({ id: 'alice' })]
    const holds = [{
      staffId: 'alice',
      slotTime: '10:00',
      duration: 60,
      date: MONDAY,
      storeId: 'store-1',
      expiresAt: new Date(Date.now() + 600000),
    }] as any[]

    const ctx = buildAvailabilityContext(
      emptyData({ staff, holds }),
      MONDAY,
    )

    expect(() =>
      resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123'),
    ).toThrow('This time slot is no longer available')
  })
})

// ============================================================================
// Store-Level Concurrency (no staff, no resources)
// ============================================================================

describe('resolveHoldAllocation — store-level concurrency', () => {
  it('allows booking when store is free', () => {
    const ctx = buildAvailabilityContext(emptyData(), MONDAY)
    const result = resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123')

    expect(result.holdId).toBeDefined()
    expect(result.totalDuration).toBe(60)
  })

  it('throws when store has overlapping booking', () => {
    const bookings = [{
      startTime: '2099-03-16T10:00:00',
      endTime: '2099-03-16T11:00:00',
      status: 'confirmed',
    }] as any[]

    const ctx = buildAvailabilityContext(
      emptyData({ bookings }),
      MONDAY,
    )

    expect(() =>
      resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123'),
    ).toThrow('This time slot is no longer available')
  })

  it('allows non-overlapping booking', () => {
    const bookings = [{
      startTime: '2099-03-16T10:00:00',
      endTime: '2099-03-16T11:00:00',
      status: 'confirmed',
    }] as any[]

    const ctx = buildAvailabilityContext(
      emptyData({ bookings }),
      MONDAY,
    )

    // 11:00 starts when previous ends — no overlap
    const result = resolveHoldAllocation(ctx, 'store-1', '11:00', 'user-123')
    expect(result.holdId).toBeDefined()
  })
})

// ============================================================================
// Edge Cases
// ============================================================================

describe('resolveHoldAllocation — edge cases', () => {
  it('sanitizes "undefined" string staffId', () => {
    const ctx = buildAvailabilityContext(emptyData(), MONDAY)
    // Pass literal "undefined" string (network serialization artifact)
    const result = resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123', 'undefined')

    // Should NOT throw — "undefined" gets converted to real undefined
    expect(result.holdId).toBe('store-1_2099-03-16_10:00_user-123')
  })

  it('sanitizes "null" string staffId', () => {
    const ctx = buildAvailabilityContext(emptyData(), MONDAY)
    const result = resolveHoldAllocation(ctx, 'store-1', '10:00', 'user-123', 'null')
    expect(result.holdId).toBe('store-1_2099-03-16_10:00_user-123')
  })
})
