/**
 * Marketplace Stores Composable
 * 
 * Provides store listing, filtering, and pagination.
 * TODO: Connect to real Firebase/API backend when ready.
 */

export type MarketplaceStore = {
  id: string
  companyId: string
  name: string
  slug: string
  address: string
  city: string
  categoryName: string
  categorySlug: string
  rating: number
  reviewCount: number
  distanceKm: number
  distanceLabel: string
  image: string
}

type StoreSort = 'featured' | 'rating' | 'distance' | 'reviews' | 'name'

type StoreFilters = {
  searchTerm: string
  categorySlug: string | null
  sortBy: StoreSort
  page: number
  pageSize: number
  city: string | null
}

const DEFAULT_FILTERS: StoreFilters = {
  searchTerm: '',
  categorySlug: null,
  sortBy: 'featured',
  page: 1,
  pageSize: 9,
  city: null
}

export const useMarketplaceStores = () => {
  const allStores = useState<MarketplaceStore[]>('marketplace:stores:all', () => [])
  const loading = useState<boolean>('marketplace:stores:loading', () => false)
  const error = useState<string | null>('marketplace:stores:error', () => null)
  const filters = useState<StoreFilters>('marketplace:stores:filters', () => ({ ...DEFAULT_FILTERS }))

  const fetchStores = async () => {
    loading.value = true
    error.value = null
    try {
      // TODO: Fetch from real API
      allStores.value = []
    } catch (err) {
      console.error('Failed to load stores', err)
      error.value = 'Unable to load stores'
      allStores.value = []
    } finally {
      loading.value = false
    }
  }

  const totalItems = computed(() => allStores.value.length)
  const totalPages = computed(() =>
    Math.max(1, Math.ceil(totalItems.value / filters.value.pageSize))
  )
  const paginatedStores = computed(() => allStores.value)

  const updateFilters = (update: Partial<StoreFilters>) => {
    filters.value = { ...filters.value, ...update }
  }

  const setSearchTerm = (term: string) => {
    updateFilters({ searchTerm: term, page: 1 })
  }

  const setCategory = (categorySlug: string | null) => {
    updateFilters({ categorySlug, page: 1 })
  }

  const setCity = (city: string | null) => {
    updateFilters({ city, page: 1 })
  }

  const setSortBy = (sortBy: StoreSort) => {
    updateFilters({ sortBy })
  }

  const setPage = (page: number) => {
    const clamped = Math.min(Math.max(1, page), totalPages.value)
    updateFilters({ page: clamped })
  }

  const resetFilters = () => {
    filters.value = { ...DEFAULT_FILTERS }
  }

  return {
    loading,
    error,
    allStores,
    stores: paginatedStores,
    filters,
    totalItems,
    totalPages,
    fetchStores,
    setSearchTerm,
    setCategory,
    setSortBy,
    setCity,
    setPage,
    resetFilters,
    pageSize: computed(() => filters.value.pageSize)
  }
}
