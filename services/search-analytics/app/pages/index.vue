<script setup lang="ts">
import * as z from 'zod'
import type { FormSubmitEvent } from '@nuxt/ui'
import { signInWithEmailAndPassword, getAuth } from 'firebase/auth'

const toast = useToast()
const router = useRouter()
const loading = ref(false)

definePageMeta({
  layout: 'default'
})

const schema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(6, 'Password must be at least 6 characters')
})

type Schema = z.output<typeof schema>

const state = reactive({
  email: '',
  password: ''
})

async function onSubmit(event: FormSubmitEvent<Schema>) {
  loading.value = true

  try {
    const auth = getAuth()
    const userCredential = await signInWithEmailAndPassword(auth, event.data.email, event.data.password)
    
    // Verify role before routing
    const tokenResult = await userCredential.user.getIdTokenResult(true)
    if (tokenResult.claims.role !== 'super_admin') {
      await auth.signOut()
      throw new Error('Insufficient permissions')
    }

    router.push('/dashboard')
  } catch (error) {
    console.error('Login failed', error)
    toast.add({
      title: 'Authentication Failed',
      description: 'You do not have permission to access this dashboard.',
      color: 'error',
      icon: 'i-lucide-alert-circle'
    })
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="flex flex-1 flex-col items-center justify-center p-4">
    <UCard class="w-full max-w-md">
      <template #header>
        <div class="flex items-center gap-2 mb-2">
          <UIcon name="i-lucide-line-chart" class="w-6 h-6 text-primary" />
          <h1 class="text-xl font-bold text-gray-900 dark:text-white">SearchAnalytics</h1>
        </div>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Super Admin access required.
        </p>
      </template>

      <UForm
        :schema="schema"
        :state="state"
        class="space-y-4"
        @submit="onSubmit"
      >
        <UFormField name="email" label="Email">
          <UInput
            v-model="state.email"
            type="email"
            placeholder="super_admin@avj.info"
            icon="i-lucide-mail"
            class="w-full"
          />
        </UFormField>

        <UFormField name="password" label="Password">
          <UInput
            v-model="state.password"
            type="password"
            icon="i-lucide-lock"
            class="w-full"
          />
        </UFormField>

        <UButton
          type="submit"
          color="primary"
          block
          :loading="loading"
          class="mt-4"
        >
          Sign In
        </UButton>
      </UForm>
    </UCard>
  </div>
</template>
