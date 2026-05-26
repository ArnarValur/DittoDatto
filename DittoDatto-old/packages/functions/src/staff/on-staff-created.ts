/**
 * Staff Invite Notification — Firestore Trigger
 *
 * Fires when a new staff document is created at
 * `companies/{companyId}/staff/{staffId}`.
 *
 * Actions:
 * 1. If invited user already exists in Auth (email lookup):
 *    → Create in-app notification at `users/{uid}/notifications/`
 * 2. Always: Write to `mail` collection → extension sends email
 *
 * ⚠️ Region: europe-west1 (explicit — setGlobalOptions does NOT apply to Firestore triggers)
 */
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import { FieldValue } from "firebase-admin/firestore";

import { renderStaffInviteEmail } from "../emails/staff-invite";

// Ensure Admin SDK is initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

export const onStaffCreated = onDocumentCreated(
  {
    document: "companies/{companyId}/staff/{staffId}",
    region: "europe-west1",
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const staff = snapshot.data();
    const companyId = event.params.companyId;
    const staffId = event.params.staffId;

    // Only act on invitations
    if (staff.status !== "invited") {
      logger.info(
        `[staff-invite] Staff ${staffId} created with status "${staff.status}" — not an invite, skipping.`
      );
      return;
    }

    const email = staff.email?.toLowerCase();
    if (!email) {
      logger.warn(
        `[staff-invite] Staff ${staffId} has no email — cannot send notification.`
      );
      return;
    }

    // Fetch company name for notification content
    let companyName = "et selskap"; // fallback
    try {
      const companyDoc = await db.collection("companies").doc(companyId).get();
      if (companyDoc.exists) {
        companyName = companyDoc.data()?.name || companyName;
      }
    } catch (e) {
      logger.warn(`[staff-invite] Failed to fetch company ${companyId}:`, e);
    }

    const roleName = staff.role || "ansatt";
    const portalUrl = "https://portal.dittodatto.no";

    // --- 1. In-App Notification (if user exists in Auth) ---
    let existingUid: string | null = null;
    let existingRole: string | null = null;
    try {
      const userRecord = await admin.auth().getUserByEmail(email);
      existingUid = userRecord.uid;
      existingRole = userRecord.customClaims?.role || null;
      logger.info(
        `[staff-invite] Found existing user ${existingUid} for email ${email}`
      );
    } catch {
      // User doesn't exist in Auth yet — that's fine, email will handle it
      logger.info(
        `[staff-invite] No existing user for ${email} — will send email only`
      );
    }

    const batch = db.batch();

    if (existingUid) {
      // --- 1a. In-App Notification ---
      const notifRef = db
        .collection("users")
        .doc(existingUid)
        .collection("notifications")
        .doc();

      batch.set(notifRef, {
        type: "staff_invite",
        title: `Du er lagt til i ${companyName}`,
        body: `Du har blitt lagt til som ${roleName}. Logg inn på bedriftsportalen for å komme i gang.`,
        icon: "i-lucide-user-plus",
        context: {
          companyId,
        },
        isRead: false,
        isArchived: false,
        requiresAction: false,
        respondedBy: "system",
        createdAt: FieldValue.serverTimestamp(),
      });

      // --- 1b. Auto-link: user already exists → activate immediately ---
      // Update staff doc with userId and set active
      batch.update(snapshot.ref, {
        userId: existingUid,
        status: "active",
        joinedAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });

      // Update user doc: add companyId to companyIds array
      const userDocRef = db.collection("users").doc(existingUid);
      batch.set(
        userDocRef,
        {
          companyIds: admin.firestore.FieldValue.arrayUnion(companyId),
          role: existingRole === "super_admin" ? "super_admin" : "business",
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true }
      );

      logger.info(
        `[staff-invite] Auto-linked user ${existingUid} to company ${companyId} (${companyName})`
      );

      // Set custom claims (must be outside batch — Auth API, not Firestore)
      try {
        // Merge with existing claims to support multi-company
        const existingClaims =
          (await admin.auth().getUser(existingUid)).customClaims || {};
        const existingCompanyIds: string[] =
          existingClaims.companyIds || [];
        if (!existingCompanyIds.includes(companyId)) {
          existingCompanyIds.push(companyId);
        }

        await admin.auth().setCustomUserClaims(existingUid, {
          ...existingClaims,
          companyId: existingCompanyIds[0], // primary
          companyIds: existingCompanyIds,
          role: existingClaims.role === "super_admin" ? "super_admin" : "business",
        });

        logger.info(
          `[staff-invite] Set custom claims for ${existingUid}: companyIds=${existingCompanyIds.join(", ")}`
        );
      } catch (claimsErr) {
        logger.error(
          `[staff-invite] Failed to set claims for ${existingUid}:`,
          claimsErr
        );
      }
    }

    // --- 2. Email via firestore-send-email extension ---
    const mailRef = db.collection("mail").doc();
    batch.set(mailRef, {
      to: [email],
      message: {
        subject: `Du er invitert til ${companyName} på DittoDatto`,
        html: renderStaffInviteEmail({
          companyName,
          roleName,
          portalUrl,
          hasExistingAccount: !!existingUid,
        }),
      },
    });

    await batch.commit();

    logger.info(
      `[staff-invite] Email queued for ${email}, company ${companyId} (${companyName})`
    );
  }
);
