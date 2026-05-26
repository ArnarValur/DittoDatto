<script setup lang="ts">
import { useNotifications } from '~/composables/useNotifications'

const { notifications, unreadCount, showArchived, loading, markRead, markAllRead, archiveNotification, unarchiveNotification, toggleArchived } = useNotifications()
const { t } = useI18n()

function getNotifIcon(type: string): string {
  const map: Record<string, string> = {
    booking_reminder: 'i-lucide-calendar-check',
    booking_change: 'i-lucide-calendar-clock',
    broadcast: 'i-lucide-megaphone',
    staff_reply: 'i-lucide-message-circle',
    feedback: 'i-lucide-message-square',
    support: 'i-lucide-life-buoy',
    event_upcoming: 'i-lucide-ticket',
    system_alert: 'i-lucide-bell',
  }
  return map[type] || 'i-lucide-bell'
}

function getNotifColor(type: string): string {
  const map: Record<string, string> = {
    booking_reminder: 'text-green-500',
    booking_change: 'text-amber-500',
    broadcast: 'text-blue-500',
    staff_reply: 'text-purple-500',
    system_alert: 'text-gray-500',
    event_upcoming: 'text-pink-500',
  }
  return map[type] || 'text-gray-500'
}

function relativeTime(iso: string | null): string {
  if (!iso) return ''
  const now = Date.now()
  const then = new Date(iso).getTime()
  const diff = now - then
  const mins = Math.floor(diff / 60000)
  if (mins < 1) return t('notifications.justNow')
  if (mins < 60) return t('notifications.minutesAgo', { n: mins })
  const hours = Math.floor(mins / 60)
  if (hours < 24) return t('notifications.hoursAgo', { n: hours })
  const days = Math.floor(hours / 24)
  if (days < 7) return t('notifications.daysAgo', { n: days })
  return new Date(iso).toLocaleDateString('nb-NO', { day: 'numeric', month: 'short' })
}

function handleCardClick(notif: { id: string; isRead: boolean }) {
  if (!notif.isRead) {
    markRead(notif.id)
  }
}
</script>

<template>
  <div class="space-y-4">
    <!-- Header -->
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-semibold text-gray-900 dark:text-white">
          {{ showArchived ? t('notifications.archivedTitle') : t('notifications.title') }}
        </h2>
        <p class="mt-0.5 text-sm text-gray-500 dark:text-gray-400">
          {{ showArchived ? t('notifications.archivedSubtitle') : t('notifications.subtitle') }}
        </p>
      </div>
      <div class="flex items-center gap-2">
        <UButton
          v-if="unreadCount > 0 && !showArchived"
          variant="ghost"
          size="xs"
          icon="i-lucide-check-check"
          :label="t('notifications.markAllRead')"
          @click="markAllRead"
        />
        <UButton
          :variant="showArchived ? 'soft' : 'ghost'"
          size="xs"
          :icon="showArchived ? 'i-lucide-inbox' : 'i-lucide-archive'"
          :label="showArchived ? t('notifications.showActive') : t('notifications.showArchived')"
          @click="toggleArchived"
        />
      </div>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="space-y-3">
      <USkeleton v-for="i in 3" :key="i" class="h-20 w-full rounded-xl" />
    </div>

    <!-- Empty State -->
    <UCard v-else-if="notifications.length === 0">
      <div class="text-center py-8">
        <UIcon
          :name="showArchived ? 'i-lucide-archive-x' : 'i-lucide-bell-off'"
          class="w-10 h-10 text-gray-300 dark:text-gray-600 mx-auto mb-3"
        />
        <p class="text-gray-500 dark:text-gray-400 text-sm">
          {{ showArchived ? t('notifications.archivedEmpty') : t('notifications.empty') }}
        </p>
        <p class="text-gray-400 dark:text-gray-500 text-xs mt-1">
          {{ showArchived ? t('notifications.archivedEmptyDesc') : t('notifications.emptyDesc') }}
        </p>
      </div>
    </UCard>

    <!-- Notification Cards -->
    <TransitionGroup
      v-else
      name="notif"
      tag="div"
      class="space-y-2"
    >
      <div
        v-for="notif in notifications"
        :key="notif.id"
        class="group flex items-start gap-3 p-3 rounded-xl transition-all cursor-pointer"
        :class="[
          notif.isRead
            ? 'bg-gray-50 dark:bg-gray-900/50'
            : 'bg-white dark:bg-gray-900 ring-1 ring-primary-100 dark:ring-primary-900/30 shadow-sm',
        ]"
        @click="handleCardClick(notif)"
      >
        <!-- Icon -->
        <div
          class="w-9 h-9 rounded-lg flex items-center justify-center shrink-0 mt-0.5"
          :class="notif.isRead ? 'bg-gray-100 dark:bg-gray-800' : 'bg-primary-50 dark:bg-primary-950'"
        >
          <UIcon
            :name="notif.icon || getNotifIcon(notif.type)"
            class="size-4.5"
            :class="notif.isRead ? 'text-gray-400 dark:text-gray-500' : getNotifColor(notif.type)"
          />
        </div>

        <!-- Content -->
        <div class="flex-1 min-w-0">
          <p
            class="text-sm leading-tight"
            :class="notif.isRead
              ? 'text-gray-600 dark:text-gray-400'
              : 'text-gray-900 dark:text-white font-medium'"
          >
            {{ notif.title }}
          </p>
          <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5 line-clamp-2">
            {{ notif.body }}
          </p>
          <p class="text-xs text-gray-400 dark:text-gray-500 mt-1">
            {{ relativeTime(notif.createdAt) }}
          </p>
        </div>

        <!-- Unread dot + Archive action -->
        <div class="flex items-center gap-1 shrink-0">
          <!-- Unread indicator -->
          <span
            v-if="!notif.isRead"
            class="w-2 h-2 rounded-full bg-primary-500"
          />

          <!-- Archive/Unarchive button (visible on hover) -->
          <UButton
            variant="ghost"
            size="xs"
            :icon="showArchived ? 'i-lucide-archive-restore' : 'i-lucide-archive'"
            class="opacity-0 group-hover:opacity-100 transition-opacity"
            :aria-label="showArchived ? t('notifications.unarchive') : t('notifications.archive')"
            @click.stop="showArchived ? unarchiveNotification(notif.id) : archiveNotification(notif.id)"
          />
        </div>
      </div>
    </TransitionGroup>
  </div>
</template>

<style scoped>
.notif-enter-active,
.notif-leave-active {
  transition: all 0.3s ease;
}
.notif-enter-from {
  opacity: 0;
  transform: translateY(-8px);
}
.notif-leave-to {
  opacity: 0;
  transform: translateX(16px);
}
.notif-move {
  transition: transform 0.3s ease;
}
</style>
