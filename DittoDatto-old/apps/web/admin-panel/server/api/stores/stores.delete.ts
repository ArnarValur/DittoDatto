// apps/admin-panel/server/api/stores.delete.ts
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const companyId = query.companyId as string
  const id = query.id as string

  if (!companyId || !id) {
    throw createError({ statusCode: 400, statusMessage: 'Company ID and Store ID required' })
  }

  const db = getFirestore()

  try {
    await db.collection('companies')
      .doc(companyId)
      .collection('stores')
      .doc(id)
      .delete()

    return { success: true, message: 'Store deleted' }
  } catch (error: unknown) {
    console.error('Error deleting store:', error)
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
