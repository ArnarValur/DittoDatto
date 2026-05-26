/**
 * Tests for pure functions extracted from booking.ts:
 * - buildBookingReceipt: snapshot/receipt construction
 * - checkCancellationPolicy: policy enforcement
 */

import { describe, it, expect } from 'vitest'
import { buildBookingReceipt, checkCancellationPolicy } from '../../src/core/bookings/booking.js'
import type { BookingReceiptInput, CancellationCheckInput } from '../../src/core/bookings/booking.js'
import type { Hold, Service } from '@dittodatto/shared-types'

// ============================================================================
// Fixtures
// ============================================================================

const makeHold = (overrides?: Partial<Hold>): Hold => ({
  id: 'store-1_2099-03-16_10:00_user-123',
  userId: 'user-123',
  companyId: 'company-1',
  storeId: 'store-1',
  serviceIds: ['svc-1'],
  date: '2099-03-16',
  slotTime: '10:00',
  duration: 60,
  expiresAt: new Date(Date.now() + 600000) as any,
  createdAt: new Date() as any,
  ...overrides,
} as Hold)

const makeService = (overrides?: Partial<Service & { id: string }>): Service & { id: string } => ({
  id: 'svc-1',
  title: 'Haircut',
  duration: 60,
  price: 500,
  currency: 'NOK',
  ...overrides,
} as Service & { id: string })

const defaultInput = (): BookingReceiptInput => ({
  hold: makeHold(),
  services: [makeService()],
  userName: 'John Doe',
  userEmail: 'john@example.com',
  storeName: 'Cool Barbers',
  paymentId: 'pay_abc123',
})

// ============================================================================
// buildBookingReceipt
// ============================================================================

describe('buildBookingReceipt', () => {
  it('creates a booking with correct identity fields', () => {
    const result = buildBookingReceipt(defaultInput())

    expect(result.id).toBe('pay_abc123')
    expect(result.userId).toBe('user-123')
    expect(result.companyId).toBe('company-1')
    expect(result.storeId).toBe('store-1')
    expect(result.serviceId).toBe('svc-1')
    expect(result.status).toBe('confirmed')
  })

  it('aggregates price and duration from multiple services', () => {
    const input = defaultInput()
    input.hold = makeHold({ serviceIds: ['svc-1', 'svc-2'] })
    input.services = [
      makeService({ id: 'svc-1', title: 'Haircut', duration: 30, price: 300 }),
      makeService({ id: 'svc-2', title: 'Beard Trim', duration: 15, price: 150 }),
    ]

    const result = buildBookingReceipt(input)

    expect(result.duration).toBe(45)
    expect(result.priceAtTimeOfBooking).toBe(450)
    expect(result.serviceTitle).toBe('Haircut, Beard Trim')
  })

  it('calculates correct start and end times', () => {
    const result = buildBookingReceipt(defaultInput())

    expect(result.startTime).toBe('2099-03-16T10:00:00')
    expect(result.endTime).toBe('2099-03-16T11:00:00')
  })

  it('handles slot times that cross hour boundaries', () => {
    const input = defaultInput()
    input.hold = makeHold({ slotTime: '10:45' })
    input.services = [makeService({ duration: 90 })]

    const result = buildBookingReceipt(input)

    expect(result.startTime).toBe('2099-03-16T10:45:00')
    expect(result.endTime).toBe('2099-03-16T12:15:00')
  })

  it('builds items array with one entry per service', () => {
    const input = defaultInput()
    input.hold = makeHold({ serviceIds: ['svc-1', 'svc-2'], staffId: 'staff-1' })
    input.services = [
      makeService({ id: 'svc-1', title: 'Haircut' }),
      makeService({ id: 'svc-2', title: 'Wash' }),
    ]

    const result = buildBookingReceipt(input)

    expect(result.items).toHaveLength(2)
    expect(result.items[0].serviceId).toBe('svc-1')
    expect(result.items[0].staffId).toBe('staff-1')
    expect(result.items[1].serviceId).toBe('svc-2')
  })

  it('includes staffId when hold has staff', () => {
    const input = defaultInput()
    input.hold = makeHold({ staffId: 'staff-alice' })

    const result = buildBookingReceipt(input)
    expect(result.staffId).toBe('staff-alice')
  })

  it('omits staffId when hold has no staff', () => {
    const result = buildBookingReceipt(defaultInput())
    expect(result.staffId).toBeUndefined()
  })

  it('attaches storeName for downstream notifications', () => {
    const result = buildBookingReceipt(defaultInput())
    expect(result.storeName).toBe('Cool Barbers')
  })

  it('trims notes and omits if empty', () => {
    const input = defaultInput()
    input.notes = '  No allergies  '
    const result = buildBookingReceipt(input)
    expect(result.notes).toBe('No allergies')

    const input2 = defaultInput()
    input2.notes = '   '
    const result2 = buildBookingReceipt(input2)
    expect(result2.notes).toBeUndefined()
  })

  it('falls back to legacy serviceId when serviceIds array is missing', () => {
    const input = defaultInput()
    input.hold = makeHold({ serviceIds: undefined as any, serviceId: 'legacy-svc' } as any)

    const result = buildBookingReceipt(input)
    expect(result.serviceId).toBe('legacy-svc')
  })
})

// ============================================================================
// checkCancellationPolicy
// ============================================================================

describe('checkCancellationPolicy', () => {
  it('allows cancellation when policy permits', () => {
    expect(() => checkCancellationPolicy({
      bookingStartTime: '2099-03-16T14:00:00',
      policy: { clientCancelEnabled: true, minCancelNoticeHours: 0 },
    })).not.toThrow()
  })

  it('throws when client cancel is disabled', () => {
    expect(() => checkCancellationPolicy({
      bookingStartTime: '2099-03-16T14:00:00',
      policy: { clientCancelEnabled: false, minCancelNoticeHours: 0 },
    })).toThrow('does not allow customer cancellations')
  })

  it('allows cancellation before notice deadline', () => {
    const bookingStart = new Date('2099-03-16T14:00:00')
    const now = new Date('2099-03-16T10:00:00') // 4 hours before

    expect(() => checkCancellationPolicy({
      bookingStartTime: bookingStart,
      policy: { clientCancelEnabled: true, minCancelNoticeHours: 2 },
      now,
    })).not.toThrow()
  })

  it('throws when past cancellation deadline', () => {
    const bookingStart = new Date('2099-03-16T14:00:00')
    const now = new Date('2099-03-16T13:00:00') // Only 1 hour before, policy requires 2

    expect(() => checkCancellationPolicy({
      bookingStartTime: bookingStart,
      policy: { clientCancelEnabled: true, minCancelNoticeHours: 2 },
      now,
    })).toThrow('Cancellation deadline has passed')
  })

  it('allows cancellation exactly at deadline', () => {
    const bookingStart = new Date('2099-03-16T14:00:00')
    const now = new Date('2099-03-16T12:00:00') // Exactly 2 hours before

    expect(() => checkCancellationPolicy({
      bookingStartTime: bookingStart,
      policy: { clientCancelEnabled: true, minCancelNoticeHours: 2 },
      now,
    })).not.toThrow()
  })

  it('handles string booking start time', () => {
    expect(() => checkCancellationPolicy({
      bookingStartTime: '2099-03-16T14:00:00',
      policy: { clientCancelEnabled: true, minCancelNoticeHours: 2 },
      now: new Date('2099-03-16T10:00:00'),
    })).not.toThrow()
  })
})
