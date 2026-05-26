/**
 * Staff Status Change — Kill Switch Trigger
 *
 * Firestore trigger on `companies/{companyId}/staff/{staffId}`.
 * When a staff member's status changes to 'removed' or 'suspended':
 * 1. Strip that company from the user's custom claims
 * 2. If no companies remain, downgrade role to 'customer'
 *
 * This instantly kills portal access, even mid-session, because
 * the next token refresh will have stripped claims.
 *
 * ⚠️ Region: europe-west1 (explicit — setGlobalOptions does NOT apply to Firestore triggers)
 *
 * @see GeminiComment2.md — "The Kill Switch"
 */
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

// Ensure Admin SDK is initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

export const onStaffStatusChange = onDocumentUpdated(
  {
    document: "companies/{companyId}/staff/{staffId}",
    region: "europe-west1",
  },
  async (event) => {
    const before = event.data?.before?.data();
    const after = event.data?.after?.data();

    if (!before || !after) return;

    const oldStatus = before.status;
    const newStatus = after.status;

    // Only act when status actually changed
    if (oldStatus === newStatus) return;

    const userId = after.userId || before.userId;
    const companyId = event.params.companyId;

    // ── REVOCATION: status → removed or suspended ──
    if (newStatus === "removed" || newStatus === "suspended") {
      if (!userId) {
        logger.info(
          `Staff ${event.params.staffId} has no userId — skipping claim strip`
        );
        return;
      }

      logger.info(
        `Staff ${event.params.staffId} status changed to "${newStatus}" — stripping claims for company ${companyId}`
      );

      try {
        const userRecord = await admin.auth().getUser(userId);
        const claims = userRecord.customClaims || {};
        const companyIds: string[] = claims.companyIds || [];

        // Remove this company from the array
        const updatedCompanyIds = companyIds.filter(
          (id: string) => id !== companyId
        );

        if (updatedCompanyIds.length === 0) {
          // No companies left — downgrade to customer
          await admin.auth().setCustomUserClaims(userId, {
            ...claims,
            companyId: null,
            companyIds: [],
            role: "customer",
          });
          logger.info(
            `User ${userId} removed from all companies — downgraded to customer`
          );
        } else {
          // Still has other companies — just remove this one
          await admin.auth().setCustomUserClaims(userId, {
            ...claims,
            companyId: updatedCompanyIds[0], // Legacy field: first company
            companyIds: updatedCompanyIds,
          });
          logger.info(
            `User ${userId} removed from company ${companyId} — ${updatedCompanyIds.length} company(ies) remaining`
          );
        }
      } catch (error) {
        logger.error(
          `Failed to strip claims for user ${userId}:`,
          error
        );
      }
    }

    // ── RE-ACTIVATION: status → active (from suspended) ──
    if (newStatus === "active" && oldStatus === "suspended") {
      if (!userId) return;

      logger.info(
        `Staff ${event.params.staffId} re-activated — restoring claims for company ${companyId}`
      );

      try {
        const userRecord = await admin.auth().getUser(userId);
        const claims = userRecord.customClaims || {};
        const companyIds: string[] = claims.companyIds || [];

        if (!companyIds.includes(companyId)) {
          companyIds.push(companyId);
        }

        await admin.auth().setCustomUserClaims(userId, {
          ...claims,
          companyId: companyIds[0],
          companyIds,
          role:
            claims.role === "super_admin" ? "super_admin" : "business",
        });

        logger.info(
          `User ${userId} re-linked to company ${companyId}`
        );
      } catch (error) {
        logger.error(
          `Failed to restore claims for user ${userId}:`,
          error
        );
      }
    }
  }
);
