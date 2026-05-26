// apps/admin-panel/server/api/services/services.delete.ts
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const id = query.id as string
  const companyId = query.companyId as string
  const storeId = query.storeId as string

  if (!id || !companyId || !storeId) {
    throw createError({ statusCode: 400, statusMessage: 'id, companyId, and storeId are required' })
  }

  const db = getFirestore()

  try {
    const serviceRef = db.collection('companies').doc(companyId).collection('stores').doc(storeId).collection('services').doc(id)
    await serviceRef.delete()

    return { success: true }
  } catch (error: unknown) {
    console.error('Error deleting service:', error)
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
