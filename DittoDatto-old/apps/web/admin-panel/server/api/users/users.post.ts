/**
 * Create User API — Admin Panel
 *
 * Creates a user in Firebase Auth + Firestore profile.
 * When role is "business" and companyId is provided:
 * - Sets companyId/companyIds in custom claims
 * - Creates a membership doc
 * - Updates company.ownerId
 * - Sets primaryCompanyId on user profile
 */
import { getAuth } from 'firebase-admin/auth'
import { getFirestore, FieldValue } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  try {
    // 1. Create in Firebase Auth
    const userRecord = await getAuth().createUser({
      email: body.email,
      password: body.password || '123456', // TODO: Require password reset flow
      displayName: body.displayName,
      emailVerified: true // Admin-created users bypass verification
    })

    const role = body.role || 'customer'
    const companyId = body.companyId // Optional: link user to company

    // 2. Build custom claims
    const claims: Record<string, unknown> = { role }

    if (role === 'business' && companyId) {
      claims.companyId = companyId
      claims.companyIds = [companyId]
    }

    await getAuth().setCustomUserClaims(userRecord.uid, claims)

    // 3. Create Firestore Profile
    const db = getFirestore()
    const userProfile: Record<string, unknown> = {
      uid: userRecord.uid,
      email: body.email,
      name: body.displayName,
      roles: [role],
      createdAt: FieldValue.serverTimestamp(),
      isOnboarded: false
    }

    if (role === 'business' && companyId) {
      userProfile.primaryCompanyId = companyId
    }

    if (body.phone) {
      userProfile.phone = body.phone
    }

    await db.collection('users').doc(userRecord.uid).set(userProfile)

    // 4. If business role with company, create membership + update company
    if (role === 'business' && companyId) {
      // Create membership
      await db.collection('memberships').add({
        userId: userRecord.uid,
        companyId,
        role: 'owner',
        createdAt: FieldValue.serverTimestamp()
      })

      // Update company owner
      await db.collection('companies').doc(companyId).set({
        ownerId: userRecord.uid,
        ownerEmail: body.email,
        updatedAt: FieldValue.serverTimestamp()
      }, { merge: true })
    }

    return { success: true, uid: userRecord.uid }
  } catch (error: any) {
    console.error('Create User Error:', error)
    throw createError({ statusCode: 400, statusMessage: error.message })
  }
})
