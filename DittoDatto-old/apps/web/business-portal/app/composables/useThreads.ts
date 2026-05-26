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
