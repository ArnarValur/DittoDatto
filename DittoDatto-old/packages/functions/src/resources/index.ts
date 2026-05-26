/**
 * Resources CRUD Functions
 *
 * Callable functions for managing resources and resource groups.
 * Access controlled via company membership verification.
 *
 * Collection paths:
 *   companies/{companyId}/stores/{storeId}/resources/{resourceId}
 *   companies/{companyId}/stores/{storeId}/resourceGroups/{groupId}
 */

import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import {
  CreateResourceSchema,
  CreateResourceGroupSchema,
} from "@dittodatto/shared-types";

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

const corsConfig = [
  "http://localhost:3000",
  "http://localhost:3001",
  /\.?dittodatto\.no$/,
];

async function verifyCompanyMembership(
  userId: string,
  companyId: string
): Promise<boolean> {
  const snap = await db
    .collection("memberships")
    .where("userId", "==", userId)
    .where("companyId", "==", companyId)
    .limit(1)
    .get();
  return !snap.empty;
}

async function verifyStoreOwnership(
  storeId: string,
  companyId: string
): Promise<boolean> {
  const snap = await db
    .collection("companies")
    .doc(companyId)
    .collection("stores")
    .doc(storeId)
    .get();
  return snap.exists;
}

// =============================================================================
// RESOURCE GROUP CRUD
// =============================================================================

export const createResourceGroup = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) throw new HttpsError("unauthenticated", "Must be logged in");
    const userId = request.auth.uid;
    const { companyId } = request.data;

    if (!companyId) throw new HttpsError("invalid-argument", "companyId is required");

    const parsed = CreateResourceGroupSchema.safeParse(request.data);
    if (!parsed.success) throw new HttpsError("invalid-argument", "Invalid data", parsed.error);

    const data = parsed.data;

    const [hasMembership, ownsStore] = await Promise.all([
      verifyCompanyMembership(userId, companyId),
      verifyStoreOwnership(data.storeId, companyId),
    ]);
    if (!hasMembership) throw new HttpsError("permission-denied", "Not a member");
    if (!ownsStore) throw new HttpsError("not-found", "Store not found");

    try {
      const ref = db.collection("companies").doc(companyId)
        .collection("stores").doc(data.storeId)
        .collection("resourceGroups").doc();

      const now = admin.firestore.FieldValue.serverTimestamp();
      await ref.set({ ...data, id: ref.id, createdAt: now, updatedAt: now });

      logger.info(`ResourceGroup created: ${ref.id} by ${userId}`);
      return { success: true, groupId: ref.id };
    } catch (error: any) {
      logger.error("Error creating resource group:", error);
      throw new HttpsError("internal", error.message || "Failed to create resource group");
    }
  }
);

export const updateResourceGroup = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) throw new HttpsError("unauthenticated", "Must be logged in");
    const userId = request.auth.uid;
    const { groupId, storeId, companyId, ...updateData } = request.data;

    if (!groupId || !storeId || !companyId)
      throw new HttpsError("invalid-argument", "groupId, storeId, companyId required");

    const hasMembership = await verifyCompanyMembership(userId, companyId);
    if (!hasMembership) throw new HttpsError("permission-denied", "Not a member");

    try {
      const ref = db.collection("companies").doc(companyId)
        .collection("stores").doc(storeId)
        .collection("resourceGroups").doc(groupId);

      const snap = await ref.get();
      if (!snap.exists) throw new HttpsError("not-found", "Resource group not found");

      await ref.update({
        ...updateData,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      logger.info(`ResourceGroup updated: ${groupId} by ${userId}`);
      return { success: true, groupId };
    } catch (error: any) {
      if (error instanceof HttpsError) throw error;
      logger.error("Error updating resource group:", error);
      throw new HttpsError("internal", error.message || "Failed to update");
    }
  }
);

export const deleteResourceGroup = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) throw new HttpsError("unauthenticated", "Must be logged in");
    const userId = request.auth.uid;
    const { groupId, storeId, companyId } = request.data;

    if (!groupId || !storeId || !companyId)
      throw new HttpsError("invalid-argument", "groupId, storeId, companyId required");

    // Owner/manager only
    const memberSnap = await db.collection("memberships")
      .where("userId", "==", userId)
      .where("companyId", "==", companyId)
      .where("role", "in", ["owner", "manager"])
      .limit(1).get();
    if (memberSnap.empty) throw new HttpsError("permission-denied", "Owner/manager only");

    try {
      const ref = db.collection("companies").doc(companyId)
        .collection("stores").doc(storeId)
        .collection("resourceGroups").doc(groupId);

      // Check for linked resources
      const resourcesSnap = await db.collection("companies").doc(companyId)
        .collection("stores").doc(storeId)
        .collection("resources")
        .where("resourceGroupId", "==", groupId)
        .limit(1).get();

      if (!resourcesSnap.empty) {
        throw new HttpsError("failed-precondition", "Cannot delete group with linked resources");
      }

      await ref.delete();
      logger.info(`ResourceGroup deleted: ${groupId} by ${userId}`);
      return { success: true };
    } catch (error: any) {
      if (error instanceof HttpsError) throw error;
      logger.error("Error deleting resource group:", error);
      throw new HttpsError("internal", error.message || "Failed to delete");
    }
  }
);

// =============================================================================
// RESOURCE CRUD
// =============================================================================

export const createResource = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) throw new HttpsError("unauthenticated", "Must be logged in");
    const userId = request.auth.uid;
    const { companyId } = request.data;

    if (!companyId) throw new HttpsError("invalid-argument", "companyId is required");

    const parsed = CreateResourceSchema.safeParse(request.data);
    if (!parsed.success) throw new HttpsError("invalid-argument", "Invalid data", parsed.error);

    const data = parsed.data;

    const [hasMembership, ownsStore] = await Promise.all([
      verifyCompanyMembership(userId, companyId),
      verifyStoreOwnership(data.storeId, companyId),
    ]);
    if (!hasMembership) throw new HttpsError("permission-denied", "Not a member");
    if (!ownsStore) throw new HttpsError("not-found", "Store not found");

    // Validate resourceGroupId if provided
    if (data.resourceGroupId) {
      const groupSnap = await db.collection("companies").doc(companyId)
        .collection("stores").doc(data.storeId)
        .collection("resourceGroups").doc(data.resourceGroupId).get();
      if (!groupSnap.exists) {
        throw new HttpsError("not-found", "Resource group not found");
      }
    }

    try {
      const ref = db.collection("companies").doc(companyId)
        .collection("stores").doc(data.storeId)
        .collection("resources").doc();

      const now = admin.firestore.FieldValue.serverTimestamp();
      await ref.set({ ...data, id: ref.id, createdAt: now, updatedAt: now });

      logger.info(`Resource created: ${ref.id} (${data.name}) by ${userId}`);
      return { success: true, resourceId: ref.id };
    } catch (error: any) {
      logger.error("Error creating resource:", error);
      throw new HttpsError("internal", error.message || "Failed to create resource");
    }
  }
);

export const updateResource = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) throw new HttpsError("unauthenticated", "Must be logged in");
    const userId = request.auth.uid;
    const { resourceId, storeId, companyId, ...updateData } = request.data;

    if (!resourceId || !storeId || !companyId)
      throw new HttpsError("invalid-argument", "resourceId, storeId, companyId required");

    const hasMembership = await verifyCompanyMembership(userId, companyId);
    if (!hasMembership) throw new HttpsError("permission-denied", "Not a member");

    try {
      const ref = db.collection("companies").doc(companyId)
        .collection("stores").doc(storeId)
        .collection("resources").doc(resourceId);

      const snap = await ref.get();
      if (!snap.exists) throw new HttpsError("not-found", "Resource not found");

      await ref.update({
        ...updateData,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      logger.info(`Resource updated: ${resourceId} by ${userId}`);
      return { success: true, resourceId };
    } catch (error: any) {
      if (error instanceof HttpsError) throw error;
      logger.error("Error updating resource:", error);
      throw new HttpsError("internal", error.message || "Failed to update");
    }
  }
);

export const deleteResource = onCall(
  { region: "europe-west1", cors: corsConfig },
  async (request) => {
    if (!request.auth) throw new HttpsError("unauthenticated", "Must be logged in");
    const userId = request.auth.uid;
    const { resourceId, storeId, companyId } = request.data;

    if (!resourceId || !storeId || !companyId)
      throw new HttpsError("invalid-argument", "resourceId, storeId, companyId required");

    // Owner/manager only
    const memberSnap = await db.collection("memberships")
      .where("userId", "==", userId)
      .where("companyId", "==", companyId)
      .where("role", "in", ["owner", "manager"])
      .limit(1).get();
    if (memberSnap.empty) throw new HttpsError("permission-denied", "Owner/manager only");

    try {
      const ref = db.collection("companies").doc(companyId)
        .collection("stores").doc(storeId)
        .collection("resources").doc(resourceId);

      const snap = await ref.get();
      if (!snap.exists) throw new HttpsError("not-found", "Resource not found");

      // TODO: Check for active bookings using this resource before deleting

      await ref.delete();
      logger.info(`Resource deleted: ${resourceId} by ${userId}`);
      return { success: true };
    } catch (error: any) {
      if (error instanceof HttpsError) throw error;
      logger.error("Error deleting resource:", error);
      throw new HttpsError("internal", error.message || "Failed to delete");
    }
  }
);
