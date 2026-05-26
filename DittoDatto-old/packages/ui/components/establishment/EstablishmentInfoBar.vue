<script setup lang="ts">
/**
 * Establishment Info Bar
 * Displays establishment details found below the image gallery.
 * Includes logo, name, ratings, address, hours, and action buttons.
 */

const { t } = useI18n()

interface Props {
  logo?: string
  name: string
  rating?: number
  reviewCount?: number
  address: string
  city: string
  hoursDisplay?: string
  favoritesCount?: number
  loading?: boolean
  isFavorited?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  isFavorited: false
})

const emit = defineEmits<{
  (e: 'book'): void
  (e: 'favorite'): void
  (e: 'more'): void
}>()
</script>

<template>
  <div class="flex flex-col md:flex-row items-center gap-6 py-6 border-b border-default">
    
    <!-- Loading State -->
    <template v-if="loading">
      <USkeleton class="size-24 rounded-full" />
      <div class="flex-1 w-full space-y-3">
        <USkeleton class="h-8 w-64" />
        <USkeleton class="h-4 w-48" />
        <USkeleton class="h-4 w-32" />
      </div>
      <div class="flex gap-2">
        <USkeleton class="h-10 w-24" />
        <USkeleton class="h-10 w-24" />
        <USkeleton class="h-10 w-10" />
      </div>
    </template>

    <!-- Content -->
    <template v-else>
      <!-- Logo -->
      <div class="shrink-0 relative">
        <div class="size-20 md:size-24 rounded-full border border-default bg-elevated overflow-hidden flex items-center justify-center p-1">
          <NuxtImg 
            v-if="logo"
            :src="logo" 
            :alt="name"
            class="w-full h-full object-cover rounded-full"
            loading="lazy"
            sizes="96px"
          />
          <span v-else class="text-2xl font-bold text-primary">
            {{ name.charAt(0) }}
          </span>
        </div>
      </div>

      <!-- Info -->
      <div class="flex-1 text-center md:text-left space-y-1">
        <h1 class="text-2xl md:text-3xl font-bold">
          {{ name }}
        </h1>
        
        <div class="flex flex-col md:flex-row items-center gap-2 md:gap-4 text-sm text-muted">
          <!-- Rating -->
          <div v-if="rating" class="flex items-center gap-1">
            <UIcon name="i-lucide-heart" class="size-4 text-red-500 fill-red-500" />
            <span class="font-medium text-default">{{ rating }}</span>
            <span v-if="reviewCount" class="text-dimmed">({{ reviewCount }})</span>
          </div>


          <!-- Favorites Count -->
          <div v-if="favoritesCount && favoritesCount > 0" class="flex items-center gap-1">
            <UIcon name="i-heroicons-heart-solid" class="size-4 text-red-500" />
            <span class="font-medium text-default">{{ favoritesCount }}</span>
          </div>

          <span v-if="(favoritesCount && favoritesCount > 0) && (rating || address || hoursDisplay)" class="hidden md:inline text-dimmed">•</span>

          <span v-if="rating" class="hidden md:inline text-dimmed">•</span>

          <!-- Address -->
          <div class="flex items-center gap-1">
            <span>{{ address }}, {{ city }}</span>
          </div>

          <span v-if="hoursDisplay" class="hidden md:inline text-dimmed">•</span>

          <!-- Hours -->
          <div v-if="hoursDisplay" class="flex items-center gap-1 text-success">
            <span>{{ hoursDisplay }}</span>
          </div>
        </div>
      </div>

      <!-- Actions -->
      <div class="flex items-center gap-2 w-full md:w-auto">
        <UButton
          size="lg"
          color="primary"
          variant="solid"
          class="flex-1 md:flex-none px-8 py-3 rounded-xl justify-center"
          icon="i-lucide-calendar-plus"
          @click="emit('book')"
        >
          {{ t('establishment.book') }}
        </UButton>
        
        <UButton
          size="lg"
          :color="isFavorited ? 'error' : 'neutral'"
          :variant="isFavorited ? 'soft' : 'outline'"
          class="flex-1 md:flex-none px-6 py-3 rounded-xl justify-center"
          @click="emit('favorite')"
        >
          <template #leading>
            <UIcon 
              :name="isFavorited ? 'i-heroicons-heart-solid' : 'i-lucide-heart'"
              :class="isFavorited ? 'text-red-500' : ''"
            />
          </template>
          {{ isFavorited ? t('establishment.favorited') : t('establishment.favorites') }}
        </UButton>

        <!-- More button hidden per Captain's decision (TODO#4) -->
        <UButton
          size="lg"
          color="neutral"
          variant="ghost"
          icon="i-lucide-more-horizontal"
          class="rounded-xl hidden"
          @click="emit('more')"
        />
      </div>
    </template>
  </div>
</template>

