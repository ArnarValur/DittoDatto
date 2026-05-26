// apps/admin-panel/server/api/stores/stores.get.ts
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const companyId = query.companyId as string

  // Pagination
  const page = Number(query.page) || 1
  const pageSize = Number(query.pageSize) || 20

  const db = getFirestore()
  let stores: any[] = []
  let total = 0

  try {
    if (companyId) {
      // --- MODE A: Specific Company (The Original Way) ---
      const storesRef = db.collection('companies').doc(companyId).collection('stores')

      // 1. Get Count
      const countSnap = await storesRef.count().get()
      total = countSnap.data().count

      // 2. Get Data
      const snapshot = await storesRef
        .offset((page - 1) * pageSize)
        .limit(pageSize)
        .get()

      stores = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }))
    } else {
      // --- MODE B: All Stores (The "Super Admin" Way) ---
      // collectionGroup finds ALL collections named 'stores' anywhere in the DB
      const storesRef = db.collectionGroup('stores')

      // 1. Get Real Count (Fixed!)
      const countSnap = await storesRef.count().get()
      total = countSnap.data().count

      // 2. Get Data
      // Note: If you have >10k stores, you might eventually need an index here
      const snapshot = await storesRef
        .offset((page - 1) * pageSize)
        .limit(pageSize)
        .get()

      // We add companyId to the response so the UI knows who owns it
      stores = snapshot.docs.map((doc) => {
        const data = doc.data()
        // The parent of a store doc is the 'stores' collection.
        // The parent of that collection is the 'company' doc.
        // We can extract the companyId from the ref path if it's not saved in the doc.
        const parentCompanyId = doc.ref.parent.parent?.id

        return {
          id: doc.id,
          companyId: data.companyId || parentCompanyId, // Fallback to path ID
          ...data
        }
      })
    }

    return {
      stores,
      total,
      page,
      pageSize
    }
  } catch (error: any) {
    console.error('Error fetching stores:', error)
    throw createError({ statusCode: 500, statusMessage: error.message })
  }
})
