<!-- apps/public-marketplace/app/pages/maintenance.vue -->
<script setup lang="ts">
const { settings } = useSiteSettings()
const { t } = useI18n()
console.log(settings)
definePageMeta({
  layout: false
})
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900 px-4">
    <div class="max-w-md w-full text-center">
      <div class="mb-8">
        <UIcon name="i-lucide-wrench" class="size-20 mx-auto text-primary-500 mb-4" />
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">
          {{ t('maintenance.title') }}
        </h1>
        <p class="text-lg text-gray-600 dark:text-gray-400">
          {{ settings?.maintenanceMode?.message || t('maintenance.defaultMessage') }}
        </p>
      </div>
    </div>
  </div>
</template>
