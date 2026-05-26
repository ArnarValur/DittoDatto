/**
 * Analytics: Log Search Event
 *
 * Lightweight onCall Cloud Function that validates and stores
 * search events from DittoBar (and future DattoBar/Discover).
 *
 * - No auth required — anonymous users are tracked via sessionId
 * - Server enriches with auth.uid + server timestamp
 * - Writes to `searchEvents/{autoId}` collection
 */
import { onCall } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { LogSearchEventRequestSchema } from "@dittodatto/shared-types";

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

export const logSearchEvent = onCall(
  { region: "europe-west1", maxInstances: 5 },
  async (request) => {
    // Validate request body
    const parsed = LogSearchEventRequestSchema.safeParse(request.data);
    if (!parsed.success) {
      console.warn("[analytics] Invalid search event payload:", parsed.error.message);
      return { success: false, error: "Invalid payload" };
    }

    const data = parsed.data;

    // Enrich with server-side data
    const event: Record<string, unknown> = {
      query: data.query.toLowerCase().trim(),
      rawQuery: data.query,
      resultCount: data.resultCount,
      sessionId: data.sessionId,
      source: data.source,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    // Optional fields
    if (data.selectedResult) {
      event.selectedResult = data.selectedResult;
    }

    // Enrich with auth UID if signed in
    if (request.auth?.uid) {
      event.userId = request.auth.uid;
    }

    try {
      const ref = await db.collection("searchEvents").add(event);
      console.log(
        `[analytics] Search event logged: "${data.query}" (${data.resultCount} results)`,
        ref.id
      );
      return { success: true };
    } catch (err) {
      console.error("[analytics] Failed to log search event:", err);
      return { success: false, error: "Write failed" };
    }
  }
);
