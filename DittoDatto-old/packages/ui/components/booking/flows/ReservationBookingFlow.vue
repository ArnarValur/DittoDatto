<script setup lang="ts">
/**
 * ReservationBookingFlow
 * Guest-first booking flow for table reservations.
 * Flow: Guest Count → Date → Time → Confirm
 *
 * Refactored: Steps extracted to atomic components.
 */

import type { ServiceItem, OpeningSchedule, ReservationConfig } from '../booking.types'
import { formatFullDate } from '../booking.utils'

import StepProgressIndicator from '../steps/StepProgressIndicator.vue'
import StepDateSelect from '../steps/StepDateSelect.vue'
import StepTimeSelect from '../steps/StepTimeSelect.vue'
import StepGuestCount from '../steps/StepGuestCount.vue'
import StepConfirmSummary from '../steps/StepConfirmSummary.vue'

interface Props {
  service: ServiceItem
  storeName: string
  storeAddress?: string
  storeLogo?: string
  openingSchedule?: OpeningSchedule
  reservationConfig?: Partial<ReservationConfig>
  availableSlots?: any[]
  slotsLoading?: boolean
  slotsError?: string | null
}

const props = withDefaults(defineProps<Props>(), {
  reservationConfig: () => ({
    maxGuestsPerReservation: 8,
    largePartyHandling: 'call' as const,
    slotInterval: 30,
  }),
  availableSlots: () => [],
  slotsLoading: false,
  slotsError: null,
})

const emit = defineEmits<{
  (e: 'back'): void
  (e: 'confirm', data: { guestCount: number; date: Date; time: string }): void
  (e: 'date-change', date: Date): void
}>()

// ── Flow state ────────────────────────────────────────────────

type Step = 'guests' | 'date' | 'time' | 'confirm'
const currentStep = ref<Step>('guests')
const guestCount = ref(2)
const selectedDate = ref(new Date())
const selectedTime = ref<string>()

// ── Config ────────────────────────────────────────────────────

const maxGuests = computed(() => props.reservationConfig?.maxGuestsPerReservation || 8)
const hasGuestLimit = computed(() => maxGuests.value < 500)
const showLargePartyMessage = computed(
  () => hasGuestLimit.value && guestCount.value > maxGuests.value
)

// ── Normalize server slots to string[] ────────────────────────

const timeSlots = computed(() =>
  (props.availableSlots || []).map((slot) => {
    if (typeof slot === 'object' && slot !== null && 'time' in slot) {
      return slot.time
    }
    return String(slot)
  })
)

// ── Progress ──────────────────────────────────────────────────

const steps = ['guests', 'date', 'time', 'confirm'] as const
const currentStepIndex = computed(() => steps.indexOf(currentStep.value))

const stepTitle = computed(() => {
  switch (currentStep.value) {
    case 'guests':
      return 'Party Size'
    case 'date':
      return 'Select Date'
    case 'time':
      return 'Select Time'
    case 'confirm':
      return 'Confirm'
    default:
      return ''
  }
})

// ── Confirm summary rows ──────────────────────────────────────

const confirmRows = computed(() => [
  {
    icon: 'i-lucide-concierge-bell',
    label: 'Service',
    value: props.service.title,
  },
  {
    icon: 'i-lucide-users',
    label: 'Party Size',
    value: `${guestCount.value} ${guestCount.value === 1 ? 'Guest' : 'Guests'}`,
  },
  {
    icon: 'i-lucide-calendar',
    label: 'Date',
    value: formatFullDate(selectedDate.value),
  },
  {
    icon: 'i-lucide-clock',
    label: 'Time',
    value: selectedTime.value || '',
  },
])

// ── Navigation ────────────────────────────────────────────────

function handleBack() {
  switch (currentStep.value) {
    case 'guests':
      emit('back')
      break
    case 'date':
      currentStep.value = 'guests'
      break
    case 'time':
      currentStep.value = 'date'
      break
    case 'confirm':
      currentStep.value = 'time'
      break
  }
}

function handleDateSelect(date: Date) {
  selectedDate.value = date
  emit('date-change', date)
}

function handleNext() {
  switch (currentStep.value) {
    case 'guests':
      if (!showLargePartyMessage.value) currentStep.value = 'date'
      break
    case 'date':
      currentStep.value = 'time'
      break
    case 'time':
      if (selectedTime.value) currentStep.value = 'confirm'
      break
  }
}

function handleConfirm() {
  if (!selectedTime.value) return
  emit('confirm', {
    guestCount: guestCount.value,
    date: selectedDate.value,
    time: selectedTime.value,
  })
}
</script>

<template>
  <div class="space-y-6">
    <!-- Header with back + title -->
    <div class="flex items-center gap-3">
      <UButton icon="i-lucide-arrow-left" color="neutral" variant="ghost" size="sm" @click="handleBack" />
      <span class="font-semibold text-lg">{{ stepTitle }}</span>
    </div>

    <!-- Progress Indicator -->
    <StepProgressIndicator :steps="steps" :current-index="currentStepIndex" />

    <!-- STEP: Guest Count -->
    <div v-if="currentStep === 'guests'" class="space-y-6">
      <StepGuestCount
        v-model="guestCount"
        :max-guests="maxGuests"
        :large-party-handling="reservationConfig?.largePartyHandling"
        :large-party-contact="reservationConfig?.largePartyContact"
      />

      <UButton
        v-if="!showLargePartyMessage"
        label="Continue"
        color="primary"
        size="lg"
        block
        trailing-icon="i-lucide-arrow-right"
        @click="handleNext"
      />
    </div>

    <!-- STEP: Date Selection -->
    <div v-else-if="currentStep === 'date'" class="space-y-6">
      <StepDateSelect
        :model-value="selectedDate"
        :opening-schedule="openingSchedule"
        @update:model-value="handleDateSelect"
      />

      <div class="p-4 rounded-xl bg-muted/20 border border-default text-center">
        <p class="text-sm text-muted">Selected Date</p>
        <p class="font-semibold text-lg">{{ formatFullDate(selectedDate) }}</p>
      </div>

      <UButton
        label="Continue"
        color="primary"
        size="lg"
        block
        trailing-icon="i-lucide-arrow-right"
        @click="handleNext"
      />
    </div>

    <!-- STEP: Time Selection -->
    <div v-else-if="currentStep === 'time'" class="space-y-6">
      <div class="text-center space-y-1">
        <p class="text-sm text-muted">{{ formatFullDate(selectedDate) }}</p>
        <p class="text-muted">{{ guestCount }} {{ guestCount === 1 ? 'guest' : 'guests' }}</p>
      </div>

      <StepTimeSelect
        :slots="timeSlots"
        :model-value="selectedTime"
        :loading="slotsLoading"
        :error="slotsError"
        @update:model-value="selectedTime = $event"
        @retry="emit('date-change', selectedDate)"
      />

      <UButton
        label="Continue"
        color="primary"
        size="lg"
        block
        trailing-icon="i-lucide-arrow-right"
        :disabled="!selectedTime || slotsLoading || timeSlots.length === 0"
        @click="handleNext"
      />
    </div>

    <!-- STEP: Confirmation -->
    <div v-else-if="currentStep === 'confirm'" class="space-y-6">
      <StepConfirmSummary
        :store-name="storeName"
        :store-address="storeAddress"
        :store-logo="storeLogo"
        store-icon="i-lucide-utensils"
        :rows="confirmRows"
      />

      <UButton
        label="Confirm Reservation"
        color="primary"
        size="lg"
        block
        icon="i-lucide-check"
        @click="handleConfirm"
      />
    </div>
  </div>
</template>
