/**
 * MercuryEngine - Booking Engine Microservice
 * 
 * Cloud Run compatible HTTP server using Hono.
 * Handles: Appointments, Reservations, and Ticketing
 */

// Config validation first — crashes immediately if env vars are invalid
import { env } from './config/env.js'

import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { logger } from 'hono/logger'

// Import routes
import appointments from './routes/appointments.js'
import reservations from './routes/reservations.js'
import ticketing from './routes/ticketing.js'
import cleanup from './routes/cleanup.js'
import { errorHandler } from './middleware/error-handler.js'

// Initialize Firebase Admin (will use FIRESTORE_EMULATOR_HOST in dev)
import './config/firebase.js'

const app = new Hono()

// Middleware
app.use('*', logger())
app.use('*', cors({
    origin: (origin) => {
        const allowed = [
            'http://localhost:3000',
            'http://localhost:3001',
            'http://localhost:3002',
        ]
        if (allowed.includes(origin)) return origin
        if (/^https:\/\/(.*\.)?dittodatto\.no$/.test(origin)) return origin
        return ''
    },
    allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowHeaders: ['Content-Type', 'Authorization'],
}))

// Global error handler — maps HttpsError to HTTP status codes
app.onError(errorHandler)

// Health check (required for Cloud Run)
app.get('/health', (c) => c.json({
    status: 'ok',
    service: 'mercury-engine',
    version: '0.2.0',
    timestamp: new Date().toISOString()
}))

// Mount routes
app.route('/appointments', appointments)
app.route('/reservations', reservations)
app.route('/tickets', ticketing)
app.route('/cleanup', cleanup)

// Root endpoint
app.get('/', (c) => c.json({
    name: 'MercuryEngine',
    description: 'Booking Engine for DittoDatto',
    endpoints: {
        appointments: '/appointments/*',
        reservations: '/reservations/*',
        tickets: '/tickets/*',
        cleanup: '/cleanup/*',
        health: '/health'
    }
}))

// Start server
console.log(`🚀 MercuryEngine starting on port ${env.PORT}`)
console.log(`   Environment: ${env.NODE_ENV}`)

if (env.FIRESTORE_EMULATOR_HOST) {
    console.log(`   Firestore Emulator: ${env.FIRESTORE_EMULATOR_HOST}`)
}

serve({
    fetch: app.fetch,
    port: env.PORT,
    hostname: '0.0.0.0',
})

console.log(`✅ MercuryEngine ready at http://localhost:${env.PORT}`)

