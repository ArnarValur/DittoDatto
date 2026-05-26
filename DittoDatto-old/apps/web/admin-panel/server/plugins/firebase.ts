// apps/admin-panel/server/plugins/firebase.ts
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
    process.env.GOOGLE_APPLICATION_CREDENTIALS,
    '/app/apps/web/admin-panel/service-account.json',
    './service-account.json',
    '../service-account.json',
    resolve(dirname(fileURLToPath(import.meta.url)), '../../service-account.json'),
  ].filter(Boolean) as string[]

  for (const path of possiblePaths) {
    try {
      const absolutePath = path.startsWith('/') ? path : resolve(process.cwd(), path)
      if (existsSync(absolutePath)) {
        const content = readFileSync(absolutePath, 'utf8')
        const serviceAccount = JSON.parse(content)
        console.info(`✅ [Admin] firebase: Loaded service account from ${absolutePath}`)
        return serviceAccount
      }
    } catch {
      // Try next path
    }
  }
  return null
}

let firebaseApp: App | null = null

export default defineNitroPlugin((nitroApp) => {
  const projectId = process.env.NUXT_PUBLIC_FIREBASE_PROJECT_ID
  const isEmulator = !!process.env.FIRESTORE_EMULATOR_HOST

  if (getApps().length === 0) {
    try {
      if (!projectId) {
        console.warn('⚠️ [Admin] firebase: No NUXT_PUBLIC_FIREBASE_PROJECT_ID set.')
      }

      if (import.meta.dev || isEmulator) {
        const serviceAccount = loadServiceAccount()

        if (serviceAccount) {
          firebaseApp = initializeApp({
            credential: cert(serviceAccount),
            projectId: projectId || (serviceAccount as any).project_id
          })
          console.info('✅ [Admin] firebase: Admin SDK initialized with service account.')
        } else if (isEmulator) {
          firebaseApp = initializeApp({ projectId: projectId || 'demo-project' })
          console.info('✅ [Admin] firebase: Admin SDK initialized for emulator (no credentials).')
        } else {
          console.error('❌ [Admin] firebase: No service account found.')
        }
      } else {
        firebaseApp = initializeApp({ projectId })
        console.info('✅ [Admin] firebase: Admin SDK initialized via ADC.')
      }
    } catch (e: unknown) {
      const error = e as Error
      console.error('❌ [Admin] firebase: Admin SDK initialization failed:', error.message)
    }
  } else {
    firebaseApp = getApps()[0]
    console.info('✅ [Admin] firebase: Using existing Admin SDK instance.')
  }

  if (!firebaseApp) {
    console.warn('⚠️ [Admin] firebase: SDK not initialized.')
    nitroApp.hooks.hook('request', (event) => {
      event.context.firebaseAdmin = null
    })
    return
  }

  const auth = getAuth(firebaseApp)
  const firestore = getFirestore(firebaseApp)

  if (isEmulator) {
    console.info(`🔥 [Admin] firebase: Firestore Emulator → ${process.env.FIRESTORE_EMULATOR_HOST}`)
  }

  nitroApp.hooks.hook('request', (event) => {
    event.context.firebaseAdmin = { auth, firestore }
  })
})
