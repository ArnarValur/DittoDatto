
import { ref, computed } from 'vue';
import { useFirestore, useCurrentUser } from 'vuefire';
import { collection, collectionGroup, query, where, getDocs, orderBy, doc, getDoc } from 'firebase/firestore';
import type { Booking, BookingPolicy } from '@dittodatto/shared-types';

/**
 * Composable for fetching and managing a user's bookings AND reservations.
 * Reservations (table bookings at restaurants) are normalized to Booking shape
 * so they display alongside standard bookings in the profile.
 */
export function useUserBookings() {
  const db = useFirestore();
  const user = useCurrentUser();

  // State
  const bookings = ref<Booking[]>([]);
  const loading = ref(false);
  const error = ref<string | null>(null);
  const cancelling = ref(false);
  const storePolicies = ref<Record<string, BookingPolicy>>({});

  /**
   * Fetches all bookings AND reservations for the current authenticated user.
   */
  async function fetchBookings() {
    if (!user.value) {
      bookings.value = [];
      return;
    }

    loading.value = true;
    error.value = null;
    
    try {
      // 1. Standard bookings (top-level collection)
      const bookingsQuery = query(
        collection(db, 'bookings'),
        where('userId', '==', user.value.uid),
        orderBy('startTime', 'desc')
      );
      
      const snapshot = await getDocs(bookingsQuery);
      const standardBookings = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Booking));

      // 2. Reservations (subcollection via collectionGroup)
      let reservationBookings: Booking[] = [];
      try {
        const resQuery = query(
          collectionGroup(db, 'reservations'),
          where('customerId', '==', user.value.uid),
        );
        const resSnapshot = await getDocs(resQuery);
        reservationBookings = resSnapshot.docs.map(d => {
          const data = d.data();
          return normalizeReservationToBooking(d.id, data);
        });
      } catch (resErr: any) {
        // Non-fatal — collectionGroup may need index setup
        console.warn('[useUserBookings] Failed to fetch reservations (collectionGroup index may be missing):', resErr.message);
      }

      // 3. Merge and sort (newest first)
      bookings.value = [...standardBookings, ...reservationBookings]
        .sort((a, b) => new Date(b.startTime).getTime() - new Date(a.startTime).getTime());
    } catch (err: any) {
      console.error("Error fetching user bookings:", err);
      error.value = "Failed to load bookings.";
      if (err.code === 'failed-precondition') {
          console.error("Firestore index missing: You need a composite index on 'bookings' for 'userId' (ASC) and 'startTime' (DESC).");
          error.value = "Failed to load bookings due to a database configuration issue.";
      }
    } finally {
      loading.value = false;
    }

    // Fetch booking policies for all unique stores (fire-and-forget, non-blocking)
    fetchStorePolicies();
  }

  const { fetchFromMercury } = useMercuryREST();

  /**
   * Cancels a booking by calling the MercuryEngine REST API.
   * Returns true on success, false on failure.
   */
  async function cancelBooking(bookingId: string): Promise<boolean> {
    cancelling.value = true;
    try {
      await fetchFromMercury(`/appointments/bookings/${bookingId}/cancel`, {
        method: 'POST'
      });
      // Refresh list to reflect the change
      await fetchBookings();
      return true;
    } catch (err: any) {
      console.error('Error cancelling booking:', err);
      return false;
    } finally {
      cancelling.value = false;
    }
  }

  /**
   * Computed property to filter for upcoming bookings.
   */
  const upcomingBookings = computed(() => 
    bookings.value
      .filter(b => new Date(b.startTime) > new Date() && b.status === 'confirmed')
      // Sort ascending (soonest first)
      .sort((a, b) => new Date(a.startTime).getTime() - new Date(b.startTime).getTime())
  );

  /**
   * Computed property to filter for past bookings.
   */
  const pastBookings = computed(() =>
    bookings.value
      .filter(b => new Date(b.startTime) <= new Date() || b.status !== 'confirmed')
       // Already sorted descending by the merge step
  );

  /**
   * Fetches bookingPolicy from each unique store referenced by the user's bookings.
   * Cached per storeId to avoid redundant reads.
   */
  async function fetchStorePolicies() {
    const seen = new Set<string>();
    for (const b of bookings.value) {
      const key = `${b.companyId}/${b.storeId}`;
      if (seen.has(key) || storePolicies.value[key]) continue;
      seen.add(key);
      try {
        const storeSnap = await getDoc(doc(db, 'companies', b.companyId, 'stores', b.storeId));
        if (storeSnap.exists()) {
          const data = storeSnap.data();
          storePolicies.value[key] = {
            clientCancelEnabled: data?.bookingPolicy?.clientCancelEnabled ?? true,
            minCancelNoticeHours: data?.bookingPolicy?.minCancelNoticeHours ?? 24,
            clientRescheduleEnabled: data?.bookingPolicy?.clientRescheduleEnabled ?? true,
            minRescheduleNoticeHours: data?.bookingPolicy?.minRescheduleNoticeHours ?? 24,
          } as BookingPolicy;
        }
      } catch {
        // Non-critical — defaults will apply
      }
    }
  }

  /**
   * Returns cancel eligibility for a specific booking, based on the store's bookingPolicy.
   * @returns { canCancel: boolean, reason?: string }
   */
  function getCancelStatus(booking: Booking): { canCancel: boolean; reason?: string } {
    const key = `${booking.companyId}/${booking.storeId}`;
    const policy = storePolicies.value[key];

    // No policy loaded yet → allow (engine will enforce)
    if (!policy) return { canCancel: true };

    if (!policy.clientCancelEnabled) {
      return { canCancel: false, reason: 'Denne bedriften tillater ikke avbestilling. Kontakt bedriften direkte.' };
    }

    if (policy.minCancelNoticeHours > 0) {
      const startTime = new Date(booking.startTime);
      const deadlineMs = startTime.getTime() - (policy.minCancelNoticeHours * 60 * 60 * 1000);
      if (Date.now() > deadlineMs) {
        const hoursLabel = policy.minCancelNoticeHours >= 24
          ? `${Math.floor(policy.minCancelNoticeHours / 24)} dag(er)`
          : `${policy.minCancelNoticeHours} time(r)`;
        return {
          canCancel: false,
          reason: `Avbestillingsfristen er utløpt. Du må avbestille minst ${hoursLabel} før timen.`
        };
      }
    }

    return { canCancel: true };
  }

  return {
    bookings,
    loading,
    error,
    cancelling,
    fetchBookings,
    cancelBooking,
    getCancelStatus,
    upcomingBookings,
    pastBookings,
  };
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/**
 * Normalize a Firestore reservation document into the Booking shape
 * so it can display in BookingCard alongside standard bookings.
 */
function normalizeReservationToBooking(id: string, data: any): Booking {
  // Parse date: could be Firestore Timestamp, Date, or ISO string
  let dateStr: string;
  if (typeof data.date === 'string') {
    dateStr = data.date.slice(0, 10);
  } else if (data.date?.toDate) {
    dateStr = data.date.toDate().toISOString().slice(0, 10);
  } else {
    dateStr = new Date(data.date).toISOString().slice(0, 10);
  }

  const startTime = `${dateStr}T${data.time}:00`;
  const [h, m] = data.time.split(':').map(Number);
  const endTotalMin = h * 60 + m + (data.duration || 60);
  const endH = String(Math.floor(endTotalMin / 60) % 24).padStart(2, '0');
  const endM = String(endTotalMin % 60).padStart(2, '0');
  const endTime = `${dateStr}T${endH}:${endM}:00`;

  // Map reservation status to booking status
  const statusMap: Record<string, string> = {
    confirmed: 'confirmed',
    pending: 'pending',
    seated: 'confirmed',
    completed: 'completed',
    cancelled: 'cancelled',
    no_show: 'no-show',
  };

  return {
    id,
    companyId: data.companyId || '',
    storeId: data.storeId || '',
    userId: data.customerId || '',
    startTime,
    endTime,
    serviceTitle: `🍽️ Reservasjon (${data.guestCount} gjester)`,
    status: (statusMap[data.status] || data.status) as Booking['status'],
    priceAtTimeOfBooking: 0,
    currency: 'NOK',
    // Extra fields that BookingCard doesn't strictly need but Booking type requires
    serviceId: '',
    staffId: '',
    staffName: '',
    duration: data.duration || 60,
    createdAt: data.createdAt || '',
    updatedAt: data.updatedAt || '',
  } as Booking;
}

