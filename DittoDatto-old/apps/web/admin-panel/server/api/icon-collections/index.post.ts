import { getFirestore } from 'firebase-admin/firestore'
import { CreateIconCollectionSchema } from '@dittodatto/shared-types'

export default defineEventHandler(async (event) => {
  try {
    const body = await readBody(event)
    const parsed = CreateIconCollectionSchema.safeParse(body)

    if (!parsed.success) {
      throw createError({
        statusCode: 400,
        statusMessage: parsed.error.issues[0]?.message || 'Invalid request'
      })
    }

    const { name, description, icons } = parsed.data

    const db = getFirestore()
    const collectionsRef = db.collection('iconCollections')

    // Check for duplicate name
    const existing = await collectionsRef.where('name', '==', name).get()
    if (!existing.empty) {
      throw createError({
        statusCode: 409,
        statusMessage: 'Collection with this name already exists'
      })
    }

    // Create the collection
    const newCollection = {
      name,
      description: description || '',
      icons,
      isDefault: false,
      createdAt: new Date(),
      updatedAt: new Date()
    }

    const docRef = await collectionsRef.add(newCollection)

    return {
      success: true,
      collection: {
        id: docRef.id,
        ...newCollection,
        createdAt: newCollection.createdAt.toISOString(),
        updatedAt: newCollection.updatedAt.toISOString()
      }
    }
  } catch (error: unknown) {
    console.error('Error creating icon collection:', error)
    if (error instanceof Error && 'statusCode' in error) throw error
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to create icon collection'
    })
  }
})
