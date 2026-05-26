/**
 * Auth Middleware for Public Marketplace
 *
 * Named middleware (not global) to protect routes that require authentication.
 * Apply with: definePageMeta({ middleware: 'auth' })
 *
 * Protected routes:
 * - /profile, /profile/*
 * - /favorites
 * - Booking confirmation pages
 *
 * Philosophy: Browse freely, login required for personalized features.
 */

const MAX_WAIT_ATTEMPTS = 30
const WAIT_INTERVAL_MS = 100

export default defineNuxtRouteMiddleware(async (to) => {
  // Skip on server - auth only works client-side
  if (import.meta.server) return

  const { user, initializing } = useAuth()

  // Wait for auth to initialize (handles page refresh scenarios)
  let attempts = 0
  while (initializing.value && attempts < MAX_WAIT_ATTEMPTS) {
    await new Promise(resolve => setTimeout(resolve, WAIT_INTERVAL_MS))
    attempts++
  }

  // If still initializing after max attempts, allow through (will recheck on client)
  if (initializing.value) {
    console.warn('[auth middleware] Auth initialization timeout')
    return
  }

  // Redirect to login if not authenticated
  if (!user.value) {
    return navigateTo({
      path: '/login',
      query: { redirect: to.fullPath }
    })
  }

  // User is authenticated, allow access
})
