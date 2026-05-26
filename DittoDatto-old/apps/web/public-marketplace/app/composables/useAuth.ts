/**
 * Authentication Composable for Public Marketplace
 *
 * Provides a unified API for auth operations:
 * - user: Firebase User (reactive)
 * - userProfile: Firestore user profile document
 * - signUp, signInWithGoogle, logout
 * - createProfile, updateProfile
 * - initAuth: Initialize auth listener (for plugin)
 *
 * Philosophy: Browse freely, login required for booking/save/favorites
 */
import {
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signInWithPopup,
  GoogleAuthProvider,
  PhoneAuthProvider,
  signInWithPhoneNumber,
  RecaptchaVerifier,
  onAuthStateChanged,
  browserLocalPersistence,
  setPersistence,
  type User,
  type ConfirmationResult
} from 'firebase/auth'
import { doc, getDoc, setDoc, updateDoc, serverTimestamp } from 'firebase/firestore'
import type { UserRole } from '@dittodatto/shared-types'

// Types
interface UserProfile {
  id: string
  name: string
  email: string
  username?: string
  bio?: string
  phone?: string
  photoUrl?: string
  role: UserRole
  isOnboarded: boolean
  language: 'nb' | 'en'
  createdAt: string
  updatedAt: string
}

interface CreateProfileData {
  name: string
  username?: string
  phone?: string
}

interface UpdateProfileData {
  name?: string
  username?: string
  bio?: string
  phone?: string
  photoUrl?: string
  language?: 'nb' | 'en'
}

// Shared state (singleton pattern for SSR safety)
const user = ref<User | null>(null)
const userProfile = ref<UserProfile | null>(null)
const loading = ref(false)
const initializing = ref(true)
const error = ref<string | null>(null)
let authUnsubscribe: (() => void) | null = null

// Phone auth state
const phoneVerificationId = ref<string | null>(null)
const phoneConfirmation = ref<ConfirmationResult | null>(null)
let recaptchaVerifier: RecaptchaVerifier | null = null

/**
 * Map Firebase Auth error codes to human-readable messages.
 * Avoids leaking raw Firebase internals like
 * "Firebase: The supplied auth credential is incorrect, malformed or has expired."
 */
function getHumanError(code: string | undefined, fallback: string): string {
  const map: Record<string, string> = {
    'auth/invalid-credential': 'Wrong email or password. Please try again.',
    'auth/user-not-found': 'No account found with this email.',
    'auth/wrong-password': 'Incorrect password. Please try again.',
    'auth/email-already-in-use': 'An account with this email already exists.',
    'auth/weak-password': 'Password must be at least 6 characters.',
    'auth/invalid-email': 'Please enter a valid email address.',
    'auth/too-many-requests': 'Too many attempts. Please try again later.',
    'auth/user-disabled': 'This account has been disabled. Contact support.',
    'auth/network-request-failed': 'Network error. Check your connection and try again.',
    'auth/popup-closed-by-user': 'Sign-in popup was closed. Please try again.',
    'auth/cancelled-popup-request': 'Sign-in was cancelled.',
    'auth/account-exists-with-different-credential': 'An account already exists with this email using a different sign-in method.',
    'permission-denied': 'Account created, but profile setup failed. Please refresh and try again.',
  }
  return map[code || ''] || fallback
}

export function useAuth() {
  const auth = useFirebaseAuth()
  const firestore = useFirestore()
  const localePath = useLocalePath()

  /**
   * Initialize auth state listener
   * Called once by auth-init.client.ts plugin
   */
  async function initAuth() {
    if (!auth || authUnsubscribe) return

    try {
      // Set persistence to local (stay logged in)
      await setPersistence(auth, browserLocalPersistence)
    } catch (e) {
      console.warn('[useAuth] Failed to set persistence:', e)
    }

    // Listen to auth state changes
    authUnsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
      user.value = firebaseUser

      if (firebaseUser) {
        // Fetch user profile from Firestore
        await fetchUserProfile(firebaseUser.uid)

        // Set cross-domain bypass cookie if user has elevated role
        try {
          const tokenResult = await firebaseUser.getIdTokenResult()
          const role = tokenResult.claims.role as string | undefined
          if (role === 'admin' || role === 'super_admin' || role === 'business') {
            const { setBypassCookie } = await import('@dittodatto/ui/utils/bypass-cookie')
            setBypassCookie(firebaseUser.uid, role)
          }
        } catch { /* non-critical */ }
      } else {
        userProfile.value = null
        // Clear bypass cookie on sign-out
        const { clearBypassCookie } = await import('@dittodatto/ui/utils/bypass-cookie')
        clearBypassCookie()
      }

      initializing.value = false
    })
  }

  /**
   * Fetch user profile from Firestore
   */
  async function fetchUserProfile(uid: string) {
    if (!firestore) return

    try {
      const docRef = doc(firestore, 'users', uid)
      const docSnap = await getDoc(docRef)

      if (docSnap.exists()) {
        userProfile.value = { id: docSnap.id, ...docSnap.data() } as UserProfile
      } else {
        userProfile.value = null
      }
    } catch (e) {
      console.error('[useAuth] Failed to fetch profile:', e)
      userProfile.value = null
    }
  }

  /**
   * Sign up with email and password
   */
  async function signUp(email: string, password: string) {
    if (!auth) throw new Error('Auth not initialized')

    loading.value = true
    error.value = null

    try {
      const credential = await createUserWithEmailAndPassword(auth, email, password)
      user.value = credential.user
      return credential.user
    } catch (e: unknown) {
      const firebaseError = e as { code?: string, message?: string }
      error.value = getHumanError(firebaseError.code, 'Sign up failed. Please try again.')
      throw e
    } finally {
      loading.value = false
    }
  }

  /**
   * Sign in with email and password
   */
  async function signIn(email: string, password: string) {
    if (!auth) throw new Error('Auth not initialized')

    loading.value = true
    error.value = null

    try {
      const credential = await signInWithEmailAndPassword(auth, email, password)
      user.value = credential.user
      await fetchUserProfile(credential.user.uid)
      return credential.user
    } catch (e: unknown) {
      const firebaseError = e as { code?: string, message?: string }
      error.value = getHumanError(firebaseError.code, 'Sign in failed. Please try again.')
      throw e
    } finally {
      loading.value = false
    }
  }

  /**
   * Sign in with Google OAuth
   */
  async function signInWithGoogle() {
    if (!auth) throw new Error('Auth not initialized')

    loading.value = true
    error.value = null

    try {
      const provider = new GoogleAuthProvider()
      const credential = await signInWithPopup(auth, provider)
      user.value = credential.user

      // Check if profile exists, create if not
      if (firestore) {
        const docRef = doc(firestore, 'users', credential.user.uid)
        const docSnap = await getDoc(docRef)

        if (!docSnap.exists()) {
          // Create profile from Google data
          await createProfile({
            name: credential.user.displayName || 'User'
          })
        } else {
          await fetchUserProfile(credential.user.uid)
        }
      }

      return credential.user
    } catch (e: unknown) {
      const firebaseError = e as { code?: string, message?: string }
      error.value = getHumanError(firebaseError.code, 'Google sign in failed. Please try again.')
      throw e
    } finally {
      loading.value = false
    }
  }

  /**
   * Send OTP to phone number
   * Requires a DOM element with id="recaptcha-container" to exist
   */
  async function signInWithPhone(phoneNumber: string) {
    if (!auth) throw new Error('Auth not initialized')

    loading.value = true
    error.value = null

    try {
      // Initialize invisible reCAPTCHA if not already done
      if (!recaptchaVerifier) {
        recaptchaVerifier = new RecaptchaVerifier(auth, 'recaptcha-container', {
          size: 'invisible'
        })
      }

      const confirmation = await signInWithPhoneNumber(auth, phoneNumber, recaptchaVerifier)
      phoneConfirmation.value = confirmation
      phoneVerificationId.value = confirmation.verificationId

      return confirmation.verificationId
    } catch (e: unknown) {
      const firebaseError = e as { code?: string, message?: string }
      // Provide user-friendly error messages
      if (firebaseError.code === 'auth/invalid-phone-number') {
        error.value = 'Invalid phone number format. Use +47XXXXXXXX'
      } else if (firebaseError.code === 'auth/too-many-requests') {
        error.value = 'Too many attempts. Please try again later.'
      } else {
        error.value = firebaseError.message || 'Failed to send verification code'
      }
      throw e
    } finally {
      loading.value = false
    }
  }

  /**
   * Verify the OTP code sent to phone
   */
  async function verifyPhoneOTP(code: string) {
    if (!phoneConfirmation.value) throw new Error('No verification in progress')

    loading.value = true
    error.value = null

    try {
      const credential = await phoneConfirmation.value.confirm(code)
      user.value = credential.user

      // Check if profile exists — phone users may not have one yet
      if (firestore) {
        const docRef = doc(firestore, 'users', credential.user.uid)
        const docSnap = await getDoc(docRef)

        if (docSnap.exists()) {
          await fetchUserProfile(credential.user.uid)
        }
        // If no profile, the beforeUserCreated trigger creates one server-side.
        // Client can also call createProfile() for additional fields like name.
      }

      // Cleanup
      phoneConfirmation.value = null
      phoneVerificationId.value = null

      return credential.user
    } catch (e: unknown) {
      const firebaseError = e as { code?: string, message?: string }
      if (firebaseError.code === 'auth/invalid-verification-code') {
        error.value = 'Incorrect code. Please try again.'
      } else if (firebaseError.code === 'auth/code-expired') {
        error.value = 'Code expired. Please request a new one.'
      } else {
        error.value = firebaseError.message || 'Verification failed'
      }
      throw e
    } finally {
      loading.value = false
    }
  }

  /**
   * Cleanup reCAPTCHA verifier (call on component unmount)
   */
  function cleanupRecaptcha() {
    if (recaptchaVerifier) {
      recaptchaVerifier.clear()
      recaptchaVerifier = null
    }
  }

  /**
   * Create user profile in Firestore
   */
  async function createProfile(data: CreateProfileData) {
    if (!firestore || !user.value) throw new Error('Not authenticated')

    loading.value = true
    error.value = null

    try {
      const docRef = doc(firestore, 'users', user.value.uid)
      // Note: role is intentionally omitted — the onAuthUserCreated CF sets it
      // server-side. Firestore rules block clients from setting role on create.
      // We use merge:true so this safely updates the CF-created doc with the name.
      const profileData = {
        name: data.name,
        email: user.value.email || '',
        username: data.username || '',
        phone: data.phone || '',
        photoUrl: user.value.photoURL || '',
        isOnboarded: false,
        language: 'nb',
        updatedAt: serverTimestamp()
      }

      await setDoc(docRef, profileData, { merge: true })

      userProfile.value = {
        id: user.value.uid,
        ...profileData,
        role: 'customer',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      }
      return userProfile.value
    } catch (e: unknown) {
      const firebaseError = e as { code?: string, message?: string }
      error.value = getHumanError(firebaseError.code, 'Failed to create profile')
      throw e
    } finally {
      loading.value = false
    }
  }

  /**
   * Update user profile in Firestore
   */
  async function updateProfile(data: UpdateProfileData) {
    if (!firestore || !user.value) throw new Error('Not authenticated')

    loading.value = true
    error.value = null

    try {
      const docRef = doc(firestore, 'users', user.value.uid)

      await updateDoc(docRef, {
        ...data,
        updatedAt: serverTimestamp()
      })

      // Refresh profile
      await fetchUserProfile(user.value.uid)
      return userProfile.value
    } catch (e: unknown) {
      const firebaseError = e as { code?: string, message?: string }
      error.value = firebaseError.message || 'Failed to update profile'
      throw e
    } finally {
      loading.value = false
    }
  }

  /**
   * Sign out
   */
  async function logout() {
    if (!auth) return

    loading.value = true
    error.value = null

    try {
      const { clearBypassCookie } = await import('@dittodatto/ui/utils/bypass-cookie')
      clearBypassCookie()
      await auth.signOut()
      user.value = null
      userProfile.value = null
      await navigateTo(localePath('/'), { external: true })
    } catch (e: unknown) {
      const firebaseError = e as { code?: string, message?: string }
      error.value = firebaseError.message || 'Logout failed'
      throw e
    } finally {
      loading.value = false
    }
  }

  /**
   * Get current user's role from token claims
   */
  async function getUserRole(): Promise<UserRole | null> {
    if (!user.value) return null

    try {
      const tokenResult = await user.value.getIdTokenResult()
      return (tokenResult.claims.role as UserRole) || 'customer'
    } catch {
      return null
    }
  }

  return {
    // State
    user: readonly(user),
    userProfile: readonly(userProfile),
    loading: readonly(loading),
    initializing: readonly(initializing),
    error: readonly(error),
    phoneVerificationId: readonly(phoneVerificationId),

    // Auth methods
    initAuth,
    signUp,
    signIn,
    signInWithGoogle,
    signInWithPhone,
    verifyPhoneOTP,
    logout,

    // Profile methods
    createProfile,
    updateProfile,
    fetchUserProfile,

    // Utilities
    getUserRole,
    cleanupRecaptcha
  }
}
