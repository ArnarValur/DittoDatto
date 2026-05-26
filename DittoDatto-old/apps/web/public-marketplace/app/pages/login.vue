<script setup lang="ts">
/**
 * Login Page — Multi-Provider Authentication
 *
 * Providers:
 * - Google (OAuth popup)
 * - Phone (OTP via SMS)
 * - Email/Password (collapsible form)
 *
 * Future: BankID (Norwegian identity verification)
 */
import * as z from 'zod'
import type { FormSubmitEvent, AuthFormField } from '@nuxt/ui'

definePageMeta({
  layout: 'auth',
  /* colorMode: 'dark' */
})

const { t } = useI18n()
const localePath = useLocalePath()
const router = useRouter()
const route = useRoute()
const auth = useAuth()

// UI state
const activeMethod = ref<'providers' | 'phone' | 'email'>('providers')

// Email form schema
const schema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(1, 'Password is required')
})

type Schema = z.output<typeof schema>

const fields = computed<AuthFormField[]>(() => [
  {
    name: 'email',
    type: 'email',
    label: t('auth.email'),
    placeholder: t('auth.emailPlaceholder'),
    required: true
  },
  {
    name: 'password',
    type: 'password',
    label: t('auth.password'),
    placeholder: t('auth.passwordPlaceholder'),
    required: true
  }
])

function navigateToRedirect() {
  const redirect = route.query.redirect as string || '/'
  router.push(localePath(redirect))
}

async function handleGoogleSignIn() {
  try {
    await auth.signInWithGoogle()
    navigateToRedirect()
  } catch {
    // Error handled by useAuth
  }
}

async function onEmailSubmit(event: FormSubmitEvent<Schema>) {
  try {
    await auth.signIn(event.data.email, event.data.password)
    navigateToRedirect()
  } catch {
    // Error handled by useAuth
  }
}

function handlePhoneSuccess() {
  navigateToRedirect()
}
</script>

<template>
  <div class="w-full max-w-md space-y-6">
    <!-- Header -->
    <div class="text-center space-y-2">
      <h1 class="text-2xl font-bold">{{ t('auth.loginTitle') }}</h1>
      <p class="text-sm text-muted">{{ t('auth.loginDescription') }}</p>
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
          :loading="auth.loading.value"
          class="justify-center gap-3"
          @click="handleGoogleSignIn"
        >
          <UIcon name="i-simple-icons-google" />
          {{ t('auth.continueWithGoogle') }}
        </UButton>

        <!-- Phone -->
        <UButton
          block
          size="lg"
          color="neutral"
          variant="outline"
          class="justify-center gap-3"
          @click="activeMethod = 'phone'"
        >
          <UIcon name="i-lucide-smartphone" />
          {{ t('auth.continueWithPhone') }}
        </UButton>

        <!-- BankID — PostIt: Enable when BankID provider contract is signed -->
        <!-- <UButton
          block
          size="lg"
          color="neutral"
          variant="outline"
          class="justify-center gap-3 opacity-50 cursor-not-allowed"
          disabled
        >
          <UIcon name="i-lucide-landmark" />
          Continue with BankID
          <UBadge size="xs" color="neutral" variant="subtle">Coming Soon</UBadge>
        </UButton> -->

        <!-- Divider -->
        <div class="flex items-center gap-3 my-4">
          <div class="flex-1 h-px bg-muted/50" />
          <span class="text-xs text-muted uppercase tracking-wider">{{ t('common.or') }}</span>
          <div class="flex-1 h-px bg-muted/50" />
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
          {{ t('auth.signInWithEmail') }}
        </UButton>
      </div>

      <!-- Phone OTP Flow -->
      <div v-else-if="activeMethod === 'phone'" class="space-y-4">
        <div class="flex items-center gap-2 mb-4">
          <UButton
            size="xs"
            color="neutral"
            variant="ghost"
            icon="i-lucide-arrow-left"
            @click="activeMethod = 'providers'; auth.cleanupRecaptcha()"
          />
          <span class="text-sm font-medium">{{ t('auth.phoneSignIn') }}</span>
        </div>

        <AuthPhoneOTPForm @success="handlePhoneSuccess" />
      </div>

      <!-- Email/Password Form -->
      <div v-else-if="activeMethod === 'email'" class="space-y-4">
        <div class="flex items-center gap-2 mb-4">
          <UButton
            size="xs"
            color="neutral"
            variant="ghost"
            icon="i-lucide-arrow-left"
            @click="activeMethod = 'providers'"
          />
          <span class="text-sm font-medium">{{ t('auth.emailSignIn') }}</span>
        </div>

        <UAuthForm
          :fields="fields"
          :schema="schema"
          :loading="auth.loading.value"
          @submit="onEmailSubmit"
        />

      </div>

      <!-- Error display (shown for all auth methods) -->
      <div v-if="auth.error.value" class="p-3 rounded-lg bg-error/10 text-error text-sm text-center">
        {{ auth.error.value }}
      </div>

      <template #footer>
        <p class="text-center text-sm text-muted">
          {{ t('auth.noAccount') }}
          <NuxtLink :to="localePath('/signup')" class="text-primary hover:underline font-medium">
            {{ t('auth.createAccount') }}
          </NuxtLink>
        </p>
      </template>
    </UPageCard>

    <!-- Invisible reCAPTCHA container -->
    <div id="recaptcha-container" />
  </div>
</template>
