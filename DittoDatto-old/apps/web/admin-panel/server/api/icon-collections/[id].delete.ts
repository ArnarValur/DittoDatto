import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  try {
    const id = getRouterParam(event, 'id')
    if (!id) {
      throw createError({
        statusCode: 400,
        statusMessage: 'Collection ID is required'
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

    const data = doc.data()!

    // Prevent deleting default collections
    if (data.isDefault) {
      throw createError({
        statusCode: 403,
        statusMessage: 'Cannot delete default collections'
      })
    }

    await collectionRef.delete()

    return {
      success: true,
      message: 'Icon collection deleted successfully'
    }
  } catch (error: unknown) {
    console.error('Error deleting icon collection:', error)
    if (error instanceof Error && 'statusCode' in error) throw error
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to delete icon collection'
    })
  }
})
