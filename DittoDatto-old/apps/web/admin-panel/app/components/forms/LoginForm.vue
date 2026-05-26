<script setup lang="ts">
// apps/admin-panel/app/components/forms/LoginForm.vue
import { ref } from 'vue'
import { signInWithEmailAndPassword } from 'firebase/auth'
import { useFirebaseAuth } from 'vuefire'

const router = useRouter()
const route = useRoute()

const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMsg = ref('')

const { $auth: auth } = useNuxtApp()

const handleLogin = async () => {
  if (!email.value || !password.value) return

  loading.value = true
  errorMsg.value = ''

  try {
    if (!auth) {
      console.error('Firebase Auth is missing. Check your nuxt.config.ts and .env variables.')
      errorMsg.value = 'Configuration Error'
      return
    }

    const userCredential = await signInWithEmailAndPassword(auth, email.value, password.value)

    // Force refresh token to ensure custom claims (roles) are available in the token immediately
    const tokenResult = await userCredential.user.getIdTokenResult(true)

    // Set cross-domain bypass cookie for maintenance mode
    const role = (tokenResult.claims.role as string) || (tokenResult.claims.isMasterAdmin ? 'super_admin' : '')
    if (role) {
      const { setBypassCookie } = await import('@dittodatto/ui/utils/bypass-cookie')
      setBypassCookie(userCredential.user.uid, role)
    }

    const target = route.query.redirect as string || '/dashboard'
    await router.push(target)
  } catch (e: any) {
    console.error('Login failed', e)
    errorMsg.value = 'Access Denied.'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <form
    class="space-y-6"
    @submit.prevent="handleLogin"
  >
    <div class="text-center">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
        DittoDatto Admin
      </h1>
      <p class="text-sm text-gray-500 mt-2">
        Enter the Sanctum
      </p>
    </div>

    <div class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Email</label>
        <input
          v-model="email"
          type="email"
          required
          class="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-black focus:outline-none dark:bg-gray-800 dark:border-gray-700"
          placeholder="admin@dittodatto.no"
        >
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Password</label>
        <input
          v-model="password"
          type="password"
          required
          class="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-black focus:outline-none dark:bg-gray-800 dark:border-gray-700"
        >
      </div>
    </div>

    <!-- <div v-if="errorMsg" class="text-red-500 text-sm text-center font-medium">
      {{ errorMsg }}
    </div> -->

    <button
      type="submit"
      :disabled="loading"
      class="w-full flex justify-center rounded-md bg-black px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-gray-800 disabled:opacity-50"
    >
      <span v-if="loading">Verifying...</span>
      <span v-else>Sign In</span>
    </button>
  </form>
</template>
