<script setup lang="ts">
/**
 * Messages Panel
 *
 * Placeholder for future direct messaging between users and businesses.
 * Currently shows a contextual empty state with i18n support.
 */
const { t } = useI18n()
</script>

<template>
  <UCard>
    <div class="text-center py-12">
      <div class="mx-auto w-16 h-16 rounded-full bg-blue-50 dark:bg-blue-950 flex items-center justify-center mb-4">
        <UIcon name="i-lucide-message-circle" class="w-8 h-8 text-blue-500" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
        {{ t('notifications.messagesComingSoon') }}
      </h3>
      <p class="text-gray-500 dark:text-gray-400 max-w-sm mx-auto">
        {{ t('notifications.messagesComingSoonDesc') }}
      </p>
    </div>
  </UCard>
</template>
