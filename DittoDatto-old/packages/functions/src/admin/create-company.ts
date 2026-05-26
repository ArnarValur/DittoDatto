import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import { AdminCreateCompanySchema } from "@dittodatto/shared-types";

// Ensure Admin SDK is initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

export const createCompany = onCall(
  {
    region: "europe-west1",
    cors: [
      "http://localhost:3000",
      "http://localhost:3001",
      /\.?dittodatto\.no$/, // Production domains
    ],
  },
  async (request) => {
    // 1. RBAC Check: Only Super Admins can create companies
    if (request.auth?.token.role !== "super_admin") {
      throw new HttpsError(
        "permission-denied",
        "Only Super Admins can create companies."
      );
    }

    // 2. Validation
    const input = AdminCreateCompanySchema.safeParse(request.data);
    if (!input.success) {
      throw new HttpsError(
        "invalid-argument",
        "Invalid data format",
        input.error
      );
    }
    const data = input.data;

    const db = admin.firestore();
    const auth = admin.auth();

    try {
      // 3. Find Owner by Email
      let ownerRecord;
      try {
        ownerRecord = await auth.getUserByEmail(data.ownerEmail);
      } catch (e: any) {
        if (e.code === "auth/user-not-found") {
          throw new HttpsError(
            "not-found",
            `User with email ${data.ownerEmail} not found. Please register the user first.`
          );
        }
        throw e;
      }

      // 4. Run Transaction
      const companyId = await db.runTransaction(async (t) => {
        // A. Create Company Ref
        const companyRef = db.collection("companies").doc();

        const companyData = {
          id: companyRef.id,
          name: data.name,
          ownerId: ownerRecord.uid,
          ownerEmail: data.ownerEmail,
          email: data.email || null,
          tier: data.tier,
          // NOTE: category/subcategory removed - categories belong at Store level (see Option A architecture)
          country: data.country || "NO",
          phone: data.phone || null,
          onboardingStatus: data.onboardingStatus || "verified", // Admin created = verified
          // Feature Flags
          enabledFeatures: data.enabledFeatures || {
            tableReservation: false,
            aiAssistance: false,
            ticketSystem: false,
            eventSystem: false,
          },
          // Store Policy
          storePolicy: data.storePolicy || {
            maxStores: 1,
            canCreateOwnStores: false,
          },
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        // B. Create Membership Ref
        const membershipRef = db.collection("memberships").doc();
        const membershipData = {
          userId: ownerRecord.uid,
          companyId: companyRef.id,
          role: "owner",
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        // C. Update User Profile (Firestore)
        const userRef = db.collection("users").doc(ownerRecord.uid);

        t.set(companyRef, companyData);

        t.set(membershipRef, membershipData);

        t.set(
          userRef,

          {
            roles: admin.firestore.FieldValue.arrayUnion("business"),
            primaryCompanyId: companyRef.id,
          },
          { merge: true }
        );

        return companyRef.id;
      });

      // 5. Update Auth Claims (Outside Transaction)
      // Use companyIds array to support multi-company owners
      const currentClaims = ownerRecord.customClaims || {};
      const existingCompanyIds: string[] = currentClaims.companyIds || [];
      
      // Add new company to the array if not already present
      if (!existingCompanyIds.includes(companyId)) {
        existingCompanyIds.push(companyId);
      }
      
      await auth.setCustomUserClaims(ownerRecord.uid, {
        ...currentClaims,
        companyId: existingCompanyIds[0], // Keep legacy field for backwards compatibility
        companyIds: existingCompanyIds,   // New array field for multi-company
        role: currentClaims.role === "super_admin" ? "super_admin" : "business",
      });

      return { success: true, companyId };
    } catch (error: any) {
      logger.error("Error creating company:", error);
      // Re-throw HttpsError if it was already one
      if (error instanceof HttpsError) {
        throw error;
      }
      throw new HttpsError(
        "internal",
        error.message || "Failed to create company"
      );
    }
  }
);
