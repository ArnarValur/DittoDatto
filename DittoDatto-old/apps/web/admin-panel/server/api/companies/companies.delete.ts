// apps/admin-panel/server/api/companies/companies.delete.ts
import { getFirestore } from 'firebase-admin/firestore'
import { getAuth } from 'firebase-admin/auth'

/**
 * TODO: Data Deletion Strategy
 * - Consider implementing soft-delete (set `deletedAt` timestamp) before hard delete
 * - Add grace period for data recovery
 * - Handle cascade deletion for stores/services under company
 * - Notify affected members before deletion
 */

export default defineEventHandler(async (event) => {
  const { id } = getQuery(event)
  if (!id || typeof id !== 'string')
    throw createError({ statusCode: 400, statusMessage: 'ID required' })

  const db = getFirestore()
  const auth = getAuth()

  // 1. Get Company to find the Owner
  const companyRef = db.collection('companies').doc(id)
  const companySnap = await companyRef.get()

  if (!companySnap.exists) {
    throw createError({ statusCode: 404, statusMessage: 'Company not found' })
  }

  const { ownerId } = companySnap.data() as { ownerId: string }

  try {
    // 2. DATABASE CLEANUP (Transactional)
    await db.runTransaction(async (t) => {
      // A. Delete Company
      t.delete(companyRef)

      // B. Delete ALL memberships for this company (not just owner)
      const membershipQuery = await db
        .collection('memberships')
        .where('companyId', '==', id)
        .get()

      console.log(`[DELETE COMPANY] Deleting ${membershipQuery.size} membership(s) for company ${id}`)
      membershipQuery.docs.forEach(doc => t.delete(doc.ref))

      // C. Unlink Owner's User Profile
      const userRef = db.collection('users').doc(ownerId)
      t.set(
        userRef,
        {
          primaryCompanyId: null
        },
        { merge: true }
      )
    })

    // 3. AUTH CLEANUP (Remove access immediately)
    // We strip the 'companyId' claim so their token becomes invalid for the Portal
    try {
      const userRecord = await auth.getUser(ownerId)
      const currentClaims = userRecord.customClaims || {} as Record<string, unknown>

      // Remove companyId from claims object

      const { companyId, ...restClaims } = currentClaims

      await auth.setCustomUserClaims(ownerId, restClaims)
    } catch (e) {
      console.warn(
        'Owner Auth cleanup failed (User might already be deleted):',
        e
      )
    }

    return {
      success: true,
      message: `Company ${id} destroyed and all memberships removed.`
    }
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
