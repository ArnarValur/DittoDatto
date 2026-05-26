// apps/public-marketplace/app/plugins/auth-init.client.ts
// Initializes Firebase Auth listener on app startup (client-side only)
// This enables reactive auth state updates in components like BlockHeader

export default defineNuxtPlugin(async () => {
  const { initAuth } = useAuth()

  // Initialize the auth listener - this will:
  // 1. Set persistence to IndexedDB (stay logged in)
  // 2. Set up onAuthStateChanged listener
  // 3. Fetch user profile if authenticated
  await initAuth()
})
