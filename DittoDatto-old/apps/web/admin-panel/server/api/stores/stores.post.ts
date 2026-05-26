import { getFirestore } from 'firebase-admin/firestore'
import { nordicSlugify } from '~~/utils/slugify'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  // We now accept gmapCoord from the frontend (Google Places API)
  const {
    companyId,
    name,
    address,
    city,
    zip,
    country,
    bookingFormType,
    gmapCoord,
    category
  } = body

  if (!companyId || !name) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Company ID and Name are required'
    })
  }

  const db = getFirestore()
  const companyRef = db.collection('companies').doc(companyId)

  // 1. Verify Parent Company
  const companySnap = await companyRef.get()
  if (!companySnap.exists) {
    throw createError({
      statusCode: 404,
      statusMessage: 'Parent Company not found'
    })
  }

  // 2. Generate Nordic Slug
  // "Børres Hårpleie" -> "borres-harpleie"
  let slug = nordicSlugify(name)

  // 3. Collision Check (Optional but Smart)
  // If "viking-barbers" exists, make "viking-barbers-2"
  const existingCheck = await companyRef
    .collection('stores')
    .where('slug', '==', slug)
    .get()
  if (!existingCheck.empty) {
    slug = `${slug}-${Math.floor(Math.random() * 1000)}`
  }

  // 4. Default Schedule (The standard 09-17 grind)
  const defaultDay = { isOpen: true, open: '09:00', close: '17:00' }
  const closedDay = { isOpen: false, open: '00:00', close: '00:00' }

  const newStore = {
    name,
    slug,
    address: address || '',
    city: city || 'Oslo',
    zip: zip || '',
    country: country || 'Norge',
    bookingFormType: bookingFormType || 'standard',
    // Save the coordinate if provided, else undefined (Schema allows optional)
    gmapCoord: gmapCoord ? { lat: gmapCoord.lat, lng: gmapCoord.lng } : null,

    isActive: true,
    createdAt: new Date(),
    openingSchedule: {
      mon: defaultDay,
      tue: defaultDay,
      wed: defaultDay,
      thu: defaultDay,
      fri: defaultDay,
      sat: defaultDay,
      sun: closedDay
    },
    timezone: 'Europe/Oslo',
    category: category || null
  }

  try {
    const storeRef = await companyRef.collection('stores').add(newStore)
    return {
      success: true,
      id: storeRef.id,
      slug,
      message: 'Store created successfully'
    }
  } catch (error: any) {
    throw createError({ statusCode: 500, statusMessage: error.message })
  }
})
