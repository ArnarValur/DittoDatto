<script setup lang="ts">
/**
 * DDEventGrid
 * Displays events as cards in a grid layout.
 * Emits events for selection and ticket purchase actions.
 */

const { t } = useI18n()

interface EventItem {
  id: string
  title: string
  description?: string
  coverImageUrl?: string
  startDateTime: Date | string | { seconds: number }
  endDateTime?: Date | string | { seconds: number }
  location?: {
    name?: string
    address?: string
    city?: string
    country?: string
    coordinates?: { lat: number; lng: number }
  }
  status?: 'draft' | 'published' | 'cancelled' | 'completed'
  storeId?: string
  storeName?: string
  // Ticketing
  hasTickets?: boolean
  ticketingEnabled?: boolean
  ticketsAvailable?: number
  totalCapacity?: number
}

const props = defineProps<{
  events: EventItem[]
  showStatus?: boolean
  emptyIcon?: string
  emptyText?: string
}>()

const emit = defineEmits<{
  (e: 'select', event: EventItem): void
  (e: 'tickets', event: EventItem): void
}>()

function handleCardClick(event: EventItem) {
  emit('select', event)
}

function handleTickets(event: EventItem) {
  emit('tickets', event)
}
</script>

<template>
  <div class="space-y-6">
    <!-- Event Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
      <DDEventCard
        v-for="event in events"
        :key="event.id"
        :event="event"
        :show-status="showStatus"
        @click="handleCardClick"
        @tickets="handleTickets"
      />
    </div>

    <!-- Empty State -->
    <div
      v-if="events.length === 0"
      class="text-center py-12 text-muted"
    >
      <UIcon :name="emptyIcon || 'i-lucide-calendar-days'" class="size-12 mx-auto mb-4 opacity-50" />
      <p>{{ emptyText || t('establishment.noEvents') }}</p>
    </div>
  </div>
</template>
