// apps/admin-panel/server/api/users/users.get.ts
import { getFirestore } from 'firebase-admin/firestore'

/**
 * Fetches the list of users from the database.
 * @param event The event object.
 * @returns The list of users.
 */
export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const page = Number(query.page) || 1
  const pageSize = Number(query.pageSize) || 10
  const search = query.search as string

  const db = getFirestore()
  const usersRef = db.collection('users')

  try {
    // 1. Get Total Count (for pagination)
    const countSnapshot = await usersRef.count().get()
    const totalUsers = countSnapshot.data().count

    // 2. Fetch ALL users and sort in code (to include docs without createdAt)
    const allUsersSnapshot = await usersRef.get()

    // 3. Map and sort by createdAt (newest first), with fallback for missing dates
    const allUsers = allUsersSnapshot.docs
      .map((doc) => {
        const data = doc.data()
        return {
          doc,
          data,
          sortDate: data.createdAt?.toDate?.() || new Date(0) // Fallback to epoch if missing
        }
      })
      .sort((a, b) => b.sortDate.getTime() - a.sortDate.getTime()) // Newest first

    // 4. Apply pagination
    const paginatedUsers = allUsers.slice(
      (page - 1) * pageSize,
      page * pageSize
    )

    // 5. Map to FirebaseUser shape (expected by frontend)
    const users = paginatedUsers.map(({ doc, data }) => ({
      uid: doc.id,
      displayName: data.name || '', // Map Firestore 'name' to 'displayName'
      email: data.email || '',
      photoURL: data.photoUrl || '', // Map Firestore 'photoUrl' to 'photoURL'
      role: data.roles?.[0] || 'customer', // Map Firestore 'roles' array to single 'role'
      customClaims: { role: data.roles?.[0] }, // Mock customClaims for compatibility
      metadata: {
        creationTime:
          data.createdAt?.toDate?.()?.toISOString() || new Date().toISOString(),
        lastSignInTime: data.lastLogin?.toDate?.()?.toISOString()
      }
    }))

    return {
      users,
      total: totalUsers,
      page,
      pageSize
    }
  } catch (error) {
    console.error('Error listing users:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to list users'
    })
  }
})
