/**
 * MercuryEngine - Customer CRM Module
 * 
 * Handles automatic customer record creation/updates when bookings are made.
 * Implements the upsert pattern: finds existing customer by email within a company,
 * or creates a new one from the booking's user snapshot.
 * 
 * Inspired by Noona HQ's customer model:
 * - event_count → totalVisits (incremented on each booking)
 * - previous_event → lastBookingId (reference to most recent booking)
 * - employee_ids → staffIds (tracks which staff served this customer)
 */

import { db } from "../../config/firebase.js";
import { FieldValue } from "firebase-admin/firestore";

interface BookingCustomerData {
  companyId: string;
  storeId: string;
  userId: string;
  userName: string;
  userEmail: string;
  userPhone?: string;
  bookingId: string;
  staffId?: string;
  priceAtTimeOfBooking: number;
  bookingTime: string; // ISO date string
  channel?: string;
}

/**
 * Upsert a customer record from booking data.
 * 
 * Strategy:
 * 1. Query `companies/{companyId}/customers` where email matches
 * 2. If found → increment totalVisits, update lastVisitAt, merge storeId, add staffId
 * 3. If not found → create new Customer doc
 * 
 * This runs as a fire-and-forget side effect after booking creation.
 * Failures are logged but never block the booking.
 */
export async function upsertCustomerFromBooking(data: BookingCustomerData): Promise<void> {
  const {
    companyId,
    storeId,
    userId,
    userName,
    userEmail,
    userPhone,
    bookingId,
    staffId,
    priceAtTimeOfBooking,
    bookingTime,
    channel = "app",
  } = data;

  const customersRef = db.collection(`companies/${companyId}/customers`);

  try {
    // Try to find existing customer by userId first (most reliable match)
    let existingSnap = await customersRef
      .where("userId", "==", userId)
      .limit(1)
      .get();

    // Fallback: match by email if no userId match
    if (existingSnap.empty && userEmail) {
      existingSnap = await customersRef
        .where("email", "==", userEmail)
        .limit(1)
        .get();
    }

    const now = new Date().toISOString();

    if (!existingSnap.empty) {
      // UPDATE existing customer
      const customerDoc = existingSnap.docs[0];
      const updateData: Record<string, any> = {
        totalVisits: FieldValue.increment(1),
        totalSpent: FieldValue.increment(priceAtTimeOfBooking),
        lastVisitAt: bookingTime,
        lastBookingId: bookingId,
        status: "active",
        updatedAt: now,
      };

      // Merge storeId into storeIds if not already present
      updateData.storeIds = FieldValue.arrayUnion(storeId);

      // Track staff who served this customer
      if (staffId) {
        updateData.staffIds = FieldValue.arrayUnion(staffId);
      }

      // Update userId if we didn't have it before
      const existing = customerDoc.data();
      if (!existing.userId && userId) {
        updateData.userId = userId;
      }

      await customerDoc.ref.update(updateData);
      console.log(`[CRM] Updated customer ${customerDoc.id} for booking ${bookingId}`);
    } else {
      // CREATE new customer — use userId as doc ID to prevent duplicates from concurrent upserts
      const newCustomerRef = customersRef.doc(userId);
      const newCustomer = {
        id: userId,
        companyId,
        storeIds: [storeId],
        userId,

        // Profile from booking user snapshot
        name: userName,
        email: userEmail || "",
        phone: userPhone || "",

        // CRM fields
        status: "active",
        channel,
        staffIds: staffId ? [staffId] : [],
        notes: "",

        // Booking references
        lastBookingId: bookingId,

        // Metrics
        totalVisits: 1,
        totalSpent: priceAtTimeOfBooking,
        firstVisitAt: bookingTime,
        lastVisitAt: bookingTime,

        // Metadata
        createdAt: now,
        updatedAt: now,
      };

      await newCustomerRef.set(newCustomer);
      console.log(`[CRM] Created new customer ${newCustomerRef.id} for booking ${bookingId}`);
    }
  } catch (error) {
    // Never block the booking — log and move on
    console.error(`[CRM] Failed to upsert customer for booking ${bookingId}:`, error);

    // Dead Letter Queue: persist failed payload for later retry
    try {
      await db.collection('failed_crm_jobs').add({
        type: 'customer_upsert',
        payload: data,
        error: error instanceof Error ? error.message : String(error),
        createdAt: new Date(),
        retryCount: 0,
      });
    } catch (dlqError) {
      console.error('[CRM] Failed to write to DLQ:', dlqError);
    }
  }
}
