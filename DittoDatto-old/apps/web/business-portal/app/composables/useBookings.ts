/**
 * useBookings Composable
 *
 * Fetches bookings for the active company with CRUD actions and filtering.
 * Collection: 'bookings' filtered by companyId.
 */
import type { Booking, BookingStatus } from '@dittodatto/shared-types'
import { collection, query, where, orderBy, limit, doc, updateDoc, serverTimestamp } from 'firebase/firestore'
import { useFirestore, useCollection } from 'vuefire'

export function useBookings(options?: { limit?: number }) {
  const db = useFirestore()
  const { companyId, loading: companyLoading } = useCompany()
  const { fetchFromMercury } = useMercuryREST()
  const toast = useToast()

  // ---- Filters ----
  const statusFilter = ref<BookingStatus | 'all'>('all')
  const storeFilter = ref<string | null>(null)
  const staffFilter = ref<string | null>(null)

  // Create query when companyId is available
  const bookingsQuery = computed(() => {
    if (!companyId.value) return null

    let q = query(
      collection(db, 'bookings'),
      where('companyId', '==', companyId.value),
      orderBy('startTime', 'desc')
    )

    if (options?.limit) {
      q = query(q, limit(options.limit))
    }

    return q
  })

  // Use VueFire's useCollection for reactive Firestore binding
  const { data: allBookings, pending: bookingsLoading } = useCollection<Booking>(bookingsQuery)

  // Client-side filtered bookings
  const bookings = computed(() => {
    let result = allBookings.value ?? []

    if (statusFilter.value !== 'all') {
      result = result.filter(b => b.status === statusFilter.value)
    }

    if (storeFilter.value) {
      result = result.filter(b => b.storeId === storeFilter.value)
    }

    if (staffFilter.value) {
      result = result.filter(b => (b.staffId || b.personId) === staffFilter.value)
    }

    return result
  })

  // Computed stats (always from full set)
  const stats = computed(() => {
    const all = allBookings.value ?? []
    return {
      total: all.length,
      confirmed: all.filter(b => b.status === 'confirmed').length,
      pending: all.filter(b => b.status === 'pending').length,
      completed: all.filter(b => b.status === 'completed').length
    }
  })

  // ---- Actions ----

  async function updateBookingStatus(bookingId: string, status: BookingStatus, reason?: string) {
    if (status === 'cancelled') {
        try {
            await fetchFromMercury(`/appointments/bookings/${bookingId}/cancel`, {
                method: 'POST',
                body: reason ? { reason } : undefined
            })
            toast.add({ title: 'Booking updated', description: `Status changed to ${status}` })
            return
        } catch (error) {
            toast.add({ title: 'Error cancelling booking', description: 'Please try again', color: 'red' })
            throw error
        }
    }

    const updates: Record<string, any> = {
      status,
      updatedAt: serverTimestamp()
    }

    await updateDoc(doc(db, 'bookings', bookingId), updates)
    toast.add({ title: 'Booking updated', description: `Status changed to ${status}` })
  }

  async function assignStaff(bookingId: string, staffId: string | null) {
    await updateDoc(doc(db, 'bookings', bookingId), {
      staffId: staffId || null,
      updatedAt: serverTimestamp()
    })
    toast.add({ title: 'Staff assigned', description: staffId ? 'Staff member assigned to booking' : 'Staff assignment removed' })
  }

  async function updateNotes(bookingId: string, notes: string) {
    await updateDoc(doc(db, 'bookings', bookingId), {
      notes,
      updatedAt: serverTimestamp()
    })
    toast.add({ title: 'Notes saved' })
  }

  return {
    // Data
    bookings,
    allBookings,
    stats,

    // Filters
    statusFilter,
    storeFilter,
    staffFilter,

    // Actions
    updateBookingStatus,
    assignStaff,
    updateNotes,

    // State
    loading: computed(() => companyLoading.value || bookingsLoading.value),
    isEmpty: computed(() => !bookingsLoading.value && (!allBookings.value || allBookings.value.length === 0))
  }
}
