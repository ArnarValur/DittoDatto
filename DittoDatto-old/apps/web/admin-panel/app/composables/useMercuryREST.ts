import { useCurrentUser } from 'vuefire'

// ── Response types ──────────────────────────────────────────────────────
export interface MercuryHealthResponse {
  status: string
  service: string
  version: string
  timestamp: string
}

export interface MercuryCleanupStats {
  totalHolds: number
  expiredHolds: number
  timestamp: string
}

export interface MercuryHoldResponse {
  success: boolean
  holdId: string
  expiresAt?: string
  [key: string]: unknown
}

export interface MercuryBookingResponse {
  success: boolean
  bookingId: string
  [key: string]: unknown
}

export interface MercuryCancelResponse {
  success: boolean
  message?: string
  [key: string]: unknown
}

export interface MercuryReservationResponse {
  success: boolean
  reservationId: string
  [key: string]: unknown
}

// ── Composable ──────────────────────────────────────────────────────────
export function useMercuryREST() {
  const user = useCurrentUser()
  const runtimeConfig = useRuntimeConfig()

  // Base URL from env, fallback to localhost:5002 (MercuryEngine dev port)
  const baseURL = runtimeConfig.public.mercuryUrl || 'http://localhost:5002'

  /**
   * Wrapper around ofetch that auto-injects Firebase Auth token
   */
  async function fetchFromMercury<T>(path: string, options: any = {}): Promise<T> {
    const headers = { ...options.headers }

    // Inject auth token if user is logged in
    if (user.value) {
      try {
        const token = await user.value.getIdToken()
        headers.Authorization = `Bearer ${token}`
      } catch (err) {
        console.warn('[useMercuryREST] Failed to get auth token', err)
      }
    }

    // Make request via ofetch (Nuxt's $fetch)
    // Cast needed: $fetch returns TypedInternalResponse which wraps T at compile-time
    return await $fetch(path, {
      ...options,
      baseURL,
      headers
    }) as T
  }

  // ── Appointments ────────────────────────────────────────────────────

  /** GET /appointments/slots — Fetch available booking slots */
  async function getSlots(companyId: string, storeId: string, date: string, serviceIds: string[], staffId?: string) {
    const params: Record<string, string> = {
      companyId,
      storeId,
      date,
      serviceIds: serviceIds.join(',')
    }
    if (staffId) params.staffId = staffId

    const res = await fetchFromMercury<{ date: string, availableSlots: string[] }>('/appointments/slots', {
      query: params
    })
    return res.availableSlots
  }

  /** POST /appointments/holds — Create a hold on a time slot (10-min TTL) */
  async function createHold(companyId: string, storeId: string, serviceIds: string[], date: string, slotTime: string, staffId?: string) {
    return await fetchFromMercury<MercuryHoldResponse>('/appointments/holds', {
      method: 'POST',
      body: { companyId, storeId, serviceIds, date, slotTime, staffId }
    })
  }

  /** POST /appointments/bookings — Confirm booking from hold */
  async function createBooking(holdId: string, paymentId: string) {
    return await fetchFromMercury<MercuryBookingResponse>('/appointments/bookings', {
      method: 'POST',
      body: { holdId, paymentId }
    })
  }

  /** POST /appointments/bookings/:id/cancel — Cancel a booking */
  async function cancelBooking(bookingId: string, reason?: string) {
    return await fetchFromMercury<MercuryCancelResponse>(`/appointments/bookings/${bookingId}/cancel`, {
      method: 'POST',
      body: reason ? { reason } : {}
    })
  }

  // ── Reservations ────────────────────────────────────────────────────

  /** GET /reservations/availability — Fetch table/slot availability */
  async function getReservationAvailability(companyId: string, storeId: string, date: string, partySize?: number, serviceId?: string) {
    const params: Record<string, string> = { companyId, storeId, date }
    if (partySize) params.partySize = String(partySize)
    if (serviceId) params.serviceId = serviceId

    const res = await fetchFromMercury<{ date: string, availableSlots: Array<{ time: string, available: boolean, remainingCapacity: number }> }>('/reservations/availability', {
      query: params
    })
    return res.availableSlots
  }

  /** POST /reservations — Create a table reservation */
  async function createReservation(data: {
    companyId: string
    storeId: string
    date: string
    time: string
    partySize: number
    customerName: string
    customerPhone?: string
    notes?: string
    serviceId?: string
  }) {
    return await fetchFromMercury<MercuryReservationResponse>('/reservations', {
      method: 'POST',
      body: data
    })
  }

  // ── Engine Health ───────────────────────────────────────────────────

  /** GET /health — Engine health check */
  async function getHealthCheck() {
    return await fetchFromMercury<MercuryHealthResponse>('/health')
  }

  /** GET /cleanup/stats — Hold cleanup statistics */
  async function getCleanupStats() {
    return await fetchFromMercury<MercuryCleanupStats>('/cleanup/stats')
  }

  return {
    fetchFromMercury,
    // Appointments
    getSlots,
    createHold,
    createBooking,
    cancelBooking,
    // Reservations
    getReservationAvailability,
    createReservation,
    // Health
    getHealthCheck,
    getCleanupStats
  }
}
