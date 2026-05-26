/**
 * MercuryEngine — Domain Error System
 * 
 * Centralized error types used across all booking domains.
 * HttpsError carries both a Firebase-compatible code AND an HTTP status,
 * so the global error handler can map it without per-route try/catch.
 */

/** Maps Firebase-style error codes to HTTP status codes */
const STATUS_MAP: Record<string, number> = {
  'not-found': 404,
  'already-exists': 409,
  'failed-precondition': 400,
  'permission-denied': 403,
  'resource-exhausted': 409,
  'out-of-range': 400,
  'unauthenticated': 401,
  'invalid-argument': 400,
}

/**
 * HTTP-style error compatible with Firebase Functions HttpsError codes.
 * Used by domain logic to signal specific failure modes.
 * The global Hono error handler reads `httpStatus` to set the response code.
 */
export class HttpsError extends Error {
  public readonly httpStatus: number

  constructor(public code: string, message: string) {
    super(message)
    this.name = 'HttpsError'
    this.httpStatus = STATUS_MAP[code] ?? 500
  }
}
