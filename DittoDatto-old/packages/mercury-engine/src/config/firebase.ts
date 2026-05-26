/**
 * Firebase Admin initialization for MercuryEngine
 * 
 * In development: Uses FIRESTORE_EMULATOR_HOST env var
 * In production: Uses default credentials from Cloud Run
 */

import { initializeApp, getApps, cert } from 'firebase-admin/app'
import { getFirestore } from 'firebase-admin/firestore'

// Initialize Firebase Admin only once
if (getApps().length === 0) {
    initializeApp({
        projectId: process.env.GCLOUD_PROJECT || 'cs-poc-4zmxog23jmy4io0d4yx6rj0',
    })
}

export const db = getFirestore()

// Enable better logging in dev
if (process.env.NODE_ENV !== 'production') {
    db.settings({ ignoreUndefinedProperties: true })
}

export default db
