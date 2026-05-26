<script setup lang="ts">
/**
 * Admin Panel — Inbox (Real Notifications)
 *
 * Reads from users/{uid}/notifications/ via useNotifications composable.
 * Replaces the template mock /api/mails endpoint with live Firestore data.
 */
import { useNotifications, type Notification } from '~/composables/useNotifications'
import { useBreakpoints } from '@vueuse/core'

definePageMeta({
  layout: 'admin-dashboard'
})

const {
  notifications,
  archivedNotifications,
  unreadCount,
  loading,
  showArchived,
  markRead,
  markAllRead,
  archiveNotification,
  unarchiveNotification,
  toggleArchived,
} = useNotifications()

const tabItems = [{
  label: 'All',
  value: 'all'
}, {
  label: 'Unread',
  value: 'unread'
}, {
  label: 'Archived',
  value: 'archived'
}]
const selectedTab = ref('all')

// Sync tab ↔ archived view
watch(selectedTab, (tab) => {
  if (tab === 'archived' && !showArchived.value) toggleArchived()
  else if (tab !== 'archived' && showArchived.value) toggleArchived()
})

const selectedNotif = ref<Notification | null>(null)

// Breakpoint: only show slideover on mobile
const breakpoints = useBreakpoints({ lg: 1024 })
const isMobile = breakpoints.smaller('lg')
const isSlideoverOpen = computed({
  get: () => isMobile.value && !!selectedNotif.value,
  set: (v: boolean) => { if (!v) selectedNotif.value = null },
})

// Display list based on tab
const displayedNotifs = computed(() => {
  if (selectedTab.value === 'archived') return archivedNotifications.value
  if (selectedTab.value === 'unread') return notifications.value.filter(n => !n.isRead)
  return notifications.value
})

// Icons and colors
function getIcon(type: string): string {
  const map: Record<string, string> = {
    booking_received: 'i-lucide-calendar-plus',
    booking_reminder: 'i-lucide-calendar-check',
    booking_change: 'i-lucide-calendar-clock',
    staff_invite: 'i-lucide-user-plus',
    staff_claimed: 'i-lucide-user-check',
    system_alert: 'i-lucide-bell',
    feedback: 'i-lucide-message-square-text',
  }
  return map[type] || 'i-lucide-bell'
}

function getColor(type: string): string {
  const map: Record<string, string> = {
    booking_received: 'text-green-500',
    booking_reminder: 'text-blue-500',
    booking_change: 'text-amber-500',
    staff_invite: 'text-purple-500',
    staff_claimed: 'text-emerald-500',
    system_alert: 'text-gray-500',
    feedback: 'text-cyan-500',
  }
  return map[type] || 'text-gray-500'
}

function relativeTime(iso: string | null): string {
  if (!iso) return ''
  const now = Date.now()
  const then = new Date(iso).getTime()
  const diff = now - then
  const mins = Math.floor(diff / 60000)
  if (mins < 1) return 'Just now'
  if (mins < 60) return `${mins}m ago`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `${hours}h ago`
  const days = Math.floor(hours / 24)
  if (days < 7) return `${days}d ago`
  return new Date(iso).toLocaleDateString('nb-NO', { day: 'numeric', month: 'short' })
}

function selectNotif(notif: Notification) {
  selectedNotif.value = notif
  if (!notif.isRead) markRead(notif.id)
}

function handleArchive(notif: Notification) {
  if (showArchived.value) {
    unarchiveNotification(notif.id)
  } else {
    archiveNotification(notif.id)
  }
  if (selectedNotif.value?.id === notif.id) selectedNotif.value = null
}

// Deep-link: if notification has context.feedbackId, link to feedback page
function getFeedbackLink(notif: Notification): string | null {
  const ctx = notif.context as any
  if (ctx?.feedbackId) return `/feedback`
  return null
}
</script>

<template>
  <UDashboardPanel
    id="inbox-1"
    :default-size="30"
    :min-size="25"
    :max-size="40"
    resizable
  >
    <UDashboardNavbar title="Inbox">
      <template #leading>
        <UDashboardSidebarCollapse />
      </template>
      <template #trailing>
        <UBadge
          v-if="unreadCount > 0"
          :label="unreadCount"
          color="info"
          variant="subtle"
        />
      </template>
      <template #right>
        <div class="flex items-center gap-2">
          <UButton
            v-if="unreadCount > 0 && selectedTab !== 'archived'"
            variant="ghost"
            size="xs"
            icon="i-lucide-check-check"
            label="Mark all read"
            @click="markAllRead"
          />
          <UTabs
            v-model="selectedTab"
            :items="tabItems"
            :content="false"
            size="xs"
          />
        </div>
      </template>
    </UDashboardNavbar>

    <!-- Notification List -->
    <div class="flex-1 overflow-y-auto">
      <!-- Loading -->
      <div v-if="loading" class="p-4 space-y-3">
        <USkeleton v-for="i in 5" :key="i" class="h-16 w-full rounded-xl" />
      </div>

      <!-- Empty -->
      <div v-else-if="displayedNotifs.length === 0" class="flex flex-col items-center justify-center py-16">
        <UIcon
          :name="selectedTab === 'archived' ? 'i-lucide-archive-x' : 'i-lucide-bell-off'"
          class="size-10 text-muted mb-3"
        />
        <p class="text-sm text-muted">
          {{ selectedTab === 'archived' ? 'No archived notifications' : 'No notifications yet' }}
        </p>
      </div>

      <!-- Items -->
      <div v-else class="divide-y divide-default">
        <div
          v-for="notif in displayedNotifs"
          :key="notif.id"
          class="group flex items-start gap-3 px-4 py-3 cursor-pointer transition-colors"
          :class="[
            selectedNotif?.id === notif.id
              ? 'bg-primary/5'
              : notif.isRead
                ? 'hover:bg-elevated/50'
                : 'bg-elevated/30 hover:bg-elevated/50',
          ]"
          @click="selectNotif(notif)"
        >
          <!-- Icon -->
          <div
            class="w-8 h-8 rounded-lg flex items-center justify-center shrink-0 mt-0.5"
            :class="notif.isRead ? 'bg-muted/20' : 'bg-primary/10'"
          >
            <UIcon
              :name="notif.icon || getIcon(notif.type)"
              class="size-4"
              :class="notif.isRead ? 'text-muted' : getColor(notif.type)"
            />
          </div>

          <!-- Content -->
          <div class="flex-1 min-w-0">
            <p
              class="text-sm leading-tight truncate"
              :class="notif.isRead ? 'text-muted' : 'text-default font-medium'"
            >
              {{ notif.title }}
            </p>
            <p class="text-xs text-muted mt-0.5 line-clamp-1">{{ notif.body }}</p>
            <p class="text-xs text-dimmed mt-0.5">{{ relativeTime(notif.createdAt) }}</p>
          </div>

          <!-- Actions -->
          <div class="flex items-center gap-1 shrink-0">
            <span v-if="!notif.isRead" class="w-2 h-2 rounded-full bg-primary-500" />
            <UButton
              variant="ghost"
              size="xs"
              :icon="showArchived ? 'i-lucide-archive-restore' : 'i-lucide-archive'"
              class="opacity-0 group-hover:opacity-100 transition-opacity"
              @click.stop="handleArchive(notif)"
            />
          </div>
        </div>
      </div>
    </div>
  </UDashboardPanel>

  <!-- Detail Panel (desktop) -->
  <div v-if="selectedNotif" class="hidden lg:flex flex-1 flex-col">
    <UDashboardNavbar>
      <template #right>
        <UButton
          variant="ghost"
          icon="i-lucide-x"
          size="sm"
          @click="selectedNotif = null"
        />
      </template>
    </UDashboardNavbar>

    <div class="flex-1 p-6 overflow-y-auto">
      <div class="max-w-2xl mx-auto space-y-4">
        <!-- Header -->
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 rounded-xl flex items-center justify-center bg-primary/10">
            <UIcon
              :name="selectedNotif.icon || getIcon(selectedNotif.type)"
              class="size-5"
              :class="getColor(selectedNotif.type)"
            />
          </div>
          <div>
            <h2 class="text-lg font-semibold">{{ selectedNotif.title }}</h2>
            <p class="text-xs text-muted">{{ relativeTime(selectedNotif.createdAt) }} · {{ selectedNotif.type }}</p>
          </div>
        </div>

        <!-- Body -->
        <div class="p-4 rounded-xl bg-elevated text-sm leading-relaxed">
          {{ selectedNotif.body }}
        </div>

        <!-- Context -->
        <div v-if="selectedNotif.context" class="text-xs text-muted space-y-1 p-3 rounded-lg bg-muted/10 border border-default">
          <p v-if="(selectedNotif.context as any).feedbackId">
            <span class="font-medium">Feedback ID:</span> {{ (selectedNotif.context as any).feedbackId }}
          </p>
          <p v-if="selectedNotif.context.bookingId">
            <span class="font-medium">Booking:</span> {{ selectedNotif.context.bookingId }}
          </p>
          <p v-if="selectedNotif.context.companyId">
            <span class="font-medium">Company:</span> {{ selectedNotif.context.companyId }}
          </p>
          <p v-if="selectedNotif.context.threadId">
            <span class="font-medium">Thread:</span> {{ selectedNotif.context.threadId }}
          </p>
        </div>

        <!-- Actions -->
        <div class="flex items-center gap-2">
          <NuxtLink v-if="getFeedbackLink(selectedNotif)" :to="getFeedbackLink(selectedNotif)!">
            <UButton
              variant="soft"
              color="primary"
              size="sm"
              icon="i-lucide-external-link"
              label="View in Feedback"
            />
          </NuxtLink>
          <UButton
            variant="ghost"
            size="sm"
            :icon="showArchived ? 'i-lucide-archive-restore' : 'i-lucide-archive'"
            :label="showArchived ? 'Unarchive' : 'Archive'"
            @click="handleArchive(selectedNotif!)"
          />
        </div>
      </div>
    </div>
  </div>

  <!-- No selection (desktop) -->
  <div v-else class="hidden lg:flex flex-1 items-center justify-center">
    <UIcon name="i-lucide-inbox" class="size-32 text-dimmed" />
  </div>

  <!-- Detail Slideover (mobile only — desktop uses the inline panel above) -->
  <ClientOnly>
    <USlideover
      v-if="isMobile"
      v-model:open="isSlideoverOpen"
    >
      <template #content>
        <div v-if="selectedNotif" class="p-6 space-y-4">
          <div class="flex items-start gap-3">
            <div class="w-10 h-10 rounded-xl flex items-center justify-center bg-primary/10">
              <UIcon
                :name="selectedNotif.icon || getIcon(selectedNotif.type)"
                class="size-5"
                :class="getColor(selectedNotif.type)"
              />
            </div>
            <div>
              <h2 class="text-lg font-semibold">{{ selectedNotif.title }}</h2>
              <p class="text-xs text-muted">{{ relativeTime(selectedNotif.createdAt) }}</p>
            </div>
          </div>
          <p class="text-sm">{{ selectedNotif.body }}</p>
          <div class="flex items-center gap-2">
            <UButton
              variant="ghost"
              size="sm"
              :icon="showArchived ? 'i-lucide-archive-restore' : 'i-lucide-archive'"
              :label="showArchived ? 'Unarchive' : 'Archive'"
              @click="handleArchive(selectedNotif!)"
            />
          </div>
        </div>
      </template>
    </USlideover>
  </ClientOnly>
</template>
