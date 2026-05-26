/**
 * useStores Composable
 *
 * Fetches all stores for the currently active company.
 * Includes store policy awareness for creation limits.
 */
import type { Store } from '@dittodatto/shared-types'
import { collection } from 'firebase/firestore'
import { useFirestore, useCollection } from 'vuefire'

export function useStores() {
  const db = useFirestore()
  const { companyId, company, loading: companyLoading } = useCompany()

  // Create query when companyId is available
  // NOTE: Stores are stored as subcollection: companies/{companyId}/stores
  const storesQuery = computed(() => {
    if (!companyId.value) return null
    return collection(db, 'companies', companyId.value, 'stores')
  })

  // Use VueFire's useCollection for reactive Firestore binding
  const { data: stores, pending: storesLoading } = useCollection<Store>(storesQuery)

  // Store policy awareness
  const storeCount = computed(() => stores.value?.length ?? 0)
  const maxStores = computed(() => company.value?.storePolicy?.maxStores ?? 1)
  const canCreateStores = computed(() => company.value?.storePolicy?.canCreateOwnStores ?? false)
  const canAddMoreStores = computed(() => canCreateStores.value && storeCount.value < maxStores.value)

  return {
    stores,
    loading: computed(() => companyLoading.value || storesLoading.value),
    isEmpty: computed(() => !storesLoading.value && (!stores.value || stores.value.length === 0)),
    // Store policy
    storeCount,
    maxStores,
    canCreateStores,
    canAddMoreStores
  }
}
