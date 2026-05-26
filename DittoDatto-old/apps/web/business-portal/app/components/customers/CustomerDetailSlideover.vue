<script setup lang="ts">
import type { Customer, Booking } from '@dittodatto/shared-types'
import { formatDistanceToNow, format } from 'date-fns'
import { nb } from 'date-fns/locale'

const props = defineProps<{
  customer: Customer | null
  open: boolean
}>()

const emit = defineEmits<{
  'update:open': [value: boolean]
}>()

const isOpen = computed({
  get: () => props.open,
  set: (val) => emit('update:open', val)
})

// Edit mode toggle
const isEditing = ref(false)

// Store name resolution
const { stores } = useStores()
function storeName(storeId: string): string {
  return stores.value?.find(s => s.id === storeId)?.name ?? storeId
}

// Customer booking history
const customerIdRef = computed(() => props.customer?.id ?? null)
const customerUserIdRef = computed(() => props.customer?.userId)
const customerEmailRef = computed(() => props.customer?.email)

const { bookings, loading: bookingsLoading, totalSpent, completedCount, cancelledCount } = useCustomerBookings(
  customerIdRef,
  customerUserIdRef,
  customerEmailRef,
)

// Helpers
function timeSince(dateString?: string) {
  if (!dateString) return 'Never visited'
  return formatDistanceToNow(new Date(dateString), { addSuffix: true, locale: nb })
}

function formatDate(dateString?: string) {
  if (!dateString) return '—'
  return new Date(dateString).toLocaleDateString('nb-NO', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

function formatBookingDate(dateString: string) {
  const d = new Date(dateString)
  return format(d, 'd. MMM yyyy', { locale: nb })
}

function formatBookingTime(dateString: string) {
  const d = new Date(dateString)
  return format(d, 'HH:mm')
}

function formatCurrency(amount: number) {
  return new Intl.NumberFormat('nb-NO', { style: 'currency', currency: 'NOK' }).format(amount)
}

const statusColor: Record<string, string> = {
  confirmed: 'success',
  completed: 'success',
  pending: 'warning',
  cancelled: 'error',
  no_show: 'error',
}

function onSave(data: Partial<Customer>) {
  // TODO: Firestore update — will hook up when CRM write API is ready
  console.log('Save customer:', data)
  isEditing.value = false
}

// Reset edit mode when slideover closes
watch(isOpen, (val) => {
  if (!val) isEditing.value = false
})
</script>

<template>
  <USlideover v-model:open="isOpen" :ui="{ width: 'sm:max-w-lg' }">
    <template #content>
      <div v-if="customer" class="flex flex-col h-full">
        <!-- Header -->
        <div class="flex items-center justify-between p-6 border-b border-default">
          <div class="flex items-center gap-3">
            <UAvatar
              :text="customer.name?.substring(0, 2).toUpperCase()"
              size="lg"
            />
            <div>
              <div class="flex items-center gap-2">
                <h2 class="text-lg font-semibold">{{ customer.name }}</h2>
                <UBadge
                  :color="customer.status === 'active' ? 'success' : customer.status === 'inactive' ? 'error' : 'neutral'"
                  variant="subtle"
                  size="xs"
                >
                  {{ customer.status || 'new' }}
                </UBadge>
              </div>
              <p class="text-sm text-muted">
                {{ customer.email || 'No email' }}
              </p>
            </div>
          </div>
          <div class="flex items-center gap-1">
            <UButton
              :icon="isEditing ? 'i-lucide-x' : 'i-lucide-pencil'"
              color="neutral"
              variant="ghost"
              size="sm"
              @click="isEditing = !isEditing"
            />
            <UButton
              icon="i-lucide-x"
              color="neutral"
              variant="ghost"
              size="sm"
              @click="isOpen = false"
            />
          </div>
        </div>

        <!-- Body -->
        <div class="flex-1 overflow-y-auto">
          <!-- Edit Mode: Show Profile Form -->
          <div v-if="isEditing" class="p-6">
            <CustomersCustomerProfileForm
              :customer="customer"
              @save="onSave"
              @cancel="isEditing = false"
            />
          </div>

          <!-- View Mode: Show Customer Details -->
          <div v-else class="p-6 space-y-6">
            <!-- Stats Row -->
            <div class="grid grid-cols-4 gap-3">
              <div class="bg-elevated/30 rounded-lg p-3 text-center">
                <p class="text-xl font-bold">{{ customer.totalVisits || 0 }}</p>
                <p class="text-xs text-muted">Visits</p>
              </div>
              <div class="bg-elevated/30 rounded-lg p-3 text-center">
                <p class="text-xl font-bold">{{ formatCurrency(customer.totalSpent || totalSpent || 0) }}</p>
                <p class="text-xs text-muted">Total Spent</p>
              </div>
              <div class="bg-elevated/30 rounded-lg p-3 text-center">
                <p class="text-xl font-bold text-success">{{ completedCount }}</p>
                <p class="text-xs text-muted">Completed</p>
              </div>
              <div class="bg-elevated/30 rounded-lg p-3 text-center">
                <p class="text-xl font-bold text-error">{{ cancelledCount }}</p>
                <p class="text-xs text-muted">Cancelled</p>
              </div>
            </div>

            <!-- Visit Dates -->
            <div class="flex items-center justify-between text-xs text-muted">
              <span>First visit: {{ formatDate(customer.firstVisitAt) }}</span>
              <span>Last visit: {{ timeSince(customer.lastVisitAt) }}</span>
            </div>

            <!-- Contact Info -->
            <div class="space-y-3">
              <h3 class="text-xs font-semibold text-muted uppercase tracking-wider">Contact</h3>
              <div class="space-y-2">
                <div v-if="customer.phone" class="flex items-center gap-3 text-sm">
                  <UIcon name="i-lucide-phone" class="size-4 text-muted shrink-0" />
                  <span>{{ customer.phoneCountryCode || '' }} {{ customer.phone }}</span>
                </div>
                <div v-if="customer.email" class="flex items-center gap-3 text-sm">
                  <UIcon name="i-lucide-mail" class="size-4 text-muted shrink-0" />
                  <span>{{ customer.email }}</span>
                </div>
                <div v-if="customer.channel" class="flex items-center gap-3 text-sm">
                  <UIcon name="i-lucide-globe" class="size-4 text-muted shrink-0" />
                  <span class="capitalize">Acquired via {{ customer.channel }}</span>
                </div>
              </div>
            </div>

            <!-- Notes -->
            <div class="space-y-2">
              <h3 class="text-xs font-semibold text-muted uppercase tracking-wider">Notes</h3>
              <div class="bg-elevated/50 p-3 rounded-lg text-sm min-h-[60px]">
                {{ customer.notes || 'No notes yet — click Edit to add.' }}
              </div>
            </div>

            <!-- Establishments -->
            <div v-if="customer.storeIds?.length" class="space-y-2">
              <h3 class="text-xs font-semibold text-muted uppercase tracking-wider">Establishments Visited</h3>
              <div class="flex flex-wrap gap-1.5">
                <UBadge
                  v-for="storeId in customer.storeIds"
                  :key="storeId"
                  color="neutral"
                  variant="subtle"
                  size="sm"
                  icon="i-lucide-building-2"
                >
                  {{ storeName(storeId) }}
                </UBadge>
              </div>
            </div>

            <!-- Booking History Timeline -->
            <div class="space-y-3">
              <div class="flex items-center justify-between">
                <h3 class="text-xs font-semibold text-muted uppercase tracking-wider">Booking History</h3>
                <span v-if="bookings?.length" class="text-xs text-muted">{{ bookings.length }} bookings</span>
              </div>

              <!-- Loading State -->
              <div v-if="bookingsLoading" class="space-y-3">
                <div v-for="i in 3" :key="i" class="flex gap-3 animate-pulse">
                  <div class="w-1 rounded bg-elevated shrink-0" />
                  <div class="flex-1 space-y-2 py-2">
                    <div class="h-4 w-32 bg-elevated rounded" />
                    <div class="h-3 w-48 bg-elevated rounded" />
                  </div>
                </div>
              </div>

              <!-- Empty State -->
              <div v-else-if="!bookings?.length" class="text-center py-6">
                <UIcon name="i-lucide-calendar-x" class="size-10 mx-auto mb-2 text-muted opacity-40" />
                <p class="text-sm text-muted">No booking history found</p>
              </div>

              <!-- Timeline -->
              <div v-else class="space-y-0">
                <div
                  v-for="(booking, idx) in bookings"
                  :key="booking.id"
                  class="flex gap-3 group"
                >
                  <!-- Timeline Line + Dot -->
                  <div class="flex flex-col items-center shrink-0 w-4">
                    <div
                      class="size-2.5 rounded-full border-2 shrink-0 mt-2"
                      :class="idx === 0 ? 'bg-primary border-primary' : 'bg-default border-muted'"
                    />
                    <div
                      v-if="idx < bookings.length - 1"
                      class="w-px flex-1 bg-default"
                    />
                  </div>

                  <!-- Booking Entry -->
                  <div class="flex-1 pb-4 min-w-0">
                    <div class="flex items-center justify-between gap-2">
                      <div class="min-w-0">
                        <p class="text-sm font-medium truncate">{{ booking.serviceTitle }}</p>
                        <p class="text-xs text-muted">
                          {{ formatBookingDate(booking.startTime) }} · {{ formatBookingTime(booking.startTime) }}
                        </p>
                      </div>
                      <div class="flex items-center gap-2 shrink-0">
                        <span class="text-sm font-medium tabular-nums">
                          {{ formatCurrency(booking.priceAtTimeOfBooking) }}
                        </span>
                        <UBadge
                          :color="(statusColor[booking.status] || 'neutral') as any"
                          variant="subtle"
                          size="xs"
                        >
                          {{ booking.status }}
                        </UBadge>
                      </div>
                    </div>

                    <!-- Multi-item bookings -->
                    <div v-if="booking.items?.length > 1" class="mt-1 space-y-0.5">
                      <p
                        v-for="item in booking.items"
                        :key="item.serviceId"
                        class="text-xs text-muted flex justify-between"
                      >
                        <span>· {{ item.title }}</span>
                        <span class="tabular-nums">{{ formatCurrency(item.price) }}</span>
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Metadata -->
            <div class="text-xs text-muted pt-4 border-t border-default space-y-1">
              <p>Customer ID: {{ customer.id }}</p>
              <p>Created: {{ formatDate(customer.createdAt) }}</p>
              <p>Updated: {{ formatDate(customer.updatedAt) }}</p>
            </div>
          </div>
        </div>
      </div>
    </template>
  </USlideover>
</template>
