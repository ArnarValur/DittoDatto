<script setup lang="ts">
/**
 * DDEventCard
 * A card component for displaying an event in preview/listing contexts.
 * Reusable across Business Portal preview and Public Marketplace.
 */

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
  }
  status?: 'draft' | 'published' | 'cancelled' | 'completed'
  storeId?: string
  storeName?: string // Denormalized for display
  hasTickets?: boolean // Event has ticketing enabled
  ticketingEnabled?: boolean
  // Ticketing availability
  ticketsAvailable?: number // How many tickets left
  totalCapacity?: number   // Total capacity for percentage calculations
}

const props = defineProps<{
  event: EventItem
  showStatus?: boolean
  clickable?: boolean
}>()

const emit = defineEmits<{
  (e: 'click', event: EventItem): void
  (e: 'tickets', event: EventItem): void
}>()

// Date formatting
function formatDate(date: Date | string | { seconds: number } | undefined): string {
  if (!date) return ''
  
  let d: Date
  if (typeof date === 'object' && 'seconds' in date) {
    d = new Date(date.seconds * 1000)
  } else {
    d = new Date(date)
  }
  
  return new Intl.DateTimeFormat('nb-NO', {
    weekday: 'short',
    day: 'numeric',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit'
  }).format(d)
}

// Check if event is in the past
const isPast = computed(() => {
  const now = new Date()
  let eventDate: Date
  
  if (typeof props.event.startDateTime === 'object' && 'seconds' in props.event.startDateTime) {
    eventDate = new Date(props.event.startDateTime.seconds * 1000)
  } else {
    eventDate = new Date(props.event.startDateTime)
  }
  
  return eventDate < now
})

// Status badge color
const statusColor = computed(() => {
  switch (props.event.status) {
    case 'published': return 'success'
    case 'draft': return 'warning'
    case 'cancelled': return 'error'
    case 'completed': return 'neutral'
    default: return 'neutral'
  }
})

// Tickets left badge - shows urgency based on availability
const ticketsLeftBadge = computed(() => {
  const available = props.event.ticketsAvailable
  const total = props.event.totalCapacity
  
  if (available === undefined || available === null) return null
  if (available <= 0) return { text: 'Sold Out', color: 'error' as const }
  
  // Calculate percentage if we have total
  const percentLeft = total ? (available / total) * 100 : 100
  
  // Determine urgency color
  let color: 'error' | 'warning' | 'success'
  if (percentLeft <= 10 || available <= 5) {
    color = 'error' // Red - almost gone!
  } else if (percentLeft <= 30 || available <= 20) {
    color = 'warning' // Yellow - selling fast
  } else {
    color = 'success' // Green - plenty left
  }
  
  return { text: `${available} tickets left`, color }
})

function handleClick() {
  if (props.clickable !== false) {
    emit('click', props.event)
  }
}
</script>

<template>
  <button
    :class="[
      'group text-left rounded-xl overflow-hidden bg-card border border-default transition-all duration-300',
      clickable !== false && 'hover:border-pink-500 hover:shadow-lg hover:shadow-pink-500/10 cursor-pointer',
      isPast && 'opacity-60'
    ]"
    :disabled="clickable === false"
    @click="handleClick"
  >
    <!-- Cover Image -->
    <div class="aspect-[16/9] bg-muted relative overflow-hidden">
      <img
        v-if="event.coverImageUrl"
        :src="event.coverImageUrl"
        :alt="event.title"
        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
      >
      <div
        v-else
        class="w-full h-full flex items-center justify-center bg-gradient-to-br from-pink-500/20 to-purple-500/10"
      >
        <UIcon name="i-lucide-calendar-days" class="size-12 text-pink-500/50" />
      </div>

      <!-- Status Badge -->
      <UBadge
        v-if="showStatus && event.status"
        :color="statusColor"
        variant="solid"
        size="xs"
        class="absolute top-2 right-2 capitalize"
      >
        {{ event.status }}
      </UBadge>

      <!-- Tickets Left Badge -->
      <UBadge
        v-if="ticketsLeftBadge"
        :color="ticketsLeftBadge.color"
        variant="solid"
        size="xs"
        class="absolute top-2 left-2 shadow-lg"
      >
        <UIcon name="i-lucide-ticket" class="size-3 mr-1" />
        {{ ticketsLeftBadge.text }}
      </UBadge>

      <!-- Date Overlay -->
      <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-3 pt-8">
        <div class="flex items-center gap-1.5 text-white text-sm">
          <UIcon name="i-lucide-calendar" class="size-4" />
          <span>{{ formatDate(event.startDateTime) }}</span>
        </div>
      </div>
    </div>

    <!-- Card Info -->
    <div class="p-4 space-y-2">
      <h3 class="font-semibold line-clamp-1 group-hover:text-pink-500 transition-colors">
        {{ event.title }}
      </h3>

      <p
        v-if="event.description"
        class="text-sm text-muted line-clamp-2"
      >
        {{ event.description }}
      </p>

      <div class="flex items-center gap-3 text-xs text-muted">
        <span v-if="event.location?.city" class="flex items-center gap-1">
          <UIcon name="i-lucide-map-pin" class="size-3.5" />
          {{ event.location.city }}
        </span>
        <span v-if="event.storeName" class="flex items-center gap-1">
          <UIcon name="i-lucide-store" class="size-3.5" />
          {{ event.storeName }}
        </span>
      </div>

      <!-- Get Tickets Button (for ticketed events) -->
      <UButton
        v-if="event.hasTickets || event.ticketingEnabled"
        label="Get Tickets"
        icon="i-lucide-ticket"
        color="primary"
        :class="'bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700'"
        block
        size="sm"
        @click.stop="emit('tickets', event)"
      />
    </div>
  </button>
</template>
