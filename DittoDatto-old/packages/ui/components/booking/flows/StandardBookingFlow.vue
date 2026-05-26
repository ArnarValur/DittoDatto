<script setup lang="ts">
/**
 * StandardBookingFlow
 * Date-first booking flow for 1:1 appointments.
 * Flow: [Staff →] Date → Time → Confirm
 *
 * Refactored: Steps extracted to atomic components.
 * Client-side slot fallback REMOVED — server is sole authority.
 */

import type { ServiceItem, StaffMember, OpeningSchedule } from '../booking.types'
import { formatDuration, formatPriceCurrency, formatFullDate } from '../booking.utils'

import StepProgressIndicator from '../steps/StepProgressIndicator.vue'
import StepDateSelect from '../steps/StepDateSelect.vue'
import StepTimeSelect from '../steps/StepTimeSelect.vue'
import StepStaffSelect from '../steps/StepStaffSelect.vue'
import StepConfirmSummary from '../steps/StepConfirmSummary.vue'

interface Props {
  service: ServiceItem
  /** Additional services selected via multi-select (excluding primary) */
  additionalServices?: ServiceItem[]
  storeName: string
  storeAddress?: string
  storeLogo?: string
  openingSchedule?: OpeningSchedule
  availableSlots?: string[]
  slotsLoading?: boolean
  slotsError?: string | null
  holdExpiresAt?: Date | null
  /** Whether a booking confirmation is in progress */
  confirming?: boolean
  /** Store's available staff */
  staff?: StaffMember[]
  /** Preselected staff from storefront (if any) */
  preselectedStaff?: StaffMember | null
}

const props = withDefaults(defineProps<Props>(), {
  additionalServices: () => [],
  availableSlots: () => [],
  slotsLoading: false,
  slotsError: null,
  holdExpiresAt: null,
  confirming: false,
  staff: () => [],
  preselectedStaff: null,
})

const emit = defineEmits<{
  (e: 'back'): void
  (e: 'confirm', data: { date: Date; time: string }): void
  (e: 'date-change', date: Date): void
  (e: 'hold-expired'): void
  (e: 'retry-slots'): void
  (e: 'staff-selected', staff: StaffMember | null): void
}>()

// ── All services aggregation ──────────────────────────────────

const allServices = computed(() => [props.service, ...props.additionalServices])
const totalPrice = computed(() => allServices.value.reduce((sum, s) => sum + (s.price ?? 0), 0))
const totalDuration = computed(() => allServices.value.reduce((sum, s) => sum + (s.duration ?? 0), 0))

// ── Hold Expiration Countdown ─────────────────────────────────

const countdown = ref('')
const holdExpired = ref(false)
let timer: NodeJS.Timeout | null = null

watch(
  () => props.holdExpiresAt,
  (expires) => {
    if (timer) {
      clearInterval(timer)
      timer = null
    }

    if (expires) {
      timer = setInterval(() => {
        const remaining = Math.max(0, expires.getTime() - Date.now())

        if (remaining <= 0) {
          countdown.value = '00:00'
          if (timer) clearInterval(timer)
          selectedTime.value = undefined
          currentStep.value = 'time'
          holdExpired.value = true
          emit('hold-expired')
          return
        }

        const minutes = Math.floor(remaining / 60000)
        const seconds = Math.floor((remaining % 60000) / 1000)
        countdown.value = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
      }, 1000)
    } else {
      countdown.value = ''
    }
  }
)

onUnmounted(() => {
  if (timer) clearInterval(timer)
})

// ── Flow steps ────────────────────────────────────────────────

type Step = 'staff' | 'date' | 'time' | 'confirm'

const steps = computed(() => {
  if (props.staff.length > 1 && !props.preselectedStaff) {
    return ['staff', 'date', 'time', 'confirm'] as const
  }
  return ['date', 'time', 'confirm'] as const
})

const currentStep = ref<Step>(steps.value[0])
const selectedDate = ref(new Date())
const selectedTime = ref<string>()

// Internal staff tracking if picked during flow
const localSelectedStaff = ref<StaffMember | null>(props.preselectedStaff || null)

// Keep currentStep synced to the first step if the service changes
watch(
  () => props.service.id,
  () => {
    currentStep.value = steps.value[0]
    selectedTime.value = undefined
    localSelectedStaff.value = props.preselectedStaff || null
  }
)

// Server-authoritative slots — NO client-side fallback
const timeSlots = computed(() => {
  let slots = props.availableSlots

  // Filter out past times if selected date is today
  const now = new Date()
  if (
    selectedDate.value.getDate() === now.getDate() &&
    selectedDate.value.getMonth() === now.getMonth() &&
    selectedDate.value.getFullYear() === now.getFullYear()
  ) {
    const currentMinutes = now.getHours() * 60 + now.getMinutes()
    slots = slots.filter((slot) => {
      const [h = 0, m = 0] = slot.split(':').map(Number)
      return h * 60 + m > currentMinutes
    })
  }

  return slots
})

// ── Progress ──────────────────────────────────────────────────

const currentStepIndex = computed(() => steps.value.indexOf(currentStep.value))

const stepTitle = computed(() => {
  switch (currentStep.value) {
    case 'staff':
      return 'Select Staff'
    case 'date':
      return 'Select Date'
    case 'time':
      return 'Select Time'
    case 'confirm':
      return 'Confirm Booking'
    default:
      return ''
  }
})

// ── Confirm summary rows ──────────────────────────────────────

const confirmRows = computed(() => {
  const rows = []

  // Service(s)
  if (allServices.value.length === 1) {
    rows.push({
      icon: 'i-lucide-calendar-check',
      label: 'Service',
      value: props.service.title,
    })
  } else {
    rows.push({
      icon: 'i-lucide-calendar-check',
      label: 'Services',
      value: '',
      secondaryValues: allServices.value.map((s) => s.title),
    })
  }

  // Staff (if applicable)
  if (localSelectedStaff.value) {
    rows.push({
      icon: 'i-lucide-user',
      label: 'Staff',
      value: localSelectedStaff.value.displayName,
    })
  }

  // Date
  rows.push({
    icon: 'i-lucide-calendar',
    label: 'Date',
    value: formatFullDate(selectedDate.value),
  })

  // Time
  rows.push({
    icon: 'i-lucide-clock',
    label: 'Time',
    value: selectedTime.value || '',
  })

  return rows
})

// ── Navigation ────────────────────────────────────────────────

function handleBack() {
  switch (currentStep.value) {
    case 'staff':
      emit('back')
      break
    case 'date':
      if (steps.value[0] === 'staff') {
        currentStep.value = 'staff'
      } else {
        emit('back')
      }
      break
    case 'time':
      currentStep.value = 'date'
      break
    case 'confirm':
      currentStep.value = 'time'
      break
  }
}

function handleStaffSelected(staff: StaffMember | null) {
  localSelectedStaff.value = staff
  emit('staff-selected', staff)
  currentStep.value = 'date'
}

function handleNext() {
  holdExpired.value = false
  switch (currentStep.value) {
    case 'date':
      emit('date-change', selectedDate.value)
      selectedTime.value = undefined
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

    <!-- Service Summary Card -->
    <div class="p-4 rounded-xl bg-muted/20 border border-default">
      <!-- Single service -->
      <div v-if="allServices.length === 1" class="flex items-center gap-4">
        <div class="shrink-0 size-14 rounded-lg bg-muted overflow-hidden">
          <NuxtImg
            v-if="service.coverImage"
            :src="service.coverImage"
            :alt="service.title"
            class="w-full h-full object-cover"
            loading="lazy"
            sizes="56px"
          />
          <div v-else class="w-full h-full flex items-center justify-center">
            <UIcon name="i-lucide-calendar-check" class="size-6 text-muted" />
          </div>
        </div>
        <div>
          <p class="font-semibold">{{ service.title }}</p>
          <div class="flex items-center gap-3 text-sm text-muted">
            <span v-if="service.duration">{{ formatDuration(service.duration) }}</span>
            <span v-if="service.price" class="text-primary font-medium">{{
              formatPriceCurrency(service.price, service.currency)
            }}</span>
          </div>
        </div>
      </div>
      <!-- Multiple services -->
      <div v-else class="space-y-2">
        <div v-for="s in allServices" :key="s.id" class="flex items-center gap-3">
          <div class="shrink-0 size-10 rounded-lg bg-muted overflow-hidden">
            <NuxtImg
              v-if="s.coverImage"
              :src="s.coverImage"
              :alt="s.title"
              class="w-full h-full object-cover"
              loading="lazy"
              sizes="40px"
            />
            <div v-else class="w-full h-full flex items-center justify-center">
              <UIcon name="i-lucide-calendar-check" class="size-4 text-muted" />
            </div>
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium">{{ s.title }}</p>
          </div>
          <span class="text-xs text-muted">{{ formatDuration(s.duration) }}</span>
        </div>
        <div class="pt-2 border-t border-default flex justify-between text-sm">
          <span class="text-muted">{{ allServices.length }} services · {{ formatDuration(totalDuration) }}</span>
          <span class="text-primary font-medium">{{ formatPriceCurrency(totalPrice, service.currency) }}</span>
        </div>
      </div>
    </div>

    <!-- STEP: Staff Selection -->
    <StepStaffSelect
      v-if="currentStep === 'staff'"
      :staff="staff"
      :model-value="localSelectedStaff"
      @update:model-value="handleStaffSelected"
    />

    <!-- STEP: Date Selection -->
    <div v-else-if="currentStep === 'date'" class="space-y-6">
      <StepDateSelect
        v-model="selectedDate"
        :opening-schedule="openingSchedule"
      />

      <UButton
        label="Continue"
        color="primary"
        size="lg"
        block
        trailing-icon="i-lucide-arrow-right"
        :disabled="!!openingSchedule && false"
        @click="handleNext"
      />
    </div>

    <!-- STEP: Time Selection -->
    <div v-else-if="currentStep === 'time'" class="space-y-6">
      <div class="text-center">
        <p class="text-muted">{{ formatFullDate(selectedDate) }}</p>
      </div>

      <StepTimeSelect
        :slots="timeSlots"
        :model-value="selectedTime"
        :loading="slotsLoading"
        :error="slotsError"
        :hold-expired="holdExpired"
        @update:model-value="selectedTime = $event"
        @retry="emit('date-change', selectedDate)"
      />

      <UButton
        label="Continue"
        color="primary"
        size="lg"
        block
        trailing-icon="i-lucide-arrow-right"
        :disabled="!selectedTime"
        @click="handleNext"
      />
    </div>

    <!-- STEP: Confirmation -->
    <div v-else-if="currentStep === 'confirm'" class="space-y-6">
      <StepConfirmSummary
        :store-name="storeName"
        :store-address="storeAddress"
        :store-logo="storeLogo"
        :rows="confirmRows"
      />

      <!-- Hold countdown warning -->
      <div v-if="countdown && countdown !== '00:00'" class="flex items-center justify-center gap-2 text-sm">
        <UIcon name="i-lucide-clock" class="size-4 text-amber-500" />
        <span class="text-muted">Hold expires in</span>
        <span
          class="font-mono font-semibold"
          :class="parseInt(countdown) < 2 ? 'text-red-400' : 'text-amber-500'"
        >{{ countdown }}</span>
      </div>

      <UButton
        label="Confirm Booking"
        color="primary"
        size="lg"
        block
        icon="i-lucide-check"
        :loading="confirming"
        :disabled="confirming"
        @click="handleConfirm"
      />
    </div>
  </div>
</template>
