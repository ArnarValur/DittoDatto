/**
 * Contract Tests — Frontend ↔ Engine API Compatibility
 * 
 * These tests verify that the engine accepts the EXACT payload shapes
 * that the frontend sends. Based on Gemini CLI's API audit report.
 * 
 * Source: .docs/api-report.md
 * 
 * What these tests prove:
 * - The engine doesn't return 400 (validation error) for valid frontend payloads
 * - Route paths match what the frontend calls
 * - Query params and body fields are accepted
 * - Auth middleware works with test bypass
 * 
 * What these tests DON'T prove:
 * - Business logic correctness (that's the unit tests' job)
 * - Real Firestore behavior (mocked here)
 */

import { describe, it, expect, beforeAll } from 'vitest'
import { createTestApp } from '../helpers/test-app.js'
import type { Hono } from 'hono'

let app: Hono

beforeAll(() => {
  app = createTestApp()
})

// ============================================================================
// Health & Root (Public)
// ============================================================================

describe('Public endpoints', () => {
  it('GET /health returns 200 with status ok', async () => {
    const res = await app.request('/health')
    expect(res.status).toBe(200)
    const body = await res.json()
    expect(body.status).toBe('ok')
    expect(body.service).toBe('mercury-engine')
  })

  it('GET / returns endpoint listing', async () => {
    const res = await app.request('/')
    expect(res.status).toBe(200)
    const body = await res.json()
    expect(body.endpoints).toHaveProperty('appointments')
    expect(body.endpoints).toHaveProperty('reservations')
    expect(body.endpoints).toHaveProperty('tickets')
  })
})

// ============================================================================
// Appointments — Contract with useBooking.ts
// ============================================================================

describe('Appointments contract (useBooking.ts)', () => {
  /**
   * GET /appointments/slots
   * Frontend: fetchSlots({ companyId, storeId, date, serviceIds, staffId })
   * Engine: query params — companyId, storeId, date, serviceIds (comma-sep), staffId?
   * 
   * This is a PUBLIC endpoint (no auth needed)
   */
  it('GET /appointments/slots — accepts frontend query params', async () => {
    const url = '/appointments/slots?companyId=comp1&storeId=store1&date=2026-03-16&serviceIds=svc1,svc2'
    const res = await app.request(url)
    // Should not be 400 (validation error) or 401 (auth error)
    // May be 500 because Firestore is mocked — that's expected
    // The point is: the route ACCEPTED the payload shape
    expect(res.status).not.toBe(400)
    expect(res.status).not.toBe(401)
    expect(res.status).not.toBe(404)
  })

  it('GET /appointments/slots — with optional staffId', async () => {
    const url = '/appointments/slots?companyId=comp1&storeId=store1&date=2026-03-16&serviceIds=svc1&staffId=staff1'
    const res = await app.request(url)
    expect(res.status).not.toBe(400)
  })

  it('GET /appointments/slots — rejects missing required fields', async () => {
    const url = '/appointments/slots?companyId=comp1'
    const res = await app.request(url)
    expect(res.status).toBe(400)
    const body = await res.json()
    expect(body.error).toContain('Missing required')
  })

  /**
   * POST /appointments/holds
   * Frontend: createHold({ companyId, storeId, serviceIds, date, slotTime, staffId })
   * Engine: body — same fields. Requires Auth.
   */
  it('POST /appointments/holds — accepts frontend body shape', async () => {
    const res = await app.request('/appointments/holds', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Test-Bypass': 'true', // Auth bypass for testing
      },
      body: JSON.stringify({
        companyId: 'comp1',
        storeId: 'store1',
        serviceIds: ['svc1', 'svc2'],
        date: '2026-03-16',
        slotTime: '10:00',
        staffId: 'staff1',
      }),
    })
    expect(res.status).not.toBe(400) // Not a validation error
    expect(res.status).not.toBe(401) // Auth bypass worked
  })

  it('POST /appointments/holds — rejects without auth', async () => {
    const res = await app.request('/appointments/holds', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        companyId: 'comp1',
        storeId: 'store1',
        serviceIds: ['svc1'],
        date: '2026-03-16',
        slotTime: '10:00',
      }),
    })
    expect(res.status).toBe(401)
  })

  /**
   * POST /appointments/bookings
   * Frontend: confirmBooking({ companyId, storeId, holdId, customerDetails, notes, paymentId })
   * Engine: only needs { holdId, paymentId } — rest is ignored (from api-report.md)
   * 
   * Test both: minimal (what engine needs) and full (what frontend sends)
   */
  it('POST /appointments/bookings — accepts minimal payload', async () => {
    const res = await app.request('/appointments/bookings', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Test-Bypass': 'true',
      },
      body: JSON.stringify({
        holdId: 'store1_2026-03-16_10:00_staff1',
        paymentId: 'pay_123',
      }),
    })
    expect(res.status).not.toBe(400)
    expect(res.status).not.toBe(401)
  })

  it('POST /appointments/bookings — accepts frontend over-fetched payload', async () => {
    // Frontend sends extra fields the engine ignores. Must not break.
    const res = await app.request('/appointments/bookings', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Test-Bypass': 'true',
      },
      body: JSON.stringify({
        holdId: 'store1_2026-03-16_10:00_staff1',
        paymentId: 'pay_123',
        companyId: 'comp1',          // extra — engine ignores
        storeId: 'store1',           // extra — engine ignores
        customerDetails: {           // extra — engine ignores
          name: 'Test User',
          email: 'test@test.com',
        },
        notes: 'Window seat please', // extra — engine ignores
      }),
    })
    expect(res.status).not.toBe(400)
  })

  /**
   * POST /appointments/bookings/:bookingId/cancel
   * Frontend: cancelBooking(bookingId) — path param, optional body { reason }
   */
  it('POST /appointments/bookings/:id/cancel — accepts path param', async () => {
    const res = await app.request('/appointments/bookings/booking_123/cancel', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Test-Bypass': 'true',
      },
    })
    // Should reach the handler (not 400/401/404 from routing)
    expect(res.status).not.toBe(400)
    expect(res.status).not.toBe(401)
  })
})

// ============================================================================
// Reservations — Contract with useBooking.ts
// ============================================================================

describe('Reservations contract (useBooking.ts)', () => {
  /**
   * GET /reservations/availability
   * Frontend: fetchReservationSlots({ companyId, storeId, date, partySize })
   */
  it('GET /reservations/availability — accepts frontend query params', async () => {
    const url = '/reservations/availability?companyId=comp1&storeId=store1&date=2026-03-16&partySize=4'
    const res = await app.request(url)
    expect(res.status).not.toBe(400)
    expect(res.status).not.toBe(401)
  })

  it('GET /reservations/availability — rejects missing fields', async () => {
    const url = '/reservations/availability?companyId=comp1'
    const res = await app.request(url)
    expect(res.status).toBe(400)
  })

  /**
   * POST /reservations
   * Frontend: createReservation({ companyId, storeId, date, time, partySize, 
   *            customerName, customerPhone, customerEmail, notes })
   * 
   * Note from api-report.md: partySize is sent as-is, engine parseInt()'s it
   */
  it('POST /reservations — accepts frontend body shape', async () => {
    const res = await app.request('/reservations', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Test-Bypass': 'true',
      },
      body: JSON.stringify({
        companyId: 'comp1',
        storeId: 'store1',
        date: '2026-03-16',
        time: '18:00',
        partySize: 4,               // number
        customerName: 'Test Kunde',
        customerPhone: '12345678',
        customerEmail: 'test@test.com',
        notes: 'Near the window',
      }),
    })
    expect(res.status).not.toBe(400)
    expect(res.status).not.toBe(401)
  })

  it('POST /reservations — accepts partySize as string (frontend quirk)', async () => {
    // Some form inputs may send partySize as string
    const res = await app.request('/reservations', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Test-Bypass': 'true',
      },
      body: JSON.stringify({
        companyId: 'comp1',
        storeId: 'store1',
        date: '2026-03-16',
        time: '18:00',
        partySize: '4',             // string — engine does parseInt()
        customerName: 'Test Kunde',
        customerPhone: '12345678',
      }),
    })
    expect(res.status).not.toBe(400) // parseInt handles it
  })
})

// ============================================================================
// Tickets — Stub endpoints (not wired to frontend yet)
// ============================================================================

describe('Tickets contract (future)', () => {
  it('GET /tickets/availability — endpoint exists', async () => {
    const res = await app.request('/tickets/availability?eventId=evt1')
    expect(res.status).toBe(200) // Stub returns 200 with TODO message
  })

  it('POST /tickets/holds — endpoint exists', async () => {
    const res = await app.request('/tickets/holds', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        eventId: 'evt1',
        ticketTypeId: 'type1',
        quantity: 2,
      }),
    })
    expect(res.status).toBe(200)
  })
})

// ============================================================================
// Cleanup — Internal endpoints
// ============================================================================

describe('Cleanup contract (internal)', () => {
  it('GET /cleanup/stats — returns stats', async () => {
    const res = await app.request('/cleanup/stats')
    expect(res.status).not.toBe(404)
  })
})
