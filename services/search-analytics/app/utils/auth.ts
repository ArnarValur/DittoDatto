import { getAuth, onAuthStateChanged, type User } from 'firebase/auth'

/**
 * Returns a promise that resolves to the currently authenticated user
 * or null if unauthenticated. This ensures Firebase Auth has finished initializing.
 */
export function getCurrentUser(): Promise<User | null> {
  return new Promise((resolve, reject) => {
    const auth = getAuth()
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      unsubscribe()
      resolve(user)
    }, reject)
  })
}
