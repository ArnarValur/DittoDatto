<script setup lang="ts">
/**
 * Admin Panel — Feedback Dashboard
 *
 * Lists all feedback submissions from:
 * - Public contact form (public_contact)
 * - Logged-in user feedback (public_feedback)
 * - Portal feedback (portal_feedback)
 * - Portal support (portal_support)
 *
 * Features:
 * - Filterable by source, category, status
 * - Click to expand detail panel with admin notes
 * - Status management (new → read → in_progress → resolved → archived)
 */
import {
  collection,
  query,
  orderBy,
  onSnapshot,
  doc,
  updateDoc,
  type Unsubscribe,
} from 'firebase/firestore'
import { useFirestore } from 'vuefire'

definePageMeta({ layout: 'admin-dashboard' })

const db = useFirestore()
const toast = useToast()

// Feedback data
const feedbackItems = ref<any[]>([])
const loading = ref(true)
const selectedItem = ref<any>(null)
let unsubscribe: Unsubscribe | null = null

// Filters
const statusFilter = ref<string>('all')
const sourceFilter = ref<string>('all')
const categoryFilter = ref<string>('all')

// Subscribe to feedback collection
onMounted(() => {
  const q = query(
    collection(db, 'feedback'),
    orderBy('createdAt', 'desc')
  )

  unsubscribe = onSnapshot(q, (snapshot) => {
    feedbackItems.value = snapshot.docs.map(d => ({
      id: d.id,
      ...d.data(),
      createdAt: d.data().createdAt?.toDate?.()?.toISOString() || null,
      updatedAt: d.data().updatedAt?.toDate?.()?.toISOString() || null,
    }))
    loading.value = false
  })
})

onUnmounted(() => {
  unsubscribe?.()
})

// Filtered items
const filteredItems = computed(() => {
  return feedbackItems.value.filter((item) => {
    if (statusFilter.value !== 'all' && item.status !== statusFilter.value) return false
    if (sourceFilter.value !== 'all' && item.source !== sourceFilter.value) return false
    if (categoryFilter.value !== 'all' && item.category !== categoryFilter.value) return false
    return true
  })
})

// Stats
const stats = computed(() => ({
  total: feedbackItems.value.length,
  new: feedbackItems.value.filter(i => i.status === 'new').length,
  inProgress: feedbackItems.value.filter(i => i.status === 'in_progress').length,
  resolved: feedbackItems.value.filter(i => i.status === 'resolved').length,
}))

// Source labels
const sourceLabels: Record<string, string> = {
  public_contact: 'Contact Form',
  public_feedback: 'User Feedback',
  portal_feedback: 'Portal Feedback',
  portal_support: 'Portal Support',
}

const categoryLabels: Record<string, string> = {
  general: 'General',
  bug: 'Bug',
  feature_request: 'Feature',
  ux_issue: 'UX Issue',
  compliment: 'Compliment',
  question: 'Question',
}

const categoryIcons: Record<string, string> = {
  general: 'i-lucide-message-square',
  bug: 'i-lucide-bug',
  feature_request: 'i-lucide-lightbulb',
  ux_issue: 'i-lucide-monitor-x',
  compliment: 'i-lucide-heart',
  question: 'i-lucide-help-circle',
}

const statusColors: Record<string, string> = {
  new: 'info',
  read: 'neutral',
  in_progress: 'warning',
  resolved: 'success',
  archived: 'neutral',
}

// Update status
async function updateStatus(item: any, newStatus: string) {
  try {
    await updateDoc(doc(db, 'feedback', item.id), {
      status: newStatus,
      updatedAt: new Date(),
    })
    toast.add({
      title: `Status updated to "${newStatus}"`,
      color: 'success',
    })
    if (selectedItem.value?.id === item.id) {
      selectedItem.value = { ...selectedItem.value, status: newStatus }
    }
  } catch (e: any) {
    toast.add({ title: 'Failed to update', description: e.message, color: 'error' })
  }
}

// Update admin notes
const editingNotes = ref('')
async function saveNotes(item: any) {
  try {
    await updateDoc(doc(db, 'feedback', item.id), {
      adminNotes: editingNotes.value,
      updatedAt: new Date(),
    })
    toast.add({ title: 'Notes saved', color: 'success' })
  } catch (e: any) {
    toast.add({ title: 'Failed to save', description: e.message, color: 'error' })
  }
}

function selectItem(item: any) {
  selectedItem.value = item
  editingNotes.value = item.adminNotes || ''
  // Mark as read if new
  if (item.status === 'new') {
    updateStatus(item, 'read')
  }
}

function formatDate(iso: string | null): string {
  if (!iso) return '—'
  return new Date(iso).toLocaleDateString('nb-NO', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}
</script>

<template>
  <UDashboardPanel id="feedback">
    <template #header>
      <UDashboardNavbar title="Feedback Inbox">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6 space-y-6">
        <!-- Stats -->
        <div class="grid grid-cols-4 gap-4">
          <UPageCard class="text-center">
            <p class="text-2xl font-bold">{{ stats.total }}</p>
            <p class="text-xs text-muted">Total</p>
          </UPageCard>
          <UPageCard class="text-center">
            <p class="text-2xl font-bold text-info">{{ stats.new }}</p>
            <p class="text-xs text-muted">New</p>
          </UPageCard>
          <UPageCard class="text-center">
            <p class="text-2xl font-bold text-warning">{{ stats.inProgress }}</p>
            <p class="text-xs text-muted">In Progress</p>
          </UPageCard>
          <UPageCard class="text-center">
            <p class="text-2xl font-bold text-success">{{ stats.resolved }}</p>
            <p class="text-xs text-muted">Resolved</p>
          </UPageCard>
        </div>

        <!-- Filters -->
        <div class="flex items-center gap-3">
          <USelect
            v-model="statusFilter"
            :items="[
              { label: 'All statuses', value: 'all' },
              { label: 'New', value: 'new' },
              { label: 'Read', value: 'read' },
              { label: 'In Progress', value: 'in_progress' },
              { label: 'Resolved', value: 'resolved' },
              { label: 'Archived', value: 'archived' },
            ]"
            size="sm"
          />
          <USelect
            v-model="sourceFilter"
            :items="[
              { label: 'All sources', value: 'all' },
              { label: 'Contact Form', value: 'public_contact' },
              { label: 'User Feedback', value: 'public_feedback' },
              { label: 'Portal Feedback', value: 'portal_feedback' },
              { label: 'Portal Support', value: 'portal_support' },
            ]"
            size="sm"
          />
          <USelect
            v-model="categoryFilter"
            :items="[
              { label: 'All categories', value: 'all' },
              { label: 'General', value: 'general' },
              { label: 'Bug', value: 'bug' },
              { label: 'Feature Request', value: 'feature_request' },
              { label: 'UX Issue', value: 'ux_issue' },
              { label: 'Compliment', value: 'compliment' },
              { label: 'Question', value: 'question' },
            ]"
            size="sm"
          />
          <span class="text-sm text-muted ml-auto">{{ filteredItems.length }} items</span>
        </div>

        <!-- Split view: list + detail -->
        <div class="grid grid-cols-1 lg:grid-cols-5 gap-6">
          <!-- Feedback List -->
          <div class="lg:col-span-2 space-y-2">
            <div v-if="loading" class="space-y-3">
              <USkeleton v-for="i in 5" :key="i" class="h-20 w-full rounded-xl" />
            </div>

            <div v-else-if="filteredItems.length === 0" class="text-center py-12">
              <UIcon name="i-lucide-inbox" class="size-10 text-muted mx-auto mb-3" />
              <p class="text-muted text-sm">No feedback found.</p>
            </div>

            <div
              v-for="item in filteredItems"
              :key="item.id"
              class="p-3 rounded-xl cursor-pointer transition-all border"
              :class="[
                selectedItem?.id === item.id
                  ? 'border-primary bg-primary/5'
                  : 'border-default bg-elevated hover:border-primary/30',
                item.status === 'new' ? 'ring-1 ring-info/30' : ''
              ]"
              @click="selectItem(item)"
            >
              <div class="flex items-start justify-between gap-2">
                <div class="flex items-center gap-2 min-w-0">
                  <UIcon
                    :name="categoryIcons[item.category] || 'i-lucide-message-square'"
                    class="size-4 shrink-0 text-muted"
                  />
                  <span class="text-sm font-medium truncate">{{ item.senderName }}</span>
                </div>
                <UBadge :color="(statusColors[item.status] as any) || 'neutral'" size="xs" variant="subtle">
                  {{ item.status }}
                </UBadge>
              </div>
              <p v-if="item.subject" class="text-sm text-default mt-1 truncate">{{ item.subject }}</p>
              <p class="text-xs text-muted mt-1 line-clamp-2">{{ item.body }}</p>
              <div class="flex items-center gap-2 mt-2">
                <UBadge color="neutral" size="xs" variant="subtle">
                  {{ sourceLabels[item.source] || item.source }}
                </UBadge>
                <span class="text-xs text-muted">{{ formatDate(item.createdAt) }}</span>
              </div>
            </div>
          </div>

          <!-- Detail Panel -->
          <div class="lg:col-span-3">
            <UPageCard v-if="selectedItem" class="sticky top-6">
              <!-- Header -->
              <div class="flex items-start justify-between mb-4">
                <div>
                  <h3 class="text-lg font-semibold">
                    {{ selectedItem.subject || 'No subject' }}
                  </h3>
                  <p class="text-sm text-muted">
                    From <span class="font-medium text-default">{{ selectedItem.senderName }}</span>
                    ({{ selectedItem.senderEmail }})
                  </p>
                  <p class="text-xs text-muted mt-0.5">{{ formatDate(selectedItem.createdAt) }}</p>
                </div>
                <div class="flex items-center gap-1.5">
                  <UBadge :color="(statusColors[selectedItem.status] as any) || 'neutral'" variant="subtle">
                    {{ selectedItem.status }}
                  </UBadge>
                  <UBadge color="neutral" variant="subtle">
                    {{ categoryLabels[selectedItem.category] || selectedItem.category }}
                  </UBadge>
                </div>
              </div>

              <!-- Body -->
              <div class="p-4 rounded-lg bg-muted/30 text-sm whitespace-pre-wrap mb-4">
                {{ selectedItem.body }}
              </div>

              <!-- Metadata -->
              <div v-if="selectedItem.metadata" class="text-xs text-muted space-y-0.5 mb-4 p-3 rounded-lg bg-muted/20 border border-default">
                <p v-if="selectedItem.metadata.url">
                  <span class="font-medium">Page:</span> {{ selectedItem.metadata.url }}
                </p>
                <p v-if="selectedItem.metadata.viewport">
                  <span class="font-medium">Viewport:</span> {{ selectedItem.metadata.viewport }}
                </p>
                <p v-if="selectedItem.metadata.userAgent">
                  <span class="font-medium">UA:</span> {{ selectedItem.metadata.userAgent }}
                </p>
              </div>

              <!-- Status actions -->
              <div class="flex items-center gap-2 mb-4">
                <span class="text-xs text-muted font-medium">Set status:</span>
                <UButton
                  v-for="s in ['new', 'read', 'in_progress', 'resolved', 'archived']"
                  :key="s"
                  size="xs"
                  :variant="selectedItem.status === s ? 'solid' : 'outline'"
                  :color="selectedItem.status === s ? 'primary' : 'neutral'"
                  :label="s.replace('_', ' ')"
                  @click="updateStatus(selectedItem, s)"
                />
              </div>

              <!-- Admin notes -->
              <div class="space-y-2">
                <label class="text-xs font-medium text-muted">Admin Notes</label>
                <UTextarea
                  v-model="editingNotes"
                  placeholder="Add private notes about this feedback..."
                  :rows="3"
                  size="sm"
                />
                <UButton
                  size="xs"
                  color="primary"
                  variant="soft"
                  label="Save notes"
                  icon="i-lucide-save"
                  @click="saveNotes(selectedItem)"
                />
              </div>
            </UPageCard>

            <!-- No selection -->
            <div v-else class="flex flex-col items-center justify-center py-20 text-muted">
              <UIcon name="i-lucide-mouse-pointer-click" class="size-10 mb-3" />
              <p class="text-sm">Select a feedback item to view details</p>
            </div>
          </div>
        </div>
      </div>
    </template>
  </UDashboardPanel>
</template>
