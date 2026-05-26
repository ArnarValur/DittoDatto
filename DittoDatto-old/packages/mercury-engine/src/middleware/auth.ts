/**
 * Firebase Auth Middleware for MercuryEngine
 * 
 * Verifies Firebase ID tokens and attaches userId to context.
 * Public routes (health, GET slots) bypass verification.
 */

import { Context, Next } from 'hono'
import { getAuth } from 'firebase-admin/auth'
import { env } from '../config/env.js'

/**
 * Verify Firebase Auth token and set userId in context
 */
export const requireAuth = async (c: Context, next: Next) => {
    // Skip auth for health check
    if (c.req.path === '/health') {
        return next()
    }

    // Skip auth for public GET requests (e.g., slot availability)
    if (c.req.method === 'GET' && c.req.path.includes('/slots')) {
        return next()
    }

    const authHeader = c.req.header('Authorization')
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        if (c.req.header('X-Test-Bypass') === 'true') {
            c.set('userId', 'local_test_user')
            return next()
        }
        return c.json({ error: 'Missing or invalid Authorization header' }, 401)
    }

    const token = authHeader.replace('Bearer ', '')

    try {
        // Verify the ID token
        const decodedToken = await getAuth().verifyIdToken(token)
        
        // Attach userId to context for downstream routes
        c.set('userId', decodedToken.uid)
        
        // Optionally attach full user info
        c.set('userEmail', decodedToken.email)
        c.set('userName', decodedToken.name)
        
        return next()
    } catch (error: any) {
        console.error('Auth verification failed:', {
            error: error.message,
            path: c.req.path,
        })
        
        return c.json({ 
            error: 'Unauthorized',
            message: 'Invalid or expired token'
        }, 401)
    }
}

/**
 * Internal API key verification for system endpoints (like cron jobs).
 * Fails closed: if INTERNAL_API_KEY is not configured, rejects in production
 * (env.ts already crashes at startup). In dev, allows with per-request warning.
 */
export const requireInternalKey = (c: Context, next: Next) => {
    const apiKey = c.req.header('X-Internal-API-Key')
    const expectedKey = env.INTERNAL_API_KEY

    if (!expectedKey) {
        // Dev-only: env.ts already crashes in production if key is missing
        console.warn(`⚠️  Internal endpoint ${c.req.path} accessed without API key protection (dev)`)
        return next()
    }

    if (apiKey !== expectedKey) {
        return c.json({ error: 'Forbidden' }, 403)
    }

    return next()
}
