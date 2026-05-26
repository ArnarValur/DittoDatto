// apps/admin-panel/server/api/users.patch.ts
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const { uid, ...updates } = body

  if (!uid) {
    throw createError({ statusCode: 400, statusMessage: 'UID is required' })
  }

  try {
    const authUpdates: any = {}
    const firestoreUpdates: any = {}

    // 1. MAP UPDATES TO AUTH SYSTEM (Login/Access)
    if (updates.email) authUpdates.email = updates.email
    if (updates.displayName) authUpdates.displayName = updates.displayName
    if (updates.password) authUpdates.password = updates.password // Only if provided
    if (typeof updates.disabled === 'boolean')
      authUpdates.disabled = updates.disabled

    // Perform Auth Update
    if (Object.keys(authUpdates).length > 0) {
      await getAuth().updateUser(uid, authUpdates)
    }

    // 2. HANDLE ROLES (Security Claims)
    // If role is changing, we must update the Custom Claims on the token
    // CRITICAL: Preserve existing claims (companyId, companyIds, etc.)
    if (updates.role) {
      const userRecord = await getAuth().getUser(uid)
      const existingClaims = userRecord.customClaims || {}
      await getAuth().setCustomUserClaims(uid, {
        ...existingClaims,
        role: updates.role
      })
      // Sync to Firestore for UI filtering
      firestoreUpdates.roles = [updates.role]
    }

    // 3. MAP UPDATES TO FIRESTORE (Business Profile)
    if (updates.email) firestoreUpdates.email = updates.email
    if (updates.displayName) firestoreUpdates.name = updates.displayName
    if (updates.phone) firestoreUpdates.phone = updates.phone
    if (updates.tier) firestoreUpdates.tier = updates.tier
    if (typeof updates.isOnboarded === 'boolean')
      firestoreUpdates.isOnboarded = updates.isOnboarded

    // Perform Firestore Update
    if (Object.keys(firestoreUpdates).length > 0) {
      // { merge: true } ensures we don't wipe existing fields like createdAt
      await getFirestore()
        .collection('users')
        .doc(uid)
        .set(firestoreUpdates, { merge: true })
    }

    return { success: true, uid, message: 'User updated successfully' }
  } catch (error: any) {
    console.error('Update User Error:', error)
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Failed to update user'
    })
  }
})
