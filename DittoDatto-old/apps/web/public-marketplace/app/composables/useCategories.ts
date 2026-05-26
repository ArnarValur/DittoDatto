/**
 * Categories Composable
 *
 * Provides category listing for the marketplace.
 * Two-tier system:
 *   1. Built-in categories derived from storeType ('restaurant', 'venue', 'service')
 *   2. Custom categories from the Firestore 'categories' collection
 *
 * Store counts are live-computed from published stores.
 */
import { collection, collectionGroup, query, where, getDocs, getCountFromServer } from 'firebase/firestore'
import type { Category } from '@dittodatto/shared-types'

export type MarketplaceCategory = {
  id: string
  name: string
  slug: string
  icon: string
  description?: string
  image?: string
  count: number
  /** Whether this is a built-in storeType category */
  isBuiltIn?: boolean
}

/** Built-in categories derived from storeType enum */
const BUILT_IN_CATEGORIES: Omit<MarketplaceCategory, 'count'>[] = [
  {
    id: 'restaurant',
    name: 'Restauranter',
    slug: 'restaurant',
    icon: 'i-lucide-utensils',
    description: 'Finn og bestill bord på restauranter i nærheten',
    isBuiltIn: true,
  },
  {
    id: 'service',
    name: 'Tjenester',
    slug: 'service',
    icon: 'i-lucide-briefcase',
    description: 'Book tjenester fra lokale bedrifter',
    isBuiltIn: true,
  },
  {
    id: 'venue',
    name: 'Steder',
    slug: 'venue',
    icon: 'i-lucide-building-2',
    description: 'Utforsk og bestill unike steder og arenaer',
    isBuiltIn: true,
  },
]

/** Map built-in slug to Firestore storeType value */
const SLUG_TO_STORE_TYPE: Record<string, string> = {
  restaurant: 'restaurant',
  service: 'store', // 'store' in schema = 'service' in URL
  venue: 'venue',
}

const CATEGORY_STATE_KEY = 'marketplace:categories'

const useCategoryState = () => {
  const categories = useState<MarketplaceCategory[]>(`${CATEGORY_STATE_KEY}:data`, () => [])
  const loading = useState<boolean>(`${CATEGORY_STATE_KEY}:loading`, () => false)
  const error = useState<string | null>(`${CATEGORY_STATE_KEY}:error`, () => null)
  return { categories, loading, error }
}

export const useCategories = () => {
  const { categories, loading, error } = useCategoryState()
  const db = useFirestore()

  /**
   * Fetch categories with live counts from published stores.
   */
  const fetchCategories = async () => {
    loading.value = true
    error.value = null
    try {
      const results: MarketplaceCategory[] = []

      // 1. Count published stores per storeType for built-in categories
      for (const cat of BUILT_IN_CATEGORIES) {
        const storeType = SLUG_TO_STORE_TYPE[cat.slug]
        if (!storeType) continue

        try {
          const storesQuery = query(
            collectionGroup(db, 'stores'),
            where('storeType', '==', storeType),
            where('isPublished', '==', true),
          )
          const countSnapshot = await getCountFromServer(storesQuery)
          results.push({
            ...cat,
            count: countSnapshot.data().count,
          })
        } catch (e) {
          // If count query fails (e.g. missing index), still show category with 0
          console.warn(`[useCategories] Count query failed for ${cat.slug}:`, e)
          results.push({ ...cat, count: 0 })
        }
      }

      // 2. Fetch custom categories from Firestore 'categories' collection
      try {
        const categoriesRef = collection(db, 'categories')
        const snapshot = await getDocs(categoriesRef)
        for (const doc of snapshot.docs) {
          const data = doc.data() as Category
          // Skip if it conflicts with a built-in category slug
          if (SLUG_TO_STORE_TYPE[data.slug]) continue

          results.push({
            id: doc.id,
            name: data.name,
            slug: data.slug,
            icon: data.icon || 'i-lucide-tag',
            description: data.description,
            count: data.count || 0,
            isBuiltIn: false,
          })
        }
      } catch (e) {
        // Non-fatal — custom categories are optional
        console.warn('[useCategories] Custom categories fetch failed:', e)
      }

      // Sort: highest count first, then by name
      categories.value = results.sort((a, b) => b.count - a.count || a.name.localeCompare(b.name))
    } catch (err) {
      console.error('[useCategories] Failed to load categories:', err)
      error.value = 'Unable to load categories'
      categories.value = []
    } finally {
      loading.value = false
    }
  }

  const popularCategories = computed(() =>
    categories.value.filter((c) => c.count > 0).slice(0, 6)
  )

  const findCategoryBySlug = (slug: string) =>
    categories.value.find((category) => category.slug === slug)

  return {
    categories,
    loading,
    error,
    popularCategories,
    fetchCategories,
    findCategoryBySlug,
  }
}
