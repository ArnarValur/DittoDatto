<script setup lang="ts">
definePageMeta({
  title: 'Settings',
  layout: 'dashboard'
})
</script>

<template>
  <div class="flex flex-col gap-8 max-w-7xl mx-auto">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-white mb-1">
          Settings
        </h1>
        <p class="text-gray-500 dark:text-gray-400">
          Global configuration for the SearchAnalytics dashboard.
        </p>
      </div>
    </div>

    <UCard>
      <div class="p-12 text-center flex flex-col items-center justify-center">
        <UIcon name="i-lucide-wrench" class="w-12 h-12 text-gray-400 dark:text-gray-500 mb-4" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Settings Currently Unavailable</h3>
        <p class="text-gray-500 dark:text-gray-400 max-w-sm">
          There are no user-configurable settings available in the current MVP phase.
        </p>
      </div>
    </UCard>
  </div>
</template>
