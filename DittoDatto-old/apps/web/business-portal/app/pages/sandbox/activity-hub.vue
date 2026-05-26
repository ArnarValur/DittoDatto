<script setup lang="ts">
import type { Activity, Thread, Message } from '@dittodatto/shared-types'
import { collection, query, where, orderBy, addDoc, onSnapshot, serverTimestamp, doc, updateDoc } from 'firebase/firestore'
import { useFirestore, useCurrentUser } from 'vuefire'

definePageMeta({ layout: 'dashboard' })

useHead({ title: 'Activity Hub Sandbox' })

const db = useFirestore()
const currentUser = useCurrentUser()
const toast = useToast()
const { companyId } = useCompany()

// State
const activities = ref<Activity[]>([])
const selectedActivity = ref<Activity | null>(null)
const messages = ref<Message[]>([])
const newMessage = ref('')
const isLoading = ref(true)

// Support request form
const supportRequest = reactive({
  title: '',
  message: ''
})

// Subscribe to current user's activities
watch(currentUser, (user) => {
  if (!user) return

  const activitiesQuery = query(
    collection(db, 'activities'),
    where('recipientId', '==', user.uid),
    orderBy('createdAt', 'desc')
  )

  onSnapshot(activitiesQuery, (snapshot) => {
    activities.value = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Activity))
    isLoading.value = false
  })
}, { immediate: true })

// Watch selected activity with thread and load messages
watch(selectedActivity, async (activity) => {
  if (!activity?.context?.threadId) {
    messages.value = []
    return
  }

  const messagesQuery = query(
    collection(db, 'messages'),
    where('threadId', '==', activity.context.threadId),
    orderBy('createdAt', 'asc')
  )

  onSnapshot(messagesQuery, (snapshot) => {
    messages.value = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Message))
  })
})

// Create support request
async function createSupportRequest() {
  if (!currentUser.value || !supportRequest.title || !supportRequest.message) {
    toast.add({ title: 'Error', description: 'Title and message required', color: 'error' })
    return
  }

  try {
    // Create thread
    const threadRef = await addDoc(collection(db, 'threads'), {
      type: 'support',
      participantIds: [currentUser.value.uid, 'ADMIN'], // ADMIN placeholder
      companyId: companyId.value,
      status: 'open',
      lastMessageAt: serverTimestamp(),
      lastMessageBy: currentUser.value.uid,
      createdAt: serverTimestamp()
    })

    // Create first message
    await addDoc(collection(db, 'messages'), {
      threadId: threadRef.id,
      senderId: currentUser.value.uid,
      senderType: 'user',
      content: supportRequest.message,
      createdAt: serverTimestamp()
    })

    // Create activity for self (to see in hub)
    await addDoc(collection(db, 'activities'), {
      recipientId: currentUser.value.uid,
      type: 'support',
      title: supportRequest.title,
      body: supportRequest.message.substring(0, 100) + '...',
      context: {
        threadId: threadRef.id,
        companyId: companyId.value
      },
      isRead: true,
      isArchived: false,
      requiresAction: false,
      respondedBy: 'human',
      createdAt: serverTimestamp()
    })

    toast.add({ title: 'Sent!', description: 'Support request created', color: 'success' })
    supportRequest.title = ''
    supportRequest.message = ''
  } catch (err: any) {
    toast.add({ title: 'Error', description: err.message, color: 'error' })
  }
}

// Reply in thread
async function sendReply() {
  if (!selectedActivity.value?.context?.threadId || !newMessage.value.trim() || !currentUser.value) return

  try {
    await addDoc(collection(db, 'messages'), {
      threadId: selectedActivity.value.context.threadId,
      senderId: currentUser.value.uid,
      senderType: 'staff',
      content: newMessage.value.trim(),
      createdAt: serverTimestamp()
    })

    await updateDoc(doc(db, 'threads', selectedActivity.value.context.threadId), {
      lastMessageAt: serverTimestamp(),
      lastMessageBy: currentUser.value.uid
    })

    newMessage.value = ''
    toast.add({ title: 'Sent!', color: 'success' })
  } catch (err: any) {
    toast.add({ title: 'Error', description: err.message, color: 'error' })
  }
}

// Mark activity as read
async function markAsRead(activity: Activity) {
  if (activity.isRead) return

  try {
    await updateDoc(doc(db, 'activities', activity.id), {
      isRead: true
    })
  } catch (err) {
    console.error('Failed to mark as read:', err)
  }
}

function formatTime(timestamp: any): string {
  if (!timestamp) return ''
  const date = timestamp.toDate ? timestamp.toDate() : new Date(timestamp)
  return date.toLocaleTimeString('no-NO', { hour: '2-digit', minute: '2-digit' })
}

function getTypeIcon(type: string): string {
  const icons: Record<string, string> = {
    booking_reminder: 'i-lucide-calendar',
    booking_change: 'i-lucide-calendar-x',
    broadcast: 'i-lucide-megaphone',
    staff_reply: 'i-lucide-message-circle',
    feedback: 'i-lucide-message-square',
    support: 'i-lucide-headphones',
    event_upcoming: 'i-lucide-party-popper',
    system_alert: 'i-lucide-bell'
  }
  return icons[type] || 'i-lucide-info'
}

// Computed: unread count for badge demo
const unreadCount = computed(() => activities.value.filter(a => !a.isRead).length)

// Admin UID for demo cards (your super admin account)
const adminUid = ref('')
const isSendingDemo = ref(false)

// Send all demo cards to admin
async function sendAllDemoCards() {
  if (!adminUid.value) {
    toast.add({ title: 'Error', description: 'Enter Admin UID first', color: 'error' })
    return
  }

  isSendingDemo.value = true

  const demoCards = [
    {
      type: 'booking_reminder',
      title: '📅 Appointment Today',
      body: 'Haircut at Viking Barbers at 15:30. Remember to arrive 5 minutes early!',
      requiresAction: false
    },
    {
      type: 'booking_change',
      title: '⚠️ Reschedule Required',
      body: 'Your massage appointment needs to be rescheduled. The therapist is unavailable.',
      requiresAction: true
    },
    {
      type: 'broadcast',
      title: '🎉 Weekend Special!',
      body: 'DittoDatto AS is offering 20% off all services this Saturday! Book now.',
      requiresAction: false
    },
    {
      type: 'staff_reply',
      title: '💬 Reply from Viking Barbers',
      body: 'Hi! Yes, we can accommodate your request for a late appointment.',
      requiresAction: false
    },
    {
      type: 'feedback',
      title: '📝 Your Feedback Received',
      body: 'Thank you for your feedback about the booking flow. We appreciate it!',
      requiresAction: false
    },
    {
      type: 'support',
      title: '🆘 Support Request #1234',
      body: 'Your support ticket has been opened. We will respond within 24 hours.',
      requiresAction: false
    },
    {
      type: 'event_upcoming',
      title: '🎊 Store Opening Event',
      body: 'DittoDatto AS is opening a new location in Drammen! Join us this Friday.',
      requiresAction: false
    },
    {
      type: 'system_alert',
      title: '🔔 Platform Update',
      body: 'New features have been added to your dashboard. Check out the Activity Hub!',
      requiresAction: false
    }
  ]

  try {
    for (const card of demoCards) {
      await addDoc(collection(db, 'activities'), {
        recipientId: adminUid.value,
        type: card.type,
        title: card.title,
        body: card.body,
        context: { companyId: companyId.value },
        isRead: false,
        isArchived: false,
        requiresAction: card.requiresAction,
        respondedBy: 'human',
        createdAt: serverTimestamp()
      })
      // Small delay to ensure order
      await new Promise(resolve => setTimeout(resolve, 100))
    }

    toast.add({
      title: '🚀 Demo Cards Sent!',
      description: `${demoCards.length} cards sent to admin`,
      color: 'success'
    })
  } catch (err: any) {
    toast.add({ title: 'Error', description: err.message, color: 'error' })
  } finally {
    isSendingDemo.value = false
  }
}
</script>

<template>
  <UDashboardPanel id="activity-sandbox">
    <template #header>
      <UDashboardNavbar title="Activity Hub Sandbox">
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold flex items-center gap-2">
            🧪 Activity Hub Sandbox (Business)
            <UBadge v-if="unreadCount > 0" color="error" variant="solid">
              {{ unreadCount }}
            </UBadge>
          </div>
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6 grid grid-cols-2 gap-6 h-full">
        <!-- Left: Activity Feed -->
        <div class="flex flex-col h-full">
          <h3 class="font-semibold mb-4">
            📥 Your Activity Feed
          </h3>

          <div v-if="isLoading" class="flex-1 flex items-center justify-center">
            <UIcon name="i-lucide-loader-2" class="w-8 h-8 animate-spin text-gray-400" />
          </div>

          <div v-else-if="activities.length === 0" class="flex-1 flex items-center justify-center text-gray-500">
            No activities yet. Admin can send you cards!
          </div>

          <div v-else class="flex-1 overflow-y-auto space-y-2">
            <div
              v-for="activity in activities"
              :key="activity.id"
              class="p-3 rounded-lg cursor-pointer transition-all border"
              :class="[
                selectedActivity?.id === activity.id
                  ? 'border-blue-500 bg-blue-50 dark:bg-blue-950'
                  : 'border-gray-200 dark:border-gray-700 hover:border-gray-300',
                !activity.isRead ? 'font-semibold' : '',
                activity.requiresAction ? 'border-l-4 border-l-orange-500' : ''
              ]"
              @click="() => { selectedActivity = activity; markAsRead(activity) }"
            >
              <div class="flex items-start gap-3">
                <UIcon :name="getTypeIcon(activity.type)" class="w-5 h-5 mt-0.5 text-gray-500" />
                <div class="flex-1 min-w-0">
                  <div class="flex justify-between items-start">
                    <span class="truncate">{{ activity.title }}</span>
                    <span class="text-xs text-gray-400">{{ formatTime(activity.createdAt) }}</span>
                  </div>
                  <p class="text-sm text-gray-500 truncate">
                    {{ activity.body }}
                  </p>
                  <div class="flex gap-2 mt-1">
                    <UBadge color="neutral" variant="subtle" size="xs">
                      {{ activity.type }}
                    </UBadge>
                    <UBadge
                      v-if="!activity.isRead"
                      color="primary"
                      variant="solid"
                      size="xs"
                    >
                      NEW
                    </UBadge>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Right: Actions -->
        <div class="space-y-4">
          <!-- Create Support Request -->
          <div class="p-4 bg-purple-50 dark:bg-purple-950 rounded-lg border border-purple-200 dark:border-purple-800">
            <h3 class="font-semibold text-purple-800 dark:text-purple-200 mb-4">
              🆘 Create Support Request
            </h3>

            <div class="space-y-3">
              <UFormField label="Subject">
                <UInput v-model="supportRequest.title" placeholder="What do you need help with?" />
              </UFormField>

              <UFormField label="Message">
                <UTextarea v-model="supportRequest.message" placeholder="Describe your issue..." :rows="3" />
              </UFormField>

              <UButton
                type="button"
                label="Send to Support"
                icon="i-lucide-send"
                color="primary"
                @click="() => createSupportRequest()"
              />
            </div>
          </div>

          <!-- Send Demo Cards to Admin -->
          <div class="p-4 bg-orange-50 dark:bg-orange-950 rounded-lg border border-orange-200 dark:border-orange-800">
            <h3 class="font-semibold text-orange-800 dark:text-orange-200 mb-4">
              🚀 Send Demo Cards to Admin
            </h3>

            <div class="space-y-3">
              <UFormField label="Admin User ID">
                <UInput v-model="adminUid" placeholder="Paste your super admin UID..." />
              </UFormField>

              <UButton
                type="button"
                label="Send All 8 Card Types"
                icon="i-lucide-rocket"
                color="warning"
                :loading="isSendingDemo"
                @click="() => sendAllDemoCards()"
              />

              <p class="text-xs text-orange-600 dark:text-orange-400">
                Sends one of each: booking_reminder, booking_change, broadcast, staff_reply, feedback, support, event_upcoming, system_alert
              </p>
            </div>
          </div>

          <!-- Thread View (when activity with thread selected) -->
          <div v-if="selectedActivity?.context?.threadId" class="p-4 bg-white dark:bg-gray-800 rounded-lg border">
            <h4 class="font-semibold mb-3">
              💬 Thread Messages
            </h4>

            <div class="space-y-2 max-h-48 overflow-y-auto mb-4">
              <div
                v-for="msg in messages"
                :key="msg.id"
                class="p-2 rounded"
                :class="msg.senderType === 'user' || msg.senderType === 'staff' ? 'bg-blue-100 dark:bg-blue-900 ml-8' : 'bg-gray-100 dark:bg-gray-700 mr-8'"
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
                placeholder="Reply..."
                class="flex-1"
                @keyup.enter="sendReply"
              />
              <UButton icon="i-lucide-send" @click="sendReply" />
            </div>
          </div>

          <!-- No thread selected -->
          <div v-else-if="selectedActivity" class="p-4 bg-gray-50 dark:bg-gray-800 rounded-lg border text-center text-gray-500">
            This activity doesn't have a thread attached.
          </div>
        </div>
      </div>
    </template>
  </UDashboardPanel>
</template>
