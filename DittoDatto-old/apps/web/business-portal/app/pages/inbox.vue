<script setup lang="ts">
/**
 * Messages & Notifications — Unified Inbox
 *
 * Two modes:
 * - Varsler (Notifications): Activity feed powered by useNotifications()
 * - Samtaler (Conversations): Real-time threads powered by useThreads()
 *
 * Detail panel shows either notification detail or conversation thread.
 * 
 * TODO: Modularize this template, its 700 lines
 * 
 */
import type { Notification } from '~/composables/useNotifications'
import type { Thread } from '@dittodatto/shared-types'

definePageMeta({
  layout: 'dashboard',
})

// ============================================================
// MODE: Top-level inbox mode
// ============================================================
type InboxMode = 'notifications' | 'conversations'
const inboxMode = ref<InboxMode>('notifications')

// ============================================================
// NOTIFICATIONS (existing functionality)
// ============================================================
const {
  notifications,
  archivedNotifications,
  unreadCount: notifUnreadCount,
  loading: notifLoading,
  showArchived,
  toggleArchived,
  markRead,
  markAllRead,
  archiveNotification,
  unarchiveNotification,
} = useNotifications()

type FilterTab = 'all' | 'unread'
const activeFilter = ref<FilterTab>('all')

const filteredNotifications = computed(() => {
  const source = showArchived.value ? archivedNotifications.value : notifications.value
  if (activeFilter.value === 'unread') {
    return source.filter((n) => !n.isRead)
  }
  return source
})

const tabItems = computed(() => [
  { label: 'Alle', value: 'all' as const, count: notifications.value.length },
  { label: 'Uleste', value: 'unread' as const, count: notifUnreadCount.value },
])

const selectedNotification = ref<Notification | null>(null)

function selectNotification(notif: Notification) {
  selectedNotification.value = notif
  selectedThread.value = null
  if (!notif.isRead) {
    markRead(notif.id)
  }
}

// ============================================================
// CONVERSATIONS (new thread functionality)
// ============================================================
const {
  threads,
  loading: threadsLoading,
  totalUnread: threadsUnreadCount,
  activeThread,
  messages,
  messagesLoading,
  openThread,
  closeThread,
  sendMessage,
} = useThreads()

const selectedThread = ref<Thread | null>(null)
const messageInput = ref('')

function selectThread(thread: Thread) {
  selectedThread.value = thread
  selectedNotification.value = null
  openThread(thread.id)
}

async function handleSendMessage() {
  if (!selectedThread.value || !messageInput.value.trim()) return
  await sendMessage(selectedThread.value.id, messageInput.value)
  messageInput.value = ''
}

// ============================================================
// HELPERS (modularized into composable)
// ============================================================
const {
  getNotifIcon,
  getNotifColor,
  getNotifBgColor,
  getTypeLabel,
  getThreadIcon,
  getThreadColor,
  getThreadTypeLabel,
  relativeTime,
  formatFullDate,
} = useInboxHelpers()

// Current user for message bubble alignment
const currentUser = useCurrentUser()
</script>

<template>
  <!-- List panel -->
  <UDashboardPanel
    id="messages-list"
    :default-size="35"
    :min-size="25"
    :max-size="50"
    resizable
  >
    <template #header>
      <UDashboardNavbar title="Meldinger">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>

        <template #trailing>
          <UBadge
            v-if="(inboxMode === 'notifications' ? notifUnreadCount : threadsUnreadCount) > 0"
            :label="inboxMode === 'notifications' ? notifUnreadCount : threadsUnreadCount"
            color="primary"
            variant="subtle"
          />
        </template>

        <template #right>
          <!-- Mode toggle: Varsler / Samtaler -->
          <div class="flex gap-1">
            <UButton
              label="Varsler"
              size="xs"
              :icon="notifUnreadCount > 0 ? 'i-lucide-bell-dot' : 'i-lucide-bell'"
              :color="inboxMode === 'notifications' ? 'primary' : 'neutral'"
              :variant="inboxMode === 'notifications' ? 'solid' : 'ghost'"
              @click="inboxMode = 'notifications'"
            />
            <UButton
              label="Samtaler"
              size="xs"
              :icon="threadsUnreadCount > 0 ? 'i-lucide-message-circle' : 'i-lucide-messages-square'"
              :color="inboxMode === 'conversations' ? 'primary' : 'neutral'"
              :variant="inboxMode === 'conversations' ? 'solid' : 'ghost'"
              @click="inboxMode = 'conversations'"
            />
          </div>
        </template>
      </UDashboardNavbar>

      <!-- Notifications toolbar -->
      <UDashboardToolbar v-if="inboxMode === 'notifications'">
        <template #left>
          <div class="flex items-center gap-3">
            <div class="flex gap-1">
              <UButton
                v-for="tab in tabItems"
                :key="tab.value"
                :label="`${tab.label} (${tab.count})`"
                size="xs"
                :color="activeFilter === tab.value ? 'primary' : 'neutral'"
                :variant="activeFilter === tab.value ? 'solid' : 'ghost'"
                @click="activeFilter = tab.value"
              />
            </div>
            <UButton
              v-if="notifUnreadCount > 0 && !showArchived"
              variant="ghost"
              size="xs"
              icon="i-lucide-check-check"
              label="Merk alle som lest"
              @click="markAllRead"
            />
          </div>
        </template>

        <template #right>
          <UButton
            :icon="showArchived ? 'i-lucide-inbox' : 'i-lucide-archive'"
            :label="showArchived ? 'Vis aktive' : 'Vis arkiverte'"
            size="xs"
            color="neutral"
            variant="ghost"
            @click="toggleArchived"
          />
        </template>
      </UDashboardToolbar>

      <!-- Conversations toolbar -->
      <UDashboardToolbar v-if="inboxMode === 'conversations'">
        <template #left>
          <span class="text-xs text-muted">
            {{ threads.length }} {{ threads.length === 1 ? 'samtale' : 'samtaler' }}
          </span>
        </template>
      </UDashboardToolbar>
    </template>

    <template #body>
      <!-- ========== NOTIFICATIONS MODE ========== -->
      <template v-if="inboxMode === 'notifications'">
        <!-- Loading -->
        <div v-if="notifLoading" class="p-4 space-y-3">
          <div v-for="i in 5" :key="i" class="flex items-start gap-3 p-3">
            <USkeleton class="size-10 rounded-lg shrink-0" />
            <div class="flex-1 space-y-2">
              <USkeleton class="h-4 w-3/4" />
              <USkeleton class="h-3 w-1/2" />
            </div>
          </div>
        </div>

        <!-- Empty -->
        <div v-else-if="filteredNotifications.length === 0" class="flex flex-col items-center justify-center py-16 px-6">
          <UIcon
            :name="showArchived ? 'i-lucide-archive' : 'i-lucide-bell-off'"
            class="size-16 text-muted opacity-40 mb-4"
          />
          <h3 class="text-lg font-semibold mb-1">
            {{ showArchived ? 'Ingen arkiverte varsler' : activeFilter === 'unread' ? 'Ingen uleste varsler' : 'Ingen varsler ennå' }}
          </h3>
          <p class="text-sm text-muted text-center max-w-xs">
            {{ showArchived
              ? 'Arkiverte varsler vil vises her.'
              : 'Du vil motta varsler når bestillinger kommer inn, personalet godtar invitasjoner, og mer.'
            }}
          </p>
        </div>

        <!-- Notification list -->
        <div v-else class="divide-y divide-default">
          <div
            v-for="notif in filteredNotifications"
            :key="notif.id"
            class="group flex items-start gap-3 px-4 py-3 cursor-pointer transition-all"
            :class="[
              selectedNotification?.id === notif.id
                ? 'bg-primary-50/70 dark:bg-primary-950/30'
                : notif.isRead
                  ? 'hover:bg-elevated/50'
                  : 'bg-primary-50/30 dark:bg-primary-950/10 hover:bg-primary-50/50 dark:hover:bg-primary-950/20',
            ]"
            @click="selectNotification(notif)"
          >
            <div
              class="size-10 rounded-lg flex items-center justify-center shrink-0 mt-0.5"
              :class="getNotifBgColor(notif.type, notif.isRead)"
            >
              <UIcon
                :name="notif.icon || getNotifIcon(notif.type)"
                class="size-5"
                :class="notif.isRead ? 'text-gray-400 dark:text-gray-500' : getNotifColor(notif.type)"
              />
            </div>
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
            <div class="flex items-center gap-1.5 shrink-0 mt-1">
              <span v-if="!notif.isRead" class="size-2 rounded-full bg-primary-500" />
              <UButton
                v-if="!showArchived"
                variant="ghost"
                size="xs"
                icon="i-lucide-archive"
                class="opacity-0 group-hover:opacity-100 transition-opacity"
                aria-label="Arkiver"
                @click.stop="archiveNotification(notif.id)"
              />
              <UButton
                v-if="showArchived"
                variant="ghost"
                size="xs"
                icon="i-lucide-inbox"
                class="opacity-0 group-hover:opacity-100 transition-opacity"
                aria-label="Gjenopprett"
                @click.stop="unarchiveNotification(notif.id)"
              />
            </div>
          </div>
        </div>
      </template>

      <!-- ========== CONVERSATIONS MODE ========== -->
      <template v-if="inboxMode === 'conversations'">
        <!-- Loading -->
        <div v-if="threadsLoading" class="p-4 space-y-3">
          <div v-for="i in 4" :key="i" class="flex items-start gap-3 p-3">
            <USkeleton class="size-10 rounded-lg shrink-0" />
            <div class="flex-1 space-y-2">
              <USkeleton class="h-4 w-2/3" />
              <USkeleton class="h-3 w-full" />
            </div>
          </div>
        </div>

        <!-- Empty -->
        <div v-else-if="threads.length === 0" class="flex flex-col items-center justify-center py-16 px-6">
          <UIcon
            name="i-lucide-messages-square"
            class="size-16 text-muted opacity-40 mb-4"
          />
          <h3 class="text-lg font-semibold mb-1">Ingen samtaler ennå</h3>
          <p class="text-sm text-muted text-center max-w-xs">
            Samtaler opprettes automatisk når kunder legger igjen kommentarer på bestillinger.
          </p>
        </div>

        <!-- Thread list -->
        <div v-else class="divide-y divide-default">
          <div
            v-for="thread in threads"
            :key="thread.id"
            class="group flex items-start gap-3 px-4 py-3 cursor-pointer transition-all"
            :class="[
              selectedThread?.id === thread.id
                ? 'bg-primary-50/70 dark:bg-primary-950/30'
                : (thread.unreadByUser?.[currentUser?.uid || ''] || 0) > 0
                  ? 'bg-primary-50/30 dark:bg-primary-950/10 hover:bg-primary-50/50 dark:hover:bg-primary-950/20'
                  : 'hover:bg-elevated/50',
            ]"
            @click="selectThread(thread)"
          >
            <!-- Icon -->
            <div class="size-10 rounded-lg flex items-center justify-center shrink-0 mt-0.5 bg-elevated">
              <UIcon
                :name="getThreadIcon(thread.type)"
                class="size-5"
                :class="getThreadColor(thread.type)"
              />
            </div>

            <!-- Content -->
            <div class="flex-1 min-w-0">
              <div class="flex items-center justify-between gap-2">
                <p
                  class="text-sm leading-tight truncate"
                  :class="(thread.unreadByUser?.[currentUser?.uid || ''] || 0) > 0
                    ? 'text-highlighted font-medium'
                    : 'text-muted'"
                >
                  {{ thread.subject || getThreadTypeLabel(thread.type) }}
                </p>
                <time class="text-dimmed text-xs shrink-0">{{ relativeTime(thread.lastMessageAt) }}</time>
              </div>
              <p class="text-dimmed text-xs mt-0.5 line-clamp-1">
                {{ thread.lastMessagePreview || 'Ingen meldinger ennå' }}
              </p>
            </div>

            <!-- Unread badge -->
            <div class="flex items-center gap-1.5 shrink-0 mt-1">
              <UBadge
                v-if="(thread.unreadByUser?.[currentUser?.uid || ''] || 0) > 0"
                :label="thread.unreadByUser?.[currentUser?.uid || ''] || 0"
                color="primary"
                size="xs"
              />
              <!-- Thread mode indicator -->
              <UTooltip
                v-if="thread.mode === 'agent'"
                text="Datto svarer automatisk"
              >
                <UIcon name="i-lucide-bot" class="size-4 text-cyan-500" />
              </UTooltip>
            </div>
          </div>
        </div>
      </template>
    </template>
  </UDashboardPanel>

  <!-- ========== DETAIL PANEL ========== -->
  <UDashboardPanel id="messages-detail">
    <!-- NOTIFICATION DETAIL -->
    <template v-if="selectedNotification" #header>
      <UDashboardNavbar :title="getTypeLabel(selectedNotification.type)" :toggle="false">
        <template #leading>
          <UButton
            icon="i-lucide-x"
            color="neutral"
            variant="ghost"
            class="-ms-1.5"
            @click="selectedNotification = null"
          />
        </template>
        <template #right>
          <UButton
            v-if="!showArchived"
            icon="i-lucide-archive"
            color="neutral"
            variant="ghost"
            size="sm"
            label="Arkiver"
            @click="archiveNotification(selectedNotification!.id); selectedNotification = null"
          />
          <UButton
            v-if="showArchived"
            icon="i-lucide-inbox"
            color="neutral"
            variant="ghost"
            size="sm"
            label="Gjenopprett"
            @click="unarchiveNotification(selectedNotification!.id); selectedNotification = null"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <!-- THREAD DETAIL -->
    <template v-else-if="activeThread" #header>
      <UDashboardNavbar
        :title="activeThread.subject || getThreadTypeLabel(activeThread.type)"
        :toggle="false"
      >
        <template #leading>
          <UButton
            icon="i-lucide-x"
            color="neutral"
            variant="ghost"
            class="-ms-1.5"
            @click="closeThread(); selectedThread = null"
          />
        </template>
        <template #right>
          <UBadge
            :label="getThreadTypeLabel(activeThread.type)"
            variant="subtle"
            size="xs"
          />
          <UBadge
            v-if="activeThread.mode === 'agent'"
            label="Datto"
            color="info"
            variant="subtle"
            size="xs"
            icon="i-lucide-bot"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <!-- NOTIFICATION DETAIL BODY -->
      <div v-if="selectedNotification" class="p-6 space-y-6">
        <div class="flex items-start gap-4">
          <div
            class="size-12 rounded-xl flex items-center justify-center shrink-0"
            :class="getNotifBgColor(selectedNotification.type, false)"
          >
            <UIcon
              :name="selectedNotification.icon || getNotifIcon(selectedNotification.type)"
              class="size-6"
              :class="getNotifColor(selectedNotification.type)"
            />
          </div>
          <div class="flex-1 min-w-0">
            <h2 class="text-lg font-semibold text-highlighted">
              {{ selectedNotification.title }}
            </h2>
            <div class="flex items-center gap-3 mt-1 text-sm text-muted">
              <UBadge
                :label="getTypeLabel(selectedNotification.type)"
                variant="subtle"
                size="xs"
              />
              <time>{{ formatFullDate(selectedNotification.createdAt) }}</time>
            </div>
          </div>
        </div>

        <UCard variant="subtle">
          <p class="text-sm leading-relaxed whitespace-pre-wrap">
            {{ selectedNotification.body }}
          </p>
        </UCard>

        <div v-if="selectedNotification.actionUrl" class="flex justify-end">
          <UButton
            :to="selectedNotification.actionUrl"
            icon="i-lucide-external-link"
            label="Gå til"
            color="primary"
            variant="soft"
          />
        </div>
      </div>

      <!-- THREAD DETAIL BODY -->
      <div v-else-if="activeThread" class="flex flex-col h-full">
        <!-- Messages area -->
        <div class="flex-1 overflow-y-auto p-4 space-y-3">
          <!-- Loading messages -->
          <div v-if="messagesLoading" class="space-y-3">
            <div v-for="i in 3" :key="i" class="flex gap-2" :class="i % 2 === 0 ? 'justify-end' : ''">
              <USkeleton class="h-12 w-2/3 rounded-xl" />
            </div>
          </div>

          <!-- No messages yet -->
          <div v-else-if="messages.length === 0" class="flex items-center justify-center py-12">
            <p class="text-sm text-muted">Ingen meldinger i denne samtalen ennå.</p>
          </div>

          <!-- Message bubbles -->
          <div
            v-for="msg in messages"
            :key="msg.id"
            class="flex gap-2"
            :class="msg.senderId === currentUser?.uid ? 'justify-end' : ''"
          >
            <!-- Sender avatar for others -->
            <div
              v-if="msg.senderId !== currentUser?.uid"
              class="size-8 rounded-full bg-elevated flex items-center justify-center shrink-0 mt-1"
            >
              <UIcon
                :name="msg.senderType === 'datto' ? 'i-lucide-bot' : 'i-lucide-user'"
                class="size-4 text-muted"
              />
            </div>

            <div
              class="max-w-[75%] rounded-xl px-3.5 py-2.5 text-sm leading-relaxed"
              :class="msg.senderId === currentUser?.uid
                ? 'bg-primary-500 text-white rounded-br-sm'
                : msg.senderType === 'datto'
                  ? 'bg-cyan-100 dark:bg-cyan-900/30 text-highlighted rounded-bl-sm'
                  : 'bg-elevated text-highlighted rounded-bl-sm'"
            >
              <p class="whitespace-pre-wrap">{{ msg.content }}</p>
              <time
                class="text-[10px] mt-1 block opacity-60"
                :class="msg.senderId === currentUser?.uid ? 'text-right' : ''"
              >
                {{ relativeTime(msg.createdAt) }}
              </time>
            </div>
          </div>
        </div>

        <!-- Message input -->
        <div class="border-t border-default p-3">
          <div class="flex items-end gap-2">
            <UTextarea
              v-model="messageInput"
              placeholder="Skriv en melding..."
              :rows="1"
              autoresize
              class="flex-1"
              @keydown.enter.exact.prevent="handleSendMessage"
            />
            <UButton
              icon="i-lucide-send"
              color="primary"
              :disabled="!messageInput.trim()"
              @click="handleSendMessage"
            />
          </div>
        </div>
      </div>

      <!-- EMPTY STATE -->
      <div v-else class="flex flex-1 h-full items-center justify-center">
        <div class="text-center">
          <UIcon name="i-lucide-mail-open" class="size-24 text-dimmed opacity-30 mb-4" />
          <p class="text-muted text-sm">Velg en melding for å se detaljer</p>
        </div>
      </div>
    </template>
  </UDashboardPanel>
</template>
