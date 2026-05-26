// apps/admin-panel/server/api/bookings/bookings.get.ts
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const companyId = query.companyId as string | undefined
  const storeId = query.storeId as string | undefined
  const status = query.status as string | undefined
  const search = (query.search as string || '').toLowerCase().trim()

  // Pagination
  const page = Number(query.page) || 1
  const pageSize = Number(query.pageSize) || 20

  const db = getFirestore()

  try {
    // Build Firestore query against top-level 'bookings' collection
    let ref: FirebaseFirestore.Query = db.collection('bookings')

    // Apply filters
    if (companyId) {
      ref = ref.where('companyId', '==', companyId)
    }
    if (storeId) {
      ref = ref.where('storeId', '==', storeId)
    }
    if (status) {
      ref = ref.where('status', '==', status)
    }

    // Order by startTime descending (most recent first)
    ref = ref.orderBy('startTime', 'desc')

    // Get total count (separate query)
    const countSnap = await ref.count().get()
    const total = countSnap.data().count

    // Paginate
    const snapshot = await ref
      .offset((page - 1) * pageSize)
      .limit(pageSize)
      .get()

    let bookings = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }))

    // Client-side search filter (Firestore doesn't support full-text search)
    if (search) {
      bookings = bookings.filter((b: any) => {
        const searchable = [
          b.userName,
          b.userEmail,
          b.serviceTitle,
          b.paymentId,
          b.id
        ].filter(Boolean).join(' ').toLowerCase()
        return searchable.includes(search)
      })
    }

    // Resolve store and company names for display
    if (bookings.length > 0) {
      const storeNameMap: Record<string, string> = {}
      const companyNameMap: Record<string, string> = {}

      await Promise.all(bookings.map(async (b: any) => {
        // Resolve store name
        if (b.storeId && !storeNameMap[b.storeId] && b.companyId) {
          try {
            const sSnap = await db.collection('companies').doc(b.companyId).collection('stores').doc(b.storeId).get()
            storeNameMap[b.storeId] = sSnap.exists ? sSnap.data()?.name || 'Unknown' : 'Unknown'
          } catch { storeNameMap[b.storeId] = 'Error' }
        }

        // Resolve company name
        if (b.companyId && !companyNameMap[b.companyId]) {
          try {
            const cSnap = await db.collection('companies').doc(b.companyId).get()
            companyNameMap[b.companyId] = cSnap.exists ? cSnap.data()?.name || 'Unknown' : 'Unknown'
          } catch { companyNameMap[b.companyId] = 'Error' }
        }
      }))

      bookings = bookings.map((b: any) => ({
        ...b,
        storeName: storeNameMap[b.storeId] || b.storeId,
        companyName: companyNameMap[b.companyId] || b.companyId
      }))
    }

    return {
      bookings,
      total,
      page,
      pageSize
    }
  } catch (error: any) {
    console.error('Error fetching bookings:', error)
    throw createError({ statusCode: 500, statusMessage: error.message })
  }
})
