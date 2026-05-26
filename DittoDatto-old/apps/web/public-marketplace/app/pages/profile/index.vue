<script setup lang="ts">
import { CalendarDate, today, getLocalTimeZone } from '@internationalized/date'
import type { DateValue } from '@internationalized/date'
import { useUserBookings } from '~/composables/useUserBookings'

const { user, userProfile } = useAuth()
const { bookings, fetchBookings, cancelBooking, cancelling, loading } = useUserBookings()
const toast = useToast()
const { t, locale } = useI18n()

onMounted(() => {
  fetchBookings()
})

// --- Calendar State ---
const selectedDate = shallowRef(today(getLocalTimeZone()))

/** Set of "YYYY-MM-DD" strings for dates that have bookings */
const bookedDateSet = computed(() => {
  const set = new Set<string>()
  for (const b of bookings.value) {
    try {
      const d = new Date(b.startTime)
      const key = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
      set.add(key)
    } catch { /* skip malformed */ }
  }
  return set
})

function hasBookingOn(day: DateValue): boolean {
  const key = `${day.year}-${String(day.month).padStart(2, '0')}-${String(day.day).padStart(2, '0')}`
  return bookedDateSet.value.has(key)
}

type ChipColor = 'success' | 'neutral' | 'primary' | 'secondary' | 'info' | 'warning' | 'error' | undefined

function getChipColor(day: DateValue): ChipColor {
  if (!hasBookingOn(day)) return undefined
  const dateObj = new Date(day.year, day.month - 1, day.day)
  return dateObj >= new Date(new Date().toDateString()) ? 'success' : 'neutral'
}

// --- Booking Helpers ---
const nextBooking = computed(() => {
  const now = new Date()
  return bookings.value
    .filter(b => new Date(b.startTime) > now && b.status === 'confirmed')
    .sort((a, b) => new Date(a.startTime).getTime() - new Date(b.startTime).getTime())[0] || null
})

const upcomingBookings = computed(() => {
  const now = new Date()
  return bookings.value
    .filter(b => new Date(b.startTime) > now && b.status === 'confirmed')
    .sort((a, b) => new Date(a.startTime).getTime() - new Date(b.startTime).getTime())
})

/** Upcoming bookings excluding the hero card (next one) */
const otherUpcoming = computed(() => upcomingBookings.value.slice(1, 4))

const bookingsOnSelectedDate = computed(() => {
  const key = `${selectedDate.value.year}-${String(selectedDate.value.month).padStart(2, '0')}-${String(selectedDate.value.day).padStart(2, '0')}`
  return bookings.value.filter(b => {
    try {
      const d = new Date(b.startTime)
      const bKey = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
      return bKey === key
    } catch { return false }
  }).sort((a, b) => new Date(a.startTime).getTime() - new Date(b.startTime).getTime())
})

const timeUntilNext = computed(() => {
  if (!nextBooking.value) return null
  const now = new Date()
  const next = new Date(nextBooking.value.startTime)
  const diff = next.getTime() - now.getTime()
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))
  const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
  if (days > 0) return t('profile.inDaysHours', { days, hours })
  if (hours > 0) return t('profile.inHours', { hours })
  const mins = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
  return t('profile.inMinutes', { mins })
})

function formatDate(iso: string) {
  try {
    return new Date(iso).toLocaleDateString(locale.value, {
      weekday: 'short', month: 'short', day: 'numeric'
    })
  } catch { return '' }
}

function formatTime(iso: string) {
  try {
    return new Date(iso).toLocaleTimeString(locale.value, {
      hour: '2-digit', minute: '2-digit', hour12: false
    })
  } catch { return '' }
}

function formatPrice(price: number, currency: string) {
  try {
    return new Intl.NumberFormat(locale.value, { style: 'currency', currency: currency || 'NOK' }).format(price || 0)
  } catch { return '' }
}

// --- Cancel Modal State ---
const cancelModalOpen = ref(false)
const bookingToCancel = ref<string | null>(null)

function openCancelModal(bookingId: string) {
  bookingToCancel.value = bookingId
  cancelModalOpen.value = true
}

async function confirmCancel() {
  if (!bookingToCancel.value) return
  const success = await cancelBooking(bookingToCancel.value)
  cancelModalOpen.value = false
  bookingToCancel.value = null
  if (success) {
    toast.add({ title: t('booking.cancelled'), color: 'success', icon: 'i-lucide-check' })
  } else {
    toast.add({ title: t('booking.cancelFailed'), color: 'error', icon: 'i-lucide-alert-triangle' })
  }
}
</script>

<template>
  <div class="space-y-6">
    <!-- Greeting -->
    <div>
      <h2 class="text-xl font-semibold text-gray-900 dark:text-white">
        {{ t('profile.greeting', { name: userProfile?.name ? `, ${userProfile.name.split(' ')[0]}` : '' }) }}
      </h2>
      <p v-if="nextBooking" class="mt-0.5 text-sm text-gray-500 dark:text-gray-400">
        {{ t('profile.nextAppointment', { time: timeUntilNext }) }}
      </p>
      <p v-else class="mt-0.5 text-sm text-gray-500 dark:text-gray-400">
        {{ t('profile.noUpcoming') }}
      </p>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="space-y-4">
      <USkeleton class="h-36 w-full rounded-xl" />
      <USkeleton class="h-64 w-full rounded-xl" />
    </div>

    <template v-else>
      <!-- Next Booking Hero Card -->
      <UCard v-if="nextBooking" class="border-l-4 border-l-green-500 dark:border-l-green-400">
        <div class="flex flex-col sm:flex-row sm:items-center gap-4">
          <div class="flex-1 space-y-2">
            <div class="flex items-center gap-2">
              <UBadge color="success" variant="subtle" size="xs">{{ t('profile.nextUp') }}</UBadge>
            </div>
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
              {{ nextBooking.serviceTitle }}
            </h3>
            <div class="space-y-1 text-sm text-gray-600 dark:text-gray-400">
              <div class="flex items-center gap-2">
                <UIcon name="i-lucide-calendar-days" class="size-4 text-gray-400 dark:text-gray-500" />
                <span>{{ formatDate(nextBooking.startTime) }}</span>
              </div>
              <div class="flex items-center gap-2">
                <UIcon name="i-lucide-clock" class="size-4 text-gray-400 dark:text-gray-500" />
                <span>{{ formatTime(nextBooking.startTime) }} - {{ formatTime(nextBooking.endTime) }}</span>
              </div>
              <div class="flex items-center gap-2">
                <UIcon name="i-lucide-tag" class="size-4 text-gray-400 dark:text-gray-500" />
                <span>{{ formatPrice(nextBooking.priceAtTimeOfBooking, nextBooking.currency) }}</span>
              </div>
            </div>
          </div>

          <!-- Hero Actions -->
          <div class="flex sm:flex-col gap-2 shrink-0">
            <UButton
              size="sm"
              color="error"
              variant="soft"
              icon="i-lucide-x"
              :label="t('profile.cancel')"
              @click="openCancelModal(nextBooking.id)"
            />
          </div>
        </div>
      </UCard>

      <!-- No bookings at all -->
      <UCard v-else>
        <div class="text-center py-6">
          <UIcon name="i-lucide-calendar-plus" class="w-10 h-10 text-gray-300 dark:text-gray-600 mx-auto mb-3" />
          <p class="text-gray-500 dark:text-gray-400 text-sm">{{ t('profile.noUpcomingBookings') }}</p>
          <UButton
            to="/"
            variant="soft"
            size="sm"
            class="mt-3"
            icon="i-lucide-search"
            :label="t('profile.findServices')"
          />
        </div>
      </UCard>

      <!-- Other Upcoming -->
      <div v-if="otherUpcoming.length > 0">
        <div class="flex items-center justify-between mb-3">
          <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wide">
            {{ t('profile.upcoming', { count: upcomingBookings.length - 1 }) }}
          </h3>
          <UButton
            variant="ghost"
            size="xs"
            to="/profile/bookings"
            trailing-icon="i-lucide-arrow-right"
            :label="t('profile.viewAll')"
          />
        </div>
        <div class="space-y-2">
          <NuxtLink
            v-for="booking in otherUpcoming"
            :key="booking.id"
            to="/profile/bookings"
            class="flex items-center justify-between px-3 py-2.5 rounded-lg bg-gray-50 dark:bg-gray-900 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
          >
            <div class="flex items-center gap-3 min-w-0">
              <UIcon name="i-lucide-calendar" class="size-4 text-gray-400 dark:text-gray-500 shrink-0" />
              <span class="text-sm font-medium text-gray-900 dark:text-white truncate">{{ booking.serviceTitle }}</span>
            </div>
            <span class="text-xs text-gray-500 dark:text-gray-400 shrink-0 ml-2">
              {{ formatDate(booking.startTime) }} · {{ formatTime(booking.startTime) }}
            </span>
          </NuxtLink>
        </div>
      </div>

      <!-- Calendar -->
      <div>
        <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wide mb-3">
          {{ t('profile.calendar') }}
        </h3>
        <UCard>
          <div class="flex justify-center">
            <UCalendar
              v-model="selectedDate"
              size="md"
              color="primary"
            >
              <template #day="{ day }">
                <UChip
                  :show="hasBookingOn(day)"
                  :color="getChipColor(day)"
                  size="2xs"
                >
                  {{ day.day }}
                </UChip>
              </template>
            </UCalendar>
          </div>

          <!-- Bookings on selected date -->
          <div v-if="bookingsOnSelectedDate.length > 0" class="mt-4 pt-4 border-t border-gray-200 dark:border-gray-800">
            <p class="text-xs font-medium text-gray-500 dark:text-gray-400 mb-2">
              {{ t('profile.bookingsOnDay', { count: bookingsOnSelectedDate.length }, bookingsOnSelectedDate.length) }}
            </p>
            <div class="space-y-2">
              <div
                v-for="b in bookingsOnSelectedDate"
                :key="b.id"
                class="flex items-center justify-between px-3 py-2 rounded-lg bg-gray-50 dark:bg-gray-900"
              >
                <div class="flex items-center gap-2 min-w-0">
                  <UIcon name="i-lucide-clock" class="size-3.5 text-gray-400 shrink-0" />
                  <span class="text-sm font-medium text-gray-900 dark:text-white truncate">{{ b.serviceTitle }}</span>
                </div>
                <span class="text-xs text-gray-500 dark:text-gray-400 shrink-0 ml-2">
                  {{ formatTime(b.startTime) }}
                </span>
              </div>
            </div>
          </div>
        </UCard>
      </div>

      <!-- Past Bookings Link -->
      <NuxtLink
        to="/profile/bookings"
        class="flex items-center justify-between px-4 py-3 rounded-lg bg-gray-50 dark:bg-gray-900 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors group"
      >
        <div class="flex items-center gap-3">
          <UIcon name="i-lucide-history" class="size-4 text-gray-400" />
          <span class="text-sm text-gray-600 dark:text-gray-400">{{ t('profile.allBookingsHistory') }}</span>
        </div>
        <UIcon name="i-lucide-arrow-right" class="size-4 text-gray-400 group-hover:translate-x-0.5 transition-transform" />
      </NuxtLink>
    </template>

    <!-- Cancel Confirmation Modal
         TODO: Firestore rules currently deny client-side writes to bookings.
         Error: PERMISSION_DENIED: No matching allow statements.
         Fix: Update firestore.rules to allow users to update their own bookings (status → 'cancelled').
         Alternatively, route cancellation through a Cloud Function for business policy enforcement.
         Tracked for a future session. -->
    <UModal
      v-model:open="cancelModalOpen"
      :title="t('profile.cancelBooking')"
      :description="t('profile.cancelConfirmDesc')"
      :ui="{ footer: 'justify-end' }"
    >
      <template #body>
        <div class="flex items-center gap-3 p-2 rounded-lg bg-red-50 dark:bg-red-950/30">
          <UIcon name="i-lucide-alert-triangle" class="size-5 text-red-500 shrink-0" />
          <p class="text-sm text-red-700 dark:text-red-400">
            {{ t('profile.cancelWarning') }}
          </p>
        </div>
      </template>
      <template #footer="{ close }">
        <UButton
          :label="t('profile.keepIt')"
          color="neutral"
          variant="outline"
          @click="close"
        />
        <UButton
          :label="t('profile.yesCancel')"
          color="error"
          :loading="cancelling"
          @click="confirmCancel"
        />
      </template>
    </UModal>
  </div>
</template>
