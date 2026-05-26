<script setup lang="ts">
/**
 * DDEstablishmentCard
 * A card component for displaying an establishment/store in listing contexts.
 * Uses Nuxt UI components for consistent styling and responsiveness.
 *
 * Used on: Public Marketplace frontpage, category pages, search results
 */

interface Props {
  /** Store/Establishment ID */
  id: string
  /** Store name */
  name: string
  /** Store slug for URL generation */
  slug: string
  /** Store type (restaurant, salon, etc.) - for display only */
  storeType?: string
  /** Category slug for URL routing (e.g., 'nightclubs', 'barber') */
  categorySlug?: string
  /** Cover image URL */
  image?: string
  /** Category name */
  category?: string
  /** Category icon (e.g., i-lucide-utensils) */
  categoryIcon?: string
  /** Average rating (0-5) */
  rating?: number
  /** Total number of reviews */
  reviewCount?: number
  /** Number of favorites */
  favoritesCount?: number
  /** Whether the current user has favorited this store */
  isFavorited?: boolean
  /** Whether the store is currently open */
  isOpen?: boolean
  /** Short description or tagline */
  tagline?: string
  /** Price range indicator (e.g., "$$", "$$$") */
  priceRange?: string
  /** City/Location */
  city?: string
  /** Loading state for skeleton */
  loading?: boolean
  /** Whether clicking the card should navigate */
  clickable?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  clickable: true,
  isOpen: true
})

const emit = defineEmits<{
  (e: 'click'): void
  (e: 'favorite'): void
}>()

// Generate the route URL using category slug (matches [category]/[slug] route)
const storeUrl = computed(() => {
  const category = props.categorySlug || 'discover'
  return `/${category}/${props.slug}`
})

// Fallback image
const displayImage = computed(() => {
  return props.image || 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=400'
})

// Format rating display
const displayRating = computed(() => {
  if (!props.rating) return null
  return props.rating.toFixed(1)
})

function handleFavoriteClick(e: Event) {
  e.preventDefault()
  e.stopPropagation()
  emit('favorite')
}
</script>

<template>
  <!-- Loading Skeleton -->
  <div v-if="loading" class="rounded-xl overflow-hidden bg-card border border-default">
    <USkeleton class="w-full aspect-4/3" />
    <div class="p-3 space-y-2">
      <USkeleton class="h-5 w-3/4" />
      <USkeleton class="h-4 w-1/2" />
      <div class="flex gap-2">
        <USkeleton class="h-4 w-16" />
        <USkeleton class="h-4 w-12" />
      </div>
    </div>
  </div>

  <!-- Actual Card -->
  <NuxtLink
    v-else
    :to="storeUrl"
    :class="[
      'group block rounded-xl overflow-hidden bg-card border border-default',
      'transition-all duration-300',
      clickable && 'hover:border-primary hover:shadow-lg hover:shadow-primary/10 cursor-pointer',
      'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2'
    ]"
    @click="emit('click')"
  >
    <!-- Image Container -->
    <div class="relative aspect-4/3 overflow-hidden bg-muted">
      <NuxtImg
        :src="displayImage"
        :alt="name"
        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
        loading="lazy"
        sizes="(max-width: 640px) 50vw, (max-width: 1024px) 33vw, 25vw"
        placeholder
      />

      <!-- Open/Closed Badge -->
      <UBadge
        v-if="isOpen !== undefined"
        :color="isOpen ? 'success' : 'error'"
        variant="solid"
        size="xs"
        class="absolute top-2 left-2 backdrop-blur-sm"
      >
        {{ isOpen ? 'Open' : 'Closed' }}
      </UBadge>

      <!-- Category Badge (top-right) -->
      <UBadge
        v-if="category"
        color="neutral"
        variant="solid"
        size="xs"
        class="absolute top-2 right-2 bg-black/50 text-white backdrop-blur-sm z-10"
      >
        <UIcon v-if="categoryIcon" :name="categoryIcon" class="size-3 mr-1" />
        {{ category }}
      </UBadge>
    </div>

    <!-- Card Content -->
    <div class="p-3 space-y-1.5">
      <!-- Title -->
      <h3 class="font-semibold text-sm line-clamp-1 group-hover:text-primary transition-colors">
        {{ name }}
      </h3>

      <!-- Tagline -->
      <p v-if="tagline" class="text-xs text-muted line-clamp-1">
        {{ tagline }}
      </p>

      <!-- Meta Row -->
      <div class="flex items-center justify-between gap-2 text-xs text-muted">
        <div class="flex items-center gap-2">
          <!-- Rating (uncomment when review system is ready) -->
          <!-- <span v-if="displayRating" class="flex items-center gap-0.5">
            <UIcon name="i-lucide-star" class="size-3.5 text-amber-500" />
            <span class="font-medium text-foreground">{{ displayRating }}</span>
            <span v-if="reviewCount" class="text-muted">({{ reviewCount }})</span>
          </span> -->

          <!-- Location -->
          <span v-if="city" class="flex items-center gap-0.5">
            <UIcon name="i-lucide-map-pin" class="size-3.5" />
            {{ city }}
          </span>

          <!-- Price Range -->
          <span v-if="priceRange" class="font-medium">
            {{ priceRange }}
          </span>
        </div>

        <!-- Favorite Toggle -->
        <button
          type="button"
          class="flex items-center gap-0.5 hover:opacity-80 transition-opacity"
          :aria-label="isFavorited ? 'Remove from favorites' : 'Add to favorites'"
          @click="handleFavoriteClick"
        >
          <UIcon
            :name="isFavorited ? 'i-heroicons-heart-solid' : 'i-lucide-heart'"
            :class="['size-3.5 transition-colors', isFavorited ? 'text-red-500' : 'text-muted']"
          />
          <span v-if="favoritesCount && favoritesCount > 0">{{ favoritesCount }}</span>
        </button>
      </div>
    </div>
  </NuxtLink>
</template>

<style scoped>
/* Filled heart for favorited state */
.fill-red-500 {
  fill: currentColor;
}
</style>
