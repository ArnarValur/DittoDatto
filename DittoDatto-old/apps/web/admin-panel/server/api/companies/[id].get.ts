// apps/admin-panel/server/api/companies/[id].get.ts
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const id = getRouterParam(event, 'id')
  if (!id) throw createError({ statusCode: 400, statusMessage: 'ID required' })

  const db = getFirestore()
  const docSnap = await db.collection('companies').doc(id).get()

  if (!docSnap.exists) {
    throw createError({ statusCode: 404, statusMessage: 'Company not found' })
  }

  // Return the data with the ID merged in
  return {
    id: docSnap.id,
    ...docSnap.data()
  }
})
