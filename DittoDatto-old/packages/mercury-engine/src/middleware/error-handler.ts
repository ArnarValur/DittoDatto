/**
 * MercuryEngine — Global Error Handler
 * 
 * Hono onError middleware that catches HttpsError thrown by domain logic
 * and maps it to the correct HTTP status code automatically.
 * 
 * This replaces ~60 lines of duplicated try/catch across route files.
 */

import type { ErrorHandler } from 'hono'
import { HttpsError } from '../core/shared/errors.js'

export const errorHandler: ErrorHandler = (err, c) => {
  if (err instanceof HttpsError) {
    return c.json({ error: err.message }, err.httpStatus as any)
  }

  // Unexpected error — log full stack, expose nothing to client
  console.error('Unhandled error:', {
    message: err.message,
    stack: err.stack,
    path: c.req.path,
    method: c.req.method,
  })
  return c.json({ error: 'Internal server error' }, 500)
}
