<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getAuth, onAuthStateChanged, type User } from 'firebase/auth'

const isLoading = ref(true)
const user = ref<User | null>(null)

// DEV ONLY: Bypass auth to build UI first
const BYPASS_AUTH = false

onMounted(() => {
  if (import.meta.client) {
    if (BYPASS_AUTH) {
      isLoading.value = false
      return
    }

    const auth = getAuth()
    onAuthStateChanged(auth, (currentUser) => {
      user.value = currentUser
      isLoading.value = false
    })
  }
})
</script>

<template>
  <UApp>
    <div v-if="isLoading" class="h-screen w-screen flex items-center justify-center bg-gray-50 dark:bg-gray-950">
      <UIcon
        name="i-lucide-loader-2"
        class="w-8 h-8 text-primary animate-spin"
      />
    </div>
    <NuxtLayout v-else>
      <NuxtPage />
    </NuxtLayout>
  </UApp>
</template>
