/**
 * Auth Error Handler Plugin — Business Portal
 *
 * Handles Firebase session cookie revocation errors.
 * When custom claims are updated (e.g., claiming a staff invite),
 * Firebase marks existing tokens as revoked. This plugin detects
 * that error and forces the user to re-authenticate.
 */
import { getAuth, signOut } from 'firebase/auth'

export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.hook('app:error', async (error) => {
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

      if (import.meta.client) {
        window.location.href = '/?session=expired'
      }
    }
  })
})
