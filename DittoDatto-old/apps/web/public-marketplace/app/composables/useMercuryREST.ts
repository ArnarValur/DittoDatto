import { useAuth } from './useAuth'

export function useMercuryREST() {
  const { user } = useAuth()
  const runtimeConfig = useRuntimeConfig()
  // Base URL: use env var in production, localhost:5002 only in development
  const isDev = import.meta.dev
  const envUrl = runtimeConfig.public.mercuryUrl as string
  const baseURL = envUrl || (isDev ? 'http://localhost:5002' : '')

  if (!baseURL) {
    console.error('[useMercuryREST] NUXT_PUBLIC_MERCURY_URL not set in production!')
  }

  /**
   * Wrapper around ofetch that auto-injects Firebase Auth token
   */
  async function fetchFromMercury<T>(path: string, options: any = {}): Promise<T> {
    const headers = { ...options.headers }
    
    // Inject auth token if user is logged in
    if (user.value) {
      try {
        const token = await user.value.getIdToken()
        headers.Authorization = `Bearer ${token}`
      } catch (err) {
        console.warn('[useMercuryREST] Failed to get auth token', err)
      }
    }
    
    // Make request via ofetch (Nuxt's $fetch)
    try {
      return await $fetch<T>(path, {
        ...options,
        baseURL,
        headers
      })
    } catch (err: any) {
      // Extract error message from engine JSON response (e.g. { error: "Must book at least 60 minutes in advance" })
      const data = err?.response?._data || err?.data
      if (data) {
        err.data = data
      }
      throw err
    }
  }

  return {
    fetchFromMercury
  }
}
