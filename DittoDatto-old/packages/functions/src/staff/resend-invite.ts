/**
 * Resend Staff Invite — Callable Cloud Function
 *
 * Re-queues the staff invite email for a pending invite.
 * Only the company owner can trigger this.
 *
 * Input: { companyId, staffId }
 * Guard: caller must be company owner, staff must be status === 'invited'
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import { renderStaffInviteEmail } from "../emails/staff-invite";

const db = admin.firestore();

export const resendStaffInvite = onCall(
  { region: "europe-west1" },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be logged in.");
    }

    const { companyId, staffId } = request.data;
    if (!companyId || !staffId) {
      throw new HttpsError(
        "invalid-argument",
        "companyId and staffId are required."
      );
    }

    // Verify caller is the company owner
    const companyDoc = await db.collection("companies").doc(companyId).get();
    if (!companyDoc.exists) {
      throw new HttpsError("not-found", "Company not found.");
    }
    const company = companyDoc.data()!;
    if (company.ownerId !== request.auth.uid) {
      throw new HttpsError(
        "permission-denied",
        "Only the company owner can resend invites."
      );
    }

    // Fetch the staff doc
    const staffRef = db
      .collection("companies")
      .doc(companyId)
      .collection("staff")
      .doc(staffId);
    const staffDoc = await staffRef.get();
    if (!staffDoc.exists) {
      throw new HttpsError("not-found", "Staff member not found.");
    }
    const staff = staffDoc.data()!;

    if (staff.status !== "invited") {
      throw new HttpsError(
        "failed-precondition",
        "Can only resend invites for staff with status 'invited'."
      );
    }

    const email = staff.email?.toLowerCase();
    if (!email) {
      throw new HttpsError(
        "failed-precondition",
        "Staff member has no email address."
      );
    }

    const companyName = company.name || "et selskap";
    const roleName = staff.role || "ansatt";
    const portalUrl = "https://portal.dittodatto.no";

    // Check if user exists in Auth (affects email copy)
    let hasExistingAccount = false;
    try {
      await admin.auth().getUserByEmail(email);
      hasExistingAccount = true;
    } catch {
      // No account yet
    }

    // Write to mail collection
    await db.collection("mail").add({
      to: [email],
      message: {
        subject: `Påminnelse: Du er invitert til ${companyName} på DittoDatto`,
        html: renderStaffInviteEmail({
          companyName,
          roleName,
          portalUrl,
          hasExistingAccount,
        }),
      },
    });

    logger.info(
      `[resend-invite] Resent invite to ${email} for company ${companyId}`
    );

    return { success: true };
  }
);
