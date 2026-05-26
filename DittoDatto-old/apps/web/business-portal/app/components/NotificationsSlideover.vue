<script setup lang="ts">
import type { Notification } from '~/composables/useNotifications'

const { isNotificationsSlideoverOpen } = useDashboard()
const { notifications, unreadCount, loading, markRead, markAllRead, archiveNotification } = useNotifications()

function getNotifIcon(type: string): string {
  const map: Record<string, string> = {
    booking_received: 'i-lucide-calendar-plus',
    booking_reminder: 'i-lucide-calendar-check',
    booking_change: 'i-lucide-calendar-clock',
    staff_update: 'i-lucide-users',
    system_alert: 'i-lucide-bell',
    agent_insight: 'i-lucide-sparkles',
  }
  return map[type] || 'i-lucide-bell'
}

function getNotifColor(type: string): string {
  const map: Record<string, string> = {
    booking_received: 'text-green-500',
    booking_reminder: 'text-blue-500',
    booking_change: 'text-amber-500',
    staff_update: 'text-purple-500',
    system_alert: 'text-gray-500',
    agent_insight: 'text-cyan-500',
  }
  return map[type] || 'text-gray-500'
}

function relativeTime(iso: string | null): string {
  if (!iso) return ''
  const now = Date.now()
  const then = new Date(iso).getTime()
  const diff = now - then
  const mins = Math.floor(diff / 60000)
  if (mins < 1) return 'Akkurat nå'
  if (mins < 60) return `${mins}m siden`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `${hours}t siden`
  const days = Math.floor(hours / 24)
  if (days < 7) return `${days}d siden`
  return new Date(iso).toLocaleDateString('nb-NO', { day: 'numeric', month: 'short' })
}

function handleClick(notif: Notification) {
  if (!notif.isRead) markRead(notif.id)
}
</script>

<template>
  <USlideover
    v-model:open="isNotificationsSlideoverOpen"
    title="Varsler"
  >
    <template #body>
      <!-- Header actions -->
      <div v-if="unreadCount > 0" class="flex justify-end mb-3">
        <UButton
          variant="ghost"
          size="xs"
          icon="i-lucide-check-check"
          label="Merk alle som lest"
          @click="markAllRead"
        />
      </div>

      <!-- Loading -->
      <div v-if="loading" class="space-y-3">
        <USkeleton v-for="i in 3" :key="i" class="h-16 w-full rounded-lg" />
      </div>

      <!-- Empty state -->
      <div v-else-if="notifications.length === 0" class="text-center py-12">
        <UIcon name="i-lucide-bell-off" class="w-10 h-10 text-gray-300 dark:text-gray-600 mx-auto mb-3" />
        <p class="text-muted text-sm">Ingen varsler ennå</p>
        <p class="text-dimmed text-xs mt-1">Du vil motta varsler her når noe skjer.</p>
      </div>

      <!-- Notification list -->
      <div v-else class="space-y-1 -mx-3 first:-mt-3 last:-mb-3">
        <div
          v-for="notif in notifications"
          :key="notif.id"
          class="group flex items-start gap-3 px-3 py-2.5 rounded-lg cursor-pointer transition-all"
          :class="notif.isRead
            ? 'hover:bg-elevated/50'
            : 'bg-primary-50/50 dark:bg-primary-950/20 hover:bg-primary-50 dark:hover:bg-primary-950/30'"
          @click="handleClick(notif)"
        >
          <!-- Icon -->
          <div
            class="w-8 h-8 rounded-lg flex items-center justify-center shrink-0 mt-0.5"
            :class="notif.isRead ? 'bg-gray-100 dark:bg-gray-800' : 'bg-primary-100 dark:bg-primary-900'"
          >
            <UIcon
              :name="notif.icon || getNotifIcon(notif.type)"
              class="size-4"
              :class="notif.isRead ? 'text-gray-400 dark:text-gray-500' : getNotifColor(notif.type)"
            />
          </div>

          <!-- Content -->
          <div class="flex-1 min-w-0">
            <div class="flex items-center justify-between gap-2">
              <p
                class="text-sm leading-tight truncate"
                :class="notif.isRead ? 'text-muted' : 'text-highlighted font-medium'"
              >
                {{ notif.title }}
              </p>
              <time class="text-dimmed text-xs shrink-0">{{ relativeTime(notif.createdAt) }}</time>
            </div>
            <p class="text-dimmed text-xs mt-0.5 line-clamp-2">{{ notif.body }}</p>
          </div>

          <!-- Actions -->
          <div class="flex items-center gap-1 shrink-0">
            <span v-if="!notif.isRead" class="w-2 h-2 rounded-full bg-primary-500" />
            <UButton
              variant="ghost"
              size="xs"
              icon="i-lucide-archive"
              class="opacity-0 group-hover:opacity-100 transition-opacity"
              aria-label="Arkiver"
              @click.stop="archiveNotification(notif.id)"
            />
          </div>
        </div>
      </div>
    </template>
  </USlideover>
</template>
