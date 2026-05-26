// apps/admin-panel/server/api/companies/companies.patch.ts
import { getFirestore } from 'firebase-admin/firestore'
import { getAuth } from 'firebase-admin/auth'
import { CompanySchema } from '@dittodatto/shared-types'
import { z } from 'zod'

// Partial schema for PATCH - id required for locating
const CompanyPatchSchema = CompanySchema.partial().extend({
  id: z.string().min(1)
})

export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  // 1. Validate input
  const result = CompanyPatchSchema.safeParse(body)
  if (!result.success) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid company data',
      data: result.error
    })
  }

  const { id, ...updateData } = result.data
  const db = getFirestore()
  const auth = getAuth()
  const companyRef = db.collection('companies').doc(id)

  try {
    // 2. Check if company exists and get current data
    const companySnap = await companyRef.get()
    if (!companySnap.exists) {
      throw createError({ statusCode: 404, statusMessage: 'Company not found' })
    }

    const currentCompanyData = companySnap.data()
    const oldOwnerEmail = currentCompanyData?.ownerEmail
    const newOwnerEmail = updateData.ownerEmail

    // 3. Check if owner is changing
    const ownerChanged = newOwnerEmail && newOwnerEmail !== oldOwnerEmail

    // 4. If owner is changing, update auth claims for both old and new owner
    if (ownerChanged) {
      console.log(`[Company PATCH] Owner changing from ${oldOwnerEmail} to ${newOwnerEmail}`)

      // Get new owner's UID and update their claims
      try {
        const newOwnerRecord = await auth.getUserByEmail(newOwnerEmail)

        // Update company document with new ownerId
        updateData.ownerId = newOwnerRecord.uid

        // Update new owner's auth claims - add this company to their list
        const newOwnerClaims = newOwnerRecord.customClaims || {}
        const newOwnerCompanyIds: string[] = newOwnerClaims.companyIds || []

        if (!newOwnerCompanyIds.includes(id)) {
          newOwnerCompanyIds.push(id)
        }

        await auth.setCustomUserClaims(newOwnerRecord.uid, {
          ...newOwnerClaims,
          companyId: newOwnerClaims.companyId || id, // Keep existing primary or set new
          companyIds: newOwnerCompanyIds,
          role: newOwnerClaims.role === 'super_admin' ? 'super_admin' : 'business'
        })

        // Ensure Firestore user document also has the correct role
        const userRef = db.collection('users').doc(newOwnerRecord.uid)
        await userRef.set({
          role: newOwnerClaims.role === 'super_admin' ? 'super_admin' : 'business',
          updatedAt: new Date()
        }, { merge: true })
        console.log(`[Company PATCH] Updated claims for new owner: ${newOwnerEmail}`)

        // Remove this company from old owner's claims (if they have any)
        if (oldOwnerEmail) {
          try {
            const oldOwnerRecord = await auth.getUserByEmail(oldOwnerEmail)
            const oldOwnerClaims = oldOwnerRecord.customClaims || {}
            const oldOwnerCompanyIds: string[] = oldOwnerClaims.companyIds || []

            const updatedOldIds = oldOwnerCompanyIds.filter((cid: string) => cid !== id)

            await auth.setCustomUserClaims(oldOwnerRecord.uid, {
              ...oldOwnerClaims,
              companyId: updatedOldIds[0] || null, // Update primary to first remaining or null
              companyIds: updatedOldIds,
              // Keep role as 'business' if they still have other companies
              role: updatedOldIds.length > 0 ? 'business' : oldOwnerClaims.role
            })

            console.log(`[Company PATCH] Removed company from old owner: ${oldOwnerEmail}`)
          } catch (oldOwnerError) {
            console.warn(`[Company PATCH] Could not update old owner claims:`, oldOwnerError)
            // Non-fatal - continue with update
          }
        }
      } catch (newOwnerError: unknown) {
        const errorMsg = newOwnerError instanceof Error ? newOwnerError.message : 'Unknown error'
        throw createError({
          statusCode: 400,
          statusMessage: `Could not find new owner: ${errorMsg}`
        })
      }
    }

    // 5. Update company document with validated data
    const payload = {
      ...updateData,
      updatedAt: new Date()
    }

    await companyRef.update(payload)

    return {
      success: true,
      id,
      message: ownerChanged
        ? 'Company updated and owner claims synced'
        : 'Company updated successfully'
    }
  } catch (error: unknown) {
    // Re-throw if it's already a createError
    if (error && typeof error === 'object' && 'statusCode' in error) {
      throw error
    }
    console.error('Error updating company:', error)
    const message = error instanceof Error ? error.message : 'Unknown error'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
