// apps/admin-panel/server/api/users/[id].get.ts
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  // 1. Get the ID from the URL
  const userId = getRouterParam(event, 'id')
  if (!userId)
    throw createError({ statusCode: 400, statusMessage: 'User ID required' })

  try {
    // 2. Parallel Fetch: Get Auth Data AND Firestore Data
    const [authRecord, profileSnap] = await Promise.all([
      getAuth().getUser(userId),
      getFirestore().collection('users').doc(userId).get()
    ])

    // 3. Merge them into the "Master View" object
    return {
      // Auth Data (System of Record for Access)
      uid: authRecord.uid,
      email: authRecord.email,
      emailVerified: authRecord.emailVerified,
      disabled: authRecord.disabled,
      lastSignInTime: authRecord.metadata.lastSignInTime,
      creationTime: authRecord.metadata.creationTime,
      customClaims: authRecord.customClaims || {},

      // Firestore Data (Business Profile)
      profile: profileSnap.exists ? profileSnap.data() : null,

      // Computed Status
      status: authRecord.disabled ? 'suspended' : 'active'
    }
  } catch (error: any) {
    if (error.code === 'auth/user-not-found') {
      throw createError({
        statusCode: 404,
        statusMessage: 'User not found in Auth'
      })
    }
    console.error('Error fetching user details:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch user details'
    })
  }
})
