<script setup lang="ts">
/**
 * AppointmentBookingModal
 * Simple booking flow for standard 1:1 appointments.
 * Flow: Select Date → Select Time Slot → Confirm
 * 
 * TODO: UI - This is a basic functional implementation. 
 * Restyle as needed - the logic is what matters here.
 */

import DateSelector from './DateSelector.vue'
import TimeSlotPicker from './TimeSlotPicker.vue'

interface Service {
  id: string
  title: string
  description?: string
  coverImage?: string
  price: number
  currency: string
  duration: number
  availabilityStart?: string
  availabilityEnd?: string
}

interface Props {
  open: boolean
  service: Service | null
  storeName?: string
  storeAddress?: string
  storeLogo?: string
}

const props = defineProps<Props>()
const emit = defineEmits<{
  (e: 'update:open', value: boolean): void
  (e: 'confirm', booking: {
    serviceId: string
    date: Date
    time: string
    // TODO: Add customer info when auth is ready
  }): void
}>()

// DEBUG
onMounted(() => {
  console.log('[AppointmentModal] Mounted, open:', props.open)
})

watch(() => props.open, (newVal) => {
  console.log('[AppointmentModal] open changed to:', newVal)
})

// State
const step = ref(1) // 1: Date, 2: Time, 3: Confirm
const selectedDate = ref(new Date())
const selectedTime = ref<string>()

// TODO: CONNECT TO MERCURYENGINE - These are mock slots
// Replace with real API call: MercuryEngine.getAvailableSlots(storeId, serviceId, date)
const timeSlots = computed(() => {
  // Mock time slots based on service availability
  const start = props.service?.availabilityStart || '09:00'
  const end = props.service?.availabilityEnd || '17:00'
  const duration = props.service?.duration || 60
  
  const slots: string[] = []
  let [startHour, startMin] = start.split(':').map(Number)
  const [endHour] = end.split(':').map(Number)
  
  while (startHour < endHour) {
    slots.push(`${String(startHour).padStart(2, '0')}:${String(startMin).padStart(2, '0')}`)
    startMin += duration
    if (startMin >= 60) {
      startHour += Math.floor(startMin / 60)
      startMin = startMin % 60
    }
  }
  
  return slots
})

function formatPrice(price: number, currency: string) {
  return new Intl.NumberFormat('nb-NO', {
    style: 'currency',
    currency: currency || 'NOK'
  }).format(price)
}

function formatDate(date: Date) {
  return date.toLocaleDateString('nb-NO', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

function handleClose() {
  emit('update:open', false)
  // Reset state after close animation
  setTimeout(() => {
    step.value = 1
    selectedTime.value = undefined
  }, 300)
}

function handleConfirm() {
  if (!props.service || !selectedTime.value) return
  
  emit('confirm', {
    serviceId: props.service.id,
    date: selectedDate.value,
    time: selectedTime.value
  })
  
  // TODO: CONNECT TO MERCURYENGINE - Create booking document
  // await MercuryEngine.createBooking({ ... })
  
  handleClose()
}

function nextStep() {
  if (step.value < 3) step.value++
}

function prevStep() {
  if (step.value > 1) step.value--
}
</script>

<template>
  <UModal 
    :open="open"
    :title="service?.title || 'Book Appointment'"
    @update:open="handleClose"
  >
    <template #body>
      <!-- TODO: UI - Restyle this entire modal as needed. Logic is functional. -->
      <div class="min-h-[400px] p-4 space-y-6">
        
        <!-- Progress Indicator -->
        <div class="flex items-center justify-center gap-2 mb-6">
          <div 
            v-for="i in 3" 
            :key="i"
            class="w-3 h-3 rounded-full transition-colors"
            :class="step >= i ? 'bg-primary' : 'bg-gray-300'"
          />
        </div>

        <!-- STEP 1: Date Selection -->
        <div v-if="step === 1" class="space-y-4">
          <h3 class="text-lg font-semibold">Select Date</h3>
          <DateSelector v-model="selectedDate" />
          <UButton 
            label="Continue" 
            color="primary" 
            block 
            @click="nextStep"
          />
        </div>

        <!-- STEP 2: Time Selection -->
        <div v-else-if="step === 2" class="space-y-4">
          <div class="flex items-center gap-2 mb-4">
            <UButton 
              icon="i-lucide-arrow-left" 
              variant="ghost" 
              color="neutral"
              @click="prevStep"
            />
            <h3 class="text-lg font-semibold">Select Time</h3>
          </div>
          
          <p class="text-sm text-muted">{{ formatDate(selectedDate) }}</p>
          
          <!-- TODO: UI - TimeSlotPicker styling -->
          <TimeSlotPicker 
            :slots="timeSlots"
            v-model="selectedTime"
          />
          
          <UButton 
            v-if="selectedTime"
            label="Continue" 
            color="primary" 
            block 
            @click="nextStep"
          />
        </div>

        <!-- STEP 3: Confirmation -->
        <div v-else-if="step === 3" class="space-y-4">
          <div class="flex items-center gap-2 mb-4">
            <UButton 
              icon="i-lucide-arrow-left" 
              variant="ghost" 
              color="neutral"
              @click="prevStep"
            />
            <h3 class="text-lg font-semibold">Confirm Booking</h3>
          </div>
          
          <!-- TODO: UI - Summary Card styling -->
          <div class="p-4 rounded-lg border border-default bg-muted/20 space-y-3">
            <div class="flex items-center gap-3" v-if="storeLogo">
              <NuxtImg :src="storeLogo" :alt="storeName" class="size-12 rounded-lg object-cover" loading="lazy" sizes="48px" />
              <div>
                <p class="font-semibold">{{ storeName }}</p>
                <p class="text-sm text-muted">{{ storeAddress }}</p>
              </div>
            </div>
            
            <USeparator />
            
            <div class="space-y-2 text-sm">
              <div class="flex justify-between">
                <span class="text-muted">Service</span>
                <span class="font-medium">{{ service?.title }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-muted">Date</span>
                <span>{{ formatDate(selectedDate) }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-muted">Time</span>
                <span>{{ selectedTime }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-muted">Duration</span>
                <span>{{ service?.duration }} min</span>
              </div>
              
              <USeparator />
              
              <div class="flex justify-between text-lg font-semibold">
                <span>Total</span>
                <span class="text-primary">{{ formatPrice(service?.price || 0, service?.currency || 'NOK') }}</span>
              </div>
            </div>
          </div>
          
          <UButton 
            label="Confirm Booking" 
            color="primary" 
            size="lg"
            block 
            @click="handleConfirm"
          />
          
          <p class="text-xs text-muted text-center">
            <!-- TODO: Add cancellation policy, terms, etc. -->
            By confirming, you agree to the booking terms.
          </p>
        </div>

      </div>
    </template>
  </UModal>
</template>
