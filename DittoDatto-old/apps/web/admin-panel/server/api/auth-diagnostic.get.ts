/**
 * Auth Session Diagnostic Endpoint
 * 
 * GET /api/auth-diagnostic
 * 
 * Reports the state of the auth pipeline:
 * - Is the __session cookie present?
 * - Is Firebase Admin SDK initialized?
 * - Can the token be verified?
 * 
 * Use this to verify the cookie flow is working before manual testing.
 */
export default defineEventHandler(async (event) => {
  const sessionCookie = getCookie(event, '__session')
  const hasAdmin = !!event.context.firebaseAdmin

  const diagnostic: Record<string, unknown> = {
    timestamp: new Date().toISOString(),
    app: 'admin-panel',
    sessionCookiePresent: !!sessionCookie,
    sessionCookieLength: sessionCookie?.length ?? 0,
    firebaseAdminInitialized: hasAdmin,
    tokenVerification: null as string | null,
    userId: null as string | null,
    claims: null as Record<string, unknown> | null
  }

  if (sessionCookie && hasAdmin) {
    try {
      const decoded = await event.context.firebaseAdmin!.auth.verifyIdToken(sessionCookie)
      diagnostic.tokenVerification = 'SUCCESS'
      diagnostic.userId = decoded.uid
      diagnostic.claims = {
        role: decoded.role ?? null,
        companyId: decoded.companyId ?? null,
        companyIds: decoded.companyIds ?? null,
        email: decoded.email ?? null
      }
    } catch (err) {
      diagnostic.tokenVerification = `FAILED: ${(err as Error).message}`
    }
  } else if (sessionCookie && !hasAdmin) {
    diagnostic.tokenVerification = 'SKIPPED: Firebase Admin not initialized'
  } else {
    diagnostic.tokenVerification = 'SKIPPED: No __session cookie'
  }

  return diagnostic
})
