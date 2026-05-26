// packages/functions/src/MercuryEngine/data.ts
// Core Domain: Booking Context - Parallel Data Fetching
// Migrated from: .docs/project-context/BookingScripts/src/services/booking/data.ts

import { db } from "../../config/firebase.js";
import { Store, Booking, Hold, Service, StaffMember, Resource, ResourceGroup } from "@dittodatto/shared-types";

/**
 * MercuryEngine - Fetch Availability Data
 * Parallel fetching of all data needed for slot calculation.
 * Optimized with Promise.all for minimum latency.
 *
 * @param companyId - The company that owns the store
 * @param storeId - The store to fetch data for
 * @param date - Date string in YYYY-MM-DD format
 * @param serviceIds - Array of service IDs to check
 * @param staffId - Optional specific staff member to filter by
 * @returns Object containing store, bookings, holds, services, and staff
 */
export const fetchAvailabilityData = async (
  companyId: string,
  storeId: string,
  date: string,
  serviceIds: string[],
  staffId?: string
) => {
  // Calculate start/end of the day (Midnight to Midnight)
  // Format matches booking.ts which stores startTime as timezone-naive strings: "2026-03-13T14:00:00"
  const startOfDay = `${date}T00:00:00`;
  const endOfDay = `${date}T23:59:59`;

  // Build staff query — either specific staff member or all bookable staff for this store
  const staffQuery = staffId
    ? db.doc(`companies/${companyId}/staff/${staffId}`).get()
    : db
        .collection(`companies/${companyId}/staff`)
        .where("isBookable", "==", true)
        .where("status", "==", "active")
        .get();

  // Parallel Fetching (Optimized for latency)
  const [storeDoc, bookingsSnap, holdsSnap, servicesSnap, staffResult, resourcesSnap, resourceGroupsSnap] = await Promise.all([
    // 1. Store Document (Opening Hours)
    db.doc(`companies/${companyId}/stores/${storeId}`).get(),

    // 2. Bookings for the Date
    db
      .collection("bookings")
      .where("storeId", "==", storeId)
      .where("startTime", ">=", startOfDay)
      .where("startTime", "<=", endOfDay)
      .get(),

    // 3. Active Holds for the Date
    db
      .collection("holds")
      .where("storeId", "==", storeId)
      .where("date", "==", date)
      .get(),

    // 4. Services (To calculate total duration)
    Promise.all(
      serviceIds.map((sid: string) =>
        db.doc(`companies/${companyId}/stores/${storeId}/services/${sid}`).get()
      )
    ),

    // 5. Bookable Staff
    staffQuery,

    // 6. Bookable Resources for this store
    db
      .collection(`companies/${companyId}/stores/${storeId}/resources`)
      .where("isBookable", "==", true)
      .get(),

    // 7. Resource Groups for this store
    db
      .collection(`companies/${companyId}/stores/${storeId}/resourceGroups`)
      .get(),
  ]);

  if (!storeDoc.exists) {
    throw new Error(`Store ${storeId} not found`);
  }

  // Normalize staff result — single doc get vs collection query
  let staff: StaffMember[] = [];
  if ("docs" in staffResult) {
    // Collection query result
    staff = staffResult.docs
      .map((d) => ({ id: d.id, ...d.data() } as StaffMember))
      .filter((s) => s.storeIds?.includes(storeId));
  } else if (staffResult.exists) {
    // Single document get result
    const s = { id: staffResult.id, ...staffResult.data() } as StaffMember;
    if (s.isBookable && s.status === "active" && s.storeIds?.includes(storeId)) {
      staff = [s];
    }
  }

  // Return Typed Data
  return {
    store: storeDoc.data() as Store,
    bookings: bookingsSnap.docs
      .map((d) => d.data() as Booking)
      .filter((b) => b.status === "confirmed" || b.status === "pending"),
    holds: holdsSnap.docs
      .map((d) => d.data() as Hold)
      .filter((h) => {
        // Only include holds that haven't expired
        if (!h.expiresAt) return true; // Legacy holds without expiresAt — keep them
        return new Date(h.expiresAt).getTime() > Date.now();
      }),
    services: servicesSnap
      .filter((d) => d.exists)
      .map((d) => ({ id: d.id, ...d.data() } as Service)),
    staff,
    resources: resourcesSnap.docs.map((d) => ({ id: d.id, ...d.data() } as Resource)),
    resourceGroups: resourceGroupsSnap.docs.map((d) => ({ id: d.id, ...d.data() } as ResourceGroup)),
  };
};
