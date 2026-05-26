<script setup lang="ts">
/**
 * Public Marketplace Frontpage
 *
 * Design: Matches screenshot 3 specification
 * - Map hero with search overlay
 * - Popular Nearby horizontal cards from Firestore
 * - Browse Categories grid with icons from Firestore
 * - Footer (handled by layout)
 */
import { collection, collectionGroup, query, limit, orderBy, where } from 'firebase/firestore'

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

// Firestore queries
const categoriesQuery = query(collection(db, 'categories'), orderBy('name', 'asc'))
const allCategories = useCollection(categoriesQuery)

// Browse Categories: show all categories as a navigation grid
// (not filtered by the limited nearby stores query)
// TODO: Captain has some plans on howto sort the categories in the future.
const categories = computed(() => {
  if (!allCategories.value) return []
  return allCategories.value.slice(0, 32)
})

// Only show published stores
const nearbyQuery = query(
  collectionGroup(db, 'stores'),
  where('isPublished', '==', true),
  limit(8)
)
const nearbyStores = useCollection(nearbyQuery)

// Helper functions
const getStoreImage = (store: any) => {
  return store.images?.cover
    || 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=400'
}

// Look up category name from categories collection using the store's category UID
const getCategoryName = (categoryId: string | undefined) => {
  if (!categoryId || !allCategories.value) return null
  const category = allCategories.value.find(cat => cat.id === categoryId)
  return category?.name || null
}

// Look up category slug for URL routing
const getCategorySlug = (categoryId: string | undefined) => {
  if (!categoryId || !allCategories.value) return 'discover'
  const category = allCategories.value.find(cat => cat.id === categoryId)
  return category?.slug || category?.id || 'discover'
}

const getStoreType = (store: any) => {
  return store.storeType || store.bookingFormType || 'Service'
}

const isStoreOpen = (store: any) => {
  // TODO: Calculate based on schedule
  return store.isActive !== false
}

const { resolve: getCategoryIcon } = useCategoryIcon()

// Map reference for controlling zoom/center/pan
const mapExplorer = ref<{ zoomIn: () => void, zoomOut: () => void, centerOnUser: () => void, panTo: (lat: number, lng: number, zoom?: number) => void } | null>(null)

// DittoBar map bridge — pan map to focused store
function handleFocusStore(payload: { lat: number; lng: number }) {
  mapExplorer.value?.panTo(payload.lat, payload.lng, 15)
}

// Transform stores into map-compatible locations
const storeLocations = computed(() => {
  if (!nearbyStores.value) return []
  return nearbyStores.value
    .filter(store => store.gmapCoord?.lat && store.gmapCoord?.lng)
    .map(store => ({
      id: store.id,
      name: store.name,
      slug: store.slug,
      categorySlug: getCategorySlug(store.category),
      lat: store.gmapCoord.lat,
      lng: store.gmapCoord.lng,
      image: getStoreImage(store),
      category: getCategoryName(store.category)
    }))
})

// Navigate to store when marker clicked
function handleStoreMarkerClick(store: { slug: string, categorySlug?: string }) {
  const category = store.categorySlug || 'discover'
  navigateTo(`/${category}/${store.slug}`)
}
</script>

<template>
  <div class="min-h-screen">
    <!-- Map Hero Section -->
    <section class="relative w-full h-[50vh] md:h-[45vh] overflow-hidden">
      <!-- Interactive Map -->
      <ClientOnly>
        <DDMapExplorer
          ref="mapExplorer"
          :stores="storeLocations"
          height="100%"
          :use-user-location="true"
          @store-click="handleStoreMarkerClick"
        >
          <!-- DittoBar Search -->
          <div class="absolute bottom-6 left-1/2 -translate-x-1/2 w-full max-w-md px-4 z-10">
            <DDDittoBar
              :stores="nearbyStores"
              :categories="allCategories"
              @focus-store="handleFocusStore"
            />
          </div>

          <!-- Map Controls -->
          <div class="absolute bottom-6 right-4 flex flex-col gap-2 z-10">
            <UButton
              icon="i-lucide-plus"
              color="neutral"
              variant="solid"
              size="lg"
              class="shadow-md rounded-lg hidden"
              @click="mapExplorer?.zoomIn()"
            />
            <UButton
              icon="i-lucide-map-pin"
              color="primary"
              variant="solid"
              size="lg"
              class="shadow-md rounded-lg hidden"
              @click="mapExplorer?.centerOnUser()"
            />
          </div>
        </DDMapExplorer>

        <!-- Fallback for SSR -->
        <template #fallback>
          <div class="w-full h-full bg-muted flex items-center justify-center">
            <UIcon name="i-lucide-map" class="size-12 text-dimmed animate-pulse" />
          </div>
        </template>
      </ClientOnly>
    </section>

    <!-- Popular Nearby Section -->
    <section class="py-8 md:py-12">
      <UContainer>
        <div class="mb-6">
          <h2 class="text-xl font-bold text-highlighted text-center">
            {{ t('home.popularNearby', 'Popular') }}
          </h2>
        </div>

        <!-- "Se alle" top-right -->
        <div class="flex justify-end mb-4">
          <NuxtLink to="/discover" class="text-sm font-medium text-primary hover:underline">
            {{ t('common.viewAll', 'View all') }}
          </NuxtLink>
        </div>

        <!-- Store Cards Grid -->
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6">
          <!-- Loading Skeletons -->
          <template v-if="!nearbyStores">
            <DDEstablishmentCard
              v-for="i in 4"
              id=""
              :key="`skeleton-${i}`"
              loading
              name=""
              slug=""
            />
          </template>

          <!-- Actual Store Cards -->
          <DDEstablishmentCard
            v-for="store in nearbyStores"
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
      </UContainer>
    </section>

    <!-- Browse Categories Section -->
    <section class="py-8 md:py-12 border-t border-default bg-muted/50">
      <UContainer>
        <h2 class="text-xl font-bold text-highlighted text-center mb-6">
          {{ t('home.browseCategories', 'Discover') }}
        </h2>

        <!-- Categories Grid -->
        <div class="grid grid-cols-4 sm:grid-cols-8 gap-2 md:gap-8 lg:gap-12">
          <!-- Categories -->
          <NuxtLink
            v-for="cat in categories"
            :key="cat.id"
            :to="`/discover?category=${cat.slug || cat.id}`"
            class="group flex flex-col items-center min-w-0"
          >
            <div class="w-14 h-14 sm:w-15 sm:h-15 md:w-16 md:h-16 rounded-xl bg-elevated flex items-center justify-center mb-2 border border-default group-hover:border-primary group-hover:bg-primary/5 transition-all shadow-sm">
              <UIcon
                :name="getCategoryIcon(cat.icon)"
                class="size-6 md:size-7 text-primary"
              />
            </div>
            <span class="text-[11px] md:text-xs text-center font-medium text-muted leading-tight group-hover:text-primary transition-colors">
              {{ cat.name }}
            </span>
          </NuxtLink>

          <!-- Loading State (Skeletons) -->
          <template v-if="!allCategories">
            <div
              v-for="i in 8"
              :key="`skeleton-${i}`"
              class="flex flex-col items-center"
            >
              <div class="w-14 h-14 md:w-16 md:h-16 rounded-xl bg-accented animate-pulse mb-2" />
              <div class="w-12 h-3 bg-accented rounded animate-pulse" />
            </div>
          </template>
        </div>

        <!-- Bottom separator with link -->
        <USeparator class="mt-6">
          <NuxtLink to="/discover" class="text-sm font-medium text-primary hover:underline">
            {{ t('common.more', 'See All') }}
          </NuxtLink>
        </USeparator>
      </UContainer>
    </section>

    <!-- Mobile-only bottom links -->
    <div class="md:hidden py-6">
      <div class="flex items-center justify-center gap-3">
        <NuxtLink
          to="/contact"
          class="px-4 py-2 text-sm font-medium text-muted border border-default rounded-lg hover:text-primary hover:border-primary transition-colors"
        >
          {{ t('footer.contact', 'Contact') }}
        </NuxtLink>
        <NuxtLink
          to="/vision"
          class="px-4 py-2 text-sm font-medium text-muted border border-default rounded-lg hover:text-primary hover:border-primary transition-colors"
        >
          {{ t('footer.vision', 'Vision') }}
        </NuxtLink>
      </div>
    </div>

  </div>
</template>
