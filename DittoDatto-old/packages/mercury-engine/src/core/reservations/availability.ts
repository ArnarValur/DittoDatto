import { db } from "../../config/firebase.js";
import { Store, Reservation, Experience, Resource, ReservationConfig, Service } from "@dittodatto/shared-types";
import { generateTimeSlots, calculateSlotAvailability } from "./calculator.js";
import { HttpsError } from "../shared/errors.js";

interface AvailabilityRequest {
  companyId: string;
  storeId: string;
  date: string; // "YYYY-MM-DD"
  partySize: number;
  experienceId?: string; // Legacy — filter by specific experience
  serviceId?: string;    // Scopes table resources to the service's resource groups
}

interface TimeSlot {
  time: string;
  available: boolean;
  remainingCapacity: number;
  reason?: string;
  experienceId?: string;
}

export const getReservationAvailability = async (request: AvailabilityRequest) => {
    const { companyId, storeId, date, partySize, experienceId, serviceId } = request;

    // 1. Validate Input
    if (!companyId || !storeId || !date || !partySize) {
      throw new HttpsError("invalid-argument", "Missing required fields: companyId, storeId, date, partySize");
    }

    // 2. Fetch Store Config (correct company subcollection path)
    const storeDoc = await db
      .doc(`companies/${companyId}/stores/${storeId}`)
      .get();

    if (!storeDoc.exists) {
      throw new HttpsError("not-found", "Store not found");
    }

    const store = storeDoc.data() as Store;

    if (!store.reservationConfig) {
      throw new HttpsError("failed-precondition", "Table reservation not enabled for this store");
    }

    const config = store.reservationConfig;

    // 2b. Fetch table resources for auto-detection of pool vs table mode
    const resourcesSnap = await db
      .collection(`companies/${companyId}/stores/${storeId}/resources`)
      .where("type", "==", "table")
      .where("isBookable", "==", true)
      .get();

    const tableResources = resourcesSnap.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    })) as Resource[];

    // ---- P1 FIX: Scope tables by Service → ResourceGroup ----
    // When a serviceId is provided, only use tables that belong to
    // the service's requiredResourceGroupIds. This prevents a "Terrace"
    // reservation from being assigned an indoor table.
    let scopedTables = tableResources;

    if (serviceId) {
      const serviceDoc = await db
        .doc(`companies/${companyId}/stores/${storeId}/services/${serviceId}`)
        .get();

      if (serviceDoc.exists) {
        const service = serviceDoc.data() as Service;
        const requiredGroups = service.requiredResourceGroupIds || [];

        if (requiredGroups.length > 0) {
          scopedTables = tableResources.filter(
            (t) => t.resourceGroupId && requiredGroups.includes(t.resourceGroupId),
          );
        }
      }
    }

    const tableResourcesOrUndefined = scopedTables.length > 0 ? scopedTables : undefined;

    // 3. Fetch Experiences for this store
    const experiencesSnap = await db
      .collection(`companies/${companyId}/stores/${storeId}/experiences`)
      .where("isActive", "==", true)
      .get();

    let experiences = experiencesSnap.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    })) as Experience[];

    // Filter to specific experience if requested
    if (experienceId) {
      experiences = experiences.filter((e) => e.id === experienceId);
    }

    // Fallback: if no experiences defined, generate slots from store opening hours
    if (experiences.length === 0) {
      const { getDayName } = await import("../shared/time.js");
      const dayName = getDayName(date);
      const schedule = (store.openingSchedule as any)[dayName];

      if (!schedule || !schedule.isOpen) {
        return { slots: [] };
      }

      // Generate slots from store hours with no experience
      const slotOpts = {
        storeTimezone: store.timezone || 'Europe/Oslo',
        requestDate: date,
        noticeCutoffMinutes: store.bookingPolicy?.minBookingNoticeMinutes || 0,
      };
      const slots = generateTimeSlots(schedule.open, schedule.close, config.slotInterval, slotOpts);
      const allSlots: TimeSlot[] = [];
      const existingReservations = await fetchReservationsForDate(companyId, storeId, date);

      for (const time of slots) {
        const queryDate = new Date(date + "T00:00:00");
        const availability = calculateSlotAvailability(
          store,
          queryDate,
          time,
          config.defaultDuration,
          partySize,
          existingReservations,
          tableResourcesOrUndefined,
        );
        allSlots.push({
          time,
          available: availability.available,
          remainingCapacity: availability.remainingCapacity,
          reason: availability.reason,
        });
      }

      return { slots: allSlots };
    }

    // 4. Fetch Existing Reservations for Date (company subcollection)
    const existingReservations = await fetchReservationsForDate(companyId, storeId, date);

    // 5. Generate Slots for Each Experience
    const allSlots: TimeSlot[] = [];

    for (const exp of experiences) {
      const { startTime, endTime } = exp.operatingWindow;
      const duration = exp.duration || config.defaultDuration;
      const slotOpts = {
        storeTimezone: store.timezone || 'Europe/Oslo',
        requestDate: date,
        noticeCutoffMinutes: store.bookingPolicy?.minBookingNoticeMinutes || 0,
      };
      const slots = generateTimeSlots(startTime, endTime, config.slotInterval, slotOpts);

      for (const time of slots) {
        const queryDate = new Date(date + "T00:00:00");
        const availability = calculateSlotAvailability(
          store,
          queryDate,
          time,
          duration,
          partySize,
          existingReservations,
          tableResourcesOrUndefined,
        );

        allSlots.push({
          time,
          available: availability.available,
          remainingCapacity: availability.remainingCapacity,
          reason: availability.reason,
          experienceId: exp.id,
        });
      }
    }

    return { slots: allSlots };
  };

/**
 * Fetch reservations for a specific store and date.
 * Uses company subcollection: companies/{companyId}/reservations
 */
async function fetchReservationsForDate(
  companyId: string,
  storeId: string,
  date: string,
): Promise<Reservation[]> {
  const queryDateStart = new Date(date + "T00:00:00");
  const queryDateEnd = new Date(date + "T23:59:59");

  const snapshot = await db
    .collection(`companies/${companyId}/reservations`)
    .where("storeId", "==", storeId)
    .where("date", ">=", queryDateStart)
    .where("date", "<=", queryDateEnd)
    .get();

  return snapshot.docs.map((doc) => doc.data() as Reservation);
}

