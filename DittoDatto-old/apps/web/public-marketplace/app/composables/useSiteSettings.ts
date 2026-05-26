import { ref, watch } from 'vue'
import { doc } from 'firebase/firestore'
import { useFirestore, useDocument } from 'vuefire'

interface MaintenanceMode {
  enabled: boolean
  message?: string
  updatedAt?: string
  updatedBy?: string
}

interface SiteSettings {
  maintenanceMode?: MaintenanceMode
}

export const useSiteSettings = () => {
  const settings = useState<SiteSettings | null>('site-settings', () => null)
  const pending = useState('site-settings-pending', () => true)
  const error = useState<Error | null>('site-settings-error', () => null)

  // Only access Firestore on the client side
  if (import.meta.client) {
    const db = useFirestore()
    const settingsRef = doc(db, 'settings', 'app-settings')
    const result = useDocument<SiteSettings>(settingsRef)

    // Sync reactive values from VueFire to our state
    watch(() => result.data.value, (newData) => {
      settings.value = newData ?? null
    }, { immediate: true })

    watch(() => result.pending.value, (newPending) => {
      pending.value = newPending
    }, { immediate: true })

    watch(() => result.error.value, (newError) => {
      error.value = newError ?? null
    }, { immediate: true })
  }

  return {
    settings,
    pending,
    error
  }
}
