// apps/public-marketplace/app/middleware/maintenance.global.ts
import type { UserRole } from '@dittodatto/shared-types'
import { verifyBypassCookie, COOKIE_NAME } from '@dittodatto/ui/utils/bypass-cookie'

const MAX_WAIT_ATTEMPTS = 30
const WAIT_INTERVAL_MS = 100

// Wait for auth to be ready before checking maintenance mode
const waitForAuthReady = async () => {
  const { initializing } = useAuth()
  let attempts = 0

  while (initializing.value && attempts < MAX_WAIT_ATTEMPTS) {
    await new Promise(resolve => setTimeout(resolve, WAIT_INTERVAL_MS))
    attempts++
  }
}

export default defineNuxtRouteMiddleware(async (to) => {
  // Allow access to maintenance and login pages always
  if (to.path === '/maintenance' || to.path === '/login' || to.path === '/signup') {
    return
  }

  // ─── SERVER-SIDE: Check cross-domain bypass cookie ───────────────────
  if (import.meta.server) {
    const bypassCookie = useCookie(COOKIE_NAME)
    const role = verifyBypassCookie(bypassCookie.value ?? undefined)
    if (role) {
      // Authenticated admin/business user from a sibling domain → bypass
      return
    }
    // No bypass cookie on server — we can't check Firebase Auth here,
    // so let the client-side check handle it
    return
  }

  // ─── CLIENT-SIDE: Check Firebase Auth claims ─────────────────────────
  // Wait for auth to initialize (critical for page refresh)
  await waitForAuthReady()

  const { settings } = useSiteSettings()
  const isMaintenanceEnabled = settings.value?.maintenanceMode?.enabled

  // If maintenance mode is disabled, allow all traffic
  if (!isMaintenanceEnabled) {
    return
  }

  // Maintenance mode is enabled - check for admin access
  // CRITICAL: Use ID token claims only — NO Firestore reads
  const { user } = useAuth()

  if (user.value) {
    try {
      const tokenResult = await user.value.getIdTokenResult()
      const role = tokenResult.claims.role as UserRole | undefined

      // Allow admins and super_admins through during maintenance
      if (role === 'admin' || role === 'super_admin' || tokenResult.claims.isMasterAdmin) {
        return
      }
    } catch (error) {
      console.warn('[maintenance] Failed to get ID token claims:', error)
    }
  }

  // Non-admin users get redirected to maintenance page
  return navigateTo('/maintenance')
})
