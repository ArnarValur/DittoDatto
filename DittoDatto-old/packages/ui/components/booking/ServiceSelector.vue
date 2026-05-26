<script setup lang="ts">
/**
 * ServiceSelector
 * 
 * Displays available services for a store and allows selection.
 * First step in the booking flow.
 */

interface ServiceItem {
  id: string
  title: string
  description?: string
  price?: number
  currency?: string
  duration?: number
  coverImage?: string
  bookingMode?: 'standard' | 'tableReservation' | 'ticketSystem'
  availabilityStart?: string
  availabilityEnd?: string
}

const props = defineProps<{
  services: ServiceItem[]
  selectedId?: string
}>()

const emit = defineEmits<{
  (e: 'select', service: ServiceItem): void
}>()

function formatDuration(minutes?: number): string {
  if (!minutes) return ''
  if (minutes < 60) return `${minutes} min`
  const hours = Math.floor(minutes / 60)
  const mins = minutes % 60
  return mins ? `${hours}h ${mins}m` : `${hours}h`
}

function formatPrice(price?: number, currency?: string): string {
  if (price === undefined || price === null) return ''
  if (price === 0) return 'Free'
  return `${price} ${currency || 'kr'}`
}
</script>

<template>
  <div class="space-y-3">
    <div
      v-for="service in services"
      :key="service.id"
      class="flex gap-4 p-4 rounded-xl border cursor-pointer transition-all"
      :class="[
        selectedId === service.id
          ? 'border-primary bg-primary/10 ring-1 ring-primary'
          : 'border-default bg-default hover:border-primary/50'
      ]"
      role="button"
      tabindex="0"
      @click="emit('select', service)"
      @keydown.enter="emit('select', service)"
    >
      <!-- Service Image (if available) -->
      <div
        v-if="service.coverImage"
        class="shrink-0 size-16 rounded-lg overflow-hidden bg-muted"
      >
        <img
          :src="service.coverImage"
          :alt="service.title"
          class="w-full h-full object-cover"
        >
      </div>
      <div
        v-else
        class="shrink-0 size-16 rounded-lg bg-muted flex items-center justify-center"
      >
        <UIcon name="i-lucide-calendar-check" class="size-6 text-muted" />
      </div>

      <!-- Service Info -->
      <div class="flex-1 min-w-0">
        <h3 class="font-semibold truncate">
          {{ service.title }}
        </h3>
        <p
          v-if="service.description"
          class="text-sm text-muted line-clamp-2"
        >
          {{ service.description }}
        </p>
        <div class="flex items-center gap-3 mt-2 text-sm">
          <span v-if="service.duration" class="flex items-center gap-1 text-muted">
            <UIcon name="i-lucide-clock" class="size-3.5" />
            {{ formatDuration(service.duration) }}
          </span>
          <span
            v-if="service.price !== undefined"
            class="font-medium"
            :class="service.price === 0 ? 'text-green-500' : 'text-primary'"
          >
            {{ formatPrice(service.price, service.currency) }}
          </span>
        </div>
      </div>

      <!-- Selection Indicator -->
      <div class="shrink-0 flex items-center">
        <UIcon
          v-if="selectedId === service.id"
          name="i-lucide-check-circle"
          class="size-5 text-primary"
        />
        <UIcon
          v-else
          name="i-lucide-chevron-right"
          class="size-5 text-muted"
        />
      </div>
    </div>

    <div
      v-if="services.length === 0"
      class="text-center py-8 text-muted"
    >
      <UIcon name="i-lucide-calendar-x" class="size-12 mx-auto mb-3 opacity-50" />
      <p>No services available</p>
    </div>
  </div>
</template>
