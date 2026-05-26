/**
 * Admin Panel Authentication Middleware
 *
 * SECURITY: This middleware ensures ONLY super_admin users can access the admin panel.
 *
 * Checks:
 * 1. User is authenticated
 * 2. User has role: 'super_admin' in custom claims
 *
 * If checks fail, redirects to login page.
 */
export default defineNuxtRouteMiddleware(async (to) => {
  const user = await getCurrentUser()

  // Allow access to login page without authentication
  if (to.path === '/' || to.path === '/login') {
    // If logging out (via query param), always allow
    if (to.query.logout === 'true') {
      return
    }

    // If already logged in as super_admin, redirect to dashboard
    if (user) {
      const tokenResult = await user.getIdTokenResult()
      if (tokenResult.claims.role === 'super_admin') {
        return navigateTo('/dashboard')
      }
    }
    return
  }

  // Require authentication for all other routes
  if (!user) {
    return navigateTo({
      path: '/',
      query: { redirect: to.fullPath }
    })
  }

  // Get and verify role from custom claims
  const tokenResult = await user.getIdTokenResult(true) // Force refresh
  const role = tokenResult.claims.role

  // STRICT CHECK: Only super_admin can access admin panel
  if (role !== 'super_admin') {
    // Sign out the unauthorized user
    const auth = useFirebaseAuth()
    if (auth) {
      await auth.signOut()
    }

    return navigateTo({
      path: '/',
      query: { denied: 'role' }
    })
  }
})
