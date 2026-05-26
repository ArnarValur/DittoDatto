import { db } from "../../config/firebase.js";
import { Store, Resource, Reservation, Service } from "@dittodatto/shared-types";
import { calculateSlotAvailability } from "./calculator.js";
import { HttpsError } from "../shared/errors.js";

export interface CreateReservationRequest {
  companyId: string;
  storeId: string;
  experienceId?: string;
  serviceId?: string;    // Scopes table resources to the service's resource groups
  
  customerName: string;
  customerEmail?: string;
  customerPhone: string;
  
  guestCount: number;
  date: string; // "YYYY-MM-DD"
  time: string; // "HH:mm"
  
  notes?: string;
  userId?: string; // Optional user ID if authenticated
}

export const createReservation = async (request: CreateReservationRequest) => {
    const {
      companyId,
      storeId,
      experienceId,
      serviceId,
      customerName,
      customerEmail,
      customerPhone,
      guestCount,
      date,
      time,
      notes,
      userId,
    } = request;

    // 1. Validation
    if (!companyId || !storeId || !guestCount || !date || !time || !customerName || !customerPhone) {
      throw new HttpsError("invalid-argument", "Missing required fields: companyId, storeId, guestCount, date, time, customerName, customerPhone");
    }

    // 2. Fetch Store & Config (correct company subcollection path)
    const storeRef = db.doc(`companies/${companyId}/stores/${storeId}`);

    // 2b. Fetch table resources OUTSIDE transaction (read-only, stable within request)
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

    // Transaction to prevent overbooking (race condition handling)
    const reservationId = await db.runTransaction(async (transaction) => {
      const storeDoc = await transaction.get(storeRef);
      if (!storeDoc.exists) throw new HttpsError("not-found", "Store not found");

      const store = storeDoc.data() as Store;
      if (!store.reservationConfig) {
        throw new HttpsError("failed-precondition", "Reservations not enabled");
      }

      const { maxGuestsPerReservation, autoConfirm, defaultDuration } = store.reservationConfig;

      if (guestCount > maxGuestsPerReservation) {
        throw new HttpsError("out-of-range", "Guest count exceeds limit for instant booking");
      }

      // 3. Check Availability INSIDE Transaction (company subcollection)
      const queryDateStart = new Date(date + "T00:00:00");
      const queryDateEnd = new Date(date + "T23:59:59");

      const resQuery = db
        .collection(`companies/${companyId}/reservations`)
        .where("storeId", "==", storeId)
        .where("date", ">=", queryDateStart)
        .where("date", "<=", queryDateEnd);

      const resSnapshot = await transaction.get(resQuery);
      const existingReservations = resSnapshot.docs.map((doc) => doc.data() as Reservation);

      // Duration: use experience duration if available, else store default
      const duration = defaultDuration;

      // Capacity check — auto-detects pool vs table mode
      const check = calculateSlotAvailability(
        store,
        queryDateStart,
        time,
        duration,
        guestCount,
        existingReservations,
        scopedTables.length > 0 ? scopedTables : undefined,
      );

      if (!check.available) {
        throw new HttpsError("resource-exhausted", `Slot no longer available - ${check.reason}`);
      }

      // 4. Create Reservation (company subcollection)
      const newReservationRef = db
        .collection(`companies/${companyId}/reservations`)
        .doc();

      const now = new Date();

      const reservation: Record<string, any> = {
        id: newReservationRef.id,
        storeId,
        companyId,

        customerName,
        customerPhone,

        guestCount,
        date: new Date(date + "T" + time + ":00"),
        time,
        duration,

        status: autoConfirm ? "confirmed" : "pending",

        createdAt: now,
        updatedAt: now,
      };

      // Only include optional fields if present (Firestore rejects undefined)
      if (experienceId) reservation.experienceId = experienceId;
      if (serviceId) reservation.serviceId = serviceId;
      if (customerEmail) reservation.customerEmail = customerEmail;
      if (notes?.trim()) reservation.notes = notes.trim();
      if (autoConfirm) reservation.confirmedAt = now;

      // Table auto-assignment (set by calculator when table resources exist)
      if (check.tableId) reservation.tableId = check.tableId;

      if (userId) {
        reservation.customerId = userId;
      }

      transaction.set(newReservationRef, reservation);

      // FIX PHANTOM READS (GRANULAR):
      // Serialize on the assigned table to avoid store-wide bottleneck.
      // Table 1 reservations won't block Table 2 reservations.
      // Pool-mode stores (no tables) fall back to store-level.
      if (check.tableId) {
        const tableRef = db.doc(`companies/${companyId}/stores/${storeId}/resources/${check.tableId}`);
        transaction.update(tableRef, { _lastReservationTracker: now.getTime() });
      } else {
        transaction.update(storeRef, { _lastReservationTracker: now.getTime() });
      }

      return newReservationRef.id;
    });

    return { reservationId, status: "success" };
  };
