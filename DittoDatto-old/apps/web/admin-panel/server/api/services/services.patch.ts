// apps/admin-panel/server/api/services/services.patch.ts
import { getFirestore } from 'firebase-admin/firestore'
import { ServiceSchema } from '@dittodatto/shared-types'
import { z } from 'zod'

// Partial schema for PATCH - id, companyId, storeId required for locating
const ServicePatchSchema = ServiceSchema.partial().extend({
  id: z.string().min(1),
  companyId: z.string().min(1),
  storeId: z.string().min(1)
})

export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  // 1. Validate input
  const result = ServicePatchSchema.safeParse(body)
  if (!result.success) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid service data',
      data: result.error
    })
  }

  const { id, companyId, storeId, ...updateData } = result.data
  const db = getFirestore()

  try {
    const serviceRef = db.collection('companies').doc(companyId).collection('stores').doc(storeId).collection('services').doc(id)
    const serviceSnap = await serviceRef.get()

    if (!serviceSnap.exists) {
      throw createError({ statusCode: 404, statusMessage: 'Service not found' })
    }

    const payload = {
      ...updateData,
      updatedAt: new Date().toISOString()
    }

    await serviceRef.update(payload)

    return { success: true, id, ...payload }
  } catch (error: unknown) {
    // Re-throw if it's already a createError
    if (error && typeof error === 'object' && 'statusCode' in error) {
      throw error
    }
    console.error('Error updating service:', error)
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
