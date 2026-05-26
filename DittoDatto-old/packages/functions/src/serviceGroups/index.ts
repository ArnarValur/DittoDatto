/**
 * Service Groups CRUD Functions
 * 
 * Callable functions for managing service groups.
 * Access controlled via company membership verification.
 * 
 * Collection path: companies/{companyId}/stores/{storeId}/serviceGroups
 */

import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import {
  CreateServiceGroupInputSchema,
  UpdateServiceGroupInputSchema,
  type ServiceGroup,
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
 * Verify store belongs to company
 */
async function verifyStoreOwnership(
  storeId: string,
  companyId: string
): Promise<boolean> {
  const storeSnap = await db
    .collection("companies")
    .doc(companyId)
    .collection("stores")
    .doc(storeId)
    .get();
  
  return storeSnap.exists;
}

/**
 * Get companyId from storeId
 * Note: Since stores are subcollections, we use collectionGroup if we only have storeId.
 * For now, most functions pass both.
 */
// async function getCompanyIdFromStore(storeId: string): Promise<string | null> {
//   const storeQuery = await db.collectionGroup("stores")
//     .where(admin.firestore.FieldPath.documentId(), "==", storeId)
//     .limit(1)
//     .get();

//   if (storeQuery.empty) return null;
  
//   // Path is companies/{companyId}/stores/{storeId}
//   const path = storeQuery.docs[0].ref.path;
//   const parts = path.split("/");
//   return parts[1] || null;
// }

// =============================================================================
// CREATE SERVICE GROUP
// =============================================================================
export const createServiceGroup = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be logged in");
    }

    const userId = request.auth.uid;

    // Validate input
    const parsed = CreateServiceGroupInputSchema.safeParse(request.data);
    if (!parsed.success) {
      throw new HttpsError("invalid-argument", "Invalid service group data", parsed.error);
    }
    const data = parsed.data;

    // Get companyId from request (required)
    const companyId = request.data.companyId;
    if (!companyId || typeof companyId !== "string") {
      throw new HttpsError("invalid-argument", "companyId is required");
    }

    // Verify store exists under this company
    const ownsStore = await verifyStoreOwnership(data.storeId, companyId);
    if (!ownsStore) {
      throw new HttpsError("not-found", "Store not found or does not belong to this company");
    }

    // Verify membership
    const hasMembership = await verifyCompanyMembership(userId, companyId);
    if (!hasMembership) {
      throw new HttpsError("permission-denied", "Not a member of this company");
    }

    try {
      const groupRef = db
        .collection("companies")
        .doc(companyId)
        .collection("stores")
        .doc(data.storeId)
        .collection("serviceGroups")
        .doc();
      
      const now = admin.firestore.FieldValue.serverTimestamp();

      // Spread all validated fields, override with auto-generated ones
      const groupData: Record<string, unknown> = {
        ...data,
        id: groupRef.id,
        sortOrder: data.sortOrder ?? 0,
        showOnBookingPanel: data.showOnBookingPanel ?? true,
        multiSelect: data.multiSelect ?? false,
        createdAt: now,
        updatedAt: now,
      };

      await groupRef.set(groupData);

      logger.info(`ServiceGroup created: ${groupRef.id} by ${userId}`);

      return { success: true, groupId: groupRef.id };
    } catch (error: any) {
      logger.error("Error creating service group:", error);
      throw new HttpsError("internal", error.message || "Failed to create service group");
    }
  }
);

// =============================================================================
// UPDATE SERVICE GROUP
// =============================================================================
export const updateServiceGroup = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be logged in");
    }

    const userId = request.auth.uid;
    const { groupId, storeId, companyId, ...updateData } = request.data;

    if (!groupId || typeof groupId !== "string") {
      throw new HttpsError("invalid-argument", "groupId is required");
    }
    if (!storeId || typeof storeId !== "string") {
      throw new HttpsError("invalid-argument", "storeId is required");
    }
    if (!companyId || typeof companyId !== "string") {
      throw new HttpsError("invalid-argument", "companyId is required");
    }

    // Validate update data
    const parsed = UpdateServiceGroupInputSchema.safeParse({ id: groupId, ...updateData });
    if (!parsed.success) {
      throw new HttpsError("invalid-argument", "Invalid update data", parsed.error);
    }

    // Verify membership
    const hasMembership = await verifyCompanyMembership(userId, companyId);
    if (!hasMembership) {
      throw new HttpsError("permission-denied", "Not a member of this company");
    }

    // Verify store ownership
    const ownsStore = await verifyStoreOwnership(storeId, companyId);
    if (!ownsStore) {
      throw new HttpsError("permission-denied", "Store does not belong to this company");
    }

    try {
      const groupRef = db
        .collection("companies")
        .doc(companyId)
        .collection("stores")
        .doc(storeId)
        .collection("serviceGroups")
        .doc(groupId);

      const groupSnap = await groupRef.get();
      if (!groupSnap.exists) {
        throw new HttpsError("not-found", "Service group not found");
      }

      const { id: _id, ...fieldsToUpdate } = parsed.data;
      
      await groupRef.update({
        ...fieldsToUpdate,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      logger.info(`ServiceGroup updated: ${groupId} by ${userId}`);

      return { success: true, groupId };
    } catch (error: any) {
      logger.error("Error updating service group:", error);
      throw new HttpsError("internal", error.message || "Failed to update service group");
    }
  }
);

// =============================================================================
// DELETE SERVICE GROUP
// =============================================================================
export const deleteServiceGroup = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be logged in");
    }

    const userId = request.auth.uid;
    const { groupId, storeId, companyId } = request.data;

    if (!groupId || typeof groupId !== "string") {
      throw new HttpsError("invalid-argument", "groupId is required");
    }
    if (!storeId || typeof storeId !== "string") {
      throw new HttpsError("invalid-argument", "storeId is required");
    }
    if (!companyId || typeof companyId !== "string") {
      throw new HttpsError("invalid-argument", "companyId is required");
    }

    // Verify membership (only owners/managers can delete)
    const membershipSnap = await db
      .collection("memberships")
      .where("userId", "==", userId)
      .where("companyId", "==", companyId)
      .where("role", "in", ["owner", "manager"])
      .limit(1)
      .get();

    if (membershipSnap.empty) {
      throw new HttpsError(
        "permission-denied",
        "Only owners or managers can delete service groups"
      );
    }

    try {
      const groupRef = db
        .collection("companies")
        .doc(companyId)
        .collection("stores")
        .doc(storeId)
        .collection("serviceGroups")
        .doc(groupId);

      const groupSnap = await groupRef.get();
      if (!groupSnap.exists) {
        throw new HttpsError("not-found", "Service group not found");
      }

      // Check if any services are linked to this group
      const servicesSnap = await db
        .collection("services")
        .where("storeId", "==", storeId)
        .where("groupId", "==", groupId)
        .limit(1)
        .get();

      if (!servicesSnap.empty) {
        throw new HttpsError(
          "failed-precondition",
          "Cannot delete group with linked services. Unassign services first."
        );
      }

      await groupRef.delete();

      logger.info(`ServiceGroup deleted: ${groupId} by ${userId}`);

      return { success: true };
    } catch (error: any) {
      if (error instanceof HttpsError) throw error;
      logger.error("Error deleting service group:", error);
      throw new HttpsError("internal", error.message || "Failed to delete service group");
    }
  }
);

// =============================================================================
// LIST SERVICE GROUPS
// =============================================================================
export const listServiceGroups = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be logged in");
    }

    const userId = request.auth.uid;
    const { storeId, companyId } = request.data;

    if (!storeId || typeof storeId !== "string") {
      throw new HttpsError("invalid-argument", "storeId is required");
    }
    if (!companyId || typeof companyId !== "string") {
      throw new HttpsError("invalid-argument", "companyId is required");
    }

    // Verify membership
    const hasMembership = await verifyCompanyMembership(userId, companyId);
    if (!hasMembership) {
      throw new HttpsError("permission-denied", "Not a member of this company");
    }

    try {
      const snapshot = await db
        .collection("companies")
        .doc(companyId)
        .collection("stores")
        .doc(storeId)
        .collection("serviceGroups")
        .orderBy("sortOrder", "asc")
        .get();

      const groups = snapshot.docs.map((doc) => doc.data() as ServiceGroup);

      return { groups };
    } catch (error: any) {
      logger.error("Error listing service groups:", error);
      throw new HttpsError("internal", error.message || "Failed to list service groups");
    }
  }
);
