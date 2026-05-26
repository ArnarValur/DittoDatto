/**
 * Tests for the domain error system
 * 
 * Verifies HttpsError → HTTP status mapping and the global error handler middleware.
 */

import { describe, it, expect } from 'vitest'
import { HttpsError } from '../../src/core/shared/errors.js'

// ============================================================================
// HttpsError — Status Mapping
// ============================================================================

describe('HttpsError', () => {
  it('maps not-found to 404', () => {
    const err = new HttpsError('not-found', 'Store not found')
    expect(err.httpStatus).toBe(404)
    expect(err.code).toBe('not-found')
    expect(err.message).toBe('Store not found')
  })

  it('maps already-exists to 409', () => {
    const err = new HttpsError('already-exists', 'Hold already exists')
    expect(err.httpStatus).toBe(409)
  })

  it('maps failed-precondition to 400', () => {
    const err = new HttpsError('failed-precondition', 'Slot unavailable')
    expect(err.httpStatus).toBe(400)
  })

  it('maps permission-denied to 403', () => {
    const err = new HttpsError('permission-denied', 'Not your booking')
    expect(err.httpStatus).toBe(403)
  })

  it('maps resource-exhausted to 409', () => {
    const err = new HttpsError('resource-exhausted', 'No tables available')
    expect(err.httpStatus).toBe(409)
  })

  it('maps out-of-range to 400', () => {
    const err = new HttpsError('out-of-range', 'Party too large')
    expect(err.httpStatus).toBe(400)
  })

  it('maps unauthenticated to 401', () => {
    const err = new HttpsError('unauthenticated', 'No token')
    expect(err.httpStatus).toBe(401)
  })

  it('maps invalid-argument to 400', () => {
    const err = new HttpsError('invalid-argument', 'Missing fields')
    expect(err.httpStatus).toBe(400)
  })

  it('maps unknown codes to 500', () => {
    const err = new HttpsError('internal', 'Something broke')
    expect(err.httpStatus).toBe(500)
  })

  it('is an instance of Error', () => {
    const err = new HttpsError('not-found', 'Test')
    expect(err).toBeInstanceOf(Error)
    expect(err.name).toBe('HttpsError')
  })
})

// ============================================================================
// Error Handler Middleware — Integration
// ============================================================================

describe('errorHandler middleware', () => {
  // Import after mocks are set up by test-app
  // We test this via the Hono app directly
  it('returns correct status for HttpsError thrown in route', async () => {
    const { Hono } = await import('hono')
    const { errorHandler } = await import('../../src/middleware/error-handler.js')

    const app = new Hono()
    app.onError(errorHandler)

    // Routes that throw various HttpsErrors
    app.get('/not-found', () => {
      throw new HttpsError('not-found', 'Resource not found')
    })
    app.get('/forbidden', () => {
      throw new HttpsError('permission-denied', 'Access denied')
    })
    app.get('/conflict', () => {
      throw new HttpsError('already-exists', 'Duplicate')
    })
    app.get('/unknown', () => {
      throw new Error('Something unexpected')
    })

    // Test not-found → 404
    const res1 = await app.request('/not-found')
    expect(res1.status).toBe(404)
    const body1 = await res1.json() as { error: string }
    expect(body1.error).toBe('Resource not found')

    // Test permission-denied → 403
    const res2 = await app.request('/forbidden')
    expect(res2.status).toBe(403)
    const body2 = await res2.json() as { error: string }
    expect(body2.error).toBe('Access denied')

    // Test already-exists → 409
    const res3 = await app.request('/conflict')
    expect(res3.status).toBe(409)
    const body3 = await res3.json() as { error: string }
    expect(body3.error).toBe('Duplicate')

    // Test unhandled Error → 500 with generic message
    const res4 = await app.request('/unknown')
    expect(res4.status).toBe(500)
    const body4 = await res4.json() as { error: string }
    expect(body4.error).toBe('Internal server error')
  })
})
