// apps/admin-panel/server/api/users.delete.ts
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'

/**
 * TODO: Data Deletion Strategy
 * - Consider implementing soft-delete (set `deletedAt` timestamp) before hard delete
 * - Add grace period for data recovery
 * - Handle cascade deletion for user-owned companies
 * - Implement batch cleanup job for orphaned data
 */

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const uid = body?.uid

  if (!uid || typeof uid !== 'string')
    throw createError({ statusCode: 400, statusMessage: 'UID required' })

  const db = getFirestore()

  try {
    // 1. Delete all user's memberships first (cascade cleanup)
    const membershipsQuery = await db
      .collection('memberships')
      .where('userId', '==', uid)
      .get()

    if (!membershipsQuery.empty) {
      const batch = db.batch()
      membershipsQuery.docs.forEach(doc => batch.delete(doc.ref))
      await batch.commit()
      console.log(`[DELETE USER] Deleted ${membershipsQuery.size} membership(s) for user ${uid}`)
    }

    // 2. Delete from Auth (if exists)
    try {
      await getAuth().deleteUser(uid)
      console.log(`[DELETE USER] Auth user ${uid} deleted`)
    } catch (authError: unknown) {
      // User might not exist in Auth, but could be in Firestore
      const error = authError as { code?: string }
      if (error.code !== 'auth/user-not-found') {
        throw authError
      }
      console.log(
        `[DELETE USER] Auth user ${uid} not found, continuing with Firestore deletion`
      )
    }

    // 3. Delete from Firestore (Soft delete is safer, but this is Hard Delete)
    const result = await db.collection('users').doc(uid).delete()
    console.log(`[DELETE USER] Firestore document ${uid} deleted:`, result)

    return { success: true, message: `User ${uid} and their memberships deleted.` }
  } catch (error: unknown) {
    console.error(`[DELETE USER] Error deleting user ${uid}:`, error)
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
