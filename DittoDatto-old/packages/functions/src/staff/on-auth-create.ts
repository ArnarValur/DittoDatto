/**
 * Auth User Created — Non-blocking Auth Trigger (v1)
 *
 * Fires for EVERY new user signup (email, Google, phone, etc.).
 * Responsibilities:
 * 1. Create a `users/{uid}` Firestore profile doc (ensures admin panel visibility)
 * 2. Auto-link staff invites if email matches a pending invite
 * 3. Set custom claims for staff-linked users
 *
 * ⚠️ Uses v1 auth trigger because v2 beforeUserCreated requires GCIP
 *    (Identity Platform) which is not enabled on this project.
 * ⚠️ v1 auth triggers always deploy to us-central1 (Firebase limitation).
 *
 * @see GeminiComment2.md — "The Magic Moment" / Shadow Profile pattern
 */
import { auth } from "firebase-functions/v1";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

// Ensure Admin SDK is initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

export const onAuthUserCreated = auth.user().onCreate(async (user) => {

    const db = admin.firestore();

    // ─── Step 1: Create users/{uid} profile doc ───
    try {
      const userDocRef = db.collection("users").doc(user.uid);
      const existingDoc = await userDocRef.get();

      if (!existingDoc.exists) {
        // Determine auth provider for metadata
        const providerData = user.providerData?.[0];
        const provider = providerData?.providerId || "unknown";

        await userDocRef.set({
          name: user.displayName || "",
          email: user.email || "",
          phone: user.phoneNumber || "",
          photoUrl: user.photoURL || "",
          role: "customer",
          isOnboarded: false,
          language: "nb",
          authProvider: provider,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        logger.info(
          `Created users/${user.uid} profile (provider: ${provider})`
        );
      }
    } catch (error) {
      // Non-fatal — log and continue
      logger.error("Failed to create user profile doc:", error);
    }

    // ─── Step 2: Auto-link staff invites ───
    if (!user.email) {
      logger.info(
        "New user created without email — skipping staff auto-link"
      );
      return;
    }

    const email = user.email.toLowerCase();

    try {
      const snapshot = await db
        .collectionGroup("staff")
        .where("email", "==", email)
        .where("status", "==", "invited")
        .get();

      if (snapshot.empty) {
        logger.info(`No staff invites found for ${email}`);
        return;
      }

      logger.info(
        `Found ${snapshot.size} staff invite(s) for ${email} — auto-linking`
      );

      const companyIds: string[] = [];
      const batch = db.batch();

      for (const staffDoc of snapshot.docs) {
        // Extract companyId from path: companies/{companyId}/staff/{staffId}
        const pathParts = staffDoc.ref.path.split("/");
        const companyId = pathParts[1];

        if (companyId && !companyIds.includes(companyId)) {
          companyIds.push(companyId);
        }

        batch.update(staffDoc.ref, {
          userId: user.uid,
          status: "active",
          joinedAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      // ─── Step 3: Set custom claims for staff ───
      // User fully exists now (non-blocking trigger), so use setCustomUserClaims
      // Merge with existing claims just in case they were pre-provisioned via Admin SDK
      const userRecord = await admin.auth().getUser(user.uid);
      const existingClaims = userRecord.customClaims || {};

      const customClaims: Record<string, unknown> = {
        ...existingClaims,
        companyId: companyIds[0],
        companyIds: companyIds,
        role: existingClaims.role === "super_admin" ? "super_admin" : "business",
      };

      await admin.auth().setCustomUserClaims(user.uid, customClaims);

      logger.info(
        `Auto-linked ${email} to ${companyIds.length} company(ies): ${companyIds.join(", ")}`
      );
    } catch (error) {
      logger.error("Staff auto-link failed:", error);
    }
  });

