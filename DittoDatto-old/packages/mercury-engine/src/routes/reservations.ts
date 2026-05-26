/**
 * Reservations Routes (Capacity-Based Booking - 1:N)
 * 
 * Handles: Restaurants, Tables, Rooms, etc.
 * Pattern: One resource, multiple attendees
 * 
 * Error handling: Domain functions throw HttpsError which the global
 * error handler (middleware/error-handler.ts) maps to HTTP status codes.
 */

import { Hono } from 'hono'
import { requireAuth } from '../middleware/auth.js'
import { getReservationAvailability } from '../core/reservations/availability.js'
import { createReservation } from '../core/reservations/booking.js'

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
 * GET /reservations/availability
 * Get available tables/slots for a venue
 */
app.get('/availability', async (c) => {
    const companyId = c.req.query('companyId')
    const storeId = c.req.query('storeId')
    const date = c.req.query('date')
    const partySize = c.req.query('partySize')
    const serviceId = c.req.query('serviceId') // Optional: scopes tables to service's resource groups

    if (!companyId || !storeId || !date) {
        return c.json({
            error: 'Missing required fields: companyId, storeId, date'
        }, 400)
    }

    const result = await getReservationAvailability({
        companyId,
        storeId,
        date,
        partySize: parseInt(partySize as string),
        serviceId: serviceId || undefined,
    })
    return c.json({
        date,
        availableSlots: result.slots,
    })
})

/**
 * POST /reservations
 * Create a table reservation
 */
app.post('/', requireAuth, async (c) => {
    const body = await c.req.json()
    
    const { companyId, storeId, date, time, partySize, customerName, customerPhone, notes, serviceId } = body
    
    // Get userId from verified auth token
    const userId = c.get('userId')
    const customerEmail = c.get('userEmail')

    if (!companyId || !storeId || !date || !time || !partySize || !customerName) {
        return c.json({
            error: 'Missing required fields: companyId, storeId, date, time, partySize, customerName'
        }, 400)
    }

    const result = await createReservation({
        companyId,
        storeId,
        date,
        time,
        guestCount: parseInt(partySize),
        customerName,
        customerPhone,
        customerEmail: customerEmail || undefined,
        notes,
        userId,
        serviceId: serviceId || undefined,
    })
    return c.json({
        success: true,
        reservationId: result.reservationId,
    })
})

export default app
