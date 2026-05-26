<script setup lang="ts">
/**
 * MercuryEngine Playground — Full Engine Simulator
 *
 * Three-tab interface for testing all engine flows:
 *   1. Appointments: slots → hold → booking → cancel
 *   2. Reservations: availability → create reservation
 *   3. Engine Health: health check + cleanup stats
 *
 * All calls go to real engine at :5002 via useMercuryREST composable.
 * Every API call is logged to the response inspector at the bottom.
 */
import type { LogEntry } from '~/components/playground/PlaygroundResponseLog.vue'

definePageMeta({ layout: 'admin-dashboard' })
useHead({ title: 'MercuryEngine Playground' })

const toast = useToast()
const mercury = useMercuryREST()

// ── Shared Context ──────────────────────────────────────────────────────
const selectedCompany = ref<{ id: string, label: string } | undefined>()
const selectedStore = ref<{ id: string, label: string } | undefined>()
const selectedServiceIds = ref<string[]>([])

const companyId = computed(() => selectedCompany.value?.id || '')
const storeId = computed(() => selectedStore.value?.id || '')

// ── Tab State ───────────────────────────────────────────────────────────
const tabs = [
  { slot: 'appointments', label: 'Appointments', icon: 'i-lucide-calendar-clock' },
  { slot: 'reservations', label: 'Reservations', icon: 'i-lucide-utensils' },
  { slot: 'health', label: 'Engine Health', icon: 'i-lucide-heart-pulse' }
]

// ── Response Log ────────────────────────────────────────────────────────
const logEntries = ref<LogEntry[]>([])

function addLogEntry(partial: Omit<LogEntry, 'id' | 'timestamp'>): LogEntry {
  const entry: LogEntry = {
    id: `log_${Date.now()}_${Math.random().toString(36).slice(2, 6)}`,
    timestamp: new Date(),
    ...partial
  }
  logEntries.value.push(entry)
  return entry
}

/** Execute an API call with automatic logging */
async function trackedCall<T>(method: string, path: string, fn: () => Promise<T>, requestBody?: unknown): Promise<T> {
  const start = performance.now()
  try {
    const result = await fn()
    const latency = Math.round(performance.now() - start)
    addLogEntry({
      method,
      path,
      status: 200,
      latencyMs: latency,
      request: requestBody,
      response: result
    })
    return result
  } catch (err: any) {
    const latency = Math.round(performance.now() - start)
    const status = err?.statusCode || err?.status || null
    addLogEntry({
      method,
      path,
      status,
      latencyMs: latency,
      request: requestBody,
      error: err?.data?.message || err?.data?.error || err?.message || String(err)
    })
    throw err
  }
}

// ── Appointments Flow ───────────────────────────────────────────────────
const date = ref(new Date().toISOString().split('T')[0])
const availableSlots = ref<string[]>([])
const selectedSlot = ref('')
const holdResult = ref<{ holdId: string, expiresAt?: string } | null>(null)
const bookingResult = ref<{ bookingId: string } | null>(null)
const cancelBookingId = ref('')
const cancelReason = ref('')

const loadingSlots = ref(false)
const loadingHold = ref(false)
const loadingBooking = ref(false)
const loadingCancel = ref(false)

// Hold TTL countdown
const holdSecondsLeft = ref(0)
let holdTimer: ReturnType<typeof setInterval> | null = null

function startHoldCountdown(expiresAt?: string) {
  stopHoldCountdown()
  if (!expiresAt) {
    holdSecondsLeft.value = 600 // 10 min default
  } else {
    holdSecondsLeft.value = Math.max(0, Math.round((new Date(expiresAt).getTime() - Date.now()) / 1000))
  }
  holdTimer = setInterval(() => {
    holdSecondsLeft.value = Math.max(0, holdSecondsLeft.value - 1)
    if (holdSecondsLeft.value <= 0) stopHoldCountdown()
  }, 1000)
}

function stopHoldCountdown() {
  if (holdTimer) { clearInterval(holdTimer); holdTimer = null }
}

const holdTimeDisplay = computed(() => {
  const m = Math.floor(holdSecondsLeft.value / 60)
  const s = holdSecondsLeft.value % 60
  return `${m}:${String(s).padStart(2, '0')}`
})

// Current step in appointment flow (for stepper visual)
const appointmentStep = computed(() => {
  if (bookingResult.value) return 3
  if (holdResult.value) return 2
  if (availableSlots.value.length > 0) return 1
  return 0
})

async function getSlots() {
  if (!companyId.value || !storeId.value || !date.value || selectedServiceIds.value.length === 0) return
  loadingSlots.value = true
  try {
    availableSlots.value = await trackedCall('GET', '/appointments/slots', () =>
      mercury.getSlots(companyId.value, storeId.value, date.value, selectedServiceIds.value)
    , { companyId: companyId.value, storeId: storeId.value, date: date.value, serviceIds: selectedServiceIds.value })
    selectedSlot.value = ''
    holdResult.value = null
    bookingResult.value = null
    stopHoldCountdown()
    if (availableSlots.value.length === 0) {
      toast.add({ title: 'No slots available', description: 'Try a different date or service combination.', color: 'warning', icon: 'i-lucide-calendar-x' })
    }
  } catch (e: any) {
    toast.add({ title: 'Failed to fetch slots', description: e?.data?.error || e.message, color: 'error', icon: 'i-lucide-alert-circle' })
  } finally {
    loadingSlots.value = false
  }
}

async function createHold() {
  if (!selectedSlot.value) return
  loadingHold.value = true
  try {
    const body = { companyId: companyId.value, storeId: storeId.value, serviceIds: selectedServiceIds.value, date: date.value, slotTime: selectedSlot.value }
    const result = await trackedCall('POST', '/appointments/holds', () =>
      mercury.createHold(companyId.value, storeId.value, selectedServiceIds.value, date.value, selectedSlot.value)
    , body)
    holdResult.value = { holdId: result.holdId, expiresAt: result.expiresAt }
    bookingResult.value = null
    startHoldCountdown(result.expiresAt)
    toast.add({ title: 'Hold created!', description: `Hold ID: ${result.holdId}`, color: 'success', icon: 'i-lucide-lock' })
  } catch (e: any) {
    toast.add({ title: 'Hold failed', description: e?.data?.error || e.message, color: 'error', icon: 'i-lucide-alert-circle' })
  } finally {
    loadingHold.value = false
  }
}

async function confirmBooking() {
  if (!holdResult.value) return
  loadingBooking.value = true
  try {
    const mockPaymentId = `pay_test_${Date.now()}`
    const body = { holdId: holdResult.value.holdId, paymentId: mockPaymentId }
    const result = await trackedCall('POST', '/appointments/bookings', () =>
      mercury.createBooking(holdResult.value!.holdId, mockPaymentId)
    , body)
    bookingResult.value = { bookingId: result.bookingId }
    cancelBookingId.value = result.bookingId
    stopHoldCountdown()
    toast.add({ title: 'Booking confirmed! 🎉', description: `Booking ID: ${result.bookingId}`, color: 'success', icon: 'i-lucide-party-popper' })
  } catch (e: any) {
    toast.add({ title: 'Booking failed', description: e?.data?.error || e.message, color: 'error', icon: 'i-lucide-alert-circle' })
  } finally {
    loadingBooking.value = false
  }
}

async function cancelBooking() {
  if (!cancelBookingId.value) return
  loadingCancel.value = true
  try {
    const body = { bookingId: cancelBookingId.value, reason: cancelReason.value || undefined }
    await trackedCall('POST', `/appointments/bookings/${cancelBookingId.value}/cancel`, () =>
      mercury.cancelBooking(cancelBookingId.value, cancelReason.value || undefined)
    , body)
    toast.add({ title: 'Booking cancelled', description: `Booking ${cancelBookingId.value} has been cancelled.`, color: 'warning', icon: 'i-lucide-x-circle' })
  } catch (e: any) {
    toast.add({ title: 'Cancel failed', description: e?.data?.error || e.message, color: 'error', icon: 'i-lucide-alert-circle' })
  } finally {
    loadingCancel.value = false
  }
}

function resetAppointments() {
  availableSlots.value = []
  selectedSlot.value = ''
  holdResult.value = null
  bookingResult.value = null
  cancelBookingId.value = ''
  cancelReason.value = ''
  stopHoldCountdown()
}

// ── Reservations Flow ───────────────────────────────────────────────────
const resDate = ref(new Date().toISOString().split('T')[0])
const resPartySize = ref(2)
const resServiceId = ref('')
const resAvailableSlots = ref<Array<{ time: string, available: boolean, remainingCapacity: number }>>([])
const resSelectedSlot = ref<{ time: string, available: boolean, remainingCapacity: number } | null>(null)
const resCustomerName = ref('')
const resCustomerPhone = ref('')
const resNotes = ref('')
const resResult = ref<{ reservationId: string } | null>(null)

const loadingResAvailability = ref(false)
const loadingResCreate = ref(false)

async function getReservationAvailability() {
  if (!companyId.value || !storeId.value || !resDate.value) return
  loadingResAvailability.value = true
  try {
    const query = { companyId: companyId.value, storeId: storeId.value, date: resDate.value, partySize: resPartySize.value, serviceId: resServiceId.value || undefined }
    resAvailableSlots.value = await trackedCall('GET', '/reservations/availability', () =>
      mercury.getReservationAvailability(companyId.value, storeId.value, resDate.value, resPartySize.value, resServiceId.value || undefined)
    , query)
    resSelectedSlot.value = null
    resResult.value = null
    if (resAvailableSlots.value.length === 0) {
      toast.add({ title: 'No availability', description: 'No tables available for that date/party size.', color: 'warning', icon: 'i-lucide-calendar-x' })
    }
  } catch (e: any) {
    toast.add({ title: 'Availability check failed', description: e?.data?.error || e.message, color: 'error', icon: 'i-lucide-alert-circle' })
  } finally {
    loadingResAvailability.value = false
  }
}

async function createReservation() {
  if (!resSelectedSlot.value || !resCustomerName.value) return
  loadingResCreate.value = true
  try {
    const body = {
      companyId: companyId.value,
      storeId: storeId.value,
      date: resDate.value,
      time: resSelectedSlot.value!.time,
      partySize: resPartySize.value,
      customerName: resCustomerName.value,
      customerPhone: resCustomerPhone.value || undefined,
      notes: resNotes.value || undefined,
      serviceId: resServiceId.value || undefined
    }
    const result = await trackedCall('POST', '/reservations', () =>
      mercury.createReservation(body)
    , body)
    resResult.value = { reservationId: result.reservationId }
    toast.add({ title: 'Reservation created! 🍽️', description: `Reservation ID: ${result.reservationId}`, color: 'success', icon: 'i-lucide-check-circle' })
  } catch (e: any) {
    toast.add({ title: 'Reservation failed', description: e?.data?.error || e.message, color: 'error', icon: 'i-lucide-alert-circle' })
  } finally {
    loadingResCreate.value = false
  }
}

function resetReservations() {
  resAvailableSlots.value = []
  resSelectedSlot.value = null
  resCustomerName.value = ''
  resCustomerPhone.value = ''
  resNotes.value = ''
  resResult.value = null
}

// ── Engine Health ───────────────────────────────────────────────────────
const healthData = ref<{ status: string, service: string, version: string, timestamp: string } | null>(null)
const cleanupStats = ref<{ totalHolds: number, expiredHolds: number, timestamp: string } | null>(null)
const loadingHealth = ref(false)
const loadingCleanup = ref(false)
const autoRefresh = ref(false)
let autoRefreshTimer: ReturnType<typeof setInterval> | null = null

async function fetchHealth() {
  loadingHealth.value = true
  try {
    healthData.value = await trackedCall('GET', '/health', () => mercury.getHealthCheck())
  } catch (e: any) {
    healthData.value = null
    toast.add({ title: 'Health check failed', description: e?.data?.error || e.message, color: 'error', icon: 'i-lucide-alert-circle' })
  } finally {
    loadingHealth.value = false
  }
}

async function fetchCleanupStats() {
  loadingCleanup.value = true
  try {
    cleanupStats.value = await trackedCall('GET', '/cleanup/stats', () => mercury.getCleanupStats())
  } catch (e: any) {
    cleanupStats.value = null
    toast.add({ title: 'Stats fetch failed', description: e?.data?.error || e.message, color: 'error', icon: 'i-lucide-alert-circle' })
  } finally {
    loadingCleanup.value = false
  }
}

watch(autoRefresh, (on) => {
  if (autoRefreshTimer) { clearInterval(autoRefreshTimer); autoRefreshTimer = null }
  if (on) {
    fetchHealth()
    fetchCleanupStats()
    autoRefreshTimer = setInterval(() => {
      fetchHealth()
      fetchCleanupStats()
    }, 10_000)
  }
})

onUnmounted(() => {
  if (autoRefreshTimer) clearInterval(autoRefreshTimer)
  stopHoldCountdown()
})

// ── Reset all ───────────────────────────────────────────────────────────
watch(selectedCompany, () => {
  resetAppointments()
  resetReservations()
})

watch(selectedStore, () => {
  resetAppointments()
  resetReservations()
})
</script>

<template>
  <UDashboardPanel id="mercury-playground">
    <template #header>
      <UDashboardNavbar>
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>

        <template #default>
          <div class="flex items-center gap-3">
            <div class="flex items-center gap-2">
              <UIcon name="i-lucide-flask-conical" class="size-5 text-primary" />
              <span class="font-semibold text-lg">Engine Playground</span>
            </div>
            <UBadge label="v0.2.0" color="primary" variant="subtle" size="sm" />
          </div>
        </template>

        <template #right>
          <UButton
            icon="i-lucide-rotate-ccw"
            color="neutral"
            variant="ghost"
            size="sm"
            label="Reset"
            @click="() => { resetAppointments(); resetReservations(); logEntries = [] }"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6 grid grid-cols-1 xl:grid-cols-[1fr_600px] gap-6 items-start">
        <!-- Left Column: Controls & Flows -->
        <div class="space-y-6 min-w-0">
          <!-- Context Picker -->
          <UCard :ui="{ body: 'p-5' }">
            <div class="flex items-center gap-2 mb-4">
              <UIcon name="i-lucide-target" class="size-4 text-primary" />
              <span class="font-semibold text-sm">Target Configuration</span>
            </div>
            <PlaygroundContext
              v-model:company="selectedCompany"
              v-model:store="selectedStore"
              v-model:service-ids="selectedServiceIds"
            />
          </UCard>

          <!-- Tab Switcher -->
          <UTabs
            :items="tabs"
            :ui="{
              list: 'bg-elevated rounded-lg',
              trigger: 'data-[state=active]:text-primary font-medium'
            }"
          >
            <!-- ═══════════════════ TAB 1: APPOINTMENTS ═══════════════════ -->
            <template #appointments>
              <div class="space-y-5 pt-5">
                <!-- Step 1: Get Slots -->
                <UCard>
                  <template #header>
                    <div class="flex items-center gap-3">
                      <span
                        class="size-7 rounded-full flex items-center justify-center text-sm font-bold shrink-0 transition-colors"
                        :class="appointmentStep >= 1 ? 'bg-primary text-white' : 'bg-neutral-200 dark:bg-neutral-700 text-muted'"
                      >
                        1
                      </span>
                      <div>
                        <span class="font-semibold">Search Available Slots</span>
                        <span class="text-sm text-muted ml-2">GET /appointments/slots</span>
                      </div>
                    </div>
                  </template>

                  <div class="space-y-4">
                    <UFormField label="Date">
                      <UInput v-model="date" type="date" icon="i-lucide-calendar" />
                    </UFormField>

                    <UButton
                      icon="i-lucide-search"
                      :loading="loadingSlots"
                      :disabled="!selectedStore || !date || selectedServiceIds.length === 0"
                      @click="getSlots"
                    >
                      Get Available Slots
                    </UButton>

                    <!-- Slot Grid -->
                    <div v-if="availableSlots.length > 0" class="space-y-3">
                      <USeparator />
                      <div class="flex items-center gap-2 text-sm text-muted">
                        <UIcon name="i-lucide-clock" class="size-4" />
                        <span>{{ availableSlots.length }} slots available</span>
                      </div>
                      <div class="flex flex-wrap gap-2">
                        <UButton
                          v-for="slot in availableSlots"
                          :key="slot"
                          :color="selectedSlot === slot ? 'primary' : 'neutral'"
                          :variant="selectedSlot === slot ? 'solid' : 'outline'"
                          size="sm"
                          @click="selectedSlot = slot"
                        >
                          {{ slot }}
                        </UButton>
                      </div>
                    </div>
                  </div>
                </UCard>

                <!-- Step 2: Create Hold -->
                <UCard v-if="selectedSlot">
                  <template #header>
                    <div class="flex items-center gap-3">
                      <span
                        class="size-7 rounded-full flex items-center justify-center text-sm font-bold shrink-0 transition-colors"
                        :class="appointmentStep >= 2 ? 'bg-primary text-white' : 'bg-neutral-200 dark:bg-neutral-700 text-muted'"
                      >
                        2
                      </span>
                      <div>
                        <span class="font-semibold">Create Hold</span>
                        <span class="text-sm text-muted ml-2">POST /appointments/holds</span>
                      </div>
                      <div v-if="holdResult && holdSecondsLeft > 0" class="ml-auto flex items-center gap-2">
                        <span
                          class="font-mono text-sm font-bold"
                          :class="holdSecondsLeft < 60 ? 'text-red-500 animate-pulse' : 'text-emerald-500'"
                        >
                          {{ holdTimeDisplay }}
                        </span>
                        <UBadge label="TTL" color="neutral" variant="subtle" size="xs" />
                      </div>
                    </div>
                  </template>

                  <div class="space-y-4">
                    <div class="flex items-center gap-3 p-3 rounded-lg bg-muted/50">
                      <UIcon name="i-lucide-clock" class="size-5 text-primary" />
                      <div>
                        <span class="font-medium">{{ selectedSlot }}</span>
                        <span class="text-muted ml-2">on {{ date }}</span>
                      </div>
                    </div>

                    <UButton
                      v-if="!holdResult"
                      icon="i-lucide-lock"
                      :loading="loadingHold"
                      @click="createHold"
                    >
                      Create Hold (10min TTL)
                    </UButton>

                    <UAlert
                      v-if="holdResult"
                      icon="i-lucide-lock"
                      color="success"
                      title="Hold Active"
                      :description="`Hold ID: ${holdResult.holdId}`"
                      variant="subtle"
                    />
                  </div>
                </UCard>

                <!-- Step 3: Confirm Booking -->
                <UCard v-if="holdResult">
                  <template #header>
                    <div class="flex items-center gap-3">
                      <span
                        class="size-7 rounded-full flex items-center justify-center text-sm font-bold shrink-0 transition-colors"
                        :class="appointmentStep >= 3 ? 'bg-primary text-white' : 'bg-neutral-200 dark:bg-neutral-700 text-muted'"
                      >
                        3
                      </span>
                      <div>
                        <span class="font-semibold">Confirm Booking</span>
                        <span class="text-sm text-muted ml-2">POST /appointments/bookings</span>
                      </div>
                    </div>
                  </template>

                  <div class="space-y-4">
                    <UAlert
                      icon="i-lucide-credit-card"
                      color="warning"
                      title="Payment Bypass"
                      description="Using mock payment ID — in production, Vipps handles this step."
                      variant="subtle"
                    />

                    <UButton
                      v-if="!bookingResult"
                      icon="i-lucide-calendar-check"
                      color="success"
                      :loading="loadingBooking"
                      @click="confirmBooking"
                    >
                      Confirm Booking
                    </UButton>

                    <UAlert
                      v-if="bookingResult"
                      icon="i-lucide-party-popper"
                      color="success"
                      title="Booking Confirmed! 🎉"
                      :description="`Booking ID: ${bookingResult.bookingId}`"
                    />
                  </div>
                </UCard>

                <!-- Cancellation Zone -->
                <UCard :ui="{ root: 'ring-red-500/20 dark:ring-red-400/20' }">
                  <template #header>
                    <div class="flex items-center gap-2">
                      <UIcon name="i-lucide-x-circle" class="size-5 text-red-500" />
                      <span class="font-semibold">Cancel Booking</span>
                      <span class="text-sm text-muted ml-2">POST /appointments/bookings/:id/cancel</span>
                    </div>
                  </template>

                  <div class="space-y-4">
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <UFormField label="Booking ID">
                        <UInput v-model="cancelBookingId" placeholder="Enter booking ID..." icon="i-lucide-hash" />
                      </UFormField>
                      <UFormField label="Reason (optional)">
                        <UInput v-model="cancelReason" placeholder="Cancellation reason..." icon="i-lucide-message-square" />
                      </UFormField>
                    </div>
                    <UButton
                      icon="i-lucide-x-circle"
                      color="error"
                      variant="soft"
                      :loading="loadingCancel"
                      :disabled="!cancelBookingId"
                      @click="cancelBooking"
                    >
                      Cancel Booking
                    </UButton>
                  </div>
                </UCard>
              </div>
            </template>

            <!-- ═══════════════════ TAB 2: RESERVATIONS ═══════════════════ -->
            <template #reservations>
              <div class="space-y-5 pt-5">
                <!-- Configuration -->
                <UCard>
                  <template #header>
                    <div class="flex items-center gap-3">
                      <span
                        class="size-7 rounded-full flex items-center justify-center text-sm font-bold shrink-0 bg-primary text-white"
                      >
                        1
                      </span>
                      <div>
                        <span class="font-semibold">Check Availability</span>
                        <span class="text-sm text-muted ml-2">GET /reservations/availability</span>
                      </div>
                    </div>
                  </template>

                  <div class="space-y-4">
                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                      <UFormField label="Date">
                        <UInput v-model="resDate" type="date" icon="i-lucide-calendar" />
                      </UFormField>
                      <UFormField label="Party Size">
                        <UInputNumber v-model="resPartySize" :min="1" :max="20" />
                      </UFormField>
                      <UFormField label="Service ID (optional)">
                        <UInput v-model="resServiceId" placeholder="Scopes to resource group..." icon="i-lucide-layers" />
                      </UFormField>
                    </div>

                    <UButton
                      icon="i-lucide-search"
                      :loading="loadingResAvailability"
                      :disabled="!selectedStore || !resDate"
                      @click="getReservationAvailability"
                    >
                      Check Availability
                    </UButton>

                    <!-- Slot Grid -->
                    <div v-if="resAvailableSlots.length > 0" class="space-y-3">
                      <USeparator />
                      <div class="flex items-center gap-2 text-sm text-muted">
                        <UIcon name="i-lucide-clock" class="size-4" />
                        <span>{{ resAvailableSlots.length }} time slots available</span>
                      </div>
                      <div class="flex flex-wrap gap-2">
                        <UButton
                          v-for="slot in resAvailableSlots"
                          :key="slot.time"
                          :color="resSelectedSlot?.time === slot.time ? 'primary' : 'neutral'"
                          :variant="resSelectedSlot?.time === slot.time ? 'solid' : 'outline'"
                          size="sm"
                          :disabled="!slot.available"
                          @click="resSelectedSlot = slot"
                        >
                          {{ slot.time }}
                          <UBadge v-if="slot.available" :label="`${slot.remainingCapacity} left`" color="neutral" variant="subtle" size="xs" class="ml-1" />
                        </UButton>
                      </div>
                    </div>
                  </div>
                </UCard>

                <!-- Create Reservation -->
                <UCard v-if="resSelectedSlot">
                  <template #header>
                    <div class="flex items-center gap-3">
                      <span class="size-7 rounded-full flex items-center justify-center text-sm font-bold shrink-0 bg-primary text-white">2</span>
                      <div>
                        <span class="font-semibold">Create Reservation</span>
                        <span class="text-sm text-muted ml-2">POST /reservations</span>
                      </div>
                    </div>
                  </template>

                  <div class="space-y-4">
                    <div class="flex items-center gap-3 p-3 rounded-lg bg-muted/50">
                      <UIcon name="i-lucide-utensils" class="size-5 text-primary" />
                      <div>
                        <span class="font-medium">{{ resSelectedSlot?.time }}</span>
                        <span class="text-muted ml-2">· {{ resPartySize }} guests · {{ resDate }}</span>
                      </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <UFormField label="Customer Name" required>
                        <UInput v-model="resCustomerName" placeholder="Name..." icon="i-lucide-user" />
                      </UFormField>
                      <UFormField label="Phone (optional)">
                        <UInput v-model="resCustomerPhone" placeholder="Phone..." icon="i-lucide-phone" />
                      </UFormField>
                    </div>

                    <UFormField label="Notes (optional)">
                      <UTextarea v-model="resNotes" placeholder="Allergies, celebrations, seating preferences..." :rows="2" />
                    </UFormField>

                    <UButton
                      v-if="!resResult"
                      icon="i-lucide-check-circle"
                      color="success"
                      :loading="loadingResCreate"
                      :disabled="!resCustomerName"
                      @click="createReservation"
                    >
                      Create Reservation
                    </UButton>

                    <UAlert
                      v-if="resResult"
                      icon="i-lucide-check-circle"
                      color="success"
                      title="Reservation Created! 🍽️"
                      :description="`Reservation ID: ${resResult.reservationId}`"
                    />
                  </div>
                </UCard>
              </div>
            </template>

            <!-- ═══════════════════ TAB 3: ENGINE HEALTH ═══════════════════ -->
            <template #health>
              <div class="space-y-5 pt-5">
                <!-- Controls -->
                <div class="flex items-center gap-4">
                  <UButton
                    icon="i-lucide-heart-pulse"
                    :loading="loadingHealth"
                    @click="() => { fetchHealth(); fetchCleanupStats() }"
                  >
                    Run Health Check
                  </UButton>
                  <div class="flex items-center gap-2">
                    <USwitch v-model="autoRefresh" />
                    <span class="text-sm text-muted">Auto-refresh (10s)</span>
                  </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                  <!-- Health Check -->
                  <UCard>
                    <template #header>
                      <div class="flex items-center gap-2">
                        <UIcon name="i-lucide-activity" class="size-5 text-emerald-500" />
                        <span class="font-semibold">Health Check</span>
                        <span class="text-sm text-muted ml-2">GET /health</span>
                      </div>
                    </template>

                    <div v-if="!healthData" class="text-muted text-sm py-4 text-center">
                      <UIcon name="i-lucide-server" class="size-8 mb-2 opacity-30" />
                      <p>Click "Run Health Check" to query the engine.</p>
                    </div>

                    <div v-else class="space-y-3">
                      <div class="flex items-center gap-2">
                        <span
                          class="size-3 rounded-full"
                          :class="healthData.status === 'ok' ? 'bg-emerald-500 animate-pulse' : 'bg-red-500'"
                        />
                        <span class="font-medium capitalize">{{ healthData.status }}</span>
                      </div>
                      <div class="grid grid-cols-2 gap-3 text-sm">
                        <div>
                          <span class="text-muted">Service</span>
                          <p class="font-mono">{{ healthData.service }}</p>
                        </div>
                        <div>
                          <span class="text-muted">Version</span>
                          <p class="font-mono">{{ healthData.version }}</p>
                        </div>
                      </div>
                    </div>
                  </UCard>

                  <!-- Cleanup Stats -->
                  <UCard>
                    <template #header>
                      <div class="flex items-center gap-2">
                        <UIcon name="i-lucide-trash-2" class="size-5 text-amber-500" />
                        <span class="font-semibold">Hold Stats</span>
                        <span class="text-sm text-muted ml-2">GET /cleanup/stats</span>
                      </div>
                    </template>

                    <div v-if="!cleanupStats" class="text-muted text-sm py-4 text-center">
                      <UIcon name="i-lucide-bar-chart-3" class="size-8 mb-2 opacity-30" />
                      <p>Click "Run Health Check" to view stats.</p>
                    </div>

                    <div v-else class="space-y-3">
                      <div class="grid grid-cols-2 gap-4">
                        <div class="text-center p-3 rounded-lg bg-muted/50">
                          <p class="text-2xl font-bold font-mono">{{ cleanupStats.totalHolds }}</p>
                          <p class="text-xs text-muted">Total Holds</p>
                        </div>
                        <div class="text-center p-3 rounded-lg bg-muted/50">
                          <p
                            class="text-2xl font-bold font-mono"
                            :class="cleanupStats.expiredHolds > 0 ? 'text-amber-500' : 'text-emerald-500'"
                          >
                            {{ cleanupStats.expiredHolds }}
                          </p>
                          <p class="text-xs text-muted">Expired</p>
                        </div>
                      </div>
                    </div>
                  </UCard>
                </div>
              </div>
            </template>
          </UTabs>
        </div>

        <!-- Right Column: Response Log (sticky) -->
        <div class="xl:sticky xl:top-6 min-w-0">
          <PlaygroundResponseLog
            :entries="logEntries"
            @clear="logEntries = []"
          />
        </div>
      </div>
    </template>
  </UDashboardPanel>
</template>

