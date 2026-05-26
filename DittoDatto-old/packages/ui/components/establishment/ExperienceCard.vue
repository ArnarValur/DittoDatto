<script setup lang="ts">
/**
 * Experience Card
 * Displays a dining experience option (e.g., Lunch, Dinner, Special Event).
 * Used in the establishment page grid and booking selection.
 */

interface Props {
  title: string
  image?: string
  timeRange: string
  priceDisplay?: string
  description?: string
  selected?: boolean
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  selected: false
})
</script>

<template>
  <div 
    class="relative group rounded-xl overflow-hidden border transition-all duration-200 bg-white dark:bg-gray-900 cursor-pointer h-full flex flex-col"
    :class="[
      selected ? 'border-primary-500 ring-2 ring-primary-500 ring-offset-2 dark:ring-offset-gray-950' : 'border-gray-200 dark:border-gray-800 hover:border-primary-500/50 hover:shadow-lg'
    ]"
  >
    <!-- Loading State -->
    <template v-if="loading">
      <USkeleton class="w-full aspect-[4/3]" />
      <div class="p-4 space-y-3">
        <USkeleton class="h-6 w-3/4" />
        <USkeleton class="h-4 w-1/2" />
        <USkeleton class="h-16 w-full" />
      </div>
    </template>

    <!-- Content -->
    <template v-else>
      <!-- Image Cover -->
      <div class="relative w-full aspect-[16/9] overflow-hidden bg-gray-100 dark:bg-gray-800">
        <NuxtImg 
          v-if="image"
          :src="image" 
          :alt="title"
          class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
          loading="lazy"
          sizes="(max-width: 640px) 100vw, 50vw"
          placeholder
        />
        <div v-else class="w-full h-full flex items-center justify-center">
          <UIcon name="i-lucide-utensils" class="size-8 text-gray-400" />
        </div>
        
        <!-- Price Badge if present -->
        <div v-if="priceDisplay" class="absolute bottom-2 right-2">
          <UBadge color="black" class="backdrop-blur-md bg-black/60 text-white font-medium">
            {{ priceDisplay }}
          </UBadge>
        </div>
      </div>

      <!-- Details -->
      <div class="p-4 flex flex-col flex-1">
        <h3 class="font-bold text-lg text-gray-900 dark:text-white mb-1">
          {{ title }}
        </h3>
        
        <div class="flex items-center gap-1.5 text-sm text-gray-500 dark:text-gray-400 mb-3">
          <UIcon name="i-lucide-clock" class="size-4" />
          <span>{{ timeRange }}</span>
        </div>

        <p v-if="description" class="text-sm text-gray-600 dark:text-gray-300 line-clamp-3">
          {{ description }}
        </p>

        <!-- Selection Indicator -->
        <div v-if="selected" class="absolute top-2 right-2 bg-primary-500 text-white rounded-full p-1 shadow-lg">
          <UIcon name="i-lucide-check" class="size-5" />
        </div>
      </div>
    </template>
  </div>
</template>
