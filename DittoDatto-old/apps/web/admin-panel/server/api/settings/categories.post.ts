import { getFirestore } from 'firebase-admin/firestore'
import { CategorySchema } from '@dittodatto/shared-types'
import { z } from 'zod'

// We only need a subset for creation/update
const CategoryInputSchema = CategorySchema.omit({
  id: true,
  slug: true,
  createdAt: true,
  updatedAt: true
}).extend({
  id: z.string().optional() // Optional logic for Updates
})

export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  // 1. Validation
  const result = CategoryInputSchema.safeParse(body)
  if (!result.success) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid input',
      data: result.error.errors
    })
  }

  const data = result.data
  const db = getFirestore()

  // 2. Slug & ID Logic
  const slug = data.name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')

  const docData = {
    ...data,
    slug,
    updatedAt: new Date()
  }

  // 3. Write to Firestore
  if (data.id) {
    // Update
    await db.collection('categories').doc(data.id).set(docData, { merge: true })
    return { id: data.id, ...docData }
  } else {
    // Create new
    const docRef = db.collection('categories').doc() // Auto ID or use slug? Auto ID is safer for renames
    const newCategory = {
      ...docData,
      id: docRef.id,
      createdAt: new Date()
    }
    await docRef.set(newCategory)
    return newCategory
  }
})
