import { getFirestore } from 'firebase-admin/firestore'
import { UpdateIconCollectionSchema } from '@dittodatto/shared-types'

export default defineEventHandler(async (event) => {
  try {
    const id = getRouterParam(event, 'id')
    if (!id) {
      throw createError({
        statusCode: 400,
        statusMessage: 'Collection ID is required'
      })
    }

    const body = await readBody(event)
    const parsed = UpdateIconCollectionSchema.safeParse(body)

    if (!parsed.success) {
      throw createError({
        statusCode: 400,
        statusMessage: parsed.error.issues[0]?.message || 'Invalid request'
      })
    }

    const db = getFirestore()
    const collectionRef = db.collection('iconCollections').doc(id)
    const doc = await collectionRef.get()

    if (!doc.exists) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Icon collection not found'
      })
    }

    const currentData = doc.data()!

    // Prevent editing default collections
    if (currentData.isDefault && (parsed.data.name || parsed.data.icons)) {
      throw createError({
        statusCode: 403,
        statusMessage: 'Cannot modify default collections'
      })
    }

    // Check for name conflicts
    if (parsed.data.name && parsed.data.name !== currentData.name) {
      const existing = await db.collection('iconCollections')
        .where('name', '==', parsed.data.name)
        .get()
      if (!existing.empty) {
        throw createError({
          statusCode: 409,
          statusMessage: 'Collection with this name already exists'
        })
      }
    }

    // Update
    const updateData: Record<string, unknown> = { updatedAt: new Date() }
    if (parsed.data.name !== undefined) updateData.name = parsed.data.name
    if (parsed.data.description !== undefined) updateData.description = parsed.data.description
    if (parsed.data.icons !== undefined) updateData.icons = parsed.data.icons

    await collectionRef.update(updateData)

    const updated = await collectionRef.get()
    const updatedData = updated.data()!

    return {
      success: true,
      collection: {
        id: updated.id,
        name: updatedData.name,
        description: updatedData.description,
        icons: updatedData.icons || [],
        isDefault: updatedData.isDefault || false,
        createdAt: updatedData.createdAt?.toDate?.()?.toISOString() || new Date().toISOString(),
        updatedAt: updatedData.updatedAt?.toDate?.()?.toISOString() || new Date().toISOString()
      }
    }
  } catch (error: unknown) {
    console.error('Error updating icon collection:', error)
    if (error instanceof Error && 'statusCode' in error) throw error
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to update icon collection'
    })
  }
})
