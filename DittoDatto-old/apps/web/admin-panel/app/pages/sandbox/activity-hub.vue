<script setup lang="ts">
import type { Activity, Thread, Message } from '@dittodatto/shared-types'
import { collection, query, where, orderBy, addDoc, onSnapshot, serverTimestamp, doc, updateDoc } from 'firebase/firestore'
import { useFirestore, useCurrentUser } from 'vuefire'

definePageMeta({ layout: 'admin-dashboard' })

useHead({ title: 'Activity Hub Sandbox' })

const db = useFirestore()
const currentUser = useCurrentUser()
const toast = useToast()

// State
const activities = ref<Activity[]>([])
const threads = ref<Thread[]>([])
const selectedThread = ref<Thread | null>(null)
const messages = ref<Message[]>([])
const newMessage = ref('')
const isLoading = ref(true)

// New activity form
const newActivity = reactive({
  recipientId: '',
  type: 'system_alert' as Activity['type'],
  title: '',
  body: ''
})

const activityTypes = [
  { value: 'booking_reminder', label: 'Booking Reminder' },
  { value: 'booking_change', label: 'Booking Change' },
  { value: 'broadcast', label: 'Broadcast' },
  { value: 'staff_reply', label: 'Staff Reply' },
  { value: 'feedback', label: 'Feedback' },
  { value: 'support', label: 'Support' },
  { value: 'event_upcoming', label: 'Event Upcoming' },
  { value: 'system_alert', label: 'System Alert' }
]

// Subscribe to all threads (admin can see all)
onMounted(() => {
  const threadsQuery = query(collection(db, 'threads'), orderBy('lastMessageAt', 'desc'))

  onSnapshot(threadsQuery, (snapshot) => {
    threads.value = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Thread))
    isLoading.value = false
  })
})

// Watch selected thread and load messages
watch(selectedThread, async (thread) => {
  if (!thread) {
    messages.value = []
    return
  }

  const messagesQuery = query(
    collection(db, 'messages'),
    where('threadId', '==', thread.id),
    orderBy('createdAt', 'asc')
  )

  onSnapshot(messagesQuery, (snapshot) => {
    messages.value = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Message))
  })
})

// Send activity card to a user
async function sendActivity() {
  if (!newActivity.recipientId || !newActivity.title) {
    toast.add({ title: 'Error', description: 'Recipient ID and title required', color: 'error' })
    return
  }

  try {
    await addDoc(collection(db, 'activities'), {
      recipientId: newActivity.recipientId,
      type: newActivity.type,
      title: newActivity.title,
      body: newActivity.body,
      isRead: false,
      isArchived: false,
      requiresAction: newActivity.type === 'booking_change',
      respondedBy: 'system',
      createdAt: serverTimestamp()
    })

    toast.add({ title: 'Sent!', description: 'Activity card created', color: 'success' })
    newActivity.title = ''
    newActivity.body = ''
  } catch (err: any) {
    toast.add({ title: 'Error', description: err.message, color: 'error' })
  }
}

// Reply to thread
async function sendReply() {
  if (!selectedThread.value || !newMessage.value.trim() || !currentUser.value) return

  try {
    // Add message
    await addDoc(collection(db, 'messages'), {
      threadId: selectedThread.value.id,
      senderId: currentUser.value.uid,
      senderType: 'admin',
      content: newMessage.value.trim(),
      createdAt: serverTimestamp()
    })

    // Update thread
    await updateDoc(doc(db, 'threads', selectedThread.value.id), {
      lastMessageAt: serverTimestamp(),
      lastMessageBy: currentUser.value.uid
    })

    // Create activity for the other participant
    const otherParticipant = selectedThread.value.participantIds.find(id => id !== currentUser.value?.uid)
    if (otherParticipant) {
      await addDoc(collection(db, 'activities'), {
        recipientId: otherParticipant,
        type: 'staff_reply',
        title: 'Reply from Support',
        body: newMessage.value.trim().substring(0, 100) + '...',
        context: { threadId: selectedThread.value.id },
        isRead: false,
        isArchived: false,
        requiresAction: false,
        respondedBy: 'human',
        createdAt: serverTimestamp()
      })
    }

    newMessage.value = ''
    toast.add({ title: 'Sent!', color: 'success' })
  } catch (err: any) {
    toast.add({ title: 'Error', description: err.message, color: 'error' })
  }
}

function formatTime(timestamp: any): string {
  if (!timestamp) return ''
  const date = timestamp.toDate ? timestamp.toDate() : new Date(timestamp)
  return date.toLocaleTimeString('no-NO', { hour: '2-digit', minute: '2-digit' })
}
</script>

<template>
  <UDashboardPanel id="activity-sandbox">
    <template #header>
      <UDashboardNavbar title="Activity Hub Sandbox">
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            🧪 Activity Hub Sandbox (Admin)
          </div>
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6 grid grid-cols-2 gap-6">
        <!-- Left: Send Activity Card -->
        <div class="space-y-4">
          <div class="p-4 bg-blue-50 dark:bg-blue-950 rounded-lg border border-blue-200 dark:border-blue-800">
            <h3 class="font-semibold text-blue-800 dark:text-blue-200 mb-4">
              📤 Send Activity Card
            </h3>

            <div class="space-y-3">
              <UFormField label="Recipient User ID">
                <UInput
                  v-model="newActivity.recipientId"
                  placeholder="User UID..."
                />
              </UFormField>

              <UFormField label="Type">
                <USelectMenu
                  v-model="newActivity.type"
                  :items="activityTypes"
                  value-attribute="value"
                  option-attribute="label"
                />
              </UFormField>

              <UFormField label="Title">
                <UInput
                  v-model="newActivity.title"
                  placeholder="Activity title..."
                />
              </UFormField>

              <UFormField label="Body">
                <UTextarea
                  v-model="newActivity.body"
                  placeholder="Activity body..."
                  :rows="3"
                />
              </UFormField>

              <UButton
                type="button"
                label="Send Activity"
                icon="i-lucide-send"
                color="primary"
                @click="() => sendActivity()"
              />
            </div>
          </div>
        </div>

        <!-- Right: Threads & Messages -->
        <div class="space-y-4">
          <div class="p-4 bg-green-50 dark:bg-green-950 rounded-lg border border-green-200 dark:border-green-800">
            <h3 class="font-semibold text-green-800 dark:text-green-200 mb-4">
              💬 Support Threads
            </h3>

            <div
              v-if="isLoading"
              class="text-center py-4"
            >
              <UIcon
                name="i-lucide-loader-2"
                class="animate-spin"
              />
            </div>

            <div
              v-else-if="threads.length === 0"
              class="text-center py-4 text-gray-500"
            >
              No threads yet. Business Portal users can create support requests.
            </div>

            <div
              v-else
              class="space-y-2 max-h-48 overflow-y-auto"
            >
              <div
                v-for="thread in threads"
                :key="thread.id"
                class="p-3 rounded cursor-pointer transition-colors"
                :class="selectedThread?.id === thread.id ? 'bg-green-200 dark:bg-green-800' : 'bg-white dark:bg-gray-800 hover:bg-gray-100 dark:hover:bg-gray-700'"
                @click="selectedThread = thread"
              >
                <div class="flex justify-between items-center">
                  <span class="font-medium">{{ thread.type }}</span>
                  <UBadge
                    :color="thread.status === 'open' ? 'success' : 'neutral'"
                    variant="subtle"
                  >
                    {{ thread.status }}
                  </UBadge>
                </div>
                <div class="text-sm text-gray-500">
                  {{ thread.id.substring(0, 8) }}...
                </div>
              </div>
            </div>
          </div>

          <!-- Messages -->
          <div
            v-if="selectedThread"
            class="p-4 bg-white dark:bg-gray-800 rounded-lg border"
          >
            <h4 class="font-semibold mb-3">
              Thread: {{ selectedThread.id.substring(0, 12) }}...
            </h4>

            <div class="space-y-2 max-h-64 overflow-y-auto mb-4">
              <div
                v-for="msg in messages"
                :key="msg.id"
                class="p-2 rounded"
                :class="msg.senderType === 'admin' ? 'bg-blue-100 dark:bg-blue-900 ml-8' : 'bg-gray-100 dark:bg-gray-700 mr-8'"
              >
                <div class="text-xs text-gray-500 mb-1">
                  {{ msg.senderType }} • {{ formatTime(msg.createdAt) }}
                </div>
                <div>{{ msg.content }}</div>
              </div>
            </div>

            <div class="flex gap-2">
              <UInput
                v-model="newMessage"
                placeholder="Reply as admin..."
                class="flex-1"
                @keyup.enter="sendReply"
              />
              <UButton
                icon="i-lucide-send"
                @click="sendReply"
              />
            </div>
          </div>
        </div>
      </div>
    </template>
  </UDashboardPanel>
</template>
