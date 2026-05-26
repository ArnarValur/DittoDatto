<script setup lang="ts">
/**
 * BookingSlideover
 * Main booking shell - shows service list and routes to appropriate flow.
 * 
 * Flow routing by bookingMode:
 * - standard → StandardBookingFlow (Date → Time → Confirm)
 * - tableReservation → ReservationBookingFlow (Guests → Date → Time → Confirm)
 * - ticketSystem → TicketBookingFlow (future)
 * 
 * Views: services → flow → confirmation
 * 
 * Updated: 2026-03-15 - Types extracted to booking.types.ts
 */
import type {
  ServiceItem,
  StaffMember,
  ServiceGroupItem,
  OpeningSchedule,
  ReservationConfig,
} from './booking.types'
import { formatDuration } from './booking.utils'
import StandardBookingFlow from './flows/StandardBookingFlow.vue'
import ReservationBookingFlow from './flows/ReservationBookingFlow.vue'
import BookingConfirmation, { type BookingDetails } from './BookingConfirmation.vue'

const { t } = useI18n()

interface Props {
  open: boolean
  storeName: string
  storeAddress: string
  storeLogo?: string
  services: ServiceItem[]
  serviceGroups?: ServiceGroupItem[]
  openingSchedule?: OpeningSchedule
  reservationConfig?: Partial<ReservationConfig>
  preselectedService?: ServiceItem | null
  // Accept slots state from parent
  availableSlots?: string[]
  slotsLoading?: boolean
  slotsError?: string | null
  holdExpiresAt?: Date | null
  // Confirmation data — when set, slideover shows confirmation view
  confirmedBooking?: BookingDetails | null
  // Auth state — determines if user can confirm
  isAuthenticated?: boolean
  /** Whether a booking confirmation is in progress */
  confirming?: boolean
  /** Store's available staff */
  staff?: StaffMember[]
  /** Preselected staff from storefront (if any) */
  preselectedStaff?: StaffMember | null
  /** Group name to auto-expand when slideover opens */
  preExpandedGroup?: string
}

const props = withDefaults(defineProps<Props>(), {
  availableSlots: () => [],
  slotsLoading: false,
  slotsError: null,
  holdExpiresAt: null,
  confirming: false,
  staff: () => [],
  preselectedStaff: null
})

const emit = defineEmits<{
  (e: 'update:open', value: boolean): void
  (e: 'confirm', booking: {
    service: ServiceItem
    date: Date
    time: string
    guestCount?: number
    notes?: string
  }): void
  (e: 'date-change', payload: any): void
  (e: 'service-selected', service: ServiceItem): void
  (e: 'hold-expired'): void
  (e: 'view-bookings'): void
  (e: 'done'): void
  (e: 'login'): void
  (e: 'signup'): void
  (e: 'clear-staff'): void
  (e: 'staff-selected', staff: StaffMember | null): void
}>()

// State
type View = 'services' | 'flow' | 'confirmation' | 'login'
const view = ref<View>('services')
const selectedService = ref<ServiceItem | null>(null)
const selectedServices = ref<ServiceItem[]>([])
const pendingConfirmData = ref<{ date: Date; time: string; guestCount?: number } | null>(null)
const bookingNotes = ref('')
const expandedGroups = ref<Set<string>>(new Set())

function toggleGroupExpanded(label: string) {
  if (expandedGroups.value.has(label)) {
    expandedGroups.value.delete(label)
  } else {
    expandedGroups.value.add(label)
  }
}

function isGroupExpanded(label: string): boolean {
  return expandedGroups.value.has(label)
}

// Multi-select helpers
function isServiceSelected(service: ServiceItem): boolean {
  return selectedServices.value.some(s => s.id === service.id)
}

function toggleService(service: ServiceItem) {
  const idx = selectedServices.value.findIndex(s => s.id === service.id)
  if (idx >= 0) {
    selectedServices.value.splice(idx, 1)
  } else {
    selectedServices.value.push(service)
  }
}

const multiSelectTotal = computed(() => {
  const items = selectedServices.value
  return {
    count: items.length,
    price: items.reduce((sum, s) => sum + (s.price ?? 0), 0),
    duration: items.reduce((sum, s) => sum + (s.duration ?? 0), 0),
    currency: items[0]?.currency || 'kr',
  }
})

const hasMultiSelectGroups = computed(() =>
  groupedServices.value.some(g => g.multiSelect)
)

function proceedWithMultiSelect() {
  const first = selectedServices.value[0]
  if (!first) return
  // Use first selected service as the primary (for flow routing / bookingMode)
  selectedService.value = first
  view.value = 'flow'
  // Emit only the first to trigger slot fetch in parent — parent uses allSelectedServiceIds for hold
  emit('service-selected', first)
}

// Expose all selected service IDs for the parent to use in createHold
const allSelectedServiceIds = computed(() =>
  selectedServices.value.length > 0
    ? selectedServices.value.map(s => s.id)
    : selectedService.value ? [selectedService.value.id] : []
)

defineExpose({ allSelectedServiceIds, toggleGroupExpanded })

// Watch for preExpandedGroup prop
watch(() => props.preExpandedGroup, (groupName) => {
  if (groupName) {
    expandedGroups.value.add(groupName)
  }
})

// Watch for preselected service when modal opens
watch(() => props.open, (isOpen) => {
  if (isOpen && props.preselectedService) {
    selectedService.value = props.preselectedService
    view.value = 'flow'
  }
})

// Watch for confirmed booking data — switch to confirmation view
watch(() => props.confirmedBooking, (booking) => {
  if (booking) {
    view.value = 'confirmation'
  }
})

// Group services by their serviceGroup for display
const groupedServices = computed(() => {
  const groups = props.serviceGroups?.filter(g => g.showOnBookingPanel !== false) ?? []
  const result: { label: string; services: ServiceItem[]; multiSelect: boolean }[] = []

  // Sorted groups first
  const sortedGroups = [...groups].sort((a, b) => (a.sortOrder ?? 0) - (b.sortOrder ?? 0))
  for (const group of sortedGroups) {
    const groupServices = props.services.filter(s => s.groupId === group.id)
    if (groupServices.length > 0) {
      result.push({ label: group.name, services: groupServices, multiSelect: group.multiSelect ?? false })
    }
  }

  // Ungrouped services go into "General" (or show flat if no groups at all)
  const ungrouped = props.services.filter(s => !s.groupId || !groups.some(g => g.id === s.groupId))
  if (ungrouped.length > 0) {
    // If there are no groups at all, don't add a "General" header
    if (result.length > 0) {
      result.push({ label: 'Generelt', services: ungrouped, multiSelect: false })
    } else {
      result.push({ label: '', services: ungrouped, multiSelect: false })
    }
  }

  return result
})

// Local formatPrice override — uses i18n for the "Free" label
function formatPriceLocal(price?: number, currency?: string): string {
  if (price === undefined || price === null) return ''
  if (price === 0) return t('establishment.free')
  return new Intl.NumberFormat('nb-NO', {
    style: 'decimal',
    minimumFractionDigits: 2
  }).format(price) + ' ' + (currency || 'kr')
}

// Actions
function selectService(service: ServiceItem) {
  selectedService.value = service
  view.value = 'flow'
  emit('service-selected', service)
}

function handleFlowBack() {
  view.value = 'services'
  selectedService.value = null
}

function handleFlowConfirm(data: { date: Date; time: string; guestCount?: number }) {
  if (!selectedService.value) return
  
  // Check auth before confirming
  if (!props.isAuthenticated) {
    pendingConfirmData.value = data
    view.value = 'login'
    return
  }
  
  console.log('[BookingSlideover] Booking confirmed:', {
    service: selectedService.value,
    ...data
  })
  
  // Emit to parent — parent will handle MercuryEngine and set confirmedBooking prop
  // which will trigger the confirmation view via the watcher above
  emit('confirm', {
    service: selectedService.value,
    date: data.date,
    time: data.time,
    guestCount: data.guestCount,
    notes: bookingNotes.value.trim() || undefined
  })
}

// NEW: Handle date change from child flow
function handleDateChange(payload: any) {
  emit('date-change', payload)
}

function handleViewBookings() {
  emit('view-bookings')
  handleClose()
}

function handleDone() {
  emit('done')
  handleClose()
}

function handleLogin() {
  emit('login')
}

function handleSignup() {
  emit('signup')
}

function handleClose() {
  emit('update:open', false)
  setTimeout(() => {
    view.value = 'services'
    selectedService.value = null
    selectedServices.value = []
    expandedGroups.value = new Set()
    pendingConfirmData.value = null
    bookingNotes.value = ''
  }, 300)
}

// Computed
const headerTitle = computed(() => {
  if (view.value === 'services') return t('establishment.menuServices')
  if (view.value === 'confirmation') return t('booking.bookingConfirmed')
  if (view.value === 'login') return t('booking.signInRequired')
  return selectedService.value?.title || t('establishment.book')
})

const currentBookingMode = computed(() => 
  selectedService.value?.bookingMode || 'standard'
)
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
          {{ headerTitle }}
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
      <!-- Staff Context Banner -->
      <div
        v-if="preselectedStaff && view !== 'confirmation'"
        class="mx-4 mt-2 mb-0 flex items-center gap-3 p-3 rounded-xl bg-primary/5 border border-primary/20"
      >
        <div class="size-8 rounded-full overflow-hidden shrink-0 bg-primary/10">
          <img
            v-if="preselectedStaff.avatarUrl"
            :src="preselectedStaff.avatarUrl"
            :alt="preselectedStaff.displayName"
            class="size-full object-cover"
          />
          <div v-else class="size-full flex items-center justify-center text-primary font-semibold text-xs">
            {{ preselectedStaff.displayName.split(' ').map((n: string) => n[0]).join('').slice(0, 2).toUpperCase() }}
          </div>
        </div>
        <div class="flex-1 min-w-0">
          <p class="text-sm font-medium">{{ t('establishment.bookingWith', { name: preselectedStaff.displayName }) }}</p>
        </div>
        <UButton
          icon="i-lucide-x"
          color="neutral"
          variant="ghost"
          size="xs"
          @click="emit('clear-staff')"
        />
      </div>

      <!-- Services List View -->
      <div v-if="view === 'services'" class="p-4 space-y-3" :class="{ 'pb-28': selectedServices.length > 0 }">
        <template v-for="section in groupedServices" :key="section.label">
          <!-- Accordion group with label -->
          <div v-if="section.label" class="rounded-xl border border-default overflow-hidden">
            <!-- Accordion header -->
            <button
              class="w-full flex items-center justify-between p-4 hover:bg-muted/30 transition-colors text-left"
              @click="toggleGroupExpanded(section.label)"
            >
              <div class="flex items-center gap-3">
                <span class="font-semibold">{{ section.label }}</span>
                <span class="text-xs text-muted">{{ t('establishment.serviceCount', { count: section.services.length }) }}</span>
              </div>
              <UIcon
                name="i-lucide-chevron-down"
                class="size-5 text-muted transition-transform duration-200"
                :class="{ 'rotate-180': isGroupExpanded(section.label) }"
              />
            </button>

            <!-- Accordion content -->
            <div v-if="isGroupExpanded(section.label)" class="border-t border-default p-3 space-y-2">
              <div
                v-for="service in section.services"
                :key="service.id"
                class="flex items-center gap-3 p-3 rounded-lg transition-all cursor-pointer"
                :class="[
                  section.multiSelect && isServiceSelected(service)
                    ? 'bg-primary/10 ring-1 ring-primary/40'
                    : 'bg-muted/20 hover:bg-muted/40',
                ]"
                role="button"
                tabindex="0"
                @click="section.multiSelect ? toggleService(service) : selectService(service)"
                @keydown.enter="section.multiSelect ? toggleService(service) : selectService(service)"
              >
                <!-- Service Image -->
                <div class="shrink-0 size-12 rounded-lg bg-muted overflow-hidden">
                  <img
                    v-if="service.coverImage"
                    :src="service.coverImage"
                    :alt="service.title"
                    class="w-full h-full object-cover"
                  >
                  <div v-else class="w-full h-full flex items-center justify-center">
                    <UIcon name="i-lucide-calendar-check" class="size-5 text-muted" />
                  </div>
                </div>

                <!-- Service Info -->
                <div class="flex-1 min-w-0">
                  <h3 class="font-medium text-sm">{{ service.title }}</h3>
                  <div class="flex items-center gap-2 mt-0.5 text-xs">
                    <span v-if="service.duration" class="text-muted">
                      {{ formatDuration(service.duration) }}
                    </span>
                    <span
                      v-if="service.price !== undefined"
                      class="font-medium"
                      :class="service.price === 0 ? 'text-green-500' : 'text-primary'"
                    >
                      {{ service.price === 0 ? t('establishment.free') : formatPriceLocal(service.price, service.currency) }}
                    </span>
                  </div>
                </div>

                <!-- Checkbox / Chevron -->
                <template v-if="section.multiSelect">
                  <div
                    class="size-5 rounded border-2 flex items-center justify-center transition-all shrink-0"
                    :class="isServiceSelected(service) ? 'bg-primary border-primary' : 'border-muted'"
                  >
                    <UIcon v-if="isServiceSelected(service)" name="i-lucide-check" class="size-3.5 text-white" />
                  </div>
                </template>
                <UIcon v-else name="i-lucide-chevron-right" class="size-4 text-muted shrink-0" />
              </div>
            </div>
          </div>

          <!-- Ungrouped services (no accordion, flat list) -->
          <template v-else>
            <div class="space-y-3">
              <div
                v-for="service in section.services"
                :key="service.id"
                class="flex items-center gap-4 p-4 rounded-xl bg-muted/30 border border-default hover:border-primary/50 cursor-pointer transition-all group"
                role="button"
                tabindex="0"
                @click="selectService(service)"
                @keydown.enter="selectService(service)"
              >
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
                <div class="flex-1 min-w-0">
                  <h3 class="font-semibold group-hover:text-primary transition-colors">{{ service.title }}</h3>
                  <p v-if="service.description" class="text-sm text-muted line-clamp-2">{{ service.description }}</p>
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
                      {{ service.price === 0 ? t('establishment.free') : formatPriceLocal(service.price, service.currency) }}
                    </span>
                  </div>
                </div>
                <div class="flex items-center gap-2">
                  <UBadge
                    v-if="service.bookingMode === 'tableReservation'"
                    color="primary"
                    variant="subtle"
                    size="xs"
                  >
                    {{ t('establishment.reservation') }}
                  </UBadge>
                  <UIcon name="i-lucide-chevron-right" class="size-5 text-muted group-hover:text-primary transition-colors" />
                </div>
              </div>
            </div>
          </template>
        </template>

        <div v-if="services.length === 0" class="text-center py-12 text-muted">
          <UIcon name="i-lucide-calendar-x" class="size-12 mx-auto mb-3 opacity-50" />
          <p>{{ t('establishment.noServices') }}</p>
        </div>

        <!-- Multi-select sticky footer -->
        <Transition name="slide-up">
          <div
            v-if="selectedServices.length > 0"
            class="sticky bottom-0 z-10 p-4 bg-elevated border-t border-default shadow-lg"
          >
            <div class="flex items-center justify-between mb-2">
              <div>
                <span class="text-sm font-medium">{{ t('establishment.serviceCount', { count: multiSelectTotal.count }) }}</span>
                <span class="text-sm text-muted ml-2">{{ formatDuration(multiSelectTotal.duration) }}</span>
              </div>
              <span class="font-semibold text-primary">{{ formatPriceLocal(multiSelectTotal.price, multiSelectTotal.currency) }}</span>
            </div>
            <UButton
              :label="t('establishment.proceed')"
              icon="i-lucide-arrow-right"
              trailing
              color="primary"
              block
              size="lg"
              @click="proceedWithMultiSelect"
            />
          </div>
        </Transition>
      </div>

      <!-- Booking Flow View -->
      <div v-else-if="view === 'flow'" class="p-4">
        <!-- Standard Booking Flow -->
        <StandardBookingFlow
          v-if="currentBookingMode === 'standard'"
          :service="selectedService!"
          :additional-services="selectedServices.length > 0 ? selectedServices.filter(s => s.id !== selectedService?.id) : []"
          :store-name="storeName"
          :store-address="storeAddress"
          :store-logo="storeLogo"
          :opening-schedule="openingSchedule"
          :available-slots="availableSlots"
          :slots-loading="slotsLoading"
          :slots-error="slotsError"
          :hold-expires-at="holdExpiresAt"
          :confirming="confirming"
          :staff="staff"
          :preselected-staff="preselectedStaff"
          @back="handleFlowBack"
          @confirm="handleFlowConfirm"
          @date-change="handleDateChange"
          @staff-selected="(staff: any) => emit('staff-selected', staff)"
        />

        <!-- Reservation Booking Flow -->
        <ReservationBookingFlow
          v-else-if="currentBookingMode === 'tableReservation'"
          :service="selectedService!"
          :store-name="storeName"
          :store-address="storeAddress"
          :store-logo="storeLogo"
          :opening-schedule="openingSchedule"
          :reservation-config="reservationConfig"
          :available-slots="availableSlots"
          :slots-loading="slotsLoading"
          :slots-error="slotsError"
          @back="handleFlowBack"
          @confirm="handleFlowConfirm"
          @date-change="handleDateChange"
        />

        <!-- Ticket Booking Flow (placeholder) -->
        <div v-else-if="currentBookingMode === 'ticketSystem'" class="text-center py-12">
          <UIcon name="i-lucide-ticket" class="size-12 mx-auto mb-3 text-muted" />
          <p class="text-muted">{{ t('booking.ticketingComingSoon') }}</p>
          <UButton
            :label="t('booking.goBack')"
            color="neutral"
            variant="ghost"
            class="mt-4"
            @click="handleFlowBack"
          />
        </div>

        <!-- Notes (optional, always visible during flow) -->
        <div class="mt-4 pt-3 border-t border-default">
          <UTextarea
            v-model="bookingNotes"
            :placeholder="t('booking.notesPlaceholder', 'Valgfritt...')"
            :rows="2"
            autoresize
            color="neutral"
            variant="outline"
            class="w-full"
          />
        </div>
      </div>

      <!-- Confirmation View -->
      <div v-else-if="view === 'confirmation' && confirmedBooking">
        <BookingConfirmation
          :booking="confirmedBooking"
          @view-bookings="handleViewBookings"
          @done="handleDone"
        />
      </div>

      <!-- Login Required View -->
      <div v-else-if="view === 'login'" class="p-6 flex flex-col items-center text-center space-y-6">
        <div class="size-20 rounded-full bg-primary/10 flex items-center justify-center">
          <UIcon name="i-lucide-lock-keyhole" class="size-10 text-primary" />
        </div>

        <div class="space-y-2">
          <h3 class="text-lg font-semibold">{{ t('booking.signInToBook') }}</h3>
          <p class="text-sm text-muted">
            {{ t('booking.signInToBookDesc', { store: storeName }) }}
          </p>
        </div>

        <div class="w-full space-y-3">
          <UButton
            :label="t('auth.login')"
            color="primary"
            size="lg"
            block
            icon="i-lucide-log-in"
            @click="handleLogin"
          />
          <UButton
            :label="t('auth.signup')"
            color="primary"
            variant="outline"
            size="lg"
            block
            icon="i-lucide-user-plus"
            @click="handleSignup"
          />
        </div>

        <UButton
          :label="t('booking.goBack')"
          color="neutral"
          variant="ghost"
          size="sm"
          icon="i-lucide-arrow-left"
          @click="view = 'flow'"
        />
      </div>
    </template>

    <template #footer>
      <div class="p-4 border-t border-default">
        <UButton
          :label="t('common.close')"
          color="neutral"
          variant="ghost"
          block
          @click="handleClose"
        />
      </div>
    </template>
  </USlideover>
</template>
