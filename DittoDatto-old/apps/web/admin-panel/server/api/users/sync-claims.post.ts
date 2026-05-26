/**
 * Sync User Claims — Admin Panel
 *
 * POST /api/users/sync-claims
 * Body: { uid: string }
 *
 * Reads the user's Firestore profile and syncs companyId/role to
 * Firebase Auth custom claims. Fixes the gap where users were created
 * with a role but without company claims.
 */
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const { uid } = body

  if (!uid) {
    throw createError({ statusCode: 400, statusMessage: 'UID is required' })
  }

  try {
    const db = getFirestore()
    const auth = getAuth()

    // 1. Get current Firestore profile
    const userDoc = await db.collection('users').doc(uid).get()
    if (!userDoc.exists) {
      throw createError({ statusCode: 404, statusMessage: 'User not found in Firestore' })
    }

    const userData = userDoc.data()!
    const role = userData.roles?.[0] || 'customer'
    const primaryCompanyId = userData.primaryCompanyId

    // 2. Get current Auth claims
    const userRecord = await auth.getUser(uid)
    const existingClaims = userRecord.customClaims || {}

    // 3. Build synced claims
    const newClaims: Record<string, unknown> = {
      ...existingClaims,
      role
    }

    // If user has a company, ensure it's in claims
    if (primaryCompanyId) {
      const existingCompanyIds: string[] = existingClaims.companyIds || []
      if (!existingCompanyIds.includes(primaryCompanyId)) {
        existingCompanyIds.push(primaryCompanyId)
      }
      newClaims.companyId = existingCompanyIds[0]
      newClaims.companyIds = existingCompanyIds
    }

    // 4. Check for any memberships
    const memberships = await db.collection('memberships')
      .where('userId', '==', uid)
      .get()

    if (!memberships.empty) {
      const companyIds: string[] = (newClaims.companyIds as string[]) || []
      for (const doc of memberships.docs) {
        const cid = doc.data().companyId
        if (cid && !companyIds.includes(cid)) {
          companyIds.push(cid)
        }
      }
      if (companyIds.length > 0) {
        newClaims.companyId = companyIds[0]
        newClaims.companyIds = companyIds
      }
    }

    // 5. Apply
    await auth.setCustomUserClaims(uid, newClaims)

    // 6. Revoke refresh tokens to force re-auth with new claims
    await auth.revokeRefreshTokens(uid)

    return {
      success: true,
      uid,
      previousClaims: existingClaims,
      newClaims,
      note: 'Refresh tokens revoked — user must re-login to get new claims'
    }
  } catch (error: any) {
    console.error('Sync Claims Error:', error)
    throw createError({
      statusCode: error.statusCode || 500,
      statusMessage: error.statusMessage || error.message || 'Failed to sync claims'
    })
  }
})
