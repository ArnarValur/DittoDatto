/**
 * useBookingState — Booking Flow State Composable
 *
 * Owns the entire booking lifecycle:
 *   Service selection → Date change → Slot fetching → Hold/Confirm → Done
 *
 * This composable lives in ui so it can be used by any app.
 * API calls are injected via `BookingFetchAdapter` — each host app provides its own transport.
 *
 * Usage:
 *   const booking = useBookingState(adapter)
 *   // Template: <BookingSlideover v-bind="booking.slideoverProps" v-on="booking.slideoverEvents" />
 */
import { ref, computed } from 'vue'
import type { BookingDetails } from '../components/booking/BookingConfirmation.vue'

// ── Adapter Types ─────────────────────────────────────────────

export interface FetchSlotsOptions {
  companyId: string
  storeId: string
  date: string
  serviceIds: string[]
  staffId?: string
}

export interface FetchReservationSlotsOptions {
  companyId: string
  storeId: string
  date: string
  partySize: number
  serviceId?: string
}

export interface CreateHoldOptions {
  companyId: string
  storeId: string
  serviceIds: string[]
  date: string
  slotTime: string
  personId?: string
}

export interface ConfirmBookingOptions {
  companyId: string
  storeId: string
  holdId: string
  customerDetails: {
    name: string
    email: string
    phone: string
  }
  notes?: string
}

export interface CreateReservationOptions {
  companyId: string
  storeId: string
  date: string
  time: string
  partySize: number
  serviceId?: string
  customerName: string
  customerPhone: string
  customerEmail?: string
  notes?: string
}

export interface HoldResult {
  success: boolean
  holdId?: string
  error?: string
}

export interface BookingResult {
  success: boolean
  bookingId?: string
  error?: string
}

export interface ReservationResult {
  success: boolean
  reservationId?: string
  error?: string
}

/**
 * Adapter interface — each host app injects its own API transport.
 */
export interface BookingFetchAdapter {
  fetchSlots(opts: FetchSlotsOptions): Promise<{ availableSlots: string[] }>
  fetchReservationSlots(opts: FetchReservationSlotsOptions): Promise<{ availableSlots: string[] }>
  createHold(opts: CreateHoldOptions): Promise<HoldResult>
  confirmBooking(opts: ConfirmBookingOptions): Promise<BookingResult>
  createReservation(opts: CreateReservationOptions): Promise<ReservationResult>
}

// ── Store context (set once by host) ──────────────────────────

export interface BookingStoreContext {
  companyId: string
  storeId: string
}

// ── Service types for the composable ──────────────────────────

export interface BookingService {
  id: string
  title: string
  bookingMode?: 'standard' | 'tableReservation' | 'ticketSystem'
  duration?: number
  price?: number
  currency?: string
  [key: string]: any
}

export interface BookingStaffMember {
  id: string
  displayName: string
  avatarUrl?: string
  title?: string
  [key: string]: any
}

// ── Composable ────────────────────────────────────────────────

export function useBookingState(adapter: BookingFetchAdapter) {
  // ── Store context ──
  const storeContext = ref<BookingStoreContext | null>(null)

  // ── Slideover UI state ──
  const isOpen = ref(false)
  const selectedService = ref<BookingService | null>(null)
  const selectedStaff = ref<BookingStaffMember | null>(null)
  const preExpandedGroup = ref<string | undefined>(undefined)

  // ── Slot state ──
  const slots = ref<string[]>([])
  const slotsLoading = ref(false)
  const slotsError = ref<string | null>(null)

  // ── Hold state ──
  const holdId = ref<string | null>(null)
  const holdExpiresAt = ref<Date | null>(null)

  // ── Confirmation state ──
  const confirmedBooking = ref<BookingDetails | null>(null)
  const confirming = ref(false)

  // ── All-selected service IDs (for multi-select) ──
  const slideoverRef = ref<{ allSelectedServiceIds: string[] } | null>(null)

  // ── Setup ──────────────────────────────────────────────────

  function setStoreContext(ctx: BookingStoreContext) {
    storeContext.value = ctx
  }

  // ── Helpers ──────────────────────────────────────────────────

  function formatDateForAPI(date: Date): string {
    const y = date.getFullYear()
    const m = String(date.getMonth() + 1).padStart(2, '0')
    const d = String(date.getDate()).padStart(2, '0')
    return `${y}-${m}-${d}`
  }

  function getAllServiceIds(): string[] {
    return slideoverRef.value?.allSelectedServiceIds ?? (selectedService.value ? [selectedService.value.id] : [])
  }

  // ── Actions ─────────────────────────────────────────────────

  /**
   * Open the booking slideover (optionally with a preselected service).
   */
  function open(opts?: {
    service?: BookingService | null
    staff?: BookingStaffMember | null
    groupName?: string
  }) {
    selectedService.value = opts?.service ?? null
    selectedStaff.value = opts?.staff ?? null
    preExpandedGroup.value = opts?.groupName
    isOpen.value = true
  }

  /**
   * Close the slideover and reset transient state.
   */
  function close() {
    isOpen.value = false
    confirmedBooking.value = null
  }

  /**
   * Handle service selection inside the slideover — fetches slots for today.
   */
  async function handleServiceSelected(service: BookingService) {
    selectedService.value = service

    if (!storeContext.value) return

    const today = new Date()
    const serviceIds = getAllServiceIds()

    slotsLoading.value = true
    slotsError.value = null

    try {
      if (service.bookingMode === 'tableReservation') {
        const result = await adapter.fetchReservationSlots({
          companyId: storeContext.value.companyId,
          storeId: storeContext.value.storeId,
          date: formatDateForAPI(today),
          partySize: 2,
          serviceId: service.id,
        })
        slots.value = result.availableSlots || []
      } else {
        const result = await adapter.fetchSlots({
          companyId: storeContext.value.companyId,
          storeId: storeContext.value.storeId,
          date: formatDateForAPI(today),
          serviceIds,
          staffId: selectedStaff.value?.id,
        })
        slots.value = result.availableSlots || []
      }
    } catch (err: any) {
      console.error('[useBookingState] Error fetching slots:', err)
      const isNetwork = err?.name === 'FetchError' && err?.message?.includes('fetch failed')
      slotsError.value = isNetwork
        ? 'Unable to reach the server. Please check your connection.'
        : 'Failed to fetch available time slots. Please try again.'
      slots.value = []
    } finally {
      slotsLoading.value = false
    }
  }

  /**
   * Handle staff selection — re-fetches slots with staff filter.
   */
  async function handleStaffSelected(staff: BookingStaffMember | null) {
    selectedStaff.value = staff

    if (!selectedService.value || !storeContext.value) return

    const today = new Date()
    const serviceIds = getAllServiceIds()

    slotsLoading.value = true
    slotsError.value = null

    try {
      if (selectedService.value.bookingMode === 'tableReservation') {
        const result = await adapter.fetchReservationSlots({
          companyId: storeContext.value.companyId,
          storeId: storeContext.value.storeId,
          date: formatDateForAPI(today),
          partySize: 2,
          serviceId: selectedService.value.id,
        })
        slots.value = result.availableSlots || []
      } else {
        const result = await adapter.fetchSlots({
          companyId: storeContext.value.companyId,
          storeId: storeContext.value.storeId,
          date: formatDateForAPI(today),
          serviceIds,
          staffId: staff?.id,
        })
        slots.value = result.availableSlots || []
      }
    } catch (err: any) {
      console.error('[useBookingState] Error fetching slots:', err)
      slotsError.value = 'Failed to fetch available time slots. Please try again.'
      slots.value = []
    } finally {
      slotsLoading.value = false
    }
  }

  /**
   * Handle date change — re-fetches slots for the new date.
   */
  async function handleDateChange(payload: any) {
    if (!storeContext.value || !selectedService.value) return

    const date = payload instanceof Date ? payload : payload.date
    const guestCount = payload instanceof Date ? 2 : (payload.guestCount || 2)
    const serviceIds = getAllServiceIds()

    slotsLoading.value = true
    slotsError.value = null

    try {
      if (selectedService.value.bookingMode === 'tableReservation') {
        const result = await adapter.fetchReservationSlots({
          companyId: storeContext.value.companyId,
          storeId: storeContext.value.storeId,
          date: formatDateForAPI(date),
          partySize: guestCount,
          serviceId: selectedService.value.id,
        })
        slots.value = result.availableSlots || []
      } else {
        const result = await adapter.fetchSlots({
          companyId: storeContext.value.companyId,
          storeId: storeContext.value.storeId,
          date: formatDateForAPI(date),
          serviceIds,
          staffId: selectedStaff.value?.id,
        })
        slots.value = result.availableSlots || []
      }
    } catch (err: any) {
      console.error('[useBookingState] Error fetching slots:', err)
      slotsError.value = 'Failed to fetch available time slots. Please try again.'
      slots.value = []
    } finally {
      slotsLoading.value = false
    }
  }

  /**
   * Handle hold expiration.
   */
  function handleHoldExpired() {
    clearBookingState()
  }

  /**
   * Clear transient booking state (hold, confirmed booking).
   */
  function clearBookingState() {
    holdId.value = null
    holdExpiresAt.value = null
    slotsError.value = null
  }

  /**
   * Handle "clear staff" — re-fetches without staff filter.
   */
  async function handleClearStaff() {
    selectedStaff.value = null
    if (selectedService.value && storeContext.value) {
      const today = new Date()
      try {
        const result = await adapter.fetchSlots({
          companyId: storeContext.value.companyId,
          storeId: storeContext.value.storeId,
          date: formatDateForAPI(today),
          serviceIds: getAllServiceIds(),
        })
        slots.value = result.availableSlots || []
      } catch {
        // Non-critical
      }
    }
  }

  function handleViewBookings() {
    confirmedBooking.value = null
    isOpen.value = false
  }

  function handleDone() {
    confirmedBooking.value = null
    isOpen.value = false
  }

  // ── Computed: slideover props ────────────────────────────────

  /**
   * All the props needed by BookingSlideover, ready to v-bind.
   */
  const slideoverProps = computed(() => ({
    preselectedService: selectedService.value,
    availableSlots: slots.value,
    slotsLoading: slotsLoading.value,
    slotsError: slotsError.value,
    holdExpiresAt: holdExpiresAt.value,
    confirmedBooking: confirmedBooking.value,
    confirming: confirming.value,
    preselectedStaff: selectedStaff.value,
    preExpandedGroup: preExpandedGroup.value,
  }))

  /**
   * All the event handlers needed by BookingSlideover, ready to v-on.
   */
  const slideoverEvents = computed(() => ({
    'date-change': handleDateChange,
    'service-selected': handleServiceSelected,
    'staff-selected': handleStaffSelected,
    'hold-expired': handleHoldExpired,
    'view-bookings': handleViewBookings,
    done: handleDone,
    'clear-staff': handleClearStaff,
  }))

  return {
    // State
    isOpen,
    selectedService,
    selectedStaff,
    preExpandedGroup,
    slots,
    slotsLoading,
    slotsError,
    holdId,
    holdExpiresAt,
    confirmedBooking,
    confirming,
    slideoverRef,

    // Setup
    setStoreContext,
    storeContext,

    // Actions
    open,
    close,
    handleServiceSelected,
    handleStaffSelected,
    handleDateChange,
    handleHoldExpired,
    handleClearStaff,
    handleViewBookings,
    handleDone,
    clearBookingState,
    formatDateForAPI,
    getAllServiceIds,

    // Computed bindings
    slideoverProps,
    slideoverEvents,

    // Adapter (exposed for the confirm handler which stays in the host)
    adapter,
  }
}
