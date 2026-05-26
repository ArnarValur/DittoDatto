// seed.ts - Optimized for the "Grown" Twin Drammen Script
import { initializeApp } from 'firebase-admin/app'
import { getFirestore } from 'firebase-admin/firestore'
import { getAuth } from 'firebase-admin/auth'
import * as fs from 'fs'

const PROJECT_ID = 'cs-poc-4zmxog23jmy4io0d4yx6rj0'
process.env.FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080'

import * as path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const SEED_DATA = JSON.parse(
  fs.readFileSync(
    path.resolve(__dirname, '../../../../../.docs(DittoDatto)/Misc/scripts/Faker/drammen_seed.json'),
    'utf8'
  )
)

initializeApp({ projectId: PROJECT_ID })
const db = getFirestore()
const auth = getAuth()

async function seedDigitalTwin() {
  console.log('🏙️  Populating Digital Drammen...')
  const batch = db.batch()

  // 1. Categories (Top Level)
  if (SEED_DATA.categories) {
    SEED_DATA.categories.forEach((cat: any) =>
      batch.set(db.collection('categories').doc(cat.id), cat)
    )
  }

  // 2. Users (Top Level)
  SEED_DATA.users.forEach((u: any) =>
    batch.set(db.collection('users').doc(u.id), u)
  )

  // 3. Companies (Top Level)
  SEED_DATA.companies.forEach((c: any) =>
    batch.set(db.collection('companies').doc(c.id), c)
  )

  // 3. Nested Stores (companies/{compId}/stores/{storeId})
  SEED_DATA.stores.forEach((s: any) => {
    const ref = db
      .collection('companies')
      .doc(s.companyId)
      .collection('stores')
      .doc(s.id)
    batch.set(ref, s)
  })

  // 4. Persons & Services (companies/{compId}/stores/{storeId}/...)
  // We map stores by ID for quick parent lookup
  const storeMap = new Map(SEED_DATA.stores.map((s: any) => [s.id, s]))

  SEED_DATA.persons.forEach((p: any) => {
    const parentStore = storeMap.get(p.storeId)
    if (parentStore) {
      const ref = db
        .collection('companies')
        .doc(parentStore.companyId)
        .collection('stores')
        .doc(p.storeId)
        .collection('persons')
        .doc(p.id)
      batch.set(ref, p)
    }
  })

  SEED_DATA.services.forEach((sv: any) => {
    const parentStore = storeMap.get(sv.storeId)
    if (parentStore) {
      const ref = db
        .collection('companies')
        .doc(parentStore.companyId)
        .collection('stores')
        .doc(sv.storeId)
        .collection('services')
        .doc(sv.id)
      batch.set(ref, sv)
    }
  })

  await batch.commit()
  console.log(`✅ Success! Drammen is now live in the emulator.`)
}

seedDigitalTwin().catch(console.error)
