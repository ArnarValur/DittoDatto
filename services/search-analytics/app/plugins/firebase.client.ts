import { initializeApp, getApps, getApp } from 'firebase/app'
import { getFirestore, connectFirestoreEmulator } from 'firebase/firestore'
import { getAuth, connectAuthEmulator } from 'firebase/auth'

export default defineNuxtPlugin(() => {
  const config = useRuntimeConfig()

  const firebaseConfig = {
    apiKey: config.public.firebaseApiKey,
    authDomain: config.public.firebaseAuthDomain,
    projectId: config.public.firebaseProjectId,
    storageBucket: config.public.firebaseStorageBucket,
    messagingSenderId: config.public.firebaseMessagingSenderId,
    appId: config.public.firebaseAppId,
    measurementId: config.public.firebaseMeasurementId
  }

  // Initialize Firebase only once
  const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApp()

  const db = getFirestore(app)
  const auth = getAuth(app)

  // Connect to the Firebase Emulator if running locally (Disabled for testing staging)
  /*
  if (process.env.NODE_ENV === 'development') {
    // Check if emulator isn't already connected to prevent hot-reload errors in auth/firestore
    if (!(auth as Record<string, unknown>).emulatorConfig) {
      connectAuthEmulator(auth, 'http://localhost:9099', { disableWarnings: true })
      connectFirestoreEmulator(db, 'localhost', 8080)
      console.log('SearchAnalytics connected to Firebase Emulators [localhost:8080/9099]')
    }
  }
  */

  return {
    provide: {
      db,
      auth
    }
  }
})
