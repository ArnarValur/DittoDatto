// apps/public-marketplace/server/plugins/firebase.ts
import { initializeApp, getApps, cert, type App } from 'firebase-admin/app'
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'
import { readFileSync, existsSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

// Augment the H3 Context so every request has access to Firebase Admin
declare module 'h3' {
  interface H3EventContext {
    firebaseAdmin: {
      auth: ReturnType<typeof getAuth>
      firestore: ReturnType<typeof getFirestore>
    } | null
  }
}

/**
 * Attempts to load service account from multiple possible paths.
 * Supports both local development and Docker environments.
 */
function loadServiceAccount(): object | null {
  const possiblePaths = [
    // Explicit env var path
    process.env.GOOGLE_APPLICATION_CREDENTIALS,
    // Docker workspace path (volume mounted)
    '/app/apps/web/public-marketplace/service-account.json',
    // Local development paths
    './service-account.json',
    '../service-account.json',
    // Relative to this file
    resolve(dirname(fileURLToPath(import.meta.url)), '../../service-account.json'),
  ].filter(Boolean) as string[]

  for (const path of possiblePaths) {
    try {
      const absolutePath = path.startsWith('/') ? path : resolve(process.cwd(), path)

      if (existsSync(absolutePath)) {
        const content = readFileSync(absolutePath, 'utf8')
        const serviceAccount = JSON.parse(content)
        console.info(`✅ [Public] firebase: Loaded service account from ${absolutePath}`)
        return serviceAccount
      }
    } catch (e) {
      // Try next path
    }
  }

  return null
}

let firebaseApp: App | null = null

export default defineNitroPlugin((nitroApp) => {
  const projectId = process.env.NUXT_PUBLIC_FIREBASE_PROJECT_ID
  const isEmulator = !!process.env.FIRESTORE_EMULATOR_HOST

  // 1. Initialize Firebase Admin SDK (only once)
  if (getApps().length === 0) {
    try {
      if (!projectId) {
        console.warn('⚠️ [Public] firebase: No NUXT_PUBLIC_FIREBASE_PROJECT_ID set.')
      }

      // In development/Docker: Try to load service account
      if (import.meta.dev || isEmulator) {
        const serviceAccount = loadServiceAccount()

        if (serviceAccount) {
          firebaseApp = initializeApp({
            credential: cert(serviceAccount),
            projectId: projectId || (serviceAccount as any).project_id
          })
          console.info('✅ [Public] firebase: Admin SDK initialized with service account.')
        } else if (isEmulator) {
          // For emulators, we can initialize without credentials
          // The emulators don't require real auth
          firebaseApp = initializeApp({ projectId: projectId || 'demo-project' })
          console.info('✅ [Public] firebase: Admin SDK initialized for emulator (no credentials).')
        } else {
          console.error('❌ [Public] firebase: No service account found. Checked paths:')
          console.error('   - GOOGLE_APPLICATION_CREDENTIALS env var')
          console.error('   - /app/apps/web/public-marketplace/service-account.json')
          console.error('   - ./service-account.json')
        }
      }
      // Production: Use Application Default Credentials (ADC)
      else {
        firebaseApp = initializeApp({ projectId })
        console.info('✅ [Public] firebase: Admin SDK initialized via ADC.')
      }
    } catch (e: unknown) {
      const error = e as Error
      console.error('❌ [Public] firebase: Admin SDK initialization failed:', error.message)
    }
  } else {
    firebaseApp = getApps()[0]
    console.info('✅ [Public] firebase: Using existing Admin SDK instance.')
  }

  // 2. Only proceed if initialization succeeded
  if (!firebaseApp) {
    console.warn('⚠️ [Public] firebase: SDK not initialized. Server routes requiring admin will fail.')
    nitroApp.hooks.hook('request', (event) => {
      event.context.firebaseAdmin = null
    })
    return
  }

  // 3. Get services
  const auth = getAuth(firebaseApp)
  const firestore = getFirestore(firebaseApp)

  // 4. Log emulator connections
  if (isEmulator) {
    const firestoreHost = process.env.FIRESTORE_EMULATOR_HOST
    const authHost = process.env.FIREBASE_AUTH_EMULATOR_HOST
    console.info(`🔥 [Public] firebase: Firestore Emulator → ${firestoreHost}`)
    if (authHost) {
      console.info(`🔥 [Public] firebase: Auth Emulator → ${authHost}`)
    }
  }

  // 5. Attach to request context
  nitroApp.hooks.hook('request', (event) => {
    event.context.firebaseAdmin = { auth, firestore }
  })
})
