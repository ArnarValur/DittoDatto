# Communications & Notifications System Bundle
*A consolidated bundle of scripts and templates for the cross-platform communications system.*

---

## 1. Public Marketplace

### `apps/web/public-marketplace/app/composables/useNotifications.ts`
```typescript
/**
 * useNotifications composable
 *
 * Real-time listener on users/{uid}/notifications/ subcollection.
 * Provides unread count, notification list, and mark-read/archive actions.
 *
 * Phase 1: In-app only (no FCM, no email).
 */
import {
  collection,
  query,
  where,
  orderBy,
  limit,
  onSnapshot,
  doc,
  updateDoc,
  writeBatch,
  type Unsubscribe,
} from 'firebase/firestore'

export interface Notification {
  id: string
  type: string
  title: string
  body: string
  icon?: string
  context?: {
    bookingId?: string
    companyId?: string
    storeId?: string
    eventId?: string
    threadId?: string
  }
  isRead: boolean
  isArchived: boolean
  requiresAction: boolean
  respondedBy?: string
  createdAt: string | null
}

// Shared singleton state (SSR-safe via module-level refs)
const notifications = ref<Notification[]>([])
const loading = ref(false)
const error = ref<string | null>(null)
const showArchived = ref(false)
let unsubscribe: Unsubscribe | null = null

export function useNotifications() {
  const db = useFirestore()
  const user = useCurrentUser()

  const unreadCount = computed(() =>
    notifications.value.filter(n => !n.isRead).length
  )

  /**
   * Start real-time listener for the current user's notifications.
   * Call this when the user logs in or the composable mounts.
   */
  function subscribe() {
    // Clean up any existing listener
    if (unsubscribe) {
      unsubscribe()
      unsubscribe = null
    }

    if (!user.value) {
      notifications.value = []
      return
    }

    loading.value = true
    error.value = null

    const notifRef = collection(db, 'users', user.value.uid, 'notifications')
    const q = query(
      notifRef,
      where('isArchived', '==', showArchived.value),
      orderBy('createdAt', 'desc'),
      limit(50)
    )

    unsubscribe = onSnapshot(
      q,
      (snapshot) => {
        notifications.value = snapshot.docs.map(d => {
          const data = d.data()
          return {
            id: d.id,
            type: data.type || 'system_alert',
            title: data.title || '',
            body: data.body || '',
            icon: data.icon,
            context: data.context,
            isRead: data.isRead ?? false,
            isArchived: data.isArchived ?? false,
            requiresAction: data.requiresAction ?? false,
            respondedBy: data.respondedBy,
            createdAt: data.createdAt?.toDate?.()?.toISOString?.() ?? null,
          } as Notification
        })
        loading.value = false
      },
      (err) => {
        console.error('[useNotifications] Listener error:', err)
        error.value = err.message || 'Failed to load notifications'
        loading.value = false
      }
    )
  }

  /**
   * Stop the real-time listener. Call on logout or unmount.
   */
  function stop() {
    if (unsubscribe) {
      unsubscribe()
      unsubscribe = null
    }
    notifications.value = []
  }

  /**
   * Mark a single notification as read.
   */
  async function markRead(notifId: string) {
    if (!user.value) return

    try {
      const notifRef = doc(db, 'users', user.value.uid, 'notifications', notifId)
      await updateDoc(notifRef, { isRead: true })
      // Optimistic update
      const n = notifications.value.find(n => n.id === notifId)
      if (n) n.isRead = true
    } catch (e: any) {
      console.error('[useNotifications] Failed to mark read:', e)
    }
  }

  /**
   * Mark all unread notifications as read.
   */
  async function markAllRead() {
    if (!user.value) return

    const unread = notifications.value.filter(n => !n.isRead)
    if (unread.length === 0) return

    try {
      const batch = writeBatch(db)
      for (const n of unread) {
        const ref = doc(db, 'users', user.value.uid, 'notifications', n.id)
        batch.update(ref, { isRead: true })
      }
      await batch.commit()
      // Optimistic update
      unread.forEach(n => { n.isRead = true })
    } catch (e: any) {
      console.error('[useNotifications] Failed to mark all read:', e)
    }
  }

  /**
   * Archive a notification (hides it from the feed).
   */
  async function archiveNotification(notifId: string) {
    if (!user.value) return

    try {
      const notifRef = doc(db, 'users', user.value.uid, 'notifications', notifId)
      await updateDoc(notifRef, { isArchived: true })
      // Optimistic removal (listener will also remove it)
      notifications.value = notifications.value.filter(n => n.id !== notifId)
    } catch (e: any) {
      console.error('[useNotifications] Failed to archive:', e)
    }
  }

  /**
   * Unarchive a notification (restores it to the active feed).
   */
  async function unarchiveNotification(notifId: string) {
    if (!user.value) return

    try {
      const notifRef = doc(db, 'users', user.value.uid, 'notifications', notifId)
      await updateDoc(notifRef, { isArchived: false })
      notifications.value = notifications.value.filter(n => n.id !== notifId)
    } catch (e: any) {
      console.error('[useNotifications] Failed to unarchive:', e)
    }
  }

  /**
   * Toggle between active and archived notifications.
   */
  function toggleArchived() {
    showArchived.value = !showArchived.value
    subscribe()
  }

  // Auto-subscribe when user changes
  watch(user, (newUser) => {
    if (newUser) {
      subscribe()
    } else {
      stop()
    }
  }, { immediate: true })

  return {
    notifications: readonly(notifications),
    unreadCount,
    showArchived: readonly(showArchived),
    loading: readonly(loading),
    error: readonly(error),
    subscribe,
    stop,
    markRead,
    markAllRead,
    archiveNotification,
    unarchiveNotification,
    toggleArchived,
  }
}
```

### `apps/web/public-marketplace/app/composables/useUserThreads.ts`
```typescript
import { collection, query, where, orderBy, onSnapshot, addDoc, updateDoc, doc, serverTimestamp, increment, getDoc } from 'firebase/firestore'
import { useFirestore, useCurrentUser } from 'vuefire'
import type { Thread, Message } from '@dittodatto/shared-types'

/**
 * useUserThreads — Real-time thread management for the public-marketplace (user side).
 *
 * Mirrors the business-portal's useThreads.ts.
 * senderType is always 'user' when sending.
 * Agent-ready: Thread.mode controls who responds (human → hybrid → agent/datto).
 */
export const useUserThreads = () => {
  const db = useFirestore()
  const currentUser = useCurrentUser()
  const toast = useToast()

  const threads = ref<Thread[]>([])
  const loading = ref(true)
  const activeThreadId = ref<string | null>(null)
  const messages = ref<Message[]>([])
  const messagesLoading = ref(false)

  let unsubThreads: (() => void) | null = null
  let unsubMessages: (() => void) | null = null

  // --- Thread list (real-time, current user as participant) ---
  watch(currentUser, (user) => {
    if (unsubThreads) { unsubThreads(); unsubThreads = null }

    if (!user) {
      threads.value = []
      loading.value = false
      return
    }

    const q = query(
      collection(db, 'threads'),
      where('participantIds', 'array-contains', user.uid),
      where('status', 'in', ['open', 'closed']),
      orderBy('lastMessageAt', 'desc')
    )

    unsubThreads = onSnapshot(q, (snap) => {
      threads.value = snap.docs.map(d => ({ id: d.id, ...d.data() })) as Thread[]
      loading.value = false
    }, (err) => {
      console.error('[useUserThreads] snapshot error:', err)
      loading.value = false
    })
  }, { immediate: true })

  // --- Find thread by booking ID (from already-loaded list) ---
  function findThreadByBookingId(bookingId: string): Thread | null {
    return threads.value.find(t => t.bookingId === bookingId) || null
  }

  // --- Open a thread and subscribe to messages ---
  function openThread(threadId: string) {
    activeThreadId.value = threadId

    if (unsubMessages) { unsubMessages(); unsubMessages = null }

    messagesLoading.value = true

    const q = query(
      collection(db, 'messages'),
      where('threadId', '==', threadId),
      orderBy('createdAt', 'asc')
    )

    unsubMessages = onSnapshot(q, (snap) => {
      messages.value = snap.docs.map(d => ({ id: d.id, ...d.data() })) as Message[]
      messagesLoading.value = false
      if (currentUser.value) markThreadRead(threadId)
    }, (err) => {
      console.error('[useUserThreads] messages error:', err)
      messagesLoading.value = false
    })
  }

  function closeThread() {
    activeThreadId.value = null
    messages.value = []
    if (unsubMessages) { unsubMessages(); unsubMessages = null }
  }

  // --- Send message (always as 'user') ---
  async function sendMessage(threadId: string, content: string) {
    if (!currentUser.value || !content.trim()) return

    const uid = currentUser.value.uid
    const now = new Date().toISOString()

    try {
      await addDoc(collection(db, 'messages'), {
        threadId,
        senderId: uid,
        senderType: 'user',
        content: content.trim(),
        createdAt: now
      })

      // Update thread metadata + increment unread for other participants
      const threadRef = doc(db, 'threads', threadId)
      const threadSnap = await getDoc(threadRef)
      const threadData = threadSnap.data() as Thread | undefined
      const unreadUpdates: Record<string, unknown> = {}

      if (threadData?.participantIds) {
        for (const pid of threadData.participantIds) {
          if (pid !== uid) unreadUpdates[`unreadByUser.${pid}`] = increment(1)
        }
      }

      await updateDoc(threadRef, {
        lastMessageAt: now,
        lastMessageBy: uid,
        lastMessagePreview: content.trim().slice(0, 100),
        ...unreadUpdates
      })
    } catch (err) {
      console.error('[useUserThreads] sendMessage error:', err)
      toast.add({ title: 'Kunne ikke sende melding', color: 'error' })
    }
  }

  // --- Mark thread read ---
  async function markThreadRead(threadId: string) {
    if (!currentUser.value) return
    try {
      await updateDoc(doc(db, 'threads', threadId), {
        [`unreadByUser.${currentUser.value.uid}`]: 0
      })
    } catch { /* silent — non-critical */ }
  }

  // --- Computed ---
  const activeThread = computed(() =>
    activeThreadId.value
      ? threads.value.find(t => t.id === activeThreadId.value) || null
      : null
  )

  const totalUnread = computed(() => {
    if (!currentUser.value) return 0
    const uid = currentUser.value.uid
    return threads.value.reduce((sum, t) => sum + (t.unreadByUser?.[uid] || 0), 0)
  })

  onUnmounted(() => {
    if (unsubThreads) unsubThreads()
    if (unsubMessages) unsubMessages()
  })

  return {
    threads,
    loading,
    totalUnread,
    activeThreadId,
    activeThread,
    messages,
    messagesLoading,
    findThreadByBookingId,
    openThread,
    closeThread,
    sendMessage,
    markThreadRead
  }
}
```

### `apps/web/public-marketplace/app/pages/profile/messages.vue`
```vue
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
```

---

## 2. Business Portal

### `apps/web/business-portal/app/composables/useNotifications.ts`
```typescript
/**
 * useNotifications composable (Business Portal)
 *
 * Real-time listener on users/{uid}/notifications/ subcollection.
 * Identical to public-marketplace version — notifications are user-scoped.
 *
 * Phase 1: In-app only (no FCM, no email).
 */
import {
  collection,
  query,
  where,
  orderBy,
  limit,
  onSnapshot,
  doc,
  updateDoc,
  writeBatch,
  type Unsubscribe,
} from 'firebase/firestore'

export interface Notification {
  id: string
  type: string
  title: string
  body: string
  icon?: string
  actionUrl?: string
  context?: {
    bookingId?: string
    companyId?: string
    storeId?: string
    eventId?: string
    threadId?: string
  }
  isRead: boolean
  isArchived: boolean
  requiresAction: boolean
  respondedBy?: string
  createdAt: string | null
}

// Shared singleton state (SSR-safe via module-level refs)
const notifications = ref<Notification[]>([])
const archivedNotifications = ref<Notification[]>([])
const loading = ref(false)
const error = ref<string | null>(null)
const showArchived = ref(false)
let unsubscribe: Unsubscribe | null = null
let unsubscribeArchived: Unsubscribe | null = null

export function useNotifications() {
  const db = useFirestore()
  const user = useCurrentUser()

  const unreadCount = computed(() =>
    notifications.value.filter(n => !n.isRead).length
  )

  /**
   * Start real-time listener for the current user's notifications.
   */
  function subscribe() {
    if (unsubscribe) {
      unsubscribe()
      unsubscribe = null
    }

    if (!user.value) {
      notifications.value = []
      return
    }

    loading.value = true
    error.value = null

    const notifRef = collection(db, 'users', user.value.uid, 'notifications')
    const q = query(
      notifRef,
      where('isArchived', '==', false),
      orderBy('createdAt', 'desc'),
      limit(50)
    )

    unsubscribe = onSnapshot(
      q,
      (snapshot) => {
        notifications.value = snapshot.docs.map(d => mapDoc(d))
        loading.value = false
      },
      (err) => {
        console.error('[useNotifications] Listener error:', err)
        error.value = err.message || 'Failed to load notifications'
        loading.value = false
      }
    )
  }

  function mapDoc(d: any): Notification {
    const data = d.data()
    return {
      id: d.id,
      type: data.type || 'system_alert',
      title: data.title || '',
      body: data.body || '',
      icon: data.icon,
      actionUrl: data.actionUrl,
      context: data.context,
      isRead: data.isRead ?? false,
      isArchived: data.isArchived ?? false,
      requiresAction: data.requiresAction ?? false,
      respondedBy: data.respondedBy,
      createdAt: data.createdAt?.toDate?.()?.toISOString?.() ?? null,
    }
  }

  /**
   * Subscribe to archived notifications.
   */
  function subscribeArchived() {
    if (unsubscribeArchived) {
      unsubscribeArchived()
      unsubscribeArchived = null
    }

    if (!user.value) {
      archivedNotifications.value = []
      return
    }

    const notifRef = collection(db, 'users', user.value.uid, 'notifications')
    const q = query(
      notifRef,
      where('isArchived', '==', true),
      orderBy('createdAt', 'desc'),
      limit(50)
    )

    unsubscribeArchived = onSnapshot(
      q,
      (snapshot) => {
        archivedNotifications.value = snapshot.docs.map(d => mapDoc(d))
      },
      (err) => {
        console.error('[useNotifications] Archived listener error:', err)
      }
    )
  }

  /**
   * Stop the real-time listener.
   */
  function stop() {
    if (unsubscribe) {
      unsubscribe()
      unsubscribe = null
    }
    if (unsubscribeArchived) {
      unsubscribeArchived()
      unsubscribeArchived = null
    }
    notifications.value = []
    archivedNotifications.value = []
  }

  /**
   * Mark a single notification as read.
   */
  async function markRead(notifId: string) {
    if (!user.value) return

    try {
      const notifRef = doc(db, 'users', user.value.uid, 'notifications', notifId)
      await updateDoc(notifRef, { isRead: true })
      const n = notifications.value.find(n => n.id === notifId)
      if (n) n.isRead = true
    } catch (e: any) {
      console.error('[useNotifications] Failed to mark read:', e)
    }
  }

  /**
   * Mark all unread notifications as read.
   */
  async function markAllRead() {
    if (!user.value) return

    const unread = notifications.value.filter(n => !n.isRead)
    if (unread.length === 0) return

    try {
      const batch = writeBatch(db)
      for (const n of unread) {
        const ref = doc(db, 'users', user.value.uid, 'notifications', n.id)
        batch.update(ref, { isRead: true })
      }
      await batch.commit()
      unread.forEach(n => { n.isRead = true })
    } catch (e: any) {
      console.error('[useNotifications] Failed to mark all read:', e)
    }
  }

  /**
   * Archive a notification (hides it from the feed).
   */
  async function archiveNotification(notifId: string) {
    if (!user.value) return

    try {
      const notifRef = doc(db, 'users', user.value.uid, 'notifications', notifId)
      await updateDoc(notifRef, { isArchived: true })
      notifications.value = notifications.value.filter(n => n.id !== notifId)
    } catch (e: any) {
      console.error('[useNotifications] Failed to archive:', e)
    }
  }

  /**
   * Unarchive a notification (restores it to the feed).
   */
  async function unarchiveNotification(notifId: string) {
    if (!user.value) return

    try {
      const notifRef = doc(db, 'users', user.value.uid, 'notifications', notifId)
      await updateDoc(notifRef, { isArchived: false })
      archivedNotifications.value = archivedNotifications.value.filter(n => n.id !== notifId)
    } catch (e: any) {
      console.error('[useNotifications] Failed to unarchive:', e)
    }
  }

  /**
   * Toggle between active and archived view.
   */
  function toggleArchived() {
    showArchived.value = !showArchived.value
    // Lazy-subscribe to archived feed on first toggle
    if (showArchived.value && archivedNotifications.value.length === 0) {
      subscribeArchived()
    }
  }

  // Auto-subscribe when user changes
  watch(user, (newUser) => {
    if (newUser) {
      subscribe()
      // If archived view was open, re-subscribe
      if (showArchived.value) subscribeArchived()
    } else {
      stop()
    }
  }, { immediate: true })

  return {
    notifications: readonly(notifications),
    archivedNotifications: readonly(archivedNotifications),
    unreadCount,
    loading: readonly(loading),
    error: readonly(error),
    showArchived: readonly(showArchived),
    subscribe,
    stop,
    markRead,
    markAllRead,
    archiveNotification,
    unarchiveNotification,
    toggleArchived,
  }
}
```

### `apps/web/business-portal/app/composables/useThreads.ts`
```typescript
import { collection, query, where, orderBy, onSnapshot, addDoc, updateDoc, doc, serverTimestamp, increment, getDoc } from 'firebase/firestore'
import { useFirestore, useCurrentUser } from 'vuefire'
import type { Thread, Message } from '@dittodatto/shared-types'

/**
 * useThreads — Real-time conversation thread management
 * 
 * Listens to threads where the current user is a participant.
 * Provides methods to send messages, create threads, and manage read state.
 * Agent-ready: threads have a `mode` field for Ditto/Datto integration.
 */
export const useThreads = () => {
  const db = useFirestore()
  const currentUser = useCurrentUser()
  const toast = useToast()

  const threads = ref<Thread[]>([])
  const loading = ref(true)
  const activeThreadId = ref<string | null>(null)
  const messages = ref<Message[]>([])
  const messagesLoading = ref(false)

  // Unsubscribe handles
  let unsubThreads: (() => void) | null = null
  let unsubMessages: (() => void) | null = null

  // --- Thread List (real-time) ---

  watch(currentUser, (user) => {
    // Clean up previous listener
    if (unsubThreads) {
      unsubThreads()
      unsubThreads = null
    }

    if (!user) {
      threads.value = []
      loading.value = false
      return
    }

    const threadsQuery = query(
      collection(db, 'threads'),
      where('participantIds', 'array-contains', user.uid),
      where('status', 'in', ['open', 'closed']),
      orderBy('lastMessageAt', 'desc')
    )

    unsubThreads = onSnapshot(threadsQuery, (snapshot) => {
      threads.value = snapshot.docs.map(d => ({
        id: d.id,
        ...d.data()
      })) as Thread[]
      loading.value = false
    }, (error) => {
      console.error('[useThreads] Snapshot error:', error)
      loading.value = false
    })
  }, { immediate: true })

  // --- Active Thread Messages (real-time) ---

  function openThread(threadId: string) {
    activeThreadId.value = threadId

    // Clean up previous messages listener
    if (unsubMessages) {
      unsubMessages()
      unsubMessages = null
    }

    messagesLoading.value = true

    const messagesQuery = query(
      collection(db, 'messages'),
      where('threadId', '==', threadId),
      orderBy('createdAt', 'asc')
    )

    unsubMessages = onSnapshot(messagesQuery, (snapshot) => {
      messages.value = snapshot.docs.map(d => ({
        id: d.id,
        ...d.data()
      })) as Message[]
      messagesLoading.value = false

      // Auto-mark as read when opening
      if (currentUser.value) {
        markThreadRead(threadId)
      }
    }, (error) => {
      console.error('[useThreads] Messages snapshot error:', error)
      messagesLoading.value = false
    })
  }

  function closeThread() {
    activeThreadId.value = null
    messages.value = []
    if (unsubMessages) {
      unsubMessages()
      unsubMessages = null
    }
  }

  // --- Send Message ---

  async function sendMessage(threadId: string, content: string) {
    if (!currentUser.value || !content.trim()) return

    const uid = currentUser.value.uid
    const now = new Date().toISOString()

    try {
      // 1. Add the message
      await addDoc(collection(db, 'messages'), {
        threadId,
        senderId: uid,
        senderType: 'staff',
        content: content.trim(),
        createdAt: now
      })

      // 2. Update thread metadata
      const threadRef = doc(db, 'threads', threadId)
      const threadSnap = await getDoc(threadRef)
      const threadData = threadSnap.data() as Thread | undefined

      // Increment unread for all OTHER participants
      const unreadUpdates: Record<string, number> = {}
      if (threadData?.participantIds) {
        for (const pid of threadData.participantIds) {
          if (pid !== uid) {
            unreadUpdates[`unreadByUser.${pid}`] = increment(1) as unknown as number
          }
        }
      }

      await updateDoc(threadRef, {
        lastMessageAt: now,
        lastMessageBy: uid,
        lastMessagePreview: content.trim().slice(0, 100),
        ...unreadUpdates
      })
    } catch (err) {
      console.error('[useThreads] Send message error:', err)
      toast.add({
        title: 'Kunne ikke sende melding',
        color: 'error'
      })
    }
  }

  // --- Mark Thread Read ---

  async function markThreadRead(threadId: string) {
    if (!currentUser.value) return

    const uid = currentUser.value.uid
    const threadRef = doc(db, 'threads', threadId)

    try {
      await updateDoc(threadRef, {
        [`unreadByUser.${uid}`]: 0
      })
    } catch (err) {
      // Silent fail — non-critical
      console.warn('[useThreads] markRead error:', err)
    }
  }

  // --- Computed ---

  const activeThread = computed(() => {
    if (!activeThreadId.value) return null
    return threads.value.find(t => t.id === activeThreadId.value) || null
  })

  const totalUnread = computed(() => {
    if (!currentUser.value) return 0
    const uid = currentUser.value.uid
    return threads.value.reduce((sum, t) => {
      const count = t.unreadByUser?.[uid] || 0
      return sum + count
    }, 0)
  })

  // Cleanup on unmount
  onUnmounted(() => {
    if (unsubThreads) unsubThreads()
    if (unsubMessages) unsubMessages()
  })

  return {
    // Thread list
    threads,
    loading,
    totalUnread,

    // Active thread
    activeThreadId,
    activeThread,
    messages,
    messagesLoading,
    openThread,
    closeThread,

    // Actions
    sendMessage,
    markThreadRead
  }
}
```

### `apps/web/business-portal/app/components/NotificationsSlideover.vue`
```vue
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
```
