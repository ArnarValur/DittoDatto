// apps/admin-panel/server/api/stores/stores.patch.ts
import { getFirestore } from 'firebase-admin/firestore'
import { StoreSchema } from '@dittodatto/shared-types'
import { z } from 'zod'

// Partial schema for PATCH - id and companyId required for locating
const StorePatchSchema = StoreSchema.partial().extend({
  id: z.string().min(1),
  companyId: z.string().min(1)
})

export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  // 1. Validate input
  const result = StorePatchSchema.safeParse(body)
  if (!result.success) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid store data',
      data: result.error
    })
  }

  const { id, companyId, ...updateData } = result.data
  const db = getFirestore()

  try {
    const storeRef = db
      .collection('companies')
      .doc(companyId)
      .collection('stores')
      .doc(id)

    // 2. Check if store exists
    const storeSnap = await storeRef.get()
    if (!storeSnap.exists) {
      throw createError({ statusCode: 404, statusMessage: 'Store not found' })
    }

    // 3. Update with validated data
    const payload = {
      ...updateData,
      updatedAt: new Date()
    }

    await storeRef.update(payload)

    return { success: true, id, ...payload }
  } catch (error: unknown) {
    // Re-throw if it's already a createError
    if (error && typeof error === 'object' && 'statusCode' in error) {
      throw error
    }
    console.error('Error updating store:', error)
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
