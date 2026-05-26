/**
 * useClaimInvite Composable
 *
 * On portal load, checks if the current user has pending staff invites
 * by calling the `staff_claimInvite` Cloud Function.
 *
 * Flow:
 * 1. Wait for auth to resolve
 * 2. Check if user already has a companyId claim → if yes, skip
 * 3. Call staff_claimInvite callable
 * 4. If linked, force token refresh to pick up new claims
 * 5. Reload the page so useCompany picks up the new companyId
 *
 * This composable should be called once from the dashboard layout.
 */
import { getFunctions, httpsCallable, connectFunctionsEmulator } from 'firebase/functions'
import { useFirebaseApp, useCurrentUser } from 'vuefire'
import { getAuth } from 'firebase/auth'

let emulatorConnected = false

export function useClaimInvite() {
  const firebaseApp = useFirebaseApp()
  const currentUser = useCurrentUser()
  const toast = useToast()

  const claiming = ref(false)
  const claimed = ref(false)

  async function checkAndClaimInvite() {
    // SSR guard
    if (import.meta.server) return

    // Wait for user
    if (!currentUser.value?.email) return

    // Check if user already has company claims
    const token = await currentUser.value.getIdTokenResult()
    if (token.claims.companyId || token.claims.companyIds) {
      // User already has company access — no need to claim
      return
    }

    claiming.value = true
    try {
      // Get functions instance with correct region
      const functions = getFunctions(firebaseApp, 'europe-west1')

      // ⚠️ EMULATORS OFF — fully live Firebase for auth testing
      // if (import.meta.dev && !emulatorConnected) {
      //   connectFunctionsEmulator(functions, 'localhost', 5001)
      //   emulatorConnected = true
      // }

      const claimInviteFn = httpsCallable<void, { linked: boolean; companyIds: string[] }>(
        functions,
        'staff_claimInvite'
      )

      const result = await claimInviteFn()

      if (result.data.linked) {
        claimed.value = true

        toast.add({
          title: 'Welcome aboard! 🎉',
          description: 'Your staff invite has been activated. Refreshing...',
          color: 'success',
          icon: 'i-lucide-user-check',
        })

        // Force token refresh to pick up new claims
        const auth = getAuth(firebaseApp)
        if (auth.currentUser) {
          await auth.currentUser.getIdToken(true)
        }

        // Brief delay for UX, then reload to pick up new company data
        setTimeout(() => {
          window.location.reload()
        }, 1500)
      }
    } catch (err) {
      // Don't show error to user — this is a background check
      console.warn('[useClaimInvite] Check failed:', err)
    } finally {
      claiming.value = false
    }
  }

  return {
    claiming,
    claimed,
    checkAndClaimInvite,
  }
}
