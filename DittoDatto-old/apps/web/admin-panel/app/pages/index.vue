<script setup lang="ts">
import * as z from 'zod'
import type { FormSubmitEvent, AuthFormField } from '@nuxt/ui'
import { signInWithEmailAndPassword } from 'firebase/auth'
import { useFirebaseAuth } from 'vuefire'

const toast = useToast()
const auth = useFirebaseAuth()
const router = useRouter()
const route = useRoute()
const loading = ref(false)
const errorMessages = ref('')
const { t } = useI18n()

// Show toast if session expired or access denied
onMounted(() => {
  if (route.query.session === 'expired') {
    toast.add({
      title: 'Session Expired',
      description: 'Your session has expired. Please sign in again.',
      color: 'warning',
      icon: 'i-lucide-alert-circle'
    })
    router.replace({ query: {} })
  } else if (route.query.denied === 'role') {
    toast.add({
      title: 'Access Denied',
      description: 'Only super administrators can access the admin panel.',
      color: 'error',
      icon: 'i-lucide-shield-x'
    })
    router.replace({ query: {} })
  }
})

const fields = computed<AuthFormField[]>(() => [{
  name: 'email',
  type: 'email',
  label: t('login.email'),
  placeholder: t('login.email_placeholder'),
  required: true
}, {
  name: 'password',
  label: t('login.password'),
  type: 'password',
  placeholder: t('login.password_placeholder'),
  required: true
}])

const schema = z.object({
  email: z.email(t('login.invalid_email')),
  password: z.string(t('login.password_required'))
})

type Schema = z.output<typeof schema>

async function onSubmit(payload: FormSubmitEvent<Schema>) {
  console.log('Submitted', payload)
  if (!payload) return

  loading.value = true
  errorMessages.value = ''

  try {
    if (!auth) return

    const userCredential = await signInWithEmailAndPassword(auth, payload.data.email, payload.data.password)
    await userCredential.user.getIdTokenResult(true)
    const target = route.query.redirect as string || '/dashboard'
    router.push(target)
  } catch {
    console.error('GoAway')
  }
}
</script>

<template>
  <div class="flex min-h-screen flex-col items-center justify-center gap-4 p-4 bg-muted/50">
    <UPageCard class="w-full max-w-md">
      <UAuthForm
        :schema="schema"
        :fields="fields"
        :title="t('login.title')"
        :submit="{ label: t('authForm.submit') }"
        icon="i-lucide-lock"
        @submit="onSubmit"
      />
    </UPageCard>
  </div>
</template>
