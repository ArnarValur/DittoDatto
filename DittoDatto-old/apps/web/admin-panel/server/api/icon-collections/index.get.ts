import { getFirestore } from 'firebase-admin/firestore'
import type { IconCollection } from '@dittodatto/shared-types'

// Essential default icons for seeding (subset of Material Symbols)
const DEFAULT_ICONS = [
  'i-material-symbols-home', 'i-material-symbols-store', 'i-material-symbols-restaurant',
  'i-material-symbols-settings', 'i-material-symbols-person', 'i-material-symbols-search',
  'i-material-symbols-calendar-month', 'i-material-symbols-phone', 'i-material-symbols-mail',
  'i-material-symbols-star', 'i-material-symbols-favorite', 'i-material-symbols-shopping-cart',
  'i-material-symbols-info', 'i-material-symbols-help', 'i-material-symbols-check-circle',
  'i-material-symbols-edit', 'i-material-symbols-delete', 'i-material-symbols-add',
  'i-material-symbols-location-on', 'i-material-symbols-schedule', 'i-material-symbols-local-cafe',
  'i-material-symbols-spa', 'i-material-symbols-fitness-center', 'i-material-symbols-local-bar'
]

export default defineEventHandler(async () => {
  try {
    const db = getFirestore()
    const collectionsRef = db.collection('iconCollections')
    const snapshot = await collectionsRef.orderBy('name').get()

    const collections: IconCollection[] = []
    snapshot.forEach((doc) => {
      const data = doc.data()
      collections.push({
        id: doc.id,
        name: data.name,
        description: data.description,
        icons: data.icons || [],
        isDefault: data.isDefault || false,
        createdAt: data.createdAt?.toDate?.()?.toISOString() || new Date().toISOString(),
        updatedAt: data.updatedAt?.toDate?.()?.toISOString() || new Date().toISOString()
      })
    })

    // If no collections exist, create a default collection
    if (collections.length === 0) {
      const defaultCollection = {
        name: 'Essential Icons',
        description: 'Default icon set - upload JSON to add more',
        isDefault: true,
        icons: DEFAULT_ICONS,
        createdAt: new Date(),
        updatedAt: new Date()
      }

      const docRef = await collectionsRef.add(defaultCollection)

      collections.push({
        id: docRef.id,
        name: defaultCollection.name,
        description: defaultCollection.description,
        icons: defaultCollection.icons,
        isDefault: defaultCollection.isDefault,
        createdAt: defaultCollection.createdAt.toISOString(),
        updatedAt: defaultCollection.updatedAt.toISOString()
      })
    }

    return {
      collections,
      total: collections.length
    }
  } catch (error: unknown) {
    console.error('Error fetching icon collections:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch icon collections'
    })
  }
})
