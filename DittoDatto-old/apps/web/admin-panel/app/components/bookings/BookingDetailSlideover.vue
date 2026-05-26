<script setup lang="ts">
/**
 * BookingDetailSlideover
 * Read-only detail view for a booking record.
 */
import type { Booking } from '@dittodatto/shared-types'

const props = defineProps<{
  booking: (Booking & { storeName?: string, companyName?: string }) | null
}>()

const open = defineModel<boolean>('open', { default: false })

// Status color mapping
const statusColor = computed(() => {
  switch (props.booking?.status) {
    case 'confirmed': return 'success'
    case 'pending': return 'warning'
    case 'completed': return 'info'
    case 'cancelled': return 'error'
    case 'no-show': return 'error'
    default: return 'neutral'
  }
})

// Format date/time
const formatDateTime = (iso: string) => {
  if (!iso) return '—'
  const d = new Date(iso)
  return d.toLocaleDateString('en-GB', {
    weekday: 'short',
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const formatTime = (iso: string) => {
  if (!iso) return '—'
  const d = new Date(iso)
  return d.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' })
}

// Copy to clipboard
const copyToClipboard = (text: string, label: string) => {
  navigator.clipboard.writeText(text)
  useToast().add({ title: 'Copied', description: `${label} copied to clipboard` })
}
</script>

<template>
  <USlideover v-model:open="open" :title="booking?.serviceTitle || 'Booking Details'">
    <template #body>
      <div v-if="booking" class="space-y-6 p-1">
        <!-- Status Banner -->
        <div class="flex items-center justify-between">
          <h3 class="text-lg font-semibold">
            {{ booking.serviceTitle }}
          </h3>
          <UBadge :color="statusColor" variant="subtle" class="capitalize text-sm">
            {{ booking.status }}
          </UBadge>
        </div>

        <!-- Customer Info -->
        <div class="space-y-2">
          <h4 class="text-sm font-medium text-gray-400 uppercase tracking-wider">
            Customer
          </h4>
          <div class="bg-gray-900/50 rounded-lg p-3 space-y-1">
            <div class="flex items-center gap-2">
              <UIcon name="i-lucide-user" class="w-4 h-4 text-gray-400" />
              <span>{{ booking.userName }}</span>
            </div>
            <div class="flex items-center gap-2">
              <UIcon name="i-lucide-mail" class="w-4 h-4 text-gray-400" />
              <span class="text-sm text-gray-300">{{ booking.userEmail }}</span>
            </div>
            <div v-if="booking.userPhone" class="flex items-center gap-2">
              <UIcon name="i-lucide-phone" class="w-4 h-4 text-gray-400" />
              <span class="text-sm text-gray-300">{{ booking.userPhone }}</span>
            </div>
          </div>
        </div>

        <!-- Timing -->
        <div class="space-y-2">
          <h4 class="text-sm font-medium text-gray-400 uppercase tracking-wider">
            Schedule
          </h4>
          <div class="bg-gray-900/50 rounded-lg p-3 space-y-1">
            <div class="flex justify-between">
              <span class="text-gray-400">Start</span>
              <span class="font-medium">{{ formatDateTime(booking.startTime) }}</span>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-400">End</span>
              <span>{{ formatDateTime(booking.endTime) }}</span>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-400">Duration</span>
              <span>{{ booking.duration }} min</span>
            </div>
          </div>
        </div>

        <!-- Payment -->
        <div class="space-y-2">
          <h4 class="text-sm font-medium text-gray-400 uppercase tracking-wider">
            Payment
          </h4>
          <div class="bg-gray-900/50 rounded-lg p-3 space-y-1">
            <div class="flex justify-between">
              <span class="text-gray-400">Price</span>
              <span class="font-medium">{{ booking.priceAtTimeOfBooking }} {{ booking.currency }}</span>
            </div>
            <div v-if="booking.paymentId" class="flex justify-between items-center">
              <span class="text-gray-400">Payment ID</span>
              <div class="flex items-center gap-1">
                <span class="text-xs font-mono text-gray-300">{{ booking.paymentId }}</span>
                <UButton
                  icon="i-lucide-copy"
                  size="xs"
                  color="neutral"
                  variant="ghost"
                  @click="copyToClipboard(booking.paymentId!, 'Payment ID')"
                />
              </div>
            </div>
          </div>
        </div>

        <!-- Location -->
        <div class="space-y-2">
          <h4 class="text-sm font-medium text-gray-400 uppercase tracking-wider">
            Location
          </h4>
          <div class="bg-gray-900/50 rounded-lg p-3 space-y-1">
            <div class="flex justify-between">
              <span class="text-gray-400">Company</span>
              <span>{{ booking.companyName || booking.companyId }}</span>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-400">Store</span>
              <span>{{ booking.storeName || booking.storeId }}</span>
            </div>
          </div>
        </div>

        <!-- Metadata -->
        <div class="space-y-2">
          <h4 class="text-sm font-medium text-gray-400 uppercase tracking-wider">
            Metadata
          </h4>
          <div class="bg-gray-900/50 rounded-lg p-3 space-y-1">
            <div class="flex justify-between items-center">
              <span class="text-gray-400">Booking ID</span>
              <div class="flex items-center gap-1">
                <span class="text-xs font-mono text-gray-300">{{ booking.id }}</span>
                <UButton
                  icon="i-lucide-copy"
                  size="xs"
                  color="neutral"
                  variant="ghost"
                  @click="copyToClipboard(booking.id, 'Booking ID')"
                />
              </div>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-400">Channel</span>
              <UBadge color="neutral" variant="subtle" size="sm">{{ booking.channel }}</UBadge>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-400">Attendees</span>
              <span>{{ booking.attendeeCount }}</span>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-400">Created</span>
              <span class="text-sm">{{ formatDateTime(booking.createdAt) }}</span>
            </div>
            <div v-if="booking.updatedAt" class="flex justify-between">
              <span class="text-gray-400">Updated</span>
              <span class="text-sm">{{ formatDateTime(booking.updatedAt) }}</span>
            </div>
          </div>
        </div>

        <!-- Notes -->
        <div v-if="booking.notes" class="space-y-2">
          <h4 class="text-sm font-medium text-gray-400 uppercase tracking-wider">
            Notes
          </h4>
          <div class="bg-gray-900/50 rounded-lg p-3">
            <p class="text-sm text-gray-300">{{ booking.notes }}</p>
          </div>
        </div>

        <!-- Service Items -->
        <div v-if="booking.items?.length" class="space-y-2">
          <h4 class="text-sm font-medium text-gray-400 uppercase tracking-wider">
            Service Items
          </h4>
          <div class="space-y-2">
            <div
              v-for="(item, i) in booking.items"
              :key="i"
              class="bg-gray-900/50 rounded-lg p-3 flex justify-between items-center"
            >
              <div>
                <span class="font-medium">{{ item.title }}</span>
                <span class="text-sm text-gray-400 ml-2">{{ item.duration }} min</span>
              </div>
              <span class="text-sm">{{ item.price }} {{ booking.currency }}</span>
            </div>
          </div>
        </div>
      </div>
    </template>
  </USlideover>
</template>
