import { getAuth } from 'firebase/auth'

export default defineNuxtRouteMiddleware(async (to) => {
  // Respect the DEV bypass flag defined in app.vue
  // We can't import it directly from app.vue easily, so we check process.env or just hardcode it for dev
  // For safety, let's allow bypassing in dev via a flag
  const BYPASS_AUTH = false
  if (import.meta.dev && BYPASS_AUTH) {
    return
  }

  const user = await getCurrentUser()

  // Routes that don't require authentication (e.g., login page)
  const publicRoutes = ['/']
  const isPublicRoute = publicRoutes.includes(to.path)

  if (isPublicRoute) {
    if (user) {
      // If user is logged in, verify role
      const tokenResult = await user.getIdTokenResult()
      if (tokenResult.claims.role === 'super_admin') {
        return navigateTo('/dashboard')
      }
    }
    return
  }

  // Not authenticated? Redirect to login.
  if (!user) {
    return navigateTo('/')
  }

  // Verify super_admin role
  try {
    const tokenResult = await user.getIdTokenResult(true) // Force refresh
    
    if (tokenResult.claims.role !== 'super_admin') {
      const auth = getAuth()
      await auth.signOut()
      return navigateTo('/')
    }
  } catch (error) {
    console.error('Failed to verify user role', error)
    const auth = getAuth()
    await auth.signOut()
    return navigateTo('/')
  }
})
