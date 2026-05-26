/**
 * Staff Claim Invite — Callable Function
 *
 * Called from the Business Portal when an existing user logs in and
 * has matching staff invites. This handles the case where a user already
 * has a customer account and gets invited to a company later.
 *
 * Flow:
 * 1. Get caller's email from auth token
 * 2. Query all staff docs where email matches and status == 'invited'
 * 3. Link docs (userId, status → active, joinedAt)
 * 4. Merge companyIds into custom claims
 * 5. Return result so client can force token refresh
 *
 * ⚠️ Region: europe-west1
 *
 * @see GeminiComment2.md — Shadow Profile pattern
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

// Ensure Admin SDK is initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

export const claimInvite = onCall(
  {
    region: "europe-west1",
    cors: [
      "http://localhost:3001", // Business Portal dev
      /\.?dittodatto\.no$/,     // Production
    ],
  },
  async (request) => {
    // Must be authenticated
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be signed in.");
    }

    const email = request.auth.token.email?.toLowerCase();
    if (!email) {
      throw new HttpsError(
        "failed-precondition",
        "User account has no email address."
      );
    }

    const uid = request.auth.uid;
    const db = admin.firestore();

    try {
      // Collection group query: find ALL invited staff docs matching this email
      const snapshot = await db
        .collectionGroup("staff")
        .where("email", "==", email)
        .where("status", "==", "invited")
        .get();

      if (snapshot.empty) {
        logger.info(`No pending invites for ${email}`);
        return { linked: false, companyIds: [] };
      }

      logger.info(
        `Found ${snapshot.size} invite(s) for ${email} — claiming`
      );

      const newCompanyIds: string[] = [];
      const batch = db.batch();

      for (const staffDoc of snapshot.docs) {
        // Extract companyId from path: companies/{companyId}/staff/{staffId}
        const pathParts = staffDoc.ref.path.split("/");
        const companyId = pathParts[1];

        if (companyId && !newCompanyIds.includes(companyId)) {
          newCompanyIds.push(companyId);
        }

        batch.update(staffDoc.ref, {
          userId: uid,
          status: "active",
          joinedAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      // Merge with existing claims
      const userRecord = await admin.auth().getUser(uid);
      const existingClaims = userRecord.customClaims || {};
      const existingCompanyIds: string[] = existingClaims.companyIds || [];

      for (const id of newCompanyIds) {
        if (!existingCompanyIds.includes(id)) {
          existingCompanyIds.push(id);
        }
      }

      await admin.auth().setCustomUserClaims(uid, {
        ...existingClaims,
        companyId: existingCompanyIds[0], // Legacy
        companyIds: existingCompanyIds,
        role:
          existingClaims.role === "super_admin"
            ? "super_admin"
            : "business",
      });

      logger.info(
        `Linked ${email} to companies: ${newCompanyIds.join(", ")}`
      );

      // --- Notify company owners that staff member joined ---
      const displayName = request.auth.token.name || email;
      for (const cid of newCompanyIds) {
        try {
          const companyDoc = await db.collection("companies").doc(cid).get();
          const ownerId = companyDoc.data()?.ownerId;
          const companyName = companyDoc.data()?.name || "selskapet";

          if (ownerId && ownerId !== uid) {
            await db
              .collection("users")
              .doc(ownerId)
              .collection("notifications")
              .add({
                type: "staff_claimed",
                title: `${displayName} har blitt med i ${companyName}`,
                body: "En ny medarbeider har akseptert invitasjonen din.",
                icon: "i-lucide-user-check",
                context: { companyId: cid },
                isRead: false,
                isArchived: false,
                requiresAction: false,
                respondedBy: "system",
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
              });

            logger.info(
              `Notified owner ${ownerId} that ${email} joined ${cid}`
            );
          }
        } catch (e) {
          logger.warn(`Failed to notify owner for company ${cid}:`, e);
        }
      }

      return {
        linked: true,
        companyIds: existingCompanyIds,
      };
    } catch (error: any) {
      logger.error("Claim invite failed:", error);
      throw new HttpsError(
        "internal",
        error.message || "Failed to claim invite"
      );
    }
  }
);
