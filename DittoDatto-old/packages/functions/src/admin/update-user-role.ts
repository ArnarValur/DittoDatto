import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { z } from "zod";

// Initialize admin if not already done (though usually done in index or globally)
if (!admin.apps.length) {
  admin.initializeApp();
}

// Schema (Duplicated from shared-types to avoid build complexity for now,
// as discussed in "The North Star" but pragmatically for Sprint 0/Cloud Functions isolation)
const UserRoleSchema = z.enum(["customer", "business", "admin", "super_admin"]);
const UpdateUserRoleRequestSchema = z.object({
  userId: z.string(),
  role: UserRoleSchema.optional(),
  companyMemberships: z.array(z.any()).optional(), // Simplified for now
});

export const updateUserRole = onCall(async (request) => {
  // 1. RBAC: Only Super Admin can promote/demote
  if (request.auth?.token.role !== "super_admin") {
    throw new HttpsError(
      "permission-denied",
      "Only Super Admins can manage roles."
    );
  }

  // 2. Validation
  const input = UpdateUserRoleRequestSchema.safeParse(request.data);
  if (!input.success) {
    throw new HttpsError(
      "invalid-argument",
      "Invalid data format",
      input.error
    );
  }
  const { userId, role } = input.data;

  try {
    // 3. Update Auth Custom Claims
    const currentClaims =
      (await admin.auth().getUser(userId)).customClaims || {};
    const newClaims = { ...currentClaims, ...(role ? { role } : {}) };

    await admin.auth().setCustomUserClaims(userId, newClaims);

    // 4. Update Firestore User Document
    const updates: any = {};
    if (role) updates.role = role;

    // Ensure user doc exists or update it
    await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .set(updates, { merge: true });

    return { success: true, userId, role };
  } catch (error) {
    console.error("Error updating user role:", error);
    throw new HttpsError("internal", "Failed to update user role");
  }
});
