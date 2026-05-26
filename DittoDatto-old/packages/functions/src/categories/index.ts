/**
 * Category Store Count Triggers
 *
 * Maintains accurate store counts per category using Firestore triggers.
 * - onStoreWritten: Updates category counts when stores are created/updated/deleted
 * - recountCategories: Manual backfill function to fix counts
 */

import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { onCall } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

const db = getFirestore();

/**
 * Trigger: onStoreWritten
 * Fires when any store document is created, updated, or deleted.
 * Updates the `count` field on the associated category document.
 */
export const onStoreWritten = onDocumentWritten(
  {
    document: "companies/{companyId}/stores/{storeId}",
    region: "europe-west1"
  },
  async (event) => {
    const beforeData = event.data?.before?.data();
    const afterData = event.data?.after?.data();

    const oldCategory = beforeData?.category as string | undefined;
    const newCategory = afterData?.category as string | undefined;
    const wasPublished = beforeData?.isPublished === true;
    const isPublished = afterData?.isPublished === true;

    // Determine what changed
    const categoryChanged = oldCategory !== newCategory;
    const publishedChanged = wasPublished !== isPublished;

    // Skip if nothing relevant changed
    if (!categoryChanged && !publishedChanged) {
      logger.info("No relevant changes, skipping");
      return;
    }

    logger.info(`Store change detected - category: ${oldCategory} -> ${newCategory}, published: ${wasPublished} -> ${isPublished}`);

    const batch = db.batch();

    // Decrement: store was published and either changed category or got unpublished
    if (wasPublished && oldCategory && (categoryChanged || !isPublished)) {
      const oldCatRef = db.collection("categories").doc(oldCategory);
      batch.update(oldCatRef, { count: FieldValue.increment(-1) });
      logger.info(`Decrementing count for category: ${oldCategory}`);
    }

    // Increment: store is published and either changed category or just got published
    if (isPublished && newCategory && (categoryChanged || !wasPublished)) {
      const newCatRef = db.collection("categories").doc(newCategory);
      batch.update(newCatRef, { count: FieldValue.increment(1) });
      logger.info(`Incrementing count for category: ${newCategory}`);
    }

    await batch.commit();
    logger.info("Category counts updated successfully");
  }
);

/**
 * Callable: recountCategories
 * Manually recounts all stores per category and updates the count fields.
 * Use this to backfill existing data or fix inconsistencies.
 */
export const recountCategories = onCall(async (request) => {
  // Optional: Add admin check here
  // if (!request.auth?.token?.admin) {
  //   throw new HttpsError("permission-denied", "Admin access required");
  // }

  logger.info("Starting category recount...");

  // Get all categories
  const categoriesSnap = await db.collection("categories").get();
  const categoryIds = categoriesSnap.docs.map((doc) => doc.id);

  // Initialize counts
  const counts: Record<string, number> = {};
  for (const id of categoryIds) {
    counts[id] = 0;
  }

  // Count only PUBLISHED stores per category
  const companiesSnap = await db.collection("companies").get();
  for (const company of companiesSnap.docs) {
    const storesSnap = await db
      .collection(`companies/${company.id}/stores`)
      .where("isPublished", "==", true)
      .get();

    for (const store of storesSnap.docs) {
      const category = store.data().category as string | undefined;
      if (category && counts[category] !== undefined) {
        counts[category]++;
      }
    }
  }

  // Batch update all category counts
  const batch = db.batch();
  for (const [categoryId, count] of Object.entries(counts)) {
    const catRef = db.collection("categories").doc(categoryId);
    batch.update(catRef, { count });
  }

  await batch.commit();

  logger.info("Category recount complete", { counts });

  return {
    success: true,
    counts,
  };
});
