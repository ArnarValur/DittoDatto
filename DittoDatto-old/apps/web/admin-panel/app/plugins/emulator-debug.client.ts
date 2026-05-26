import { defineNuxtPlugin } from '#imports'
import { getAuth, connectAuthEmulator } from 'firebase/auth'
import { getFirestore, connectFirestoreEmulator } from 'firebase/firestore'

export default defineNuxtPlugin((nuxtApp) => {
  // Only enabling in development with a simple check
  /* if (process.env.NODE_ENV === 'development' || import.meta.dev) {
    if (import.meta.server) return; // Only run on client-side

    console.log('🔥 [Manual Plugin] Initializing manual emulator connection override...')
    
    try {
        const auth = getAuth()
        // connectAuthEmulator often requires the full URL
        connectAuthEmulator(auth, 'http://localhost:9099', { disableWarnings: true })
        console.log('✅ [Manual Plugin] Auth Emulator FORCE connected: http://localhost:9099')
    } catch (e) {
        // It might be already connected if nuxt-vuefire actually worked partially
        console.warn('⚠️ [Manual Plugin] Auth Emulator connection skipped (likely already connected):', e)
    }

    try {
        const db = getFirestore()
        connectFirestoreEmulator(db, 'localhost', 8080)
        console.log('✅ [Manual Plugin] Firestore Emulator FORCE connected: localhost:8080')
    } catch (e) {
         console.warn('⚠️ [Manual Plugin] Firestore Emulator connection skipped:', e)
    }
  } */
})
