/**
 * Favorites Triggers
 *
 * Firestore triggers that update favoritesCount on stores when users
 * add or remove favorites.
 *
 * Path: users/{userId}/favorites/{favoriteId}
 * Expected document shape: { entityId: string, type: 'store' | 'person', addedAt: Timestamp }
 */
import { onDocumentCreated, onDocumentDeleted } from "firebase-functions/v2/firestore";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

const db = getFirestore();

/**
 * When a favorite is added, increment the favoritesCount on the target store.
 */
export const onFavoriteCreated = onDocumentCreated(
  {
    document: "users/{userId}/favorites/{favoriteId}",
    region: "europe-west1",
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.warn("[Favorites] No data in created document");
      return;
    }

    const data = snapshot.data();
    const { entityId, type, companyId } = data;

    if (type !== "store") {
      logger.info("[Favorites] Ignoring non-store favorite:", type);
      return;
    }

    if (!entityId) {
      logger.error("[Favorites] Missing entityId in favorite document");
      return;
    }

    if (!companyId) {
      logger.error("[Favorites] Missing companyId - cannot update store count");
      return;
    }

    // Use direct path since we have companyId
    try {
      const storeRef = db.doc(`companies/${companyId}/stores/${entityId}`);
      const storeDoc = await storeRef.get();

      if (!storeDoc.exists) {
        logger.warn("[Favorites] Store not found:", entityId);
        return;
      }

      await storeRef.update({
        favoritesCount: FieldValue.increment(1),
      });

      logger.info("[Favorites] Incremented favoritesCount for store:", entityId);
    } catch (error) {
      logger.error("[Favorites] Error incrementing favoritesCount:", error);
    }
  }
);

/**
 * When a favorite is removed, decrement the favoritesCount on the target store.
 */
export const onFavoriteDeleted = onDocumentDeleted(
  {
    document: "users/{userId}/favorites/{favoriteId}",
    region: "europe-west1",
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.warn("[Favorites] No data in deleted document");
      return;
    }

    const data = snapshot.data();
    const { entityId, type, companyId } = data;

    if (type !== "store") {
      logger.info("[Favorites] Ignoring non-store favorite:", type);
      return;
    }

    if (!entityId) {
      logger.error("[Favorites] Missing entityId in favorite document");
      return;
    }

    if (!companyId) {
      logger.error("[Favorites] Missing companyId - cannot update store count");
      return;
    }

    // Use direct path since we have companyId
    try {
      const storeRef = db.doc(`companies/${companyId}/stores/${entityId}`);
      const storeDoc = await storeRef.get();

      if (!storeDoc.exists) {
        logger.warn("[Favorites] Store not found:", entityId);
        return;
      }

      await storeRef.update({
        favoritesCount: FieldValue.increment(-1),
      });

      logger.info("[Favorites] Decremented favoritesCount for store:", entityId);
    } catch (error) {
      logger.error("[Favorites] Error decrementing favoritesCount:", error);
    }
  }
);
