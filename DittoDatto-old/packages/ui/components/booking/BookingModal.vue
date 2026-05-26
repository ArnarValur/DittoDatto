<script setup lang="ts">
/**
 * Booking Modal - Polished UI
 * 
 * Service-first booking flow with modern design.
 * Flow: Service selection → Date/Time/Guests → Confirm
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
  capacity?: number
}

interface OpeningDay {
  isOpen: boolean
  open: string
  close: string
}

interface OpeningSchedule {
  mon?: OpeningDay
  tue?: OpeningDay
  wed?: OpeningDay
  thu?: OpeningDay
  fri?: OpeningDay
  sat?: OpeningDay
  sun?: OpeningDay
}

interface Props {
  open: boolean
  storeName: string
  storeAddress: string
  storeLogo?: string
  services: ServiceItem[]
  openingSchedule?: OpeningSchedule
}

const props = defineProps<Props>()
const emit = defineEmits<{
  (e: 'update:open', value: boolean): void
  (e: 'confirm', booking: {
    service: ServiceItem
    date: Date
    time: string
    guestCount: number
  }): void
}>()

// State
const selectedService = ref<ServiceItem | null>(null)
const selectedDate = ref(new Date())
const selectedTime = ref('')
const guestCount = ref(1)

// Views: 'services' | 'details'
const view = ref<'services' | 'details'>('services')

// Base date for the date scroller (can be changed via calendar picker)
const baseDate = ref(new Date())

// Generate dates for the week scroller (starting from baseDate)
const weekDates = computed(() => {
  const dates = []
  const start = new Date(baseDate.value)
  for (let i = 0; i < 7; i++) {
    const date = new Date(start)
    date.setDate(start.getDate() + i)
    dates.push(date)
  }
  return dates
})

// Generate time slots from service availability
const timeSlots = computed(() => {
  if (!selectedService.value) return []
  
  const start = selectedService.value.availabilityStart || '09:00'
  const end = selectedService.value.availabilityEnd || '17:00'
  const duration = selectedService.value.duration || 60
  
  const slots: string[] = []
  const [startHour, startMin] = start.split(':').map(Number)
  const [endHour, endMin] = end.split(':').map(Number)
  
  let currentMinutes = startHour * 60 + startMin
  const endMinutes = endHour * 60 + endMin
  
  while (currentMinutes + duration <= endMinutes) {
    const h = Math.floor(currentMinutes / 60)
    const m = currentMinutes % 60
    slots.push(`${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}`)
    currentMinutes += 30
  }
  
  return slots
})

// Max guests based on service capacity
const maxGuests = computed(() => selectedService.value?.capacity || 10)

// Format helpers
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
  return new Intl.NumberFormat('nb-NO', {
    style: 'decimal',
    minimumFractionDigits: 2
  }).format(price) + ' ' + (currency || 'kr')
}

function formatDateShort(date: Date): string {
  return date.toLocaleDateString('en-US', { weekday: 'short' })
}

function formatDateNum(date: Date): number {
  return date.getDate()
}

function isToday(date: Date): boolean {
  const today = new Date()
  return date.toDateString() === today.toDateString()
}

function isSameDay(a: Date, b: Date): boolean {
  return a.toDateString() === b.toDateString()
}

// Check if a day is closed based on openingSchedule
function isDayClosed(date: Date): boolean {
  if (!props.openingSchedule) return false
  const dayMap = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'] as const
  const dayKey = dayMap[date.getDay()]
  const daySchedule = props.openingSchedule[dayKey]
  return !daySchedule?.isOpen
}

// Actions
function selectService(service: ServiceItem) {
  selectedService.value = service
  view.value = 'details'
  // Reset selections
  selectedTime.value = ''
  guestCount.value = 1
}

function goBack() {
  if (view.value === 'details') {
    view.value = 'services'
    selectedService.value = null
  } else {
    handleClose()
  }
}

function handleConfirm() {
  if (!selectedService.value || !selectedTime.value) return
  
  emit('confirm', {
    service: selectedService.value,
    date: selectedDate.value,
    time: selectedTime.value,
    guestCount: guestCount.value
  })
  handleClose()
}

function handleClose() {
  emit('update:open', false)
  setTimeout(() => {
    view.value = 'services'
    selectedService.value = null
    selectedTime.value = ''
    guestCount.value = 1
  }, 300)
}

const canConfirm = computed(() => selectedService.value && selectedTime.value)

// Calendar picker state
const showCalendar = ref(false)

function handleCalendarChange(newDate: Date) {
  baseDate.value = newDate
  selectedDate.value = newDate
  showCalendar.value = false
}

// Date scroll container ref
const dateScrollRef = ref<HTMLElement | null>(null)
</script>

<template>
  <USlideover
    :open="open"
    side="right"
    :dismissible="false"
    @update:open="handleClose"
  >
    <template #header>
      <div class="flex items-center justify-between w-full">
        <span class="font-semibold text-lg">
          {{ view === 'services' ? 'Menu / Services' : 'Service Details' }}
        </span>
        <UButton
          icon="i-lucide-x"
          color="neutral"
          variant="ghost"
          size="sm"
          @click="handleClose"
        />
      </div>
    </template>

    <template #body>
      <!-- Services List View -->
      <div v-if="view === 'services'" class="p-4 space-y-3">
        <div
          v-for="service in services"
          :key="service.id"
          class="flex items-center gap-4 p-4 rounded-xl bg-muted/30 border border-default hover:border-primary/50 cursor-pointer transition-all group"
          role="button"
          tabindex="0"
          @click="selectService(service)"
          @keydown.enter="selectService(service)"
        >
          <!-- Service Image -->
          <div class="shrink-0 size-16 rounded-lg bg-muted overflow-hidden">
            <img
              v-if="service.coverImage"
              :src="service.coverImage"
              :alt="service.title"
              class="w-full h-full object-cover"
            >
            <div v-else class="w-full h-full flex items-center justify-center">
              <UIcon name="i-lucide-calendar-check" class="size-6 text-muted" />
            </div>
          </div>

          <!-- Service Info -->
          <div class="flex-1 min-w-0">
            <h3 class="font-semibold group-hover:text-primary transition-colors">
              {{ service.title }}
            </h3>
            <p v-if="service.description" class="text-sm text-muted line-clamp-2">
              {{ service.description }}
            </p>
            <div class="flex items-center gap-3 mt-1.5 text-sm">
              <span v-if="service.duration" class="flex items-center gap-1 text-muted">
                <UIcon name="i-lucide-clock" class="size-3.5" />
                {{ formatDuration(service.duration) }}
              </span>
              <span
                v-if="service.price !== undefined"
                class="font-medium"
                :class="service.price === 0 ? 'text-green-500' : 'text-primary'"
              >
                {{ service.price === 0 ? 'Free' : formatPrice(service.price, service.currency) }}
              </span>
            </div>
          </div>

          <!-- Chevron -->
          <UIcon name="i-lucide-chevron-right" class="size-5 text-muted group-hover:text-primary transition-colors" />
        </div>

        <div v-if="services.length === 0" class="text-center py-12 text-muted">
          <UIcon name="i-lucide-calendar-x" class="size-12 mx-auto mb-3 opacity-50" />
          <p>No services available</p>
        </div>
      </div>

      <!-- Service Details View -->
      <div v-else class="flex flex-col h-full">
        <!-- Service Header -->
        <div class="p-4 border-b border-default">
          <div class="flex items-start gap-4">
            <div class="shrink-0 size-16 rounded-xl bg-muted overflow-hidden">
              <img
                v-if="selectedService?.coverImage"
                :src="selectedService.coverImage"
                :alt="selectedService?.title"
                class="w-full h-full object-cover"
              >
              <div v-else class="w-full h-full flex items-center justify-center">
                <UIcon name="i-lucide-calendar-check" class="size-8 text-muted" />
              </div>
            </div>
            <div class="flex-1 min-w-0">
              <h2 class="text-xl font-bold">{{ selectedService?.title }}</h2>
              <p v-if="selectedService?.description" class="text-sm text-muted line-clamp-2 mt-1">
                {{ selectedService.description }}
              </p>
            </div>
          </div>

          <!-- Price & Duration Row -->
          <div class="flex items-center justify-between mt-4 pt-3 border-t border-default">
            <span class="text-lg font-bold">
              {{ selectedService?.price === 0 ? '0,00 kr' : formatPrice(selectedService?.price, selectedService?.currency) }}
            </span>
            <span class="text-sm text-muted">
              {{ selectedService?.availabilityStart || '09:00' }} - {{ selectedService?.availabilityEnd || '17:00' }}
            </span>
          </div>
        </div>

        <!-- Date & Time Selection -->
        <div class="flex-1 p-4 space-y-6 overflow-y-auto">
          <!-- Date Selector -->
          <div>
            <div class="flex items-center justify-between mb-3">
              <h3 class="text-sm font-semibold">Select Date & Time</h3>
              <!-- Calendar Picker Button -->
              <UPopover v-model:open="showCalendar">
                <UButton
                  icon="i-lucide-calendar"
                  color="neutral"
                  variant="ghost"
                  size="xs"
                  label="Pick date"
                />
                <template #content>
                  <div class="p-2">
                    <input
                      type="date"
                      class="bg-default border border-default rounded-lg px-3 py-2 text-sm"
                      :value="selectedDate.toISOString().split('T')[0]"
                      @change="(e) => handleCalendarChange(new Date((e.target as any).value))"
                    >
                  </div>
                </template>
              </UPopover>
            </div>
            
            <!-- Date Scroller -->
            <div
              ref="dateScrollRef"
              class="flex gap-2 overflow-x-auto pb-2 scrollbar-hide"
            >
              <button
                v-for="date in weekDates"
                :key="date.toISOString()"
                class="shrink-0 flex flex-col items-center px-4 py-2 rounded-xl transition-all"
                :class="[
                  isDayClosed(date)
                    ? 'bg-muted/30 text-muted cursor-not-allowed opacity-50'
                    : isSameDay(date, selectedDate)
                      ? 'bg-primary text-primary-foreground'
                      : 'bg-muted/50 hover:bg-muted text-default'
                ]"
                :disabled="isDayClosed(date)"
                @click="!isDayClosed(date) && (selectedDate = date)"
              >
                <span class="text-xs uppercase font-medium">{{ formatDateShort(date) }}</span>
                <span class="text-lg font-bold">{{ formatDateNum(date) }}</span>
                <span v-if="isToday(date)" class="w-1.5 h-1.5 rounded-full bg-current opacity-70 mt-0.5" />
                <span v-if="isDayClosed(date)" class="text-[10px] text-muted">Closed</span>
              </button>
            </div>
          </div>

          <!-- Time Slots -->
          <div>
            <h4 class="text-sm font-medium text-muted mb-3">Available Times</h4>
            <div class="flex flex-wrap gap-2">
              <button
                v-for="time in timeSlots"
                :key="time"
                class="px-4 py-2 rounded-lg text-sm font-medium transition-all"
                :class="[
                  selectedTime === time
                    ? 'bg-primary text-primary-foreground'
                    : 'bg-muted/50 hover:bg-muted text-default'
                ]"
                @click="selectedTime = time"
              >
                {{ time }}
              </button>
            </div>
            <p v-if="timeSlots.length === 0" class="text-sm text-muted">
              No available times for this date
            </p>
          </div>

          <!-- Guest Count -->
          <div>
            <h4 class="text-sm font-medium text-muted mb-3">Number of Guests</h4>
            <div class="flex items-center gap-4">
              <UButton
                icon="i-lucide-minus"
                color="neutral"
                variant="soft"
                size="sm"
                :disabled="guestCount <= 1"
                @click="guestCount--"
              />
              <span class="text-2xl font-bold min-w-12 text-center">{{ guestCount }}</span>
              <UButton
                icon="i-lucide-plus"
                color="neutral"
                variant="soft"
                size="sm"
                :disabled="guestCount >= maxGuests"
                @click="guestCount++"
              />
              <span class="text-sm text-muted ml-2">Max {{ maxGuests }}</span>
            </div>
          </div>
        </div>
      </div>
    </template>

    <template #footer>
      <div class="p-4 border-t border-default">
        <div v-if="view === 'services'" class="flex gap-3">
          <UButton
            label="Close"
            color="neutral"
            variant="ghost"
            block
            @click="handleClose"
          />
        </div>
        <div v-else class="flex gap-3">
          <UButton
            icon="i-lucide-arrow-left"
            color="neutral"
            variant="ghost"
            @click="goBack"
          />
          <UButton
            label="Book Now"
            color="primary"
            block
            size="lg"
            :disabled="!canConfirm"
            @click="handleConfirm"
          />
        </div>
      </div>
    </template>
  </USlideover>
</template>

<style scoped>
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
</style>
