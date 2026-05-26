<script setup lang="ts">
/**
 * Signup Page — Multi-Provider Registration
 *
 * Providers:
 * - Google (OAuth popup — auto-creates profile)
 * - Phone (OTP → name prompt → profile)
 * - Email/Password (name + email + password → profile)
 *
 * Future: BankID (Norwegian identity verification)
 */
import * as z from 'zod'
import type { FormSubmitEvent, AuthFormField } from '@nuxt/ui'

definePageMeta({
  layout: 'auth'
})

const { t } = useI18n()
const localePath = useLocalePath()
const router = useRouter()
const auth = useAuth()

// UI state
const activeMethod = ref<'providers' | 'phone' | 'email' | 'phone-name'>('providers')
const phoneUserName = ref('')

// Email form schema
const schema = z.object({
  name: z.string().min(2, 'Name is required'),
  email: z.string().email('Invalid email'),
  password: z.string().min(8, 'Password must be at least 8 characters')
})

type Schema = z.output<typeof schema>

const fields = computed<AuthFormField[]>(() => [
  {
    name: 'name',
    type: 'text',
    label: t('auth.name'),
    placeholder: t('auth.namePlaceholder'),
    required: true
  },
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

async function handleGoogleSignUp() {
  try {
    await auth.signInWithGoogle()
    router.push(localePath('/'))
  } catch {
    // Error handled by useAuth
  }
}

async function onEmailSubmit(event: FormSubmitEvent<Schema>) {
  try {
    await auth.signUp(event.data.email, event.data.password)
    await auth.createProfile({ name: event.data.name })
    router.push(localePath('/'))
  } catch {
    // Error handled by useAuth
  }
}

function handlePhoneSuccess() {
  // Phone user authenticated — now collect their name
  activeMethod.value = 'phone-name'
}

async function handlePhoneNameSubmit() {
  if (!phoneUserName.value.trim()) return

  try {
    await auth.createProfile({ name: phoneUserName.value.trim() })
    router.push(localePath('/'))
  } catch {
    // Error handled by useAuth
  }
}
</script>

<template>
  <div class="w-full max-w-md space-y-6">
    <!-- Header -->
    <div class="text-center space-y-2">
      <h1 class="text-2xl font-bold">{{ t('auth.signupTitle') }}</h1>
      <p class="text-sm text-muted">{{ t('auth.signupDescription') }}</p>
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
          @click="handleGoogleSignUp"
        >
          <UIcon name="i-simple-icons-google" />
          {{ t('auth.signUpWithGoogle') }}
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
          {{ t('auth.signUpWithPhone') }}
        </UButton>

        <!-- BankID — PostIt: Enable when BankID provider contract is signed.
             Will be used for legal identity verification of Users and Business owners. -->
        <!-- <UButton
          block
          size="lg"
          color="neutral"
          variant="outline"
          class="justify-center gap-3 opacity-50 cursor-not-allowed"
          disabled
        >
          <UIcon name="i-lucide-landmark" />
          Sign up with BankID
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
          {{ t('auth.signUpWithEmail') }}
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
          <span class="text-sm font-medium">{{ t('auth.phoneSignUp') }}</span>
        </div>

        <AuthPhoneOTPForm @success="handlePhoneSuccess" />
      </div>

      <!-- Phone: Name collection (after OTP verified) -->
      <div v-else-if="activeMethod === 'phone-name'" class="space-y-4">
        <div class="text-center mb-2">
          <UIcon name="i-lucide-user-check" class="text-3xl text-primary mb-2" />
          <p class="text-sm text-muted">{{ t('auth.phoneVerified') }}</p>
        </div>

        <UFormField :label="t('auth.yourName')">
          <UInput
            v-model="phoneUserName"
            type="text"
            :placeholder="t('auth.yourFullName')"
            size="lg"
            @keydown.enter="handlePhoneNameSubmit"
          />
        </UFormField>

        <UButton
          block
          size="lg"
          :loading="auth.loading.value"
          :disabled="phoneUserName.trim().length < 2"
          @click="handlePhoneNameSubmit"
        >
          {{ t('auth.completeRegistration') }}
        </UButton>
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
          <span class="text-sm font-medium">{{ t('auth.emailSignUp') }}</span>
        </div>

        <UAuthForm
          :fields="fields"
          :schema="schema"
          :loading="auth.loading.value"
          @submit="onEmailSubmit"
        />

        <!-- Error display -->
        <div v-if="auth.error.value" class="p-3 rounded-lg bg-error/10 text-error text-sm text-center">
          {{ auth.error.value }}
        </div>
      </div>

      <template #footer>
        <p class="text-center text-sm text-muted">
          {{ t('auth.hasAccount') }}
          <NuxtLink :to="localePath('/login')" class="text-primary hover:underline font-medium">
            {{ t('auth.signIn') }}
          </NuxtLink>
        </p>
      </template>
    </UPageCard>

    <!-- Invisible reCAPTCHA container -->
    <div id="recaptcha-container" />
  </div>
</template>
