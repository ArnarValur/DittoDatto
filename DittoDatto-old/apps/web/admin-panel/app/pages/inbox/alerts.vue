<script setup lang="ts">
/**
 * Admin Panel — System Alerts Management
 *
 * Create, edit, and deactivate system alerts.
 * Zero-fan-out: one doc write, all matching users see it.
 */
import {
  collection,
  query,
  orderBy,
  onSnapshot,
  addDoc,
  doc,
  updateDoc,
  serverTimestamp,
  type Unsubscribe,
} from 'firebase/firestore'
import { useFirestore, useCurrentUser } from 'vuefire'

definePageMeta({ layout: 'admin-dashboard' })

const db = useFirestore()
const user = useCurrentUser()
const toast = useToast()

// State
const alerts = ref<any[]>([])
const loading = ref(true)
const showComposeModal = ref(false)
const editingAlert = ref<any>(null)
let unsub: Unsubscribe | null = null

// Subscribe
onMounted(() => {
  const q = query(collection(db, 'systemAlerts'), orderBy('createdAt', 'desc'))
  unsub = onSnapshot(q, (snap) => {
    alerts.value = snap.docs.map(d => ({
      id: d.id,
      ...d.data(),
      createdAt: d.data().createdAt?.toDate?.()?.toISOString() || null,
      expiresAt: d.data().expiresAt?.toDate?.()?.toISOString() || null,
    }))
    loading.value = false
  })
})
onUnmounted(() => unsub?.())

// Compose form
const form = reactive({
  title: '',
  body: '',
  severity: 'info' as 'info' | 'warning' | 'critical',
  targetAudience: 'all' as 'all' | 'business' | 'customers' | 'admin',
  actionUrl: '',
  actionLabel: '',
  expiresInHours: 0,
})

function resetForm() {
  form.title = ''
  form.body = ''
  form.severity = 'info'
  form.targetAudience = 'all'
  form.actionUrl = ''
  form.actionLabel = ''
  form.expiresInHours = 0
}

async function handleCreate() {
  if (!form.title.trim() || !form.body.trim()) return

  try {
    const data: Record<string, any> = {
      title: form.title.trim(),
      body: form.body.trim(),
      severity: form.severity,
      targetAudience: form.targetAudience,
      isActive: true,
      createdBy: user.value?.uid || null,
      createdAt: serverTimestamp(),
    }

    if (form.actionUrl.trim()) {
      data.actionUrl = form.actionUrl.trim()
      data.actionLabel = form.actionLabel.trim() || 'Les mer'
    }

    if (form.expiresInHours > 0) {
      data.expiresAt = new Date(Date.now() + form.expiresInHours * 3600_000)
    }

    await addDoc(collection(db, 'systemAlerts'), data)

    toast.add({ title: 'Alert sent!', color: 'success', icon: 'i-lucide-megaphone' })
    showComposeModal.value = false
    resetForm()
  } catch (e: any) {
    toast.add({ title: 'Failed', description: e.message, color: 'error' })
  }
}

async function toggleActive(alert: any) {
  try {
    await updateDoc(doc(db, 'systemAlerts', alert.id), {
      isActive: !alert.isActive,
      updatedAt: serverTimestamp(),
    })
    toast.add({
      title: alert.isActive ? 'Alert deactivated' : 'Alert reactivated',
      color: 'success',
    })
  } catch (e: any) {
    toast.add({ title: 'Failed', description: e.message, color: 'error' })
  }
}

// Severity config
const severityConfig: Record<string, { color: string; icon: string }> = {
  info: { color: 'info', icon: 'i-lucide-info' },
  warning: { color: 'warning', icon: 'i-lucide-alert-triangle' },
  critical: { color: 'error', icon: 'i-lucide-alert-octagon' },
}

const audienceLabels: Record<string, string> = {
  all: 'All Users',
  business: 'Business Only',
  customers: 'Customers Only',
  admin: 'Admin Only',
}

function formatDate(iso: string | null): string {
  if (!iso) return '—'
  return new Date(iso).toLocaleDateString('nb-NO', {
    day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit',
  })
}
</script>

<template>
  <UDashboardPanel id="system-alerts">
    <template #header>
      <UDashboardNavbar title="System Alerts">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>
        <template #right>
          <UButton
            color="primary"
            icon="i-lucide-megaphone"
            label="New Alert"
            @click="showComposeModal = true; resetForm()"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6 space-y-4">
        <!-- Loading -->
        <div v-if="loading" class="space-y-3">
          <USkeleton v-for="i in 3" :key="i" class="h-20 w-full rounded-xl" />
        </div>

        <!-- Empty -->
        <div v-else-if="alerts.length === 0" class="text-center py-16">
          <UIcon name="i-lucide-megaphone" class="size-10 text-muted mx-auto mb-3" />
          <p class="text-sm text-muted">No system alerts yet.</p>
          <UButton
            class="mt-3"
            variant="soft"
            label="Create your first alert"
            icon="i-lucide-plus"
            @click="showComposeModal = true; resetForm()"
          />
        </div>

        <!-- Alert list -->
        <div v-else class="space-y-3">
          <div
            v-for="alert in alerts"
            :key="alert.id"
            class="p-4 rounded-xl border transition-all"
            :class="alert.isActive ? 'border-default bg-elevated' : 'border-default/50 bg-muted/10 opacity-60'"
          >
            <div class="flex items-start justify-between gap-3">
              <div class="flex items-start gap-3 min-w-0">
                <div
                  class="w-8 h-8 rounded-lg flex items-center justify-center shrink-0"
                  :class="{
                    'bg-blue-500/10': alert.severity === 'info',
                    'bg-amber-500/10': alert.severity === 'warning',
                    'bg-red-500/10': alert.severity === 'critical',
                  }"
                >
                  <UIcon
                    :name="severityConfig[alert.severity]?.icon || 'i-lucide-info'"
                    class="size-4"
                    :class="{
                      'text-blue-500': alert.severity === 'info',
                      'text-amber-500': alert.severity === 'warning',
                      'text-red-500': alert.severity === 'critical',
                    }"
                  />
                </div>
                <div class="min-w-0">
                  <p class="text-sm font-medium">{{ alert.title }}</p>
                  <p class="text-xs text-muted mt-0.5 line-clamp-2">{{ alert.body }}</p>
                  <div class="flex items-center gap-2 mt-2">
                    <UBadge :color="(severityConfig[alert.severity]?.color as any) || 'neutral'" size="xs" variant="subtle">
                      {{ alert.severity }}
                    </UBadge>
                    <UBadge color="neutral" size="xs" variant="subtle">
                      {{ audienceLabels[alert.targetAudience] || alert.targetAudience }}
                    </UBadge>
                    <UBadge :color="alert.isActive ? 'success' : 'neutral'" size="xs" variant="subtle">
                      {{ alert.isActive ? 'Active' : 'Inactive' }}
                    </UBadge>
                    <span class="text-xs text-muted">{{ formatDate(alert.createdAt) }}</span>
                    <span v-if="alert.expiresAt" class="text-xs text-muted">
                      · Expires {{ formatDate(alert.expiresAt) }}
                    </span>
                  </div>
                </div>
              </div>
              <UButton
                :icon="alert.isActive ? 'i-lucide-eye-off' : 'i-lucide-eye'"
                :variant="alert.isActive ? 'outline' : 'soft'"
                :color="alert.isActive ? 'neutral' : 'primary'"
                size="xs"
                :label="alert.isActive ? 'Deactivate' : 'Reactivate'"
                @click="toggleActive(alert)"
              />
            </div>
          </div>
        </div>
      </div>
    </template>
  </UDashboardPanel>

  <!-- Compose Modal -->
  <UModal v-model:open="showComposeModal" title="New System Alert" description="Broadcast to all users in the selected audience.">
    <template #body>
      <form class="space-y-4" @submit.prevent="handleCreate">
        <!-- Severity -->
        <UFormField label="Severity">
          <div class="flex gap-2">
            <UButton
              v-for="sev in (['info', 'warning', 'critical'] as const)"
              :key="sev"
              size="sm"
              :icon="severityConfig[sev].icon"
              :label="sev.charAt(0).toUpperCase() + sev.slice(1)"
              :variant="form.severity === sev ? 'solid' : 'outline'"
              :color="form.severity === sev ? (severityConfig[sev].color as any) : 'neutral'"
              @click="form.severity = sev"
            />
          </div>
        </UFormField>

        <!-- Audience -->
        <UFormField label="Target audience">
          <USelect
            v-model="form.targetAudience"
            :items="[
              { label: 'All Users', value: 'all' },
              { label: 'Business Users Only', value: 'business' },
              { label: 'Customers Only', value: 'customers' },
              { label: 'Admin Only', value: 'admin' },
            ]"
          />
        </UFormField>

        <!-- Title -->
        <UFormField label="Title" required>
          <UInput v-model="form.title" placeholder="Planlagt vedlikehold..." size="lg" />
        </UFormField>

        <!-- Body -->
        <UFormField label="Message" required>
          <UTextarea v-model="form.body" placeholder="Detailed message..." :rows="4" size="lg" />
        </UFormField>

        <!-- Expiry -->
        <UFormField label="Auto-expire after (hours, 0 = never)">
          <UInput v-model.number="form.expiresInHours" type="number" :min="0" :max="720" size="sm" />
        </UFormField>

        <!-- Action URL (optional) -->
        <UFormField label="Action URL (optional)">
          <UInput v-model="form.actionUrl" placeholder="https://..." size="sm" />
        </UFormField>
        <UFormField v-if="form.actionUrl" label="Button label">
          <UInput v-model="form.actionLabel" placeholder="Les mer" size="sm" />
        </UFormField>
      </form>
    </template>

    <template #footer>
      <div class="flex items-center justify-end gap-2">
        <UButton variant="ghost" color="neutral" label="Cancel" @click="showComposeModal = false" />
        <UButton
          color="primary"
          icon="i-lucide-megaphone"
          label="Send Alert"
          :disabled="!form.title.trim() || !form.body.trim()"
          @click="handleCreate"
        />
      </div>
    </template>
  </UModal>
</template>
