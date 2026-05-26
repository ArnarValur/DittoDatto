/**
 * Feedback Submit — Callable Cloud Function
 *
 * Accepts feedback from any DittoDatto surface (public contact form,
 * logged-in user feedback, portal feedback/support).
 *
 * Flow:
 * 1. Validate input against SubmitFeedbackSchema
 * 2. Auto-populate senderId if caller is authenticated
 * 3. Store in feedback/{feedbackId}
 * 4. Create admin notification at users/{adminUid}/notifications/
 *
 * Collection: feedback/{feedbackId}
 * ⚠️ Region: europe-west1
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

// Ensure Admin SDK is initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

// Strip HTML tags and control characters to prevent injection
function sanitize(str: string, maxLen = 2000): string {
  return str
    .replace(/<[^>]*>/g, "")       // strip HTML tags
    .replace(/[\x00-\x08\x0B\x0C\x0E-\x1F]/g, "") // strip control chars
    .trim()
    .slice(0, maxLen);
}

// Arnar's UID for admin notifications
// TODO: Move to env config or admin-users collection when multi-admin
const ADMIN_UID = "auFPUislFmOrguw2bxC1sW7fztl2";

export const submitFeedback = onCall(
  {
    region: "europe-west1",
    cors: [
      "http://localhost:3000", // Admin Panel dev
      "http://localhost:3001", // Business Portal dev
      "http://localhost:3002", // Public Marketplace dev
      /\.?dittodatto\.no$/,   // Production
    ],
  },
  async (request) => {
    const data = request.data;

    // Basic validation
    if (!data?.body || typeof data.body !== "string" || data.body.trim().length === 0) {
      throw new HttpsError("invalid-argument", "Feedback body is required.");
    }

    if (!data?.senderEmail || typeof data.senderEmail !== "string") {
      throw new HttpsError("invalid-argument", "Sender email is required.");
    }

    if (!data?.senderName || typeof data.senderName !== "string") {
      throw new HttpsError("invalid-argument", "Sender name is required.");
    }

    const validSources = [
      "public_contact",
      "public_feedback",
      "portal_feedback",
      "portal_support",
      "business_inquiry",
    ];
    const source = validSources.includes(data.source) ? data.source : "public_contact";

    const validCategories = [
      "general",
      "bug",
      "feature_request",
      "ux_issue",
      "compliment",
      "question",
    ];
    const category = validCategories.includes(data.category) ? data.category : "general";

    // Build feedback doc
    const feedbackDoc: Record<string, any> = {
      senderName: sanitize(data.senderName, 200),
      senderEmail: sanitize(data.senderEmail, 320).toLowerCase(),
      source,
      category,
      body: sanitize(data.body, 2000),
      status: "new",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    // Optional fields
    if (data.subject) {
      feedbackDoc.subject = sanitize(String(data.subject), 200);
    }

    if (data.metadata && typeof data.metadata === "object") {
      feedbackDoc.metadata = {
        url: sanitize(data.metadata.url || "", 500),
        userAgent: sanitize(data.metadata.userAgent || "", 500),
        viewport: sanitize(data.metadata.viewport || "", 50),
      };
    }

    // Auto-populate senderId if authenticated
    if (request.auth?.uid) {
      feedbackDoc.senderId = request.auth.uid;
    }

    // Store in Firestore
    const feedbackRef = await db.collection("feedback").add(feedbackDoc);

    logger.info(
      `[feedback] New ${source}/${category} from ${feedbackDoc.senderEmail} → ${feedbackRef.id}`
    );

    // Notify admin (if ADMIN_UID is configured)
    if (ADMIN_UID) {
      const sourceLabels: Record<string, string> = {
        public_contact: "Kontaktskjema",
        public_feedback: "Kundetilbakemelding",
        portal_feedback: "Portal-tilbakemelding",
        portal_support: "Støtteforespørsel",
        business_inquiry: "Bedriftssøknad",
      };

      await db
        .collection("users")
        .doc(ADMIN_UID)
        .collection("notifications")
        .add({
          type: "system_alert",
          title: `Ny ${sourceLabels[source] || "tilbakemelding"}`,
          body: `Fra ${feedbackDoc.senderName}: ${feedbackDoc.body.slice(0, 80)}${feedbackDoc.body.length > 80 ? "…" : ""}`,
          icon: "i-lucide-message-square-text",
          context: { feedbackId: feedbackRef.id },
          isRead: false,
          isArchived: false,
          requiresAction: true,
          respondedBy: "system",
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

      logger.info(`[feedback] Admin notification sent to ${ADMIN_UID}`);
    }

    return {
      success: true,
      feedbackId: feedbackRef.id,
    };
  }
);
