/**
 * useServiceGroups Composable
 *
 * Fetches service groups for stores owned by the active company.
 * Groups are stored as subcollections under each store:
 * companies/{companyId}/stores/{storeId}/serviceGroups
 */
import type { ServiceGroup, Store } from '@dittodatto/shared-types'
import { collection, getDocs, orderBy, query } from 'firebase/firestore'
import { useFirestore } from 'vuefire'
import { toValue, type Ref } from 'vue'

export function useServiceGroups(storeId?: Ref<string | undefined>) {
  const db = useFirestore()
  const { companyId, loading: companyLoading } = useCompany()
  const { stores, loading: storesLoading } = useStores()

  const groups = ref<ServiceGroup[]>([])
  const groupsLoading = ref(false)

  // Fetch groups when stores/company changes
  watch(
    () => [toValue(stores), toValue(companyId), toValue(storeId)] as const,
    async ([storesValue, companyIdValue, storeIdValue]) => {
      // VueFire collection data is in storesValue. Ensure it's treated as array
      const storesArr = storesValue as Store[] | undefined
      if (!storesArr || storesArr.length === 0 || !companyIdValue) {
        groups.value = []
        return
      }

      groupsLoading.value = true
      const allGroups: ServiceGroup[] = []

      try {
      // If a specific storeId is provided, only fetch for that store
        const storesToFetch = storeIdValue
          ? storesArr.filter(s => s.id === storeIdValue)
          : storesArr

        // Fetch groups from each store's subcollection
        for (const store of storesToFetch) {
          const groupsRef = collection(toValue(db), 'companies', companyIdValue, 'stores', store.id, 'serviceGroups')
          const q = query(groupsRef, orderBy('sortOrder', 'asc'))
          const snapshot = await getDocs(q)
          snapshot.forEach((doc) => {
            allGroups.push({ id: doc.id, storeId: store.id, ...doc.data() } as ServiceGroup)
          })
        }

        console.log('[useServiceGroups] Fetched groups:', allGroups.length)
        groups.value = allGroups
      } catch (e) {
        console.error('[useServiceGroups] Error fetching groups:', e)
        groups.value = []
      } finally {
        groupsLoading.value = false
      }
    }, { immediate: true })

  // Refresh function
  async function refresh() {
    const storesValue = toValue(stores)
    const companyIdValue = toValue(companyId)
    const storeIdValue = toValue(storeId)

    if (!storesValue || storesValue.length === 0 || !companyIdValue) {
      groups.value = []
      return
    }

    groupsLoading.value = true
    const allGroups: ServiceGroup[] = []

    try {
      const storesToFetch = storeIdValue
        ? storesValue.filter((s: Store) => s.id === storeIdValue)
        : storesValue

      for (const store of storesToFetch) {
        const groupsRef = collection(toValue(db), 'companies', companyIdValue, 'stores', store.id, 'serviceGroups')
        const q = query(groupsRef, orderBy('sortOrder', 'asc'))
        const snapshot = await getDocs(q)
        snapshot.forEach((doc) => {
          allGroups.push({ id: doc.id, storeId: store.id, ...doc.data() } as ServiceGroup)
        })
      }

      groups.value = allGroups
    } catch (e) {
      console.error('[useServiceGroups] Error refreshing groups:', e)
    } finally {
      groupsLoading.value = false
    }
  }

  return {
    groups: computed(() => groups.value),
    loading: computed(() => companyLoading.value || storesLoading.value || groupsLoading.value),
    isEmpty: computed(() => !groupsLoading.value && groups.value.length === 0),
    refresh
  }
}
