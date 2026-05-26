import { getFirestore } from 'firebase-admin/firestore'
import { CategorySchema } from '@dittodatto/shared-types'

// Partial schema for PATCH - only id is required, rest optional
const CategoryPatchSchema = CategorySchema.partial().required({ id: true })

export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  // 1. Validation
  const result = CategoryPatchSchema.safeParse(body)
  if (!result.success) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid input',
      data: result.error.errors
    })
  }

  const { id, ...updateData } = result.data
  const db = getFirestore()
  const docRef = db.collection('categories').doc(id)

  try {
    // 2. Check if category exists
    const docSnap = await docRef.get()
    if (!docSnap.exists) {
      throw createError({ statusCode: 404, statusMessage: 'Category not found' })
    }

    // 3. Update slug if name changed
    const payload: Record<string, unknown> = {
      ...updateData,
      updatedAt: new Date()
    }

    if (updateData.name) {
      payload.slug = updateData.name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
    }

    // 4. Update Firestore
    await docRef.update(payload)

    return { success: true, id, ...payload }
  } catch (error: unknown) {
    // Re-throw if it's already a createError
    if (error && typeof error === 'object' && 'statusCode' in error) {
      throw error
    }
    console.error('Error updating category:', error)
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
