<script setup lang="ts">
/**
 * Business Portal Login Page
 *
 * Premium, clean login flow matching public-marketplace design language.
 * Supports:
 * - Google (OAuth popup)
 * - Email/Password
 *
 * Post-login: checks companyId claim, attempts staff invite claim if missing.
 */
import * as z from 'zod'
import type { FormSubmitEvent, AuthFormField } from '@nuxt/ui'
import {
  signInWithEmailAndPassword,
  signInWithPopup,
  GoogleAuthProvider
} from 'firebase/auth'
import { getFunctions, httpsCallable } from 'firebase/functions'
import { useFirebaseAuth, useFirebaseApp } from 'vuefire'

definePageMeta({
  layout: 'auth'
})

const auth = useFirebaseAuth()
const firebaseApp = useFirebaseApp()
const router = useRouter()
const route = useRoute()

// UI state
const activeMethod = ref<'providers' | 'email'>('providers')
const loading = ref(false)
const errorMessage = ref('')

// Email form schema
const schema = z.object({
  email: z.string().email('Please enter a valid email address'),
  password: z.string().min(1, 'Password is required')
})

type Schema = z.output<typeof schema>

const fields = computed<AuthFormField[]>(() => [
  {
    name: 'email',
    type: 'email',
    label: 'Email',
    placeholder: 'you@company.com',
    required: true
  },
  {
    name: 'password',
    type: 'password',
    label: 'Password',
    placeholder: 'Enter your password',
    required: true
  }
])

/**
 * Post-login flow: check claims, attempt claimInvite if needed
 */
async function postLoginClaimFlow(userCredential: import('firebase/auth').UserCredential) {
  let tokenResult = await userCredential.user.getIdTokenResult(true)

  if (!tokenResult.claims.companyId) {
    console.log('[Login] No companyId claim — attempting to claim staff invite...')

    try {
      const functions = getFunctions(firebaseApp, 'europe-west1')
      const claimInviteFn = httpsCallable<void, { linked: boolean; companyIds: string[] }>(
        functions,
        'staff_claimInvite'
      )

      const result = await claimInviteFn()

      if (result.data.linked) {
        console.log('[Login] Staff invite claimed! Companies:', result.data.companyIds)
        tokenResult = await userCredential.user.getIdTokenResult(true)
      }
    } catch (claimError) {
      console.warn('[Login] Claim invite failed:', claimError)
    }
  }

  if (!tokenResult.claims.companyId) {
    console.error('User does not have a companyId claim')
    errorMessage.value = 'Access denied — no company is associated with this account. Contact your business administrator.'
    return
  }

  // Set cross-domain bypass cookie for maintenance mode
  const role = (tokenResult.claims.role as string) || 'business'
  setBypassCookie(userCredential.user.uid, role)

  const target = route.query.redirect as string || '/dashboard'
  router.push(target)
}

async function handleGoogleSignIn() {
  if (!auth) {
    errorMessage.value = 'Authentication service unavailable'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    const provider = new GoogleAuthProvider()
    const userCredential = await signInWithPopup(auth, provider)
    await postLoginClaimFlow(userCredential)
  } catch (e: any) {
    console.error('Google login failed:', e)
    if (e?.code === 'auth/popup-closed-by-user') {
      // User cancelled — don't show error
      return
    }
    errorMessage.value = 'Google sign-in failed. Please try again.'
  } finally {
    loading.value = false
  }
}

async function onEmailSubmit(event: FormSubmitEvent<Schema>) {
  if (!auth) {
    errorMessage.value = 'Authentication service unavailable'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    const userCredential = await signInWithEmailAndPassword(auth, event.data.email, event.data.password)
    await postLoginClaimFlow(userCredential)
  } catch (e: any) {
    console.error('Login failed:', e)
    if (e?.code === 'auth/invalid-credential' || e?.code === 'auth/wrong-password') {
      errorMessage.value = 'Invalid email or password'
    } else if (e?.code === 'auth/user-not-found') {
      errorMessage.value = 'No account found with this email'
    } else if (e?.code === 'auth/too-many-requests') {
      errorMessage.value = 'Too many attempts. Please try again later.'
    } else {
      errorMessage.value = 'Sign-in failed. Please try again.'
    }
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="w-full max-w-md space-y-6">
    <!-- Header -->
    <div class="text-center space-y-2">
      <div class="inline-flex items-center justify-center size-14 rounded-2xl bg-primary/15 mb-2">
        <UIcon name="i-lucide-building-2" class="size-7 text-primary" />
      </div>
      <h1 class="text-2xl font-bold text-highlighted">Business Portal</h1>
      <p class="text-sm text-muted">Sign in to manage your business</p>
    </div>

    <UPageCard>
      <!-- Provider Buttons (default view) -->
      <div v-if="activeMethod === 'providers'" class="space-y-3">
        <!-- Google -->
        <UButton
          block
          size="lg"
          color="neutral"
          variant="outline"
          :loading="loading"
          class="justify-center gap-3"
          @click="handleGoogleSignIn"
        >
          <UIcon name="i-simple-icons-google" />
          Continue with Google
        </UButton>

        <!-- Divider -->
        <div class="flex items-center gap-3 my-4">
          <div class="flex-1 h-px bg-muted/40" />
          <span class="text-xs text-muted uppercase tracking-wider">or</span>
          <div class="flex-1 h-px bg-muted/40" />
        </div>

        <!-- Email option -->
        <UButton
          block
          size="lg"
          color="neutral"
          variant="ghost"
          class="justify-center gap-3"
          @click="activeMethod = 'email'"
        >
          <UIcon name="i-lucide-mail" />
          Sign in with Email
        </UButton>
      </div>

      <!-- Email/Password Form -->
      <div v-else-if="activeMethod === 'email'" class="space-y-4">
        <div class="flex items-center gap-2 mb-2">
          <UButton
            size="xs"
            color="neutral"
            variant="ghost"
            icon="i-lucide-arrow-left"
            @click="activeMethod = 'providers'; errorMessage = ''"
          />
          <span class="text-sm font-medium text-default">Email Sign In</span>
        </div>

        <UAuthForm
          :fields="fields"
          :schema="schema"
          :loading="loading"
          @submit="onEmailSubmit"
        />
      </div>

      <!-- Error display -->
      <div
        v-if="errorMessage"
        class="mt-4 p-3 rounded-lg bg-error/10 border border-error/20 text-error text-sm text-center"
      >
        {{ errorMessage }}
      </div>

      <template #footer>
        <p class="text-center text-sm text-muted hidden">
          Need access?
          <span class="text-default">
            Ask your company admin for an invite.
          </span>
        </p>
      </template>
    </UPageCard>

    <!-- Access denied / session notices -->
    <div
      v-if="$route.query.denied === 'role'"
      class="p-3 rounded-lg bg-error/10 border border-error/20 text-error text-sm text-center flex items-center gap-2 justify-center"
    >
      <UIcon name="i-lucide-shield-x" class="size-4 shrink-0" />
      <span>This portal is for business accounts. If you believe this is an error, contact your administrator.</span>
    </div>
    <div
      v-else-if="$route.query.denied === 'no-company'"
      class="p-3 rounded-lg bg-warning/10 border border-warning/20 text-warning text-sm text-center flex items-center gap-2 justify-center"
    >
      <UIcon name="i-lucide-building-2" class="size-4 shrink-0" />
      <span>Your account is not linked to any company. Ask your company admin for an invite.</span>
    </div>
    <div
      v-else-if="$route.query.session === 'expired'"
      class="p-3 rounded-lg bg-warning/10 border border-warning/20 text-warning text-sm text-center flex items-center gap-2 justify-center"
    >
      <UIcon name="i-lucide-clock" class="size-4 shrink-0" />
      <span>Your session has expired. Please sign in again.</span>
    </div>
  </div>
</template>

