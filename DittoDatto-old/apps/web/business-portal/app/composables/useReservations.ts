import type { Reservation } from "@dittodatto/shared-types";

/**
 * useReservations — reactive Firestore collection of Reservations.
 *
 * Firestore path: companies/{companyId}/reservations
 *
 * This is the RESTAURANT reservation system (separate from the service booking system).
 * Uses the ReservationSchema with guestCount, tableId, customerName, etc.
 */
export function useReservations() {
  const { companyId } = useCompany();
  const firestore = useFirestore();

  const allReservations = ref<Reservation[]>([]);
  const loading = ref(true);

  async function fetchReservations(cid?: string | null) {
    const id = cid ?? companyId.value;
    if (!id) {
      allReservations.value = [];
      loading.value = false;
      return;
    }

    loading.value = true;

    try {
      const { collection, getDocs } = await import("firebase/firestore");

      const snap = await getDocs(
        collection(firestore, "companies", id, "reservations"),
      );

      const reservations: Reservation[] = [];
      for (const doc of snap.docs) {
        reservations.push({ id: doc.id, ...doc.data() } as Reservation);
      }

      allReservations.value = reservations;
    } catch (e) {
      console.error("[useReservations] Failed to fetch reservations:", e);
      allReservations.value = [];
    } finally {
      loading.value = false;
    }
  }

  // Watch for company changes and fetch reservations
  watch(companyId, (cid) => fetchReservations(cid), { immediate: true });

  /**
   * Filter reservations by store and date string (YYYY-MM-DD).
   * Handles both ISO string dates and Firestore Timestamps.
   */
  function reservationsByDate(storeId: string, dateStr: string): Reservation[] {
    return allReservations.value.filter((r) => {
      if (r.storeId !== storeId) return false;
      // Handle Firestore Timestamp or ISO string
      const rDate = coerceToDateStr(r.date);
      return rDate === dateStr;
    });
  }

  function reservationsByStore(storeId: string): Reservation[] {
    return allReservations.value.filter((r) => r.storeId === storeId);
  }

  async function updateReservation(id: string, updates: Partial<Reservation>) {
    if (!companyId.value) return false;
    try {
      const { doc, updateDoc } = await import("firebase/firestore");
      const ref = doc(firestore, "companies", companyId.value, "reservations", id);
      
      // Strip undefined values — Firestore rejects them.
      // (deleteField() sentinels are valid and pass through)
      const sanitized = Object.fromEntries(
        Object.entries(updates).filter(([, v]) => v !== undefined),
      );
      
      await updateDoc(ref, {
        ...sanitized,
        updatedAt: new Date().toISOString(),
      });
      
      // Update local state optimistically
      const existing = allReservations.value.find((r) => r.id === id);
      if (existing) {
        Object.assign(existing, updates);
      }
      return true;
    } catch (e) {
      console.error("[useReservations] update failed:", e);
      return false;
    }
  }

  async function cancelReservation(id: string) {
    if (!companyId.value) return false;
    try {
      const { doc, updateDoc } = await import("firebase/firestore");
      const ref = doc(firestore, "companies", companyId.value, "reservations", id);
      await updateDoc(ref, {
        status: "cancelled",
        updatedAt: new Date().toISOString(),
      });
      // Remove from local state so it disappears from timeline immediately
      allReservations.value = allReservations.value.filter((r) => r.id !== id);
      return true;
    } catch (e) {
      console.error("[useReservations] cancel failed:", e);
      return false;
    }
  }

  return {
    allReservations,
    loading,
    fetchReservations,
    reservationsByDate,
    reservationsByStore,
    updateReservation,
    cancelReservation,
  };
}

/** Coerce Firestore Timestamp | Date | string → "YYYY-MM-DD" */
function coerceToDateStr(val: any): string {
  if (typeof val === "string") return val.slice(0, 10);
  if (val?.toDate) return val.toDate().toISOString().slice(0, 10);
  if (val instanceof Date) return val.toISOString().slice(0, 10);
  return "";
}
