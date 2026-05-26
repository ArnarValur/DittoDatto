<script setup lang="ts">
/**
 * Category Listing Page - Public Marketplace
 * 
 * URL Pattern: /{category}
 * Examples:
 *   - /barber → All barber shops
 *   - /restaurant → All restaurants
 *   - /discover → All uncategorized stores
 * 
 * Shows a grid of stores in this category with filtering options.
 */
import { collection, collectionGroup, query, where, getDocs, orderBy, limit } from 'firebase/firestore'
import type { Store, Category } from '@dittodatto/shared-types'

definePageMeta({
  layout: 'default'
})

const route = useRoute()
const db = useFirestore()
const { t } = useI18n()

// Route params
const categorySlug = computed(() => route.params.category as string)

// State
const category = ref<Category | null>(null)
const stores = ref<Store[]>([])
const loading = ref(true)
const error = ref<string | null>(null)

// Store type slugs that serve as fallback categories
const STORE_TYPE_SLUGS = ['restaurant', 'venue', 'service'] as const
type StoreTypeSlug = typeof STORE_TYPE_SLUGS[number]

// Map URL slugs to schema storeType values
const STORE_TYPE_MAP: Record<StoreTypeSlug, { schemaValue: string; label: string; icon: string }> = {
  'restaurant': { schemaValue: 'restaurant', label: 'Restaurants', icon: 'i-lucide-utensils' },
  'venue': { schemaValue: 'venue', label: 'Venues', icon: 'i-lucide-building-2' },
  'service': { schemaValue: 'store', label: 'Services', icon: 'i-lucide-briefcase' }
}

// Pagination
const PAGE_SIZE = 12
const hasMore = ref(false)

// Computed helpers
const isStoreTypeFallback = computed(() => 
  STORE_TYPE_SLUGS.includes(categorySlug.value as StoreTypeSlug)
)
const isDiscover = computed(() => categorySlug.value === 'discover')

// ============================================================================
// Data Fetching
// ============================================================================

/**
 * Fetch category metadata and stores
 */
async function fetchCategoryData() {
  loading.value = true
  error.value = null
  
  try {
    if (isDiscover.value) {
      // "discover" is a virtual category for truly uncategorized stores
      category.value = {
        id: 'discover',
        name: 'Discover',
        slug: 'discover',
        description: 'Explore all establishments',
        icon: 'i-lucide-compass',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      }
    } else if (isStoreTypeFallback.value) {
      // StoreType route (/restaurant, /venue, /service)
      const typeConfig = STORE_TYPE_MAP[categorySlug.value as StoreTypeSlug]
      category.value = {
        id: categorySlug.value,
        name: typeConfig.label,
        slug: categorySlug.value,
        description: `Browse all ${typeConfig.label.toLowerCase()}`,
        icon: typeConfig.icon,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      }
    } else {
      // Real category from Firestore
      const categoriesRef = collection(db, 'categories')
      const categoryQuery = query(
        categoriesRef,
        where('slug', '==', categorySlug.value)
      )
      const categorySnapshot = await getDocs(categoryQuery)
      
      if (!categorySnapshot.empty) {
        const doc = categorySnapshot.docs[0]
        category.value = { id: doc.id, ...doc.data() } as Category
      } else {
        // Category not found — show 404
        showError({
          statusCode: 404,
          statusMessage: 'Page not found'
        })
        return
      }
    }
    
    // Fetch stores
    await fetchStores()
  } catch (e) {
    console.error('[CategoryPage] Error fetching category:', e)
    error.value = 'fetch_error'
  } finally {
    loading.value = false
  }
}

/**
 * Fetch stores for the current category/storeType
 */
async function fetchStores() {
  try {
    const storesRef = collectionGroup(db, 'stores')
    
    let storesQuery
    if (isDiscover.value) {
      // Show all published stores
      storesQuery = query(
        storesRef,
        where('isPublished', '==', true),
        limit(PAGE_SIZE + 1)
      )
    } else if (isStoreTypeFallback.value) {
      // Filter by storeType
      const typeConfig = STORE_TYPE_MAP[categorySlug.value as StoreTypeSlug]
      storesQuery = query(
        storesRef,
        where('storeType', '==', typeConfig.schemaValue),
        where('isPublished', '==', true),
        limit(PAGE_SIZE + 1)
      )
    } else {
      // Filter by category ID
      storesQuery = query(
        storesRef,
        where('category', '==', category.value?.id || categorySlug.value),
        where('isPublished', '==', true),
        limit(PAGE_SIZE + 1)
      )
    }
    
    const snapshot = await getDocs(storesQuery)
    const allStores = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    } as Store))
    
    // Check if there are more results
    hasMore.value = allStores.length > PAGE_SIZE
    stores.value = allStores.slice(0, PAGE_SIZE)
  } catch (e) {
    console.error('[CategoryPage] Error fetching stores:', e)
    stores.value = []
  }
}

// ============================================================================
// Computed
// ============================================================================

const pageTitle = computed(() => {
  if (category.value) {
    return category.value.name
  }
  return 'Browse'
})

const pageDescription = computed(() => {
  if (category.value?.description) {
    return category.value.description
  }
  return `Explore ${stores.value.length} establishments`
})

/**
 * Generate URL for a store using fallback logic:
 * 1. Category slug if set
 * 2. StoreType slug (restaurant/venue/service)
 * 3. "discover" as last resort
 */
function getStoreUrl(store: Store): string {
  // Priority 1: Use category if set
  if (store.category) {
    return `/${store.category}/${store.slug}`
  }
  
  // Priority 2: Use storeType
  const storeTypeToSlug: Record<string, string> = {
    'restaurant': 'restaurant',
    'venue': 'venue',
    'store': 'service' // 'store' in schema = 'service' in URL
  }
  const typeSlug = storeTypeToSlug[store.storeType] || 'discover'
  return `/${typeSlug}/${store.slug}`
}

// ============================================================================
// SEO
// ============================================================================

useSeoMeta({
  title: () => `${pageTitle.value} | DittoDatto`,
  description: () => pageDescription.value
})

// ============================================================================
// Lifecycle
// ============================================================================

watch(
  categorySlug,
  () => fetchCategoryData(),
  { immediate: true }
)
</script>

<template>
  <UContainer class="py-8">
    <!-- Loading -->
    <div v-if="loading" class="space-y-6">
      <USkeleton class="h-12 w-1/3" />
      <USkeleton class="h-6 w-2/3" />
      <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <div v-for="i in 8" :key="i" class="space-y-3">
          <USkeleton class="aspect-4/3 w-full rounded-xl" />
          <USkeleton class="h-5 w-3/4" />
          <USkeleton class="h-4 w-1/2" />
        </div>
      </div>
    </div>

    <!-- Content -->
    <template v-else>
      <!-- Header -->
      <div class="mb-8">
        <div class="flex items-center gap-3 mb-2">
          <UIcon 
            v-if="category?.icon" 
            :name="category.icon" 
            class="size-8 text-primary" 
          />
          <h1 class="text-3xl font-bold">{{ pageTitle }}</h1>
        </div>
        <p class="text-muted text-lg">{{ pageDescription }}</p>
      </div>

      <!-- Store Grid -->
      <div 
        v-if="stores.length > 0" 
        class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6"
      >
        <NuxtLink
          v-for="store in stores"
          :key="store.id"
          :to="getStoreUrl(store)"
          class="group"
        >
          <UCard class="overflow-hidden hover:shadow-lg transition-shadow">
            <!-- Cover Image -->
            <div class="aspect-4/3 bg-muted overflow-hidden">
              <img
                v-if="store.images?.cover || store.images?.logo"
                :src="store.images.cover || store.images.logo"
                :alt="store.name"
                class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
              />
              <div v-else class="w-full h-full flex items-center justify-center">
                <UIcon name="i-lucide-image" class="size-12 text-muted" />
              </div>
            </div>
            
            <!-- Info -->
            <template #footer>
              <div class="space-y-1">
                <h3 class="font-semibold truncate group-hover:text-primary transition-colors">
                  {{ store.name }}
                </h3>
                <p class="text-sm text-muted truncate">
                  {{ store.address }}, {{ store.city }}
                </p>
                <div v-if="store.aggregateRating" class="flex items-center gap-1 text-sm">
                  <UIcon name="i-lucide-star" class="size-4 text-yellow-500 fill-current" />
                  <span class="font-medium">{{ store.aggregateRating.ratingValue.toFixed(1) }}</span>
                  <span class="text-muted">({{ store.aggregateRating.ratingCount }})</span>
                </div>
              </div>
            </template>
          </UCard>
        </NuxtLink>
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-20">
        <UIcon name="i-lucide-compass" class="size-12 text-muted mx-auto mb-4" />
        <p class="text-muted mb-4">
          {{ t('discover.empty', 'No establishments found in this category yet.') }}
        </p>
        <UButton to="/discover" variant="outline" color="primary" :label="t('common.discoverAll', 'Discover all')" />
      </div>

      <!-- Load More -->
      <div v-if="hasMore" class="mt-8 text-center">
        <UButton 
          variant="outline" 
          label="Load more" 
          icon="i-lucide-chevron-down"
        />
      </div>
    </template>
  </UContainer>
</template>
