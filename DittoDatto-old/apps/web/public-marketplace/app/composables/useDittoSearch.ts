/**
 * DittoBar Search Composable
 *
 * Client-side fuzzy matching against stores and categories.
 * Accepts already-fetched Firestore refs to avoid duplicate reads.
 * Debounces input at 300ms.
 *
 * Emits search analytics events via `analytics_logSearchEvent` Cloud Function.
 */
import { httpsCallable } from 'firebase/functions'

type StoreDoc = {
  id: string
  name: string
  slug: string
  tagline?: string
  city?: string
  category?: string
  companyId?: string
  images?: { cover?: string }
  gmapCoord?: { lat: number; lng: number }
  isActive?: boolean
  favoritesCount?: number
}

type CategoryDoc = {
  id: string
  name: string
  slug?: string
  icon?: string
}

export type DittoSearchStoreResult = {
  id: string
  name: string
  slug: string
  tagline?: string
  city?: string
  categoryName: string | null
  categorySlug: string
  image: string
  lat?: number
  lng?: number
  isActive: boolean
  favoritesCount: number
}

export type DittoSearchCategoryResult = {
  id: string
  name: string
  slug: string
  icon: string
}

export function useDittoSearch(
  stores: Ref<StoreDoc[] | undefined>,
  categories: Ref<CategoryDoc[] | undefined>
) {
  const query = ref('')
  const debouncedQuery = ref('')
  const isSearching = ref(false)
  const selectedResultIndex = ref(0)

  // --- Analytics: session tracking ---
  const sessionId = useState<string>('ditto-search-session', () => {
    // Generate a simple UUID-like session ID
    return 'ds-' + Date.now().toString(36) + '-' + Math.random().toString(36).slice(2, 9)
  })
  let lastLoggedQuery = ''

  // Analytics: fire-and-forget Cloud Function call
  const functions = useCallableFunctions()

  function logSearchEvent(payload: {
    query: string
    resultCount: number
    selectedResult?: { type: 'store' | 'category'; id: string; name: string }
  }) {
    try {
      if (import.meta.server) return
      if (!functions) return
      const logFn = httpsCallable(functions, 'analytics_logSearchEvent')
      logFn({
        ...payload,
        sessionId: sessionId.value,
        source: 'dittobar',
      }).catch(() => {
        // Silent — analytics never degrades search UX
      })
    } catch {
      // Silent
    }
  }

  // Debounce the query
  let debounceTimer: ReturnType<typeof setTimeout> | null = null

  watch(query, (val) => {
    isSearching.value = true
    if (debounceTimer) clearTimeout(debounceTimer)
    if (!val || val.length < 2) {
      debouncedQuery.value = ''
      isSearching.value = false
      selectedResultIndex.value = 0
      return
    }
    debounceTimer = setTimeout(() => {
      debouncedQuery.value = val
      isSearching.value = false
      selectedResultIndex.value = 0
    }, 300)
  })

  // Helper: resolve category name from ID
  function getCategoryName(categoryId: string | undefined): string | null {
    if (!categoryId || !categories.value) return null
    const cat = categories.value.find(c => c.id === categoryId)
    return cat?.name || null
  }

  function getCategorySlug(categoryId: string | undefined): string {
    if (!categoryId || !categories.value) return 'discover'
    const cat = categories.value.find(c => c.id === categoryId)
    return cat?.slug || cat?.id || 'discover'
  }

  // Category matches (max 5)
  const categoryMatches = computed<DittoSearchCategoryResult[]>(() => {
    if (!debouncedQuery.value || !categories.value) return []
    const q = debouncedQuery.value.toLowerCase()
    return categories.value
      .filter(cat => cat.name.toLowerCase().includes(q))
      .slice(0, 5)
      .map(cat => ({
        id: cat.id,
        name: cat.name,
        slug: cat.slug || cat.id,
        icon: cat.icon || 'grid-2x2'
      }))
  })

  // Store matches (max 5)
  const storeMatches = computed<DittoSearchStoreResult[]>(() => {
    if (!debouncedQuery.value || !stores.value) return []
    const q = debouncedQuery.value.toLowerCase()
    return stores.value
      .filter(store => {
        const nameMatch = store.name?.toLowerCase().includes(q)
        const taglineMatch = store.tagline?.toLowerCase().includes(q)
        const cityMatch = store.city?.toLowerCase().includes(q)
        const catName = getCategoryName(store.category)
        const categoryMatch = catName?.toLowerCase().includes(q)
        return nameMatch || taglineMatch || cityMatch || categoryMatch
      })
      .slice(0, 5)
      .map(store => ({
        id: store.id,
        name: store.name,
        slug: store.slug,
        tagline: store.tagline,
        city: store.city,
        categoryName: getCategoryName(store.category),
        categorySlug: getCategorySlug(store.category),
        image: store.images?.cover
          || 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=400',
        lat: store.gmapCoord?.lat,
        lng: store.gmapCoord?.lng,
        isActive: store.isActive !== false,
        favoritesCount: store.favoritesCount || 0
      }))
  })

  // --- Analytics: log on debounce settle ---
  watch(debouncedQuery, (q) => {
    if (!q || q === lastLoggedQuery) return
    lastLoggedQuery = q
    // Wait one tick for computed results to settle
    nextTick(() => {
      logSearchEvent({
        query: q,
        resultCount: storeMatches.value.length + categoryMatches.value.length,
      })
    })
  })

  // Combined results for State 3 navigation
  const allResults = computed(() => storeMatches.value)

  const hasResults = computed(() =>
    categoryMatches.value.length > 0 || storeMatches.value.length > 0
  )

  const currentResult = computed(() =>
    allResults.value[selectedResultIndex.value] || null
  )

  function selectNext() {
    if (allResults.value.length === 0) return
    selectedResultIndex.value = (selectedResultIndex.value + 1) % allResults.value.length
  }

  function selectPrev() {
    if (allResults.value.length === 0) return
    selectedResultIndex.value = selectedResultIndex.value <= 0
      ? allResults.value.length - 1
      : selectedResultIndex.value - 1
  }

  function clearSearch() {
    query.value = ''
    debouncedQuery.value = ''
    isSearching.value = false
    selectedResultIndex.value = 0
  }

  // Analytics: log when user selects a result (click-through)
  function logResultSelected(result: { type: 'store' | 'category'; id: string; name: string }) {
    if (!debouncedQuery.value) return
    logSearchEvent({
      query: debouncedQuery.value,
      resultCount: storeMatches.value.length + categoryMatches.value.length,
      selectedResult: result,
    })
  }

  // Cleanup
  onUnmounted(() => {
    if (debounceTimer) clearTimeout(debounceTimer)
  })

  return {
    query,
    debouncedQuery,
    isSearching,
    categoryMatches,
    storeMatches,
    allResults,
    hasResults,
    currentResult,
    selectedResultIndex,
    selectNext,
    selectPrev,
    clearSearch,
    logResultSelected
  }
}

