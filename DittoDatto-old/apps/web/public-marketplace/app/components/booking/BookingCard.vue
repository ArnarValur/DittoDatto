<script setup lang="ts">
/**
 * BookingCard.vue
 * Unified booking card for profile/bookings and profile/index.
 * Matches the Overview hero card style: green left border for upcoming confirmed.
 */
import type { Booking } from '@dittodatto/shared-types'

interface Props {
  booking: Booking
  cancelling?: boolean
}

const props = defineProps<Props>()

const emit = defineEmits<{
  (e: 'cancel', id: string): void
  (e: 'review', id: string): void
}>()

const { t, locale } = useI18n()
const { findThreadByBookingId } = useUserThreads()

/** Resolve thread by bookingId (thread.bookingId → booking.id) */
const resolvedThreadId = computed(() =>
  findThreadByBookingId(props.booking.id)?.id ?? null
)

const isUpcoming = computed(() =>
  new Date(props.booking.startTime) > new Date() && props.booking.status === 'confirmed'
)

const formattedDate = computed(() => {
  try {
    return new Date(props.booking.startTime).toLocaleDateString(locale.value, {
      weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
    })
  } catch { return '' }
})

const formattedTime = computed(() => {
  try {
    const toTime = (val: string) =>
      new Date(val).toLocaleTimeString(locale.value, {
        hour: '2-digit', minute: '2-digit', hour12: false
      })
    return `${toTime(props.booking.startTime)} – ${toTime(props.booking.endTime)}`
  } catch { return '' }
})

const formattedPrice = computed(() => {
  try {
    return new Intl.NumberFormat(locale.value, {
      style: 'currency',
      currency: props.booking.currency || 'NOK'
    }).format(props.booking.priceAtTimeOfBooking || 0)
  } catch { return '' }
})

const bookingReference = computed(() =>
  (props.booking.id || '').substring(0, 8).toUpperCase()
)

const statusConfig = computed(() => {
  switch (props.booking.status) {
    case 'confirmed': return { color: 'success' as const, icon: 'i-lucide-check-circle', label: t('booking.status.confirmed') }
    case 'completed': return { color: 'neutral' as const, icon: 'i-lucide-circle-check-big', label: t('booking.status.completed') }
    case 'cancelled': return { color: 'error' as const, icon: 'i-lucide-x-circle', label: t('booking.status.cancelled') }
    case 'no-show':   return { color: 'warning' as const, icon: 'i-lucide-alert-circle', label: t('booking.status.noShow') }
    case 'pending':   return { color: 'info' as const, icon: 'i-lucide-clock', label: t('booking.status.pending') }
    default:          return { color: 'neutral' as const, icon: 'i-lucide-circle', label: props.booking.status }
  }
})

// Border accent matches Overview hero card style
const borderClass = computed(() => {
  if (props.booking.status === 'confirmed' && isUpcoming.value)
    return 'border-l-4 border-l-green-500 dark:border-l-green-400'
  if (props.booking.status === 'cancelled')
    return 'border-l-4 border-l-red-400 dark:border-l-red-600 opacity-75'
  return 'border-l-4 border-l-gray-200 dark:border-l-gray-700'
})

// Chat slideover state (self-contained per card)
const chatOpen = ref(false)
</script>

<template>
  <UCard :class="['transition-shadow hover:shadow-md', borderClass]">
    <div class="flex flex-col sm:flex-row sm:items-start gap-4">
      <!-- Left: Details -->
      <div class="flex-1 space-y-3">
        <!-- Header: Service + Status -->
        <div class="flex items-center justify-between gap-2">
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white truncate">
            {{ booking.serviceTitle }}
          </h3>
          <UBadge :color="statusConfig.color" variant="subtle" class="shrink-0">
            <UIcon :name="statusConfig.icon" class="size-3.5 mr-1" />
            {{ statusConfig.label }}
          </UBadge>
        </div>

        <!-- Detail rows -->
        <div class="space-y-2 text-sm">
          <div class="flex items-center text-gray-600 dark:text-gray-400">
            <UIcon name="i-lucide-calendar-days" class="size-4 mr-2.5 text-gray-400 dark:text-gray-500" />
            <span>{{ formattedDate }}</span>
          </div>
          <div class="flex items-center text-gray-600 dark:text-gray-400">
            <UIcon name="i-lucide-clock" class="size-4 mr-2.5 text-gray-400 dark:text-gray-500" />
            <span>{{ formattedTime }}</span>
          </div>
          <div class="flex items-center text-gray-600 dark:text-gray-400">
            <UIcon name="i-lucide-tag" class="size-4 mr-2.5 text-gray-400 dark:text-gray-500" />
            <span>{{ formattedPrice }}</span>
          </div>
        </div>

        <!-- Reference -->
        <div class="text-xs text-gray-400 dark:text-gray-500">
          Ref: <span class="font-mono bg-gray-100 dark:bg-gray-800 px-1.5 py-0.5 rounded">{{ bookingReference }}</span>
        </div>
      </div>

      <!-- Right: Actions -->
      <div class="flex sm:flex-col gap-2 sm:items-end shrink-0">
        <!-- Chat button — visible for all upcoming confirmed bookings -->
        <UButton
          v-if="isUpcoming"
          size="sm"
          color="primary"
          variant="ghost"
          icon="i-lucide-message-circle"
          class="sm:w-full"
          @click="chatOpen = true"
        >
          <span class="hidden sm:inline">{{ t('profile.chat.openChat') }}</span>
        </UButton>

        <!-- Cancel (upcoming only) -->
        <UButton
          v-if="isUpcoming"
          size="sm"
          color="error"
          variant="soft"
          icon="i-lucide-x"
          :label="t('profile.cancel')"
          :loading="cancelling"
          class="sm:w-full"
          @click="emit('cancel', booking.id)"
        />

        <!-- Review (completed only) -->
        <UButton
          v-if="!isUpcoming && booking.status === 'completed'"
          size="sm"
          color="primary"
          variant="soft"
          icon="i-lucide-star"
          :label="t('common.review')"
          class="sm:w-full"
          @click="emit('review', booking.id)"
        />
      </div>
    </div>
  </UCard>

  <!-- Chat Slideover — self-contained per card -->
  <BookingChatSlideover
    v-model:open="chatOpen"
    :booking="booking"
    :thread-id="resolvedThreadId"
  />
</template>
