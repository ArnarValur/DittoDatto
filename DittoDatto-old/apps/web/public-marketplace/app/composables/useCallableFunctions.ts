import { getFunctions, type Functions } from 'firebase/functions'

/**
 * Returns callable Cloud Functions client pinned to europe-west1.
 *
 * Why manual emulator connection?
 * nuxt-vuefire's emulators config connects to getFunctions(app) (default region us-central1).
 * Our functions are deployed to europe-west1, so getFunctions(app, 'europe-west1') returns
 * a DIFFERENT singleton. We must connect the emulator to THIS specific instance.
 */
export const useCallableFunctions = (): Functions => {
  if (import.meta.server) {
    return null as unknown as Functions
  }

  const app = useFirebaseApp()
  const functions = getFunctions(app, 'europe-west1')

  return functions
}
