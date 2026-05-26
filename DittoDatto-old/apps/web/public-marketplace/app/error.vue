<script setup lang="ts">
import type { NuxtError } from '#app'

const props = defineProps<{ error: NuxtError }>()

const is404 = computed(() => props.error.statusCode === 404)

function handleError() {
  clearError({ redirect: '/' })
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-default">
    <div class="text-center px-6">
      <p class="text-6xl font-bold text-primary mb-4">
        {{ error.statusCode }}
      </p>
      <h1 class="text-xl font-semibold mb-2">
        {{ is404 ? 'Page not found' : 'Something went wrong' }}
      </h1>
      <p class="text-muted mb-8 max-w-sm mx-auto">
        {{ is404 ? "The page you're looking for doesn't exist." : error.message }}
      </p>
      <UButton
        color="primary"
        size="lg"
        icon="i-lucide-home"
        label="Back to home"
        @click="handleError"
      />
    </div>
  </div>
</template>
