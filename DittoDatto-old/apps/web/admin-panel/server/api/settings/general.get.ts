import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (_event) => {
  const db = getFirestore()
  const docRef = db.collection('settings').doc('general')

  try {
    const docSnap = await docRef.get()

    if (!docSnap.exists) {
      // Return default settings if not found
      return {
        maintenanceMode: false,
        maintenanceMessage: 'The site is currently under maintenance. We will be back soon.',
        solarDebugEnabled: false
      }
    }

    return docSnap.data()
  } catch (error: unknown) {
    console.error('Error fetching general settings:', error)
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
