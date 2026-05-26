/**
 * Business Portal Authentication Middleware (Global)
 *
 * Uses nuxt-vuefire's getCurrentUser() which works on BOTH:
 * - Server: decodes __session cookie via Firebase Admin SDK
 * - Client: resolves from Firebase Auth SDK
 *
 * Routes:
 * - `/` (index) = Login page → allow unauthenticated
 * - Everything else → require auth + companyId claim + role >= business
 */
import { hasMinRole, type Role } from '@dittodatto/shared-types'

export default defineNuxtRouteMiddleware(async (to) => {
  // Allow the login page without authentication
  if (to.path === '/') {
    // If already authenticated with company + valid role, redirect to dashboard
    const user = await getCurrentUser()
    if (user) {
      const tokenResult = await user.getIdTokenResult(true) // Force refresh
      const role = tokenResult.claims.role as Role | undefined
      if (tokenResult.claims.companyId && hasMinRole(role, 'business')) {
        return navigateTo('/dashboard')
      }
    }
    return
  }

  // All other routes require authentication
  const user = await getCurrentUser()

  if (!user) {
    return navigateTo({
      path: '/',
      query: { redirect: to.fullPath }
    })
  }

  // Verify company access AND role (force refresh to pick up latest claims)
  const tokenResult = await user.getIdTokenResult(true)
  const role = tokenResult.claims.role as Role | undefined

  if (!hasMinRole(role, 'business')) {
    // Insufficient role — sign out and redirect with deny reason
    const auth = useFirebaseAuth()
    if (auth) {
      await auth.signOut()
    }
    return navigateTo({
      path: '/',
      query: { denied: 'role' }
    })
  }

  if (!tokenResult.claims.companyId) {
    // Has business role but no company — redirect with specific reason
    return navigateTo({
      path: '/',
      query: { denied: 'no-company' }
    })
  }
})

