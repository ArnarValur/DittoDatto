<script setup lang="ts">
/**
 * AuthLoginForm Component
 *
 * Login form using useAuth composable with:
 * - Email/password sign in
 * - Google OAuth
 * - Redirect after login
 */
import * as z from 'zod'
import type { FormSubmitEvent, AuthFormField } from '@nuxt/ui'

const props = defineProps<{
  title?: string
  description?: string
  redirectTo?: string
}>()

const { t } = useI18n()
const localePath = useLocalePath()
const { signIn, signInWithGoogle, loading, error } = useAuth()
const router = useRouter()
const route = useRoute()

// Schema for form validation
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

const providers = computed(() => [
  {
    label: 'Google',
    icon: 'i-simple-icons-google',
    color: 'neutral' as const,
    variant: 'outline' as const,
    click: handleGoogleSignIn
  }
])

async function handleGoogleSignIn() {
  try {
    await signInWithGoogle()
    navigateToRedirect()
  } catch {
    // Error handled by useAuth
  }
}

async function onSubmit(event: FormSubmitEvent<Schema>) {
  try {
    await signIn(event.data.email, event.data.password)
    navigateToRedirect()
  } catch {
    // Error handled by useAuth
  }
}

function navigateToRedirect() {
  const redirect = route.query.redirect as string || props.redirectTo || '/'
  router.push(localePath(redirect))
}
</script>

<template>
  <div class="w-full">
    <UAuthForm
      :title="title"
      :description="description"
      :fields="fields"
      :providers="providers"
      :schema="schema"
      :loading="loading"
      @submit="onSubmit"
    />

    <!-- Error display -->
    <div v-if="error" class="mt-4 p-3 rounded-lg bg-error/10 text-error text-sm text-center">
      {{ error }}
    </div>
  </div>
</template>
