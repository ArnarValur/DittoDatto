import { getFirestore } from 'firebase-admin/firestore'
import { AppSettingsSchema } from '@dittodatto/shared-types'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  // Validate input
  const validation = AppSettingsSchema.partial().safeParse(body)
  if (!validation.success) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid settings data',
      data: validation.error.format()
    })
  }

  const db = getFirestore()
  const docRef = db.collection('settings').doc('general')

  try {
    const updateData = {
      ...validation.data,
      updatedAt: new Date()
    }

    await docRef.set(updateData, { merge: true })

    return { success: true, settings: updateData }
  } catch (error: unknown) {
    console.error('Error updating general settings:', error)
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
