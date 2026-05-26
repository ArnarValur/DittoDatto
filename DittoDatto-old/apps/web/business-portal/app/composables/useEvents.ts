/**
 * useEvents Composable
 *
 * Fetches events for the active company.
 * Uses Firebase callable functions for CRUD operations.
 *
 * NOTE: This composable wraps Firebase Functions which are client-only.
 * The actual fetching is deferred to client-side to avoid SSR issues.
 */
import type { Event } from '@dittodatto/shared-types'
import { getFunctions, httpsCallable, connectFunctionsEmulator, type Functions } from 'firebase/functions'

export function useEvents() {
  const { companyId, company, loading: companyLoading } = useCompany()
  const { stores } = useStores()

  const events = ref<Event[]>([])
  const loading = ref(true)
  const error = ref<string | null>(null)
  const functionsReady = ref(false)

  // Firebase Functions instance (initialized client-side only)
  let functions: Functions | null = null
  let listEventsFunc: ReturnType<typeof httpsCallable> | null = null
  let createEventFunc: ReturnType<typeof httpsCallable> | null = null
  let updateEventFunc: ReturnType<typeof httpsCallable> | null = null
  let deleteEventFunc: ReturnType<typeof httpsCallable> | null = null

  // Initialize on client side only
  if (import.meta.client) {
    // Use onMounted to ensure we're in the client context
    onMounted(async () => {
      try {
        // Dynamic import to avoid SSR issues
        const { getApp } = await import('firebase/app')
        functions = getFunctions(getApp(), 'europe-west1')

        // ⚠️ EMULATORS OFF — fully live Firebase for auth testing
        // if (import.meta.dev) {
        //   try {
        //     connectFunctionsEmulator(functions, 'localhost', 5001)
        //   } catch {
        //     // Already connected
        //   }
        // }

        listEventsFunc = httpsCallable(functions, 'events_list')
        createEventFunc = httpsCallable(functions, 'events_create')
        updateEventFunc = httpsCallable(functions, 'events_update')
        deleteEventFunc = httpsCallable(functions, 'events_delete')

        functionsReady.value = true

        // Fetch events if company is ready
        if (companyId.value && isEnabled.value) {
          await fetchEvents()
        }
      } catch (e) {
        console.error('[useEvents] Failed to initialize Firebase Functions:', e)
        error.value = 'Failed to initialize'
        loading.value = false
      }
    })
  }

  // Computed
  const isEmpty = computed(() => !loading.value && events.value.length === 0)

  // Check if eventSystem is enabled
  const isEnabled = computed(() => company.value?.enabledFeatures?.eventSystem === true)

  // Fetch events when companyId is available
  async function fetchEvents() {
    if (!companyId.value || !listEventsFunc) {
      loading.value = false
      return
    }

    loading.value = true
    error.value = null

    try {
      const result = await listEventsFunc({ companyId: companyId.value })
      const data = result.data as { events: Event[] }
      events.value = data.events || []
    } catch (e: any) {
      console.error('[useEvents] Error fetching events:', e)
      error.value = e.message || 'Failed to load events'
      events.value = []
    } finally {
      loading.value = false
    }
  }

  // Create a new event
  async function createEvent(eventData: Partial<Event>): Promise<string | null> {
    if (!companyId.value || !createEventFunc) return null

    try {
      const result = await createEventFunc({
        ...eventData,
        companyId: companyId.value
      })
      const data = result.data as { success: boolean, eventId: string }

      if (data.success) {
        await fetchEvents() // Refresh list
        return data.eventId
      }
      return null
    } catch (e: any) {
      console.error('[useEvents] Error creating event:', e)
      throw e
    }
  }

  // Update an event
  async function updateEvent(eventId: string, updates: Partial<Event>): Promise<boolean> {
    if (!updateEventFunc) return false

    try {
      const result = await updateEventFunc({ eventId, ...updates })
      const data = result.data as { success: boolean }

      if (data.success) {
        await fetchEvents() // Refresh list
        return true
      }
      return false
    } catch (e: any) {
      console.error('[useEvents] Error updating event:', e)
      throw e
    }
  }

  // Delete an event
  async function deleteEvent(eventId: string): Promise<boolean> {
    if (!deleteEventFunc) return false

    try {
      const result = await deleteEventFunc({ eventId })
      const data = result.data as { success: boolean }

      if (data.success) {
        await fetchEvents() // Refresh list
        return true
      }
      return false
    } catch (e: any) {
      console.error('[useEvents] Error deleting event:', e)
      throw e
    }
  }

  // Watch for company changes - client side only
  if (import.meta.client) {
    watch(
      [() => companyId.value, () => isEnabled.value, functionsReady],
      ([newCompanyId, enabled, ready]) => {
        if (newCompanyId && enabled && ready) {
          fetchEvents()
        }
      }
    )
  }

  // Helper to get store name by ID
  function getStoreName(storeId?: string): string | null {
    if (!storeId) return null
    const store = stores.value?.find(s => s.id === storeId)
    return store?.name || null
  }

  return {
    events,
    loading: computed(() => loading.value || companyLoading.value),
    error,
    isEmpty,
    isEnabled,

    // Actions
    fetchEvents,
    createEvent,
    updateEvent,
    deleteEvent,

    // Helpers
    getStoreName
  }
}
