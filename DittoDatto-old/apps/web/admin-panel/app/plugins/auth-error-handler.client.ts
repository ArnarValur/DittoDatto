/**
 * Auth Error Handler Plugin
 *
 * Handles Firebase session cookie revocation errors.
 * When custom claims are updated (e.g., creating a company), Firebase marks
 * existing tokens as revoked. This plugin detects that error and forces
 * the user to re-authenticate to get a fresh session.
 */
import { getAuth, signOut } from 'firebase/auth'

export default defineNuxtPlugin((nuxtApp) => {
  // Listen for errors during SSR hydration
  nuxtApp.hook('app:error', async (error) => {
    // Check if this is a token revocation error
    const errorMessage = error?.message || error?.toString() || ''
    const isTokenRevoked = errorMessage.includes('id-token-revoked') ||
                           errorMessage.includes('token has been revoked')

    if (isTokenRevoked) {
      console.warn('[Auth] Session token was revoked, signing out user...')

      try {
        const auth = getAuth()
        if (auth.currentUser) {
          await signOut(auth)
        }
      } catch (signOutError) {
        console.error('[Auth] Error during sign out:', signOutError)
      }

      // Redirect to login page
      if (import.meta.client) {
        window.location.href = '/?session=expired'
      }
    }
  })

  // Also intercept fetch errors for the session endpoint
  nuxtApp.hook('app:created', () => {
    if (import.meta.client) {
      // Override fetch to catch session errors
      const originalFetch = window.fetch
      window.fetch = async (...args) => {
        try {
          const response = await originalFetch(...args)

          // Check if this is the session endpoint with an error
          const url = typeof args[0] === 'string' ? args[0] : args[0]?.url
          if (url?.includes('__session') && !response.ok) {
            const clone = response.clone()
            try {
              const data = await clone.json()
              if (data?.message?.includes('revoked') || data?.code === 'auth/id-token-revoked') {
                console.warn('[Auth] Session revoked detected in fetch, redirecting...')
                const auth = getAuth()
                if (auth.currentUser) {
                  await signOut(auth)
                }
                window.location.href = '/?session=expired'
              }
            } catch {
              // Ignore JSON parse errors
            }
          }

          return response
        } catch (error) {
          throw error
        }
      }
    }
  })
})
