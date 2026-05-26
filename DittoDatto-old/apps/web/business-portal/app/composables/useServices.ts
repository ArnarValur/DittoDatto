/**
 * useServices Composable
 * 
 * Fetches all services for the stores owned by the active company.
 * Note: Services are stored as subcollections under each store:
 * companies/{companyId}/stores/{storeId}/services
 */
import type { Service } from '@dittodatto/shared-types'
import { collection, getDocs } from 'firebase/firestore'
import { useFirestore } from 'vuefire'

export function useServices() {
  const db = useFirestore()
  const { companyId, loading: companyLoading } = useCompany()
  const { stores, loading: storesLoading } = useStores()

  const services = ref<Service[]>([])
  const servicesLoading = ref(false)

  async function fetchServices() {
    const storesValue = stores.value
    const companyIdValue = companyId.value
    if (!storesValue || storesValue.length === 0 || !companyIdValue) {
      services.value = []
      return
    }

    servicesLoading.value = true
    const allServices: Service[] = []

    try {
      for (const store of storesValue) {
        const servicesRef = collection(db, 'companies', companyIdValue, 'stores', store.id, 'services')
        const snapshot = await getDocs(servicesRef)
        snapshot.forEach((doc) => {
          allServices.push({ id: doc.id, ...doc.data() } as Service)
        })
      }
      
      console.log('[useServices] Fetched services:', allServices.length)
      services.value = allServices
    } catch (e) {
      console.error('[useServices] Error fetching services:', e)
      services.value = []
    } finally {
      servicesLoading.value = false
    }
  }

  // Auto-fetch when stores/company change
  watch([stores, companyId], () => fetchServices(), { immediate: true })

  return {
    services: computed(() => services.value),
    loading: computed(() => companyLoading.value || storesLoading.value || servicesLoading.value),
    isEmpty: computed(() => !servicesLoading.value && services.value.length === 0),
    refresh: fetchServices,
  }
}


