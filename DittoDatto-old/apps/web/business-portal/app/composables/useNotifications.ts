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
