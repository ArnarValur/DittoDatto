import { collection, query, where, orderBy } from 'firebase/firestore'
import { useFirestore, useCollection } from 'vuefire'
import type { Booking } from '@dittodatto/shared-types'

/**
 * Fetches all bookings for a specific customer across the company.
 * Matches by userId (preferred) or userEmail (fallback).
 */
export function useCustomerBookings(
  customerId: Ref<string | null>,
  customerUserId: Ref<string | undefined>,
  customerEmail: Ref<string | undefined>,
) {
  const db = useFirestore()
  const { companyId } = useCompany()

  // Query bookings by userId or email
  const bookingsRef = computed(() => {
    if (!companyId.value || !customerId.value) return null

    const bookingsCol = collection(db, 'bookings')

    // Prefer userId if available (most reliable match)
    if (customerUserId.value) {
      return query(
        bookingsCol,
        where('companyId', '==', companyId.value),
        where('userId', '==', customerUserId.value),
        orderBy('startTime', 'desc'),
      )
    }

    // Fallback to email match
    if (customerEmail.value) {
      return query(
        bookingsCol,
        where('companyId', '==', companyId.value),
        where('userEmail', '==', customerEmail.value),
        orderBy('startTime', 'desc'),
      )
    }

    return null
  })

  const { data: bookings, pending: loading } = useCollection<Booking>(
    bookingsRef,
    { ssrKey: `customerBookings-${customerId.value}` }
  )

  // Computed stats
  const totalSpent = computed(() =>
    (bookings.value ?? []).reduce((sum, b) => sum + (b.priceAtTimeOfBooking ?? 0), 0)
  )

  const completedCount = computed(() =>
    (bookings.value ?? []).filter(b => b.status === 'confirmed' || b.status === 'completed').length
  )

  const cancelledCount = computed(() =>
    (bookings.value ?? []).filter(b => b.status === 'cancelled').length
  )

  return {
    bookings,
    loading,
    totalSpent,
    completedCount,
    cancelledCount,
  }
}
