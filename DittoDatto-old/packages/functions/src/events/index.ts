/**
 * Events CRUD Functions
 * 
 * Callable functions for managing company events.
 * Access controlled via company membership verification.
 */

import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import {
  CreateEventSchema,
  UpdateEventSchema,
  type Event,
} from "@dittodatto/shared-types";

// Ensure Admin SDK is initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

// CORS configuration for local development and production
const corsConfig = [
  "http://localhost:3000",
  "http://localhost:3001",
  /\.?dittodatto\.no$/,
];

/**
 * Verify user has access to a company via membership
 */
async function verifyCompanyMembership(
  userId: string,
  companyId: string
): Promise<boolean> {
  const membershipSnap = await db
    .collection("memberships")
    .where("userId", "==", userId)
    .where("companyId", "==", companyId)
    .limit(1)
    .get();

  return !membershipSnap.empty;
}

/**
 * Verify company has eventSystem feature enabled
 */
async function verifyEventSystemEnabled(companyId: string): Promise<boolean> {
  const companySnap = await db.collection("companies").doc(companyId).get();
  const company = companySnap.data();
  return company?.enabledFeatures?.eventSystem === true;
}

// =============================================================================
// CREATE EVENT
// =============================================================================
export const createEvent = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be logged in");
    }

    const userId = request.auth.uid;

    // Validate input
    const parsed = CreateEventSchema.safeParse(request.data);
    if (!parsed.success) {
      throw new HttpsError("invalid-argument", "Invalid event data", parsed.error);
    }
    const data = parsed.data;

    // Verify membership
    const hasMembership = await verifyCompanyMembership(userId, data.companyId);
    if (!hasMembership) {
      throw new HttpsError("permission-denied", "Not a member of this company");
    }

    // Verify feature flag
    const hasFeature = await verifyEventSystemEnabled(data.companyId);
    if (!hasFeature) {
      throw new HttpsError(
        "failed-precondition",
        "Event System is not enabled for this company"
      );
    }

    try {
      const eventRef = db.collection("events").doc();
      const now = admin.firestore.FieldValue.serverTimestamp();

      // Build event data, filtering out undefined values
      const eventData: Record<string, any> = {
        id: eventRef.id,
        companyId: data.companyId,
        title: data.title,
        startDateTime: data.startDateTime,
        timezone: data.timezone || "Europe/Oslo",
        location: data.location,
        status: data.status || "draft",
        visibility: data.visibility || "public",
        createdBy: userId,
        createdAt: now,
        updatedAt: now,
        hasTickets: data.hasTickets ?? false,
        ticketingEnabled: data.ticketingEnabled ?? false,
      };

      // Only add optional fields if they have values
      if (data.storeId) eventData.storeId = data.storeId;
      if (data.description) eventData.description = data.description;
      if (data.endDateTime) eventData.endDateTime = data.endDateTime;
      if (data.coverImageUrl) eventData.coverImageUrl = data.coverImageUrl;
      if (data.ticketBundleId) eventData.ticketBundleId = data.ticketBundleId;

      await eventRef.set(eventData);

      logger.info(`Event created: ${eventRef.id} by ${userId}`);

      return { success: true, eventId: eventRef.id };
    } catch (error: any) {
      logger.error("Error creating event:", error);
      throw new HttpsError("internal", error.message || "Failed to create event");
    }
  }
);

// =============================================================================
// UPDATE EVENT
// =============================================================================
export const updateEvent = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be logged in");
    }

    const userId = request.auth.uid;
    const { eventId, ...updateData } = request.data;

    if (!eventId || typeof eventId !== "string") {
      throw new HttpsError("invalid-argument", "eventId is required");
    }

    // Validate update data
    const parsed = UpdateEventSchema.safeParse(updateData);
    if (!parsed.success) {
      throw new HttpsError("invalid-argument", "Invalid update data", parsed.error);
    }

    // Get existing event
    const eventRef = db.collection("events").doc(eventId);
    const eventSnap = await eventRef.get();

    if (!eventSnap.exists) {
      throw new HttpsError("not-found", "Event not found");
    }

    const event = eventSnap.data() as Event;

    // Verify membership
    const hasMembership = await verifyCompanyMembership(userId, event.companyId);
    if (!hasMembership) {
      throw new HttpsError("permission-denied", "Not a member of this company");
    }

    try {
      // Filter out undefined values - Firestore doesn't accept them
      const updateData: Record<string, any> = {
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      
      const parsedData = parsed.data as Record<string, any>;
      for (const [key, value] of Object.entries(parsedData)) {
        if (value !== undefined) {
          updateData[key] = value;
        }
      }

      await eventRef.update(updateData);

      logger.info(`Event updated: ${eventId} by ${userId}`);

      return { success: true, eventId };
    } catch (error: any) {
      logger.error("Error updating event:", error);
      throw new HttpsError("internal", error.message || "Failed to update event");
    }
  }
);

// =============================================================================
// DELETE EVENT
// =============================================================================
export const deleteEvent = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be logged in");
    }

    const userId = request.auth.uid;
    const { eventId } = request.data;

    if (!eventId || typeof eventId !== "string") {
      throw new HttpsError("invalid-argument", "eventId is required");
    }

    // Get existing event
    const eventRef = db.collection("events").doc(eventId);
    const eventSnap = await eventRef.get();

    if (!eventSnap.exists) {
      throw new HttpsError("not-found", "Event not found");
    }

    const event = eventSnap.data() as Event;

    // Verify membership (only owners/managers can delete)
    const membershipSnap = await db
      .collection("memberships")
      .where("userId", "==", userId)
      .where("companyId", "==", event.companyId)
      .where("role", "in", ["owner", "manager"])
      .limit(1)
      .get();

    if (membershipSnap.empty) {
      throw new HttpsError(
        "permission-denied",
        "Only owners or managers can delete events"
      );
    }

    try {
      // 🎫 TODO-PostIt: TICKETING INTEGRATION
      // When Ticketing is implemented, check if event has tickets sold
      // and prevent deletion or handle ticket refunds

      await eventRef.delete();

      logger.info(`Event deleted: ${eventId} by ${userId}`);

      return { success: true };
    } catch (error: any) {
      logger.error("Error deleting event:", error);
      throw new HttpsError("internal", error.message || "Failed to delete event");
    }
  }
);

// =============================================================================
// GET EVENT
// =============================================================================
export const getEvent = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    const { eventId } = request.data;

    if (!eventId || typeof eventId !== "string") {
      throw new HttpsError("invalid-argument", "eventId is required");
    }

    const eventRef = db.collection("events").doc(eventId);
    const eventSnap = await eventRef.get();

    if (!eventSnap.exists) {
      throw new HttpsError("not-found", "Event not found");
    }

    const event = eventSnap.data() as Event;

    // Public events can be read by anyone
    if (event.visibility === "public" && event.status === "published") {
      return { event };
    }

    // Private/draft events require membership
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be logged in to view this event");
    }

    const hasMembership = await verifyCompanyMembership(
      request.auth.uid,
      event.companyId
    );
    if (!hasMembership) {
      throw new HttpsError("permission-denied", "Not authorized to view this event");
    }

    return { event };
  }
);

// =============================================================================
// LIST EVENTS
// =============================================================================
export const listEvents = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    const { companyId, storeId, status, limit = 50, startAfter } = request.data;

    if (!companyId || typeof companyId !== "string") {
      throw new HttpsError("invalid-argument", "companyId is required");
    }

    // Build query
    let query = db
      .collection("events")
      .where("companyId", "==", companyId)
      .orderBy("startDateTime", "desc")
      .limit(Math.min(limit, 100));

    if (storeId) {
      query = query.where("storeId", "==", storeId);
    }

    // If user is authenticated and a member, show all events
    // Otherwise, only show published public events
    let showAllEvents = false;

    if (request.auth) {
      const hasMembership = await verifyCompanyMembership(
        request.auth.uid,
        companyId
      );
      showAllEvents = hasMembership;
    }

    if (!showAllEvents) {
      query = query
        .where("status", "==", "published")
        .where("visibility", "==", "public");
    } else if (status) {
      query = query.where("status", "==", status);
    }

    if (startAfter) {
      const startDoc = await db.collection("events").doc(startAfter).get();
      if (startDoc.exists) {
        query = query.startAfter(startDoc);
      }
    }

    try {
      logger.info(`Listing events for company ${companyId}, showAllEvents: ${showAllEvents}`);
      const snapshot = await query.get();
      const events = snapshot.docs.map((doc) => doc.data() as Event);
      logger.info(`Found ${events.length} events`);

      return {
        events,
        lastEventId: events.length > 0 ? events[events.length - 1].id : null,
      };
    } catch (error: any) {
      logger.error("Error listing events:", error);
      throw new HttpsError("internal", error.message || "Failed to list events");
    }
  }
);
