// composables/useDataTable.ts
import { refDebounced } from '@vueuse/core'

interface DataTableOptions<T> {
  query?: Record<string, any> | Ref<Record<string, any>>
  transform?: (data: any) => { items: T[], total: number }
}

export function useDataTable<T>(endpoint: string, options: DataTableOptions<T> = {}) {
  // State
  const search = ref('')
  const page = ref(1)
  const pageCount = ref(10)
  const isFormOpen = ref(false)
  const selectedItem = ref<T | undefined>(undefined)

  // Debounce search to prevent API flooding
  const debouncedSearch = refDebounced(search, 300)

  // Handle reactive query filters
  const queryRef = isRef(options.query) ? options.query : ref(options.query || {})

  // Build complete query object reactively
  const completeQuery = computed(() => {
    const baseQuery: Record<string, any> = {
      search: debouncedSearch.value,
      page: page.value,
      pageSize: pageCount.value
    }
    // Merge with dynamic filters
    const filters = queryRef.value as Record<string, any>
    return { ...baseQuery, ...filters }
  })

  // Data Fetching
  const { data, status, refresh } = useFetch(endpoint, {
    key: `table-${endpoint}`,
    query: completeQuery,
    watch: [page, pageCount, debouncedSearch, queryRef],
    transform: (response: any) => {
      // Allow custom transform if provided (e.g., for Date objects), otherwise expect standard format
      if (options.transform) return options.transform(response)

      // Default fallback assumption: { items: [], total: 0 }
      return {
        items: response.items || response[endpoint.split('/').pop()!] || [],
        total: response.total || 0
      }
    }
  })

  // Computed Wrappers
  const rows = computed(() => data.value?.items || [])
  const total = computed(() => data.value?.total || 0)
  const isLoading = computed(() => status.value === 'pending')

  // Actions
  function handleCreate() {
    selectedItem.value = undefined
    isFormOpen.value = true
  }

  function handleEdit(item: T) {
    selectedItem.value = item
    isFormOpen.value = true
  }

  return {
    // State
    search,
    page,
    pageCount,
    isFormOpen,
    selectedItem,
    // Data
    rows,
    total,
    isLoading,
    refresh,
    // Actions
    handleCreate,
    handleEdit
  }
}
