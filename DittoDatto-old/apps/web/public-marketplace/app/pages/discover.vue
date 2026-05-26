<script setup lang="ts">
/**
 * Discover Page — All published stores
 *
 * Reached via "View All" on the frontpage.
 * Shows all published stores with category filter pills.
 * Uses collectionGroup to query stores across all company subcollections.
 */
import { collection, collectionGroup, query, where, orderBy } from 'firebase/firestore'

definePageMeta({ layout: 'default' })

const db = useFirestore()
const { t } = useI18n()
const localePath = useLocalePath()
const user = useCurrentUser()
const { favorites, fetchFavorites, addFavorite, removeFavorite } = useFavorites()

// Fetch favorites when user is logged in
watch(user, (newUser) => {
  if (newUser) fetchFavorites('store')
}, { immediate: true })

const isFavoriteStore = (storeId: string) =>
  favorites.value.some(f => f.id === storeId)

async function toggleFavorite(store: any) {
  if (!user.value) {
    navigateTo(localePath('/login'))
    return
  }
  if (isFavoriteStore(store.id)) {
    await removeFavorite(store.id, 'store')
  } else {
    await addFavorite(store.id, 'store', store.companyId)
  }
}

useHead({
  title: `${t('discover.title')} — DittoDatto`,
  meta: [{ name: 'description', content: t('discover.subtitle') }]
})

// Fetch all published stores (across company subcollections)
const storesQuery = query(
  collectionGroup(db, 'stores'),
  where('isPublished', '==', true)
)
const allStores = useCollection(storesQuery)

// Fetch categories for filter pills
const categoriesQuery = query(collection(db, 'categories'), orderBy('name', 'asc'))
const allCategories = useCollection(categoriesQuery)

// Active category filter (null = all)
// Initialize from ?category query param if present
const route = useRoute()
const activeCategory = ref<string | null>(null)

// Resolve ?category=slug to the category ID on load
watch(allCategories, (cats) => {
  if (!cats || activeCategory.value) return
  const slug = route.query.category as string | undefined
  if (slug) {
    const match = cats.find(c => c.slug === slug || c.id === slug)
    if (match) activeCategory.value = match.id
  }
}, { immediate: true })

// Filtered stores
const filteredStores = computed(() => {
  if (!allStores.value) return []
  if (!activeCategory.value) return allStores.value
  return allStores.value.filter(store => store.category === activeCategory.value)
})

// Categories that have at least one published store (store.category = category ID)
const activeCategories = computed(() => {
  if (!allCategories.value || !allStores.value) return []
  const storeCategoryIds = new Set(allStores.value.map(s => s.category).filter(Boolean))
  return allCategories.value.filter(cat => storeCategoryIds.has(cat.id))
})

// Helpers (same pattern as frontpage)
const getStoreImage = (store: any) => {
  return store.images?.cover
    || 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=400'
}

const getCategoryName = (categoryId: string | undefined) => {
  if (!categoryId || !allCategories.value) return null
  const category = allCategories.value.find(cat => cat.id === categoryId)
  return category?.name || null
}

const getCategorySlug = (categoryId: string | undefined) => {
  if (!categoryId || !allCategories.value) return 'discover'
  const category = allCategories.value.find(cat => cat.id === categoryId)
  return category?.slug || category?.id || 'discover'
}

const { resolve: getCategoryIcon } = useCategoryIcon()

const isStoreOpen = (store: any) => {
  return store.isActive !== false
}

function setCategory(categoryId: string | null) {
  activeCategory.value = categoryId
  // Sync URL ?category=slug without hard navigation
  const query = { ...route.query }
  if (categoryId) {
    const cat = allCategories.value?.find(c => c.id === categoryId)
    query.category = cat?.slug || categoryId
  } else {
    delete query.category
  }
  navigateTo({ path: '/discover', query }, { replace: true })
}
</script>

<template>
  <div class="py-8 md:py-12">
    <UContainer>
      <!-- Header -->
      <div class="mb-8">
        <div class="flex items-center gap-3 mb-2">
          <UIcon name="i-lucide-compass" class="size-8 text-primary" />
          <h1 class="text-3xl md:text-4xl font-bold">{{ t('discover.title', 'Discover') }}</h1>
        </div>
        <p class="text-muted text-lg">
          {{ t('discover.subtitle', 'Explore all local businesses and services near you') }}
        </p>
      </div>

      <!-- Category Filter Pills -->
      <div v-if="activeCategories.length > 1" class="flex flex-wrap gap-2 mb-8">
        <UButton
          :color="!activeCategory ? 'primary' : 'neutral'"
          :variant="!activeCategory ? 'solid' : 'outline'"
          size="sm"
          @click="setCategory(null)"
        >
          <UIcon name="i-lucide-grid-2x2" class="size-4 mr-1" />
          {{ t('discover.all', 'All') }}
          <UBadge v-if="allStores" color="neutral" variant="subtle" size="xs" class="ml-1">
            {{ allStores.length }}
          </UBadge>
        </UButton>

        <UButton
          v-for="cat in activeCategories"
          :key="cat.id"
          :color="activeCategory === cat.id ? 'primary' : 'neutral'"
          :variant="activeCategory === cat.id ? 'solid' : 'outline'"
          size="sm"
          @click="setCategory(cat.id)"
        >
          <UIcon :name="getCategoryIcon(cat.icon)" class="size-4 mr-1" />
          {{ cat.name }}
        </UButton>
      </div>

      <!-- Results Count -->
      <div class="flex items-center justify-between mb-6">
        <p class="text-sm text-muted">
          {{ t('discover.showing', 'Showing') }}
          <span class="font-semibold text-default">{{ filteredStores.length }}</span>
          {{ t('discover.establishments', 'establishments') }}
        </p>
      </div>

      <!-- Loading Skeletons -->
      <div v-if="!allStores" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6">
        <DDEstablishmentCard
          v-for="i in 8"
          :id="''"
          :key="`skeleton-${i}`"
          loading
          name=""
          slug=""
        />
      </div>

      <!-- Store Grid -->
      <div
        v-else-if="filteredStores.length > 0"
        class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6"
      >
        <DDEstablishmentCard
          v-for="store in filteredStores"
          :id="store.id"
          :key="store.id"
          :name="store.name"
          :slug="store.slug"
          :category-slug="getCategorySlug(store.category)"
          :image="getStoreImage(store)"
          :category="getCategoryName(store.category)"
          :is-open="isStoreOpen(store)"
          :favorites-count="store.favoritesCount"
          :is-favorited="isFavoriteStore(store.id)"
          :city="store.city"
          :tagline="store.tagline"
          @favorite="toggleFavorite(store)"
        />
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-20">
        <div class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-muted/50 text-muted mb-6">
          <UIcon name="i-lucide-search-x" class="size-8" />
        </div>
        <h2 class="text-xl font-semibold mb-2">{{ t('discover.empty', 'No establishments found') }}</h2>
        <p class="text-muted mb-6 max-w-md mx-auto">
          {{ t('discover.emptyDesc', 'We couldn\'t find any establishments yet. Check back soon!') }}
        </p>
        <UButton to="/" color="primary">
          {{ t('discover.backHome', 'Back to home') }}
        </UButton>
      </div>
    </UContainer>
  </div>
</template>
