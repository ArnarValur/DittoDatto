// packages/functions/src/MercuryEngine/booking.ts
// Core Domain: Booking Context - Create Booking from Hold
// Migrated from: .docs/project-context/BookingScripts/src/services/booking/create.ts

import { getAuth } from "firebase-admin/auth";
import { db } from "../../config/firebase.js";
import { Booking, Hold, Service, BookingPolicySchema } from "@dittodatto/shared-types";
import { upsertCustomerFromBooking } from "../shared/customer.js";

import { HttpsError } from "../shared/errors.js";

// ============================================================================
// Pure Functions (testable without Firestore)
// ============================================================================

/**
 * Input data for building a booking receipt.
 * All fields are plain data — no Firestore refs.
 */
export interface BookingReceiptInput {
  hold: Hold;
  services: (Service & { id: string })[];
  userName: string;
  userEmail: string;
  storeName: string;
  paymentId: string;
  notes?: string;
}

/**
 * Builds a Booking object (the receipt/snapshot) from hold + services + user data.
 * Pure function — no IO. All data passed in, Booking object returned.
 *
 * Uses the Snapshot Pattern: copies service price/title at booking time
 * for historical accuracy (prices can change later).
 */
export function buildBookingReceipt(input: BookingReceiptInput): Booking & { storeName: string } {
  const { hold, services, userName, userEmail, paymentId, storeName, notes } = input;

  const holdServiceIds: string[] = hold.serviceIds
    || (hold.serviceId ? [hold.serviceId] : []);

  // Aggregate totals from all services
  const totalDuration = services.reduce((sum, s) => sum + (s.duration || 60), 0);
  const totalPrice = services.reduce((sum, s) => sum + (s.price || 0), 0);
  const serviceTitle = services.map((s) => s.title).join(", ");

  // Calculate Start/End Time as timezone-naive local times.
  const startTime = `${hold.date}T${hold.slotTime}:00`;

  const [startH, startM] = hold.slotTime.split(":").map(Number);
  const endTotalMinutes = startH * 60 + startM + totalDuration;
  const endH = String(Math.floor(endTotalMinutes / 60) % 24).padStart(2, "0");
  const endM = String(endTotalMinutes % 60).padStart(2, "0");
  const endTime = `${hold.date}T${endH}:${endM}:00`;

  // Build items array — one entry per service
  const items = services.map((s) => ({
    serviceId: s.id,
    title: s.title,
    price: s.price,
    duration: s.duration,
    ...(hold.staffId ? { staffId: hold.staffId } : {}),
    storeId: hold.storeId,
    companyId: hold.companyId,
  }));

  const booking: Booking = {
    id: paymentId,
    status: "confirmed",
    userId: hold.userId,
    companyId: hold.companyId,
    storeId: hold.storeId,
    serviceId: holdServiceIds[0],
    ...(hold.staffId ? { staffId: hold.staffId } : {}),
    ...((hold as any).resourceId ? { resourceId: (hold as any).resourceId } : {}),
    serviceTitle,
    duration: totalDuration,
    priceAtTimeOfBooking: totalPrice,
    currency: services[0].currency,
    userName,
    userEmail,
    startTime: startTime as unknown as Date,
    endTime: endTime as unknown as Date,
    createdAt: new Date() as unknown as Date,
    items,
    addonResourceIds: [],
    paymentId,
    channel: "app",
    attendeeCount: 1,
    ...(notes?.trim() ? { notes: notes.trim() } : {}),
  };

  return { ...booking, storeName };
}

/**
 * Input for cancellation policy check.
 */
export interface CancellationCheckInput {
  bookingStartTime: string | Date;
  policy: {
    clientCancelEnabled: boolean;
    minCancelNoticeHours: number;
  };
  now?: Date;
}

/**
 * Validates that a customer cancellation is allowed per the store's policy.
 * Pure function — throws HttpsError if policy forbids cancellation.
 *
 * Only called for customer-initiated cancellations (staff/admin bypass).
 */
export function checkCancellationPolicy(input: CancellationCheckInput): void {
  const { policy, now = new Date() } = input;

  if (!policy.clientCancelEnabled) {
    throw new HttpsError(
      "failed-precondition",
      "This business does not allow customer cancellations. Please contact the business directly.",
    );
  }

  if (policy.minCancelNoticeHours > 0) {
    const startTime = typeof input.bookingStartTime === 'string'
      ? new Date(input.bookingStartTime)
      : (input.bookingStartTime as any)?.toDate?.()
        ?? new Date(input.bookingStartTime as any);

    const deadlineMs = startTime.getTime() - (policy.minCancelNoticeHours * 60 * 60 * 1000);
    const deadline = new Date(deadlineMs);

    if (now.getTime() > deadlineMs) {
      throw new HttpsError(
        "failed-precondition",
        `Cancellation deadline has passed. Must cancel at least ${policy.minCancelNoticeHours} hours before the appointment (deadline: ${deadline.toISOString()}).`,
      );
    }
  }
}

/**
 * MercuryEngine - Create Booking from Hold
 * Converts a valid hold into a permanent booking using the Snapshot Pattern.
 * Copies service price/title at booking time for historical accuracy.
 *
 * @param holdId - The composite hold ID to convert
 * @param paymentId - Payment reference ID (used as booking ID for idempotency)
 * @returns Object with success status and bookingId
 */
export const createBookingFromHold = async (
  holdId: string,
  paymentId: string,
  notes?: string
) => {
  const holdRef = db.collection("holds").doc(holdId);

  // CRM data captured inside the transaction, used after it completes
  let crmData: {
    companyId: string; storeId: string; userId: string;
    userName: string; userEmail: string; userPhone?: string;
    staffId?: string; totalPrice: number; startTime: string;
    channel: string;
  } | null = null;

  // Atomic Transaction: Read Hold -> Create Booking -> Delete Hold
  await db.runTransaction(async (transaction) => {
    // A. Read the Hold
    const holdDoc = await transaction.get(holdRef);
    if (!holdDoc.exists) {
      throw new HttpsError("not-found", "Hold expired or not found");
    }
    const hold = holdDoc.data() as Hold;

    // B. Fetch Service Snapshots for the receipt
    const holdServiceIds: string[] = hold.serviceIds
      || (hold.serviceId ? [hold.serviceId] : []);

    if (holdServiceIds.length === 0) {
      throw new HttpsError("failed-precondition", "Hold has no service IDs");
    }

    const serviceSnaps = await Promise.all(
      holdServiceIds.map((sid: string) =>
        transaction.get(
          db.doc(
            `companies/${hold.companyId}/stores/${hold.storeId}/services/${sid}`
          )
        )
      )
    );

    const services = serviceSnaps.map((s) => ({
      ...(s.data() as Service),
      id: s.id,
    }));

    // Resolve user name/email
    let userName = "Kunde";
    let userEmail = "";
    try {
      const profileSnap = await transaction.get(db.doc(`users/${hold.userId}`));
      if (profileSnap.exists) {
        const profile = profileSnap.data();
        userName = profile?.name || "";
        userEmail = profile?.email || "";
      }
      if (!userName || userName === "Kunde") {
        const userRecord = await getAuth().getUser(hold.userId);
        userName = userName || userRecord.displayName || userRecord.email || "Kunde";
        userEmail = userEmail || userRecord.email || "";
      }
    } catch {
      // User might be deleted — fallback
    }

    // Fetch store name
    let storeName = "";
    try {
      const storeSnap = await transaction.get(
        db.doc(`companies/${hold.companyId}/stores/${hold.storeId}`)
      );
      if (storeSnap.exists) {
        storeName = storeSnap.data()?.name || "";
      }
    } catch {
      // Non-critical
    }

    // C. Build the receipt (pure)
    const bookingWithMeta = buildBookingReceipt({
      hold, services, userName, userEmail, storeName, paymentId, notes,
    });
    const bookingId = paymentId;

    // D. Write the Booking & Delete Hold (Atomic)
    const bookingRef = db.collection("bookings").doc(bookingId);
    transaction.set(bookingRef, bookingWithMeta);
    transaction.delete(holdRef);

    // E. Capture data for CRM upsert
    const totalPrice = bookingWithMeta.priceAtTimeOfBooking;
    const startTime = bookingWithMeta.startTime;
    crmData = {
      companyId: hold.companyId,
      storeId: hold.storeId,
      userId: hold.userId,
      userName,
      userEmail,
      staffId: hold.staffId,
      totalPrice,
      startTime: startTime as unknown as string,
      channel: "app",
    };
  });

  // CRM Side-Effect: Upsert customer record (fire-and-forget)
  // Runs AFTER the transaction so it never blocks or rolls back the booking.
  if (crmData) {
    const d: any = crmData;
    upsertCustomerFromBooking({
      companyId: d.companyId,
      storeId: d.storeId,
      userId: d.userId,
      userName: d.userName,
      userEmail: d.userEmail,
      bookingId: paymentId,
      staffId: d.staffId,
      priceAtTimeOfBooking: d.totalPrice,
      bookingTime: d.startTime,
      channel: d.channel,
    }).catch(() => {}); // Silently swallow — logged inside upsertCustomerFromBooking
  }

  return { success: true, bookingId: paymentId };
};

/**
 * MercuryEngine - Cancel Booking
 * Cancels an existing booking.
 * Bypasses client-side Firestore rules by operating via the server SDK.
 * 
 * @param bookingId - The ID of the booking to cancel
 * @param userId - The ID of the user requesting the cancellation (used for authorization)
 * @param reason - Optional reason for cancellation
 * @returns Object with success status
 */
export const cancelBooking = async (
  bookingId: string,
  userId: string,
  reason?: string
) => {
  const bookingRef = db.collection("bookings").doc(bookingId);

  await db.runTransaction(async (transaction) => {
    const bookingDoc = await transaction.get(bookingRef);

    if (!bookingDoc.exists) {
      throw new HttpsError("not-found", "Booking not found");
    }

    const booking = bookingDoc.data() as Booking;

    // Authorization: Must be the customer OR a company admin/member
    // A. Check if the user is the customer who made the booking
    let isAuthorized = booking.userId === userId;

    if (!isAuthorized) {
      // B. If not the customer, check if they are a company member
      try {
        const userRef = db.collection("users").doc(userId);
        const userDoc = await transaction.get(userRef);
        
        if (userDoc.exists) {
          const userData = userDoc.data();
          // Check if they are a superadmin
          if (userData?.role === 'super_admin') {
            isAuthorized = true;
          }
          // Check if they belong to the company that owns the booking
          else if (
             userData?.primaryCompanyId === booking.companyId ||
             (Array.isArray(userData?.companyIds) && userData.companyIds.includes(booking.companyId))
          ) {
            isAuthorized = true;
          }
        } else {
           // Fallback to Firebase auth claims (if we can read them, but since we only have userId here)
           const userRecord = await getAuth().getUser(userId);
           if (
              userRecord.customClaims?.role === 'super_admin' ||
              userRecord.customClaims?.companyId === booking.companyId ||
              (Array.isArray(userRecord.customClaims?.companyIds) && userRecord.customClaims.companyIds.includes(booking.companyId))
           ) {
              isAuthorized = true;
           }
        }
      } catch (err) {
        // Ignore auth fetch errors, authorization fails closed.
        console.warn("Failed to check extended permissions for user: ", userId);
      }
    }

    if (!isAuthorized) {
      throw new HttpsError("permission-denied", "You don't have permission to cancel this booking");
    }

    if (booking.status === "cancelled") {
       throw new HttpsError("failed-precondition", "Booking is already cancelled");
    }
    
    if (booking.status === "completed") {
       throw new HttpsError("failed-precondition", "Cannot cancel a completed booking");
    }

    // --- Cancellation Policy Enforcement (pure) ---
    const isCustomer = booking.userId === userId;
    if (isCustomer) {
      try {
        const storeRef = db.doc(`companies/${booking.companyId}/stores/${booking.storeId}`);
        const storeDoc = await transaction.get(storeRef);
        const storeData = storeDoc.exists ? storeDoc.data() : {};
        const policy = BookingPolicySchema.parse(storeData?.bookingPolicy ?? {});

        checkCancellationPolicy({
          bookingStartTime: booking.startTime,
          policy,
        });
      } catch (err) {
        if (err instanceof HttpsError) throw err;
        console.warn("Failed to fetch store for policy check, allowing cancellation:", err);
      }
    }

    // Update the booking status
    const updates: Partial<Booking> = {
      status: "cancelled",
      updatedAt: new Date() as unknown as Date,
    };
    
    if (reason) {
       updates.cancellationReason = reason;
    }

    transaction.update(bookingRef, updates);
  });

  return { success: true };
};
