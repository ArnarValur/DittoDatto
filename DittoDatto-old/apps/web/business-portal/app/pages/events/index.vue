<script setup lang="ts">
import type { Event } from '@dittodatto/shared-types'

definePageMeta({
  layout: 'dashboard'
})

const { events, loading, isEmpty, isEnabled, getStoreName } = useEvents()

// Slideover state
const isSlideoverOpen = ref(false)
const selectedEvent = ref<Event | null>(null)

function openCreateForm() {
  selectedEvent.value = null
  isSlideoverOpen.value = true
}

function openEditForm(event: Event) {
  selectedEvent.value = event
  isSlideoverOpen.value = true
}

// Refresh events after save/delete
function onEventChanged() {
  window.location.reload()
}

// Format date for display
const formatDate = (date: Date | string | { seconds?: number, _seconds?: number } | null | undefined) => {
  if (!date) return 'No date'

  let d: Date
  try {
    if (date instanceof Date) {
      d = date
    } else if (typeof date === 'string') {
      d = new Date(date)
    } else if (date && typeof date === 'object' && ('seconds' in date || '_seconds' in (date as Record<string, any>))) {
      const timestamp = date as { seconds?: number, _seconds?: number }
      const seconds = timestamp.seconds ?? timestamp._seconds ?? 0
      d = new Date(seconds * 1000)
    } else {
      return 'Invalid date'
    }

    // Check if date is valid
    if (isNaN(d.getTime())) {
      console.warn('[formatDate] Invalid date value:', date)
      return 'Invalid date'
    }

    return new Intl.DateTimeFormat('nb-NO', {
      weekday: 'short',
      day: 'numeric',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    }).format(d)
  } catch (e) {
    console.error('[formatDate] Error formatting date:', date, e)
    return 'Date error'
  }
}

// Get status badge color
const getStatusColor = (status: string) => {
  switch (status) {
    case 'published': return 'success'
    case 'draft': return 'warning'
    case 'cancelled': return 'error'
    case 'completed': return 'neutral'
    default: return 'neutral'
  }
}
</script>

<template>
  <UDashboardPanel id="events">
    <template #header>
      <UDashboardNavbar title="Events" :ui="{ right: 'gap-3' }">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>

        <template #right>
          <UButton
            icon="i-lucide-plus"
            label="Create Event"
            color="primary"
            @click="openCreateForm"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6">
        <!-- Feature Not Enabled -->
        <UCard v-if="!isEnabled" class="text-center py-12">
          <UIcon name="i-lucide-lock" class="size-16 mx-auto mb-4 text-muted opacity-50" />
          <h3 class="text-lg font-semibold mb-2">
            Event System Not Enabled
          </h3>
          <p class="text-muted">
            Contact your administrator to enable the Event System feature.
          </p>
        </UCard>

        <!-- Loading State -->
        <div v-else-if="loading" class="space-y-4">
          <UCard v-for="i in 3" :key="i">
            <div class="flex items-center gap-4">
              <USkeleton class="size-16 rounded-lg" />
              <div class="flex-1 space-y-2">
                <USkeleton class="h-5 w-48" />
                <USkeleton class="h-4 w-32" />
              </div>
              <USkeleton class="h-6 w-20" />
            </div>
          </UCard>
        </div>

        <!-- Empty State -->
        <UCard v-else-if="isEmpty" class="text-center py-12">
          <UIcon name="i-lucide-calendar-days" class="size-16 mx-auto mb-4 text-pink-500 opacity-50" />
          <h3 class="text-lg font-semibold mb-2">
            No events yet
          </h3>
          <p class="text-muted mb-4">
            Create your first event to get started.
          </p>
          <UButton
            icon="i-lucide-plus"
            label="Create Event"
            color="primary"
            @click="openCreateForm"
          />
        </UCard>

        <!-- Events List -->
        <div v-else class="space-y-4">
          <UCard
            v-for="event in events"
            :key="event.id"
            class="cursor-pointer hover:bg-muted/50 transition-colors"
            @click="openEditForm(event)"
          >
            <div class="flex items-center gap-4">
              <!-- Cover Image -->
              <div class="shrink-0 size-16 rounded-lg overflow-hidden bg-pink-500/10 flex items-center justify-center">
                <img
                  v-if="event.coverImageUrl"
                  :src="event.coverImageUrl"
                  :alt="event.title"
                  class="w-full h-full object-cover"
                >
                <UIcon v-else name="i-lucide-calendar-days" class="size-6 text-pink-500" />
              </div>

              <!-- Event Info -->
              <div class="flex-1 min-w-0">
                <h3 class="font-semibold truncate">
                  {{ event.title }}
                </h3>
                <div class="flex items-center gap-3 text-sm text-muted">
                  <span class="flex items-center gap-1">
                    <UIcon name="i-lucide-calendar" class="size-4" />
                    {{ formatDate(event.startDateTime) }}
                  </span>
                  <span v-if="event.location?.city" class="flex items-center gap-1">
                    <UIcon name="i-lucide-map-pin" class="size-4" />
                    {{ event.location.city }}
                  </span>
                  <span v-if="getStoreName(event.storeId)" class="flex items-center gap-1">
                    <UIcon name="i-lucide-store" class="size-4" />
                    {{ getStoreName(event.storeId) }}
                  </span>
                </div>
              </div>

              <!-- Status -->
              <div class="text-right">
                <UBadge
                  :color="getStatusColor(event.status)"
                  variant="subtle"
                  class="capitalize"
                >
                  {{ event.status }}
                </UBadge>
                <p v-if="event.visibility === 'private'" class="text-xs text-muted mt-1">
                  <UIcon name="i-lucide-lock" class="size-3 inline" /> Private
                </p>
              </div>
            </div>
          </UCard>
        </div>
      </div>
    </template>
  </UDashboardPanel>

  <!-- Event Form Slideover -->
  <EventsEventFormSlideover
    v-model:open="isSlideoverOpen"
    :event="selectedEvent"
    @saved="onEventChanged"
    @deleted="onEventChanged"
    @close="isSlideoverOpen = false"
  />
</template>
