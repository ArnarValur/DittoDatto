import { ref } from 'vue'
import { useMercuryREST } from './useMercuryREST'

interface FetchSlotsOptions {
  companyId: string
  storeId: string
  date: string
  serviceIds: string[]
  staffId?: string
}

interface CreateHoldOptions {
  companyId: string
  storeId: string
  serviceIds: string[]
  date: string
  slotTime: string
  staffId?: string
}

interface ConfirmBookingOptions {
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

interface FetchReservationSlotsOptions {
  companyId: string
  storeId: string
  date: string
  partySize: number
  serviceId?: string
}

interface CreateReservationOptions {
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

/**
 * Manages the booking process by interacting with MercuryEngine cloud functions.
 */
export function useBooking() {
  const { fetchFromMercury } = useMercuryREST()

  // Reactive state for the booking flow
  const slots = ref<string[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)
  const holdId = ref<string | null>(null)
  const holdExpiresAt = ref<Date | null>(null)
  const reservationId = ref<string | null>(null)

  /**
   * Fetches available time slots from MercuryEngine.
   */
  async function fetchSlots(options: FetchSlotsOptions) {
    loading.value = true
    error.value = null
    try {
      const result = await fetchFromMercury<{ availableSlots: string[] }>('/appointments/slots', {
        method: 'GET',
        query: options
      })
      slots.value = result.availableSlots || []
    } catch (err: any) {
      console.error('Error fetching slots:', err)
      const isNetwork = err?.name === 'FetchError' && err?.message?.includes('fetch failed')
      error.value = isNetwork 
        ? 'Unable to reach the server. Please check your connection.' 
        : 'Failed to fetch available time slots. Please try again.'
      slots.value = []
    } finally {
      loading.value = false
    }
  }

  /**
   * Fetches available reservation slots from MercuryEngine for tables/capacity.
   */
  async function fetchReservationSlots(options: FetchReservationSlotsOptions) {
    loading.value = true
    error.value = null
    try {
      const result = await fetchFromMercury<{ availableSlots: string[] }>('/reservations/availability', {
        method: 'GET',
        query: options
      })
      slots.value = result.availableSlots || []
    } catch (err: any) {
      console.error('Error fetching reservation slots:', err)
      const isNetwork = err?.name === 'FetchError' && err?.message?.includes('fetch failed')
      error.value = isNetwork 
        ? 'Unable to reach the server. Please check your connection.' 
        : 'Failed to fetch available time slots. Please try again.'
      slots.value = []
    } finally {
      loading.value = false
    }
  }

  /**
   * Creates a hold on a selected time slot.
   */
  async function createHold(options: CreateHoldOptions) {
    loading.value = true
    error.value = null
    try {
      const result = await fetchFromMercury<any>('/appointments/holds', {
        method: 'POST',
        body: options
      })
      if (result.holdId) {
        holdId.value = result.holdId
        holdExpiresAt.value = new Date(Date.now() + 10 * 60 * 1000) // Set 10-minute expiry
      }
      return result
    } catch (err: any) {
      console.error('Error creating hold:', err)
      // Use engine error message when available (e.g. "Must book at least 60 minutes in advance")
      const engineMessage = err?.data?.error
      if (engineMessage) {
        error.value = engineMessage
      } else {
        const isConflict = err?.response?.status === 409 || err?.message?.includes('conflict')
        error.value = isConflict
          ? 'This time slot was just booked by someone else. Please choose another.'
          : 'This time slot may no longer be available. Please try another.'
      }
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Converts an active hold into a confirmed booking.
   */
  async function confirmBooking(options: ConfirmBookingOptions) {
    loading.value = true
    error.value = null
    try {
      const mockPaymentId = `mock_${Date.now()}`
      const result = await fetchFromMercury<any>('/appointments/bookings', {
        method: 'POST',
        body: {
          ...options,
          paymentId: mockPaymentId
        }
      })
      
      // Clear state on successful booking
      if (result?.bookingId) {
        holdId.value = null
        holdExpiresAt.value = null
      }
      
      return result
    } catch (err: any) {
      console.error('Error confirming booking:', err)
      const isHoldExpired = err?.response?.status === 404 || err?.message?.includes('expired')
      error.value = isHoldExpired
        ? 'Your hold has expired. Please select a new time slot.'
        : 'There was an issue confirming your booking. Please try again.'
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Creates an immediate reservation securely.
   */
  async function createReservation(options: CreateReservationOptions) {
    loading.value = true
    error.value = null
    try {
      const result = await fetchFromMercury<any>('/reservations', {
        method: 'POST',
        body: options
      })
      
      if (result?.reservationId) {
        reservationId.value = result.reservationId
      }
      
      return result
    } catch (err: any) {
      console.error('Error creating reservation:', err)
      const engineMessage = err?.data?.error
      if (engineMessage) {
        error.value = engineMessage
      } else {
        const isConflict = err?.response?.status === 409 || err?.message?.includes('conflict') || err?.message?.includes('resource-exhausted')
        error.value = isConflict
          ? 'This time slot or table is no longer available. Please select another time.'
          : 'There was an issue confirming your reservation. Please try again.'
      }
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Clears the current booking hold state.
   */
  function clearBookingState() {
    holdId.value = null
    holdExpiresAt.value = null
    reservationId.value = null
    error.value = null
  }

  return {
    slots,
    loading,
    error,
    holdId,
    holdExpiresAt,
    reservationId,
    fetchSlots,
    fetchReservationSlots,
    createHold,
    confirmBooking,
    createReservation,
    clearBookingState
  }
}
