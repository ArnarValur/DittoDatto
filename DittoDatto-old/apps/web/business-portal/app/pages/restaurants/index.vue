<script setup lang="ts">
/**
 * Redirect /restaurants to /establishments with restaurant filter
 */
definePageMeta({
  layout: 'dashboard'
})

// Redirect to unified establishments page
onMounted(() => {
  navigateTo('/establishments', { replace: true })
})
</script>

<template>
  <div class="p-6 flex items-center justify-center">
    <UIcon name="i-lucide-loader-2" class="size-8 animate-spin text-muted" />
    <span class="ml-2 text-muted">Redirecting to Establishments...</span>
  </div>
</template>
