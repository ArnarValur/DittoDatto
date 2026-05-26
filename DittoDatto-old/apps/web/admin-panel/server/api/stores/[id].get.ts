// apps/admin-panel/server/api/stores/[id].get.ts
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const id = getRouterParam(event, 'id')
  const query = getQuery(event)
  const companyId = query.companyId as string

  if (!id || !companyId) {
    throw createError({ statusCode: 400, statusMessage: 'Store ID and Company ID (query) required' })
  }

  const db = getFirestore()
  const docSnap = await db.collection('companies')
    .doc(companyId)
    .collection('stores')
    .doc(id)
    .get()

  if (!docSnap.exists) {
    throw createError({ statusCode: 404, statusMessage: 'Store not found' })
  }

  return {
    id: docSnap.id,
    ...docSnap.data()
  }
})
