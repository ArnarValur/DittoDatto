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
