// apps/admin-panel/server/api/services/services.get.ts
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const companyId = query.companyId as string
  const storeId = query.storeId as string

  // Pagination
  const page = Number(query.page) || 1
  const pageSize = Number(query.pageSize) || 20

  const db = getFirestore()
  let services: any[] = []
  let total = 0

  try {
    if (companyId && storeId) {
      // --- MODE A: Specific Store ---
      const servicesRef = db.collection('companies').doc(companyId).collection('stores').doc(storeId).collection('services')

      const countSnap = await servicesRef.count().get()
      total = countSnap.data().count

      const snapshot = await servicesRef
        .offset((page - 1) * pageSize)
        .limit(pageSize)
        .get()

      services = snapshot.docs.map(doc => ({ id: doc.id, companyId, storeId, ...doc.data() }))
    } else if (companyId) {
      // --- MODE B: All Services in a Company ---
      // This is trickier if we don't use collectionGroup.
      // But collectionGroup 'services' with a filter on path is better.
      const servicesRef = db.collectionGroup('services')

      // We'll need to filter by parent path or do it in-memory if not too many.
      // Better: Fetch all services and filter by path if companyId is provided.
      // Firestore doesn't support path prefix queries on collectionGroup easily without extra fields.
      // For now, if companyId is provided but not storeId, we might need to fetch all and filter or
      // just use collectionGroup and filter by a 'companyId' field if it exists (it should in our denormalized world).

      const snapshot = await servicesRef.get()
      const allServices = snapshot.docs.map((doc) => {
        const data = doc.data()
        // Extract IDs from path: companies/{cId}/stores/{sId}/services/{svcId}
        const pathParts = doc.ref.path.split('/')
        const cId = pathParts[1]
        const sId = pathParts[3]
        return { id: doc.id, companyId: cId, storeId: sId, ...data }
      })

      const filtered = allServices.filter(s => s.companyId === companyId)
      total = filtered.length
      services = filtered.slice((page - 1) * pageSize, page * pageSize)
    } else {
      // --- MODE C: Global Services ---
      const servicesRef = db.collectionGroup('services')

      const countSnap = await servicesRef.count().get()
      total = countSnap.data().count

      const snapshot = await servicesRef
        .offset((page - 1) * pageSize)
        .limit(pageSize)
        .get()

      services = snapshot.docs.map((doc) => {
        const data = doc.data()
        const pathParts = doc.ref.path.split('/')
        const cId = pathParts[1]
        const sId = pathParts[3]

        return {
          id: doc.id,
          companyId: cId,
          storeId: sId,
          ...data
        }
      })
    }

    // Resolve store names for UI display
    if (services.length > 0) {
      const storeIds = [...new Set(services.map(s => s.storeId))]
      // We can't easily do a join across paths in Firestore, but we can fetch the stores in parallel
      const storeNameMap: Record<string, string> = {}

      await Promise.all(services.map(async (s) => {
        if (storeNameMap[s.storeId]) return

        try {
          const sRef = db.collection('companies').doc(s.companyId).collection('stores').doc(s.storeId)
          const sSnap = await sRef.get()
          if (sSnap.exists) {
            storeNameMap[s.storeId] = sSnap.data()?.name || 'Unknown'
          }
        } catch (e) {
          storeNameMap[s.storeId] = 'Error'
        }
      }))

      services = services.map(s => ({
        ...s,
        storeName: storeNameMap[s.storeId] || s.storeId
      }))
    }

    return {
      services,
      total,
      page,
      pageSize
    }
  } catch (error: any) {
    console.error('Error fetching services:', error)
    throw createError({ statusCode: 500, statusMessage: error.message })
  }
})
