/**
 * Appointments Routes (Standard Booking - 1:1)
 * 
 * Handles: Barbers, Dentists, etc.
 * Pattern: One customer, one time slot
 * 
 * 5-Phase Flow: Search → Hold → Pay → Confirm → Cleanup
 * 
 * Error handling: Domain functions throw HttpsError which the global
 * error handler (middleware/error-handler.ts) maps to HTTP status codes.
 */

import { Hono } from 'hono'
import {
    calculateSlots,
    createHold,
    createBookingFromHold,
    cancelBooking
} from '../core/bookings/index.js'
import { requireAuth } from '../middleware/auth.js'

// Define auth context variables for Hono
type AuthEnv = {
    Variables: {
        userId: string
        userName: string | undefined
        userEmail: string | undefined
    }
}

const app = new Hono<AuthEnv>()

/**
 * GET /appointments/slots
 * Phase 1: SEARCH — Get available booking slots for a store on a date
 */
app.get('/slots', async (c) => {
    const companyId = c.req.query('companyId')
    const storeId = c.req.query('storeId')
    const date = c.req.query('date')
    const serviceIds = c.req.query('serviceIds')?.split(',')
    const staffId = c.req.query('staffId') || undefined

    if (!companyId || !storeId || !date || !serviceIds?.length) {
        return c.json({
            error: 'Missing required fields: companyId, storeId, date, serviceIds'
        }, 400)
    }

    const slots = await calculateSlots(companyId, storeId, date, serviceIds, staffId)
    return c.json({
        date,
        availableSlots: slots,
    })
})

/**
 * POST /appointments/holds
 * Phase 2: HOLD — Create a hold on a time slot (10-min TTL)
 * PROTECTED: Requires Firebase Auth
 */
app.post('/holds', requireAuth, async (c) => {
    const body = await c.req.json()
    const { companyId, storeId, serviceIds, date, slotTime, staffId } = body

    // Get userId from verified auth token (set by middleware)
    const userId = c.get('userId')

    if (!companyId || !storeId || !date || !slotTime || !serviceIds) {
        return c.json({
            error: 'Missing required fields: companyId, storeId, date, slotTime, serviceIds'
        }, 400)
    }

    const result = await createHold(userId, companyId, storeId, serviceIds, date, slotTime, staffId)
    return c.json(result)
})

/**
 * POST /appointments/bookings
 * Phase 4: CONFIRM — Convert a hold into a confirmed booking
 * PROTECTED: Requires Firebase Auth
 */
app.post('/bookings', requireAuth, async (c) => {
    const body = await c.req.json()
    const { holdId, paymentId } = body

    if (!holdId || !paymentId) {
        return c.json({
            error: 'Missing required fields: holdId, paymentId'
        }, 400)
    }

    const result = await createBookingFromHold(holdId, paymentId)
    return c.json(result)
})

/**
 * POST /appointments/bookings/:bookingId/cancel
 * Phase 5: CANCEL — Cancel a confirmed or pending booking
 * PROTECTED: Requires Firebase Auth (Customer OR Company Admin)
 */
app.post('/bookings/:bookingId/cancel', requireAuth, async (c) => {
    const bookingId = c.req.param('bookingId')
    const userId = c.get('userId')
    
    let reason;
    try {
        const body = await c.req.json()
        reason = body.reason
    } catch (e) {
        // Keep reason undefined if no body was provided
    }

    if (!bookingId) {
        return c.json({
            error: 'Missing bookingId'
        }, 400)
    }

    const result = await cancelBooking(bookingId, userId, reason)
    return c.json(result)
})

export default app
