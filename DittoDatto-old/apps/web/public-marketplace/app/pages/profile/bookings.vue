
<script setup lang="ts">
/**
 * /profile/bookings.vue
 * Page for users to view their upcoming and past bookings.
 * Includes a date-range picker to filter past bookings.
 */
import { CalendarDate, today, getLocalTimeZone, DateFormatter } from '@internationalized/date'
import BookingCard from '~/components/booking/BookingCard.vue';
import ProfileCancelModal from '~/components/profile/ProfileCancelModal.vue';
import { useUserBookings } from '~/composables/useUserBookings';

definePageMeta({
  // Auth is inherited from parent profile.vue
});

const { t, locale } = useI18n();

const {
  upcomingBookings,
  pastBookings,
  loading,
  error,
  cancelling,
  fetchBookings,
  cancelBooking,
  getCancelStatus,
} = useUserBookings();

const toast = useToast();

// Fetch bookings when the component is mounted
onMounted(() => {
  fetchBookings();
});

// --- Date Range Filter ---
const df = computed(() => new DateFormatter(locale.value, { dateStyle: 'medium' }))

const dateRange = shallowRef<{ start: Date | null, end: Date | null }>({
  start: null,
  end: null
})

const presets = computed(() => [
  { label: t('profile.bookings.presets.last7'), days: 7 },
  { label: t('profile.bookings.presets.last30'), days: 30 },
  { label: t('profile.bookings.presets.last3months'), months: 3 },
  { label: t('profile.bookings.presets.last6months'), months: 6 },
  { label: t('profile.bookings.presets.lastYear'), years: 1 },
  { label: t('profile.bookings.presets.allTime'), clear: true }
])

const toCalendarDate = (date: Date) =>
  new CalendarDate(date.getFullYear(), date.getMonth() + 1, date.getDate())

const calendarRange = computed({
  get: () => ({
    start: dateRange.value.start ? toCalendarDate(dateRange.value.start) : undefined,
    end: dateRange.value.end ? toCalendarDate(dateRange.value.end) : undefined
  }),
  set: (val: { start: CalendarDate | null, end: CalendarDate | null }) => {
    dateRange.value = {
      start: val.start ? val.start.toDate(getLocalTimeZone()) : null,
      end: val.end ? val.end.toDate(getLocalTimeZone()) : null
    }
  }
})

function selectPreset(preset: typeof presets.value[0]) {
  if ('clear' in preset && preset.clear) {
    dateRange.value = { start: null, end: null }
    return
  }
  const endDate = today(getLocalTimeZone())
  let startDate = endDate.copy()
  if ('days' in preset && preset.days) startDate = startDate.subtract({ days: preset.days })
  else if ('months' in preset && preset.months) startDate = startDate.subtract({ months: preset.months })
  else if ('years' in preset && preset.years) startDate = startDate.subtract({ years: preset.years })

  dateRange.value = {
    start: startDate.toDate(getLocalTimeZone()),
    end: endDate.toDate(getLocalTimeZone())
  }
}

function isPresetSelected(preset: typeof presets.value[0]) {
  if ('clear' in preset && preset.clear) return !dateRange.value.start && !dateRange.value.end
  if (!dateRange.value.start || !dateRange.value.end) return false

  const currentDate = today(getLocalTimeZone())
  let startDate = currentDate.copy()
  if ('days' in preset && preset.days) startDate = startDate.subtract({ days: preset.days })
  else if ('months' in preset && preset.months) startDate = startDate.subtract({ months: preset.months })
  else if ('years' in preset && preset.years) startDate = startDate.subtract({ years: preset.years })

  const selectedStart = toCalendarDate(dateRange.value.start)
  const selectedEnd = toCalendarDate(dateRange.value.end)
  return selectedStart.compare(startDate) === 0 && selectedEnd.compare(currentDate) === 0
}

const hasDateFilter = computed(() => dateRange.value.start !== null || dateRange.value.end !== null)

/** Past bookings filtered by date range */
const filteredPastBookings = computed(() => {
  if (!hasDateFilter.value) return pastBookings.value

  const start = dateRange.value.start
  const end = dateRange.value.end

  return pastBookings.value.filter(b => {
    const bDate = new Date(b.startTime)
    if (start && bDate < start) return false
    if (end) {
      const endOfDay = new Date(end)
      endOfDay.setHours(23, 59, 59, 999)
      if (bDate > endOfDay) return false
    }
    return true
  })
})

// --- Cancel Modal State ---
const cancelModalOpen = ref(false);
const bookingToCancel = ref<string | null>(null);

function openCancelModal(bookingId: string) {
  bookingToCancel.value = bookingId;
  cancelModalOpen.value = true;
}

// Compute cancel status for the booking being cancelled
const cancelStatus = computed(() => {
  if (!bookingToCancel.value) return { canCancel: true };
  const booking = upcomingBookings.value.find(b => b.id === bookingToCancel.value);
  if (!booking) return { canCancel: true };
  return getCancelStatus(booking);
});

async function confirmCancel() {
  if (!bookingToCancel.value) return;
  const success = await cancelBooking(bookingToCancel.value);
  cancelModalOpen.value = false;
  bookingToCancel.value = null;
  if (success) {
    toast.add({ title: t('booking.cancelled'), color: 'success', icon: 'i-lucide-check' });
  } else {
    toast.add({ title: t('booking.cancelFailed'), color: 'error', icon: 'i-lucide-alert-triangle' });
  }
}

function handleReview(bookingId: string) {
  console.log("MVP Scope: Review action triggered for", bookingId);
}

</script>

<template>
  <div>
    <h1 class="text-3xl font-bold mb-6">{{ t('profile.bookings.title') }}</h1>

    <!-- Loading State -->
    <div v-if="loading" class="space-y-4">
      <USkeleton class="h-24 w-full" />
      <USkeleton class="h-24 w-full" />
      <USkeleton class="h-24 w-full" />
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-12">
        <UIcon name="i-lucide-alert-triangle" class="size-12 text-red-500 mx-auto mb-3" />
        <p class="text-lg font-medium">{{ t('profile.bookings.loadError') }}</p>
        <p class="text-muted">{{ error }}</p>
        <UButton
            :label="t('common.tryAgain')"
            @click="fetchBookings"
            variant="ghost"
            class="mt-4"
        />
    </div>

    <!-- Content -->
    <div v-else>
      <!-- Upcoming Bookings -->
      <section>
        <h2 class="text-xl font-semibold mb-4 border-b pb-2">
          {{ t('profile.bookings.upcomingCount', { count: upcomingBookings.length }) }}
        </h2>
        <div v-if="upcomingBookings.length > 0" class="space-y-4">
          <BookingCard
            v-for="booking in upcomingBookings"
            :key="booking.id"
            :booking="booking"
            :cancelling="cancelling"
            @cancel="openCancelModal"
          />
        </div>
        <div v-else class="text-center py-10 border border-dashed rounded-lg">
          <p class="text-muted">{{ t('profile.bookings.noUpcoming') }}</p>
          <UButton
            :label="t('profile.bookings.bookService')"
            to="/"
            variant="link"
            class="mt-2"
          />
        </div>
      </section>

      <!-- Past Bookings -->
      <section class="mt-12">
        <div class="flex items-center justify-between mb-4 border-b pb-2">
          <h2 class="text-xl font-semibold">
            <template v-if="hasDateFilter">
              {{ t('profile.bookings.pastCountFiltered', { filtered: filteredPastBookings.length, total: pastBookings.length }) }}
            </template>
            <template v-else>
              {{ t('profile.bookings.pastCount', { count: filteredPastBookings.length }) }}
            </template>
          </h2>

          <!-- Date Range Picker -->
          <UPopover :content="{ align: 'end' }" :modal="true">
            <UButton
              color="neutral"
              variant="ghost"
              icon="i-lucide-calendar"
              size="sm"
              class="data-[state=open]:bg-elevated"
            >
              <span class="truncate text-sm">
                <template v-if="dateRange.start">
                  {{ df.format(dateRange.start) }}
                  <template v-if="dateRange.end"> – {{ df.format(dateRange.end) }}</template>
                </template>
                <template v-else>
                  {{ t('profile.bookings.filterByDate') }}
                </template>
              </span>
              <template #trailing>
                <UIcon
                  name="i-lucide-chevron-down"
                  class="shrink-0 text-dimmed size-4"
                />
              </template>
            </UButton>

            <template #content>
              <div class="flex items-stretch sm:divide-x divide-default">
                <div class="hidden sm:flex flex-col justify-center py-1">
                  <UButton
                    v-for="(preset, index) in presets"
                    :key="index"
                    :label="preset.label"
                    color="neutral"
                    variant="ghost"
                    class="rounded-none px-4"
                    :class="[isPresetSelected(preset) ? 'bg-elevated' : 'hover:bg-elevated/50']"
                    truncate
                    @click="selectPreset(preset)"
                  />
                </div>

                <UCalendar
                  v-model="calendarRange"
                  class="p-2"
                  :number-of-months="2"
                  range
                />
              </div>
            </template>
          </UPopover>
        </div>

        <div v-if="filteredPastBookings.length > 0" class="space-y-4">
          <BookingCard
            v-for="booking in filteredPastBookings"
            :key="booking.id"
            :booking="booking"
            @review="handleReview"
          />
        </div>
        <div v-else class="text-center py-10 border border-dashed rounded-lg">
          <p v-if="hasDateFilter" class="text-muted">{{ t('profile.bookings.noResultsInRange') }}</p>
          <p v-else class="text-muted">{{ t('profile.bookings.noPast') }}</p>
          <UButton
            v-if="hasDateFilter"
            :label="t('profile.bookings.clearFilter')"
            variant="link"
            class="mt-2"
            @click="dateRange = { start: null, end: null }"
          />
        </div>
      </section>
    </div>

    <!-- Cancel Confirmation Modal -->
    <ProfileCancelModal
      v-model:open="cancelModalOpen"
      :cancelling="cancelling"
      :can-cancel="cancelStatus.canCancel"
      :cancel-block-reason="cancelStatus.reason"
      @confirm="confirmCancel"
    />
  </div>
</template>
