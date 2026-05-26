/**
 * Server-side authentication utilities for Nitro API routes.
 * 
 * Usage in an API route:
 * ```ts
 * import { requireAuth, requireRole } from '~/server/utils/auth'
 * 
 * export default defineEventHandler(async (event) => {
 *   const user = await requireAuth(event)
 *   // user is now the decoded token
 * })
 * ```
 */
import type { H3Event } from 'h3'
import type { DecodedIdToken } from 'firebase-admin/auth'

/**
 * Extracts and verifies the Firebase ID token from the request.
 * Returns null if no valid token is present.
 */
export async function getAuthUser(event: H3Event): Promise<DecodedIdToken | null> {
    const { firebaseAdmin } = event.context

    if (!firebaseAdmin) {
        console.warn('[auth] Firebase Admin not initialized')
        return null
    }

    // Check for session cookie first (SSR), then Authorization header (API calls)
    const sessionCookie = getCookie(event, '__session')
    const authHeader = getHeader(event, 'Authorization')

    let token: string | undefined

    if (sessionCookie) {
        token = sessionCookie
    } else if (authHeader?.startsWith('Bearer ')) {
        token = authHeader.slice(7)
    }

    if (!token) {
        return null
    }

    try {
        // Verify the token
        const decodedToken = await firebaseAdmin.auth.verifyIdToken(token)
        return decodedToken
    } catch (error) {
        console.warn('[auth] Token verification failed:', (error as Error).message)
        return null
    }
}

/**
 * Requires authentication. Throws 401 if not authenticated.
 */
export async function requireAuth(event: H3Event): Promise<DecodedIdToken> {
    const user = await getAuthUser(event)

    if (!user) {
        throw createError({
            statusCode: 401,
            statusMessage: 'Unauthorized',
            message: 'Authentication required'
        })
    }

    return user
}

/**
 * Requires specific role(s). Throws 403 if role doesn't match.
 */
export async function requireRole(
    event: H3Event,
    allowedRoles: string | string[]
): Promise<DecodedIdToken> {
    const user = await requireAuth(event)
    const roles = Array.isArray(allowedRoles) ? allowedRoles : [allowedRoles]

    const userRole = user.role as string | undefined

    if (!userRole || !roles.includes(userRole)) {
        throw createError({
            statusCode: 403,
            statusMessage: 'Forbidden',
            message: `Required role: ${roles.join(' or ')}`
        })
    }

    return user
}

/**
 * Requires super_admin role. Throws 403 if not super_admin.
 */
export async function requireSuperAdmin(event: H3Event): Promise<DecodedIdToken> {
    return requireRole(event, 'super_admin')
}

/**
 * Requires company membership. Validates user has access to the specified company.
 */
export async function requireCompanyAccess(
    event: H3Event,
    companyId: string
): Promise<DecodedIdToken> {
    const user = await requireAuth(event)

    // Super admins have access to all companies
    if (user.role === 'super_admin') {
        return user
    }

    // Check single companyId claim (legacy)
    if (user.companyId === companyId) {
        return user
    }

    // Check companyIds array (multi-company)
    const companyIds = user.companyIds as string[] | undefined
    if (companyIds && companyIds.includes(companyId)) {
        return user
    }

    throw createError({
        statusCode: 403,
        statusMessage: 'Forbidden',
        message: 'No access to this company'
    })
}
