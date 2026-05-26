<script setup lang="ts">
/**
 * Profile / Favorites Page
 *
 * Shows the user's saved stores using the shared DDEstablishmentCard.
 * Consistent with frontpage/discover card styling.
 */

const { favorites, loading, error, fetchFavorites, removeFavorite } = useFavorites()
const user = useCurrentUser()
const toast = useToast()
const { t } = useI18n()

const removing = ref<string | null>(null)

onMounted(() => {
  if (user.value) {
    fetchFavorites('store')
  }
})

watch(user, (newUser) => {
  if (newUser) fetchFavorites('store')
})

async function handleRemove(entityId: string) {
  removing.value = entityId
  await removeFavorite(entityId, 'store')
  removing.value = null
  toast.add({
    title: t('favorites.removed'),
    color: 'neutral',
    icon: 'i-lucide-heart-off'
  })
}

function handleRefresh() {
  fetchFavorites('store')
}
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-semibold text-gray-900 dark:text-white">
          {{ t('profile.favorites.title') }}
        </h2>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5">
          {{ t('profile.favorites.subtitle') }}
        </p>
      </div>
      <UButton
        variant="ghost"
        size="sm"
        icon="i-lucide-refresh-cw"
        :label="t('profile.favorites.refresh')"
        :loading="loading"
        @click="handleRefresh"
      />
    </div>

    <!-- Loading State -->
    <div v-if="loading && favorites.length === 0" class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
      <DDEstablishmentCard
        v-for="i in 4"
        :key="`skeleton-${i}`"
        id=""
        name=""
        slug=""
        :loading="true"
      />
    </div>

    <!-- Error State -->
    <UCard v-else-if="error" class="border-red-200 dark:border-red-900">
      <div class="flex items-center gap-3 text-red-600 dark:text-red-400">
        <UIcon name="i-lucide-alert-circle" class="size-5 shrink-0" />
        <p class="text-sm">{{ error }}</p>
      </div>
    </UCard>

    <!-- Empty State -->
    <div
      v-else-if="!loading && favorites.length === 0"
      class="py-16 text-center"
    >
      <div class="w-20 h-20 mx-auto mb-6 rounded-full bg-primary-50 dark:bg-primary-950 flex items-center justify-center">
        <UIcon name="i-lucide-heart" class="size-10 text-primary-400 dark:text-primary-500" />
      </div>
      <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">
        {{ t('profile.favorites.emptyTitle') }}
      </h3>
      <p class="text-sm text-gray-500 dark:text-gray-400 max-w-sm mx-auto mb-6">
        {{ t('profile.favorites.emptyDesc') }}
      </p>
      <UButton
        to="/"
        variant="soft"
        size="md"
        icon="i-lucide-compass"
        :label="t('profile.favorites.explore')"
      />
    </div>

    <!-- Favorites Grid — using DDEstablishmentCard -->
    <div
      v-else
      class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4"
    >
      <div
        v-for="fav in favorites"
        :key="fav.id"
        class="relative group"
      >
        <!-- Remove Button (top-right overlay) -->
        <button
          class="absolute top-2 right-2 z-10 p-1.5 rounded-full bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm border border-gray-200 dark:border-gray-700 text-gray-400 hover:text-red-500 hover:border-red-300 dark:hover:border-red-700 transition-all duration-200 opacity-0 group-hover:opacity-100"
          :class="{ 'opacity-100': removing === fav.id }"
          :disabled="removing === fav.id"
          @click.prevent="handleRemove(fav.id)"
        >
          <UIcon
            :name="removing === fav.id ? 'i-lucide-loader-2' : 'i-lucide-heart-off'"
            class="size-4"
            :class="{ 'animate-spin': removing === fav.id }"
          />
        </button>

        <DDEstablishmentCard
          :id="fav.id"
          :name="fav.name || fav.id"
          :slug="fav.slug || fav.id"
          :category-slug="fav.category"
          :image="fav.coverImage"
          :city="fav.city"
          :rating="fav.rating"
          :review-count="fav.reviewCount"
          :is-favorited="true"
        />
      </div>
    </div>
  </div>
</template>
