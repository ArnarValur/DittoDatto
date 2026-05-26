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
