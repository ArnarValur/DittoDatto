<script setup lang="ts">
type AuditLog = {
  id: string
  action: string
  details: string
  timestamp: string
}

const props = defineProps<{
  logs: AuditLog[]
}>()

const getActionConfig = (action: string) => {
  switch (action) {
    case 'login':
      return { icon: 'i-lucide-log-in' }
    case 'role_change':
      return { icon: 'i-lucide-shield-alert' }
    case 'invite_sent':
      return { icon: 'i-lucide-send' }
    case 'user_created':
      return { icon: 'i-lucide-user-plus' }
    case 'user_deleted':
      return { icon: 'i-lucide-trash' }
    default:
      return { icon: 'i-lucide-activity' }
  }
}

const timelineItems = computed(() => {
  return props.logs.map((log) => {
    const config = getActionConfig(log.action)
    return {
      date: new Date(log.timestamp).toLocaleString(undefined, {
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      }),
      title: log.action.replace(/_/g, ' ').replace(/\b\w/g, char => char.toUpperCase()),
      description: log.details,
      icon: config.icon
    }
  })
})
</script>

<template>
  <div class="px-4 py-4">
    <h3 class="text-base font-semibold text-gray-900 dark:text-white mb-6">
      Activity History
    </h3>

    <UTimeline
      :items="timelineItems"
      active
      :ui="{
        item: 'min-h-[80px]',
        date: 'text-xs text-gray-500 dark:text-gray-400 min-w-[120px] text-right mr-4'
      }"
    />

    <div
      v-if="logs.length === 0"
      class="text-center py-8 text-gray-500"
    >
      <UIcon
        name="i-lucide-history"
        class="w-8 h-8 mx-auto mb-2 opacity-50"
      />
      <p class="text-sm">
        No activity recorded yet.
      </p>
    </div>
  </div>
</template>
