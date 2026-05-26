// apps/admin-panel/server/api/services/services.post.ts
import { getFirestore } from 'firebase-admin/firestore'
import { ServiceSchema } from '@dittodatto/shared-types'
import { z } from 'zod'

// Input schema: omit generated fields, require storeId context
const ServiceInputSchema = ServiceSchema.omit({
  id: true
}).extend({
  companyId: z.string().min(1) // Required to locate parent store
})

export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  // 1. Validate input
  const result = ServiceInputSchema.safeParse(body)
  if (!result.success) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid service data',
      data: result.error
    })
  }

  const { companyId, storeId, ...serviceData } = result.data
  const db = getFirestore()

  try {
    const storeRef = db.collection('companies').doc(companyId).collection('stores').doc(storeId)
    const storeSnap = await storeRef.get()

    if (!storeSnap.exists) {
      throw createError({ statusCode: 404, statusMessage: 'Store not found' })
    }

    const servicesRef = storeRef.collection('services')
    const newServiceRef = servicesRef.doc()

    const now = new Date().toISOString()
    const payload = {
      ...serviceData,
      id: newServiceRef.id,
      storeId,
      companyId, // Denormalize for easier querying
      createdAt: now,
      updatedAt: now
    }

    await newServiceRef.set(payload)

    return payload
  } catch (error: unknown) {
    // Re-throw if it's already a createError
    if (error && typeof error === 'object' && 'statusCode' in error) {
      throw error
    }
    console.error('Error creating service:', error)
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
