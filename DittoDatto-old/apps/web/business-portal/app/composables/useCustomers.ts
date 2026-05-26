import { collection } from 'firebase/firestore'
import { useFirestore, useCollection } from 'vuefire'
import type { Customer } from '@dittodatto/shared-types'

export function useCustomers() {
  const db = useFirestore()
  const { companyId } = useCompany()
  const { stores } = useStores()
  
  // Filters
  const storeFilter = ref<string | null>(null)
  const statusFilter = ref<string>('all')
  const searchQuery = ref<string>('')

  // Base Collection: companies/{companyId}/customers
  const customersRef = computed(() => {
    if (!companyId.value) return null
    return collection(db, 'companies', companyId.value, 'customers')
  })

  // Subscribe to real-time customer data
  const { data: allCustomers, pending: loading } = useCollection<Customer>(
    customersRef,
    { ssrKey: 'companyCustomersList' }
  )

  // Multi-store detection
  const isMultiStore = computed(() => (stores.value?.length ?? 0) > 1)

  // Per-store customer count (for tab badges)
  function customerCountForStore(storeId: string): number {
    if (!allCustomers.value) return 0
    return allCustomers.value.filter(c => c.storeIds?.includes(storeId)).length
  }

  const totalCustomerCount = computed(() => allCustomers.value?.length ?? 0)

  // Derived filtered client list
  const customers = computed(() => {
    let list = allCustomers.value || []

    // 1. Establishment / Store Filter
    if (storeFilter.value) {
      list = list.filter(c => c.storeIds && c.storeIds.includes(storeFilter.value!))
    }

    // 2. Status Filter
    if (statusFilter.value && statusFilter.value !== 'all') {
      list = list.filter(c => (c as any).status === statusFilter.value)
    }

    // 3. Search Filter (Name, Email, Phone)
    if (searchQuery.value) {
      const q = searchQuery.value.toLowerCase()
      list = list.filter(c => 
        (c.name && c.name.toLowerCase().includes(q)) ||
        (c.email && c.email.toLowerCase().includes(q)) ||
        (c.phone && c.phone.includes(q))
      )
    }

    return list
  })

  // Store options (for tab-style switcher — no "All" entry, handled by null filter)
  const storeOptions = computed(() =>
    (stores.value ?? []).map((s) => ({ label: s.name, value: s.id })),
  )

  return {
    customers,
    allCustomers,
    loading,
    storeFilter,
    statusFilter,
    searchQuery,
    storeOptions,
    isMultiStore,
    customerCountForStore,
    totalCustomerCount,
  }
}

