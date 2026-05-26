/**
 * Debug endpoint to check Firebase Admin SDK state and CWD
 */
export default defineEventHandler(async (event) => {
  const { getApps } = await import('firebase-admin/app')
  
  return {
    cwd: process.cwd(),
    googleAppCredentials: process.env.GOOGLE_APPLICATION_CREDENTIALS,
    firebaseAdminApps: getApps().map(a => a.name),
    nodeEnv: process.env.NODE_ENV,
    hasFirebaseAdmin: !!event.context.firebaseAdmin
  }
})
