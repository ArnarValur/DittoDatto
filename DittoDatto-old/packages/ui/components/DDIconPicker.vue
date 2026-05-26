<template>
  <UPopover
    :ui="{ content: 'w-80' }"
    @update:open="onPopoverOpen"
  >
    <!-- Trigger Button -->
    <UButton
      :icon="modelValue || 'i-lucide-image'"
      :color="modelValue ? 'primary' : 'neutral'"
      :variant="modelValue ? 'soft' : 'outline'"
      :size="size"
      :disabled="disabled"
      class="w-full justify-start"
    >
      <span v-if="!modelValue" class="text-muted">{{ placeholder }}</span>
      <span v-else class="truncate">{{ selectedLabel }}</span>
    </UButton>

    <!-- Popover Content -->
    <template #content>
      <div class="p-3 space-y-3">
        <!-- Loading State -->
        <div v-if="loadingIcons" class="flex flex-col items-center py-6 gap-2">
          <UIcon name="i-lucide-loader-2" class="size-6 animate-spin text-primary" />
          <span class="text-xs text-muted">Loading icons...</span>
        </div>

        <!-- Error State -->
        <div v-else-if="errorMessage" class="text-center py-4">
          <p class="text-sm text-error">{{ errorMessage }}</p>
          <UButton
            size="xs"
            variant="ghost"
            class="mt-2"
            @click="fetchIcons"
          >
            Retry
          </UButton>
        </div>

        <template v-else>
          <!-- Collection Filter with My Collection -->
          <div class="flex gap-1 flex-wrap">
            <!-- My Collection (Favorites) -->
            <UButton
              size="xs"
              :color="selectedCollectionId === 'favorites' ? 'success' : 'neutral'"
              :variant="selectedCollectionId === 'favorites' ? 'solid' : 'ghost'"
              @click="selectedCollectionId = 'favorites'"
            >
              <UIcon name="i-lucide-heart" class="size-3 mr-1" />
              My ({{ favorites.length }})
            </UButton>

            <!-- All -->
            <UButton
              size="xs"
              :color="selectedCollectionId === null ? 'primary' : 'neutral'"
              :variant="selectedCollectionId === null ? 'solid' : 'ghost'"
              @click="selectedCollectionId = null"
            >
              All ({{ allIcons.length }})
            </UButton>

            <!-- Other Collections -->
            <UButton
              v-for="collection in collections"
              :key="collection.id"
              size="xs"
              :color="selectedCollectionId === collection.id ? 'primary' : 'neutral'"
              :variant="selectedCollectionId === collection.id ? 'solid' : 'ghost'"
              @click="selectedCollectionId = collection.id"
            >
              {{ truncateName(collection.name) }} ({{ collection.icons.length }})
            </UButton>
          </div>

          <!-- Search Input -->
          <UInput
            v-model="searchQuery"
            placeholder="Search icons..."
            icon="i-lucide-search"
            size="sm"
            autofocus
            :ui="{ trailing: 'pe-1' }"
          >
            <template v-if="searchQuery" #trailing>
              <UButton
                color="neutral"
                variant="link"
                size="xs"
                icon="i-lucide-x"
                @click="searchQuery = ''"
              />
            </template>
          </UInput>

          <!-- Icon Grid with Infinite Scroll -->
          <div
            ref="scrollContainer"
            class="grid grid-cols-5 gap-1 max-h-48 overflow-y-auto"
            @scroll="onScroll"
          >
            <div
              v-for="icon in displayedIcons"
              :key="icon"
              class="relative group"
            >
              <!-- Icon Button -->
              <button
                type="button"
                class="flex items-center justify-center w-10 h-10 rounded-md transition-colors"
                :class="[
                  modelValue === icon 
                    ? 'bg-primary text-primary-foreground ring-2 ring-primary' 
                    : 'hover:bg-elevated border border-transparent hover:border-accented'
                ]"
                :title="formatIconName(icon)"
                @click="selectIcon(icon)"
              >
                <UIcon :name="icon" class="size-5" />
              </button>

              <!-- Favorite/Unfavorite Badge -->
              <button
                v-if="selectedCollectionId === 'favorites'"
                type="button"
                class="absolute -top-1 -right-1 w-4 h-4 bg-error text-white rounded-full flex items-center justify-center text-xs opacity-0 group-hover:opacity-100 transition-opacity"
                title="Remove from My Collection"
                @click.stop="removeFavorite(icon)"
              >
                ×
              </button>
              <button
                v-else-if="!isFavorite(icon)"
                type="button"
                class="absolute -top-1 -right-1 w-4 h-4 bg-success text-white rounded-full flex items-center justify-center text-xs opacity-0 group-hover:opacity-100 transition-opacity"
                title="Add to My Collection"
                @click.stop="addFavorite(icon)"
              >
                +
              </button>
              <div
                v-else
                class="absolute -top-1 -right-1 w-4 h-4 bg-success/50 text-white rounded-full flex items-center justify-center text-xs"
                title="In My Collection"
              >
                ✓
              </div>
            </div>
          </div>

          <!-- Empty State -->
          <div 
            v-if="displayedIcons.length === 0" 
            class="text-center py-4 text-muted text-sm"
          >
            <template v-if="selectedCollectionId === 'favorites'">
              No favorites yet. Click + on icons to add them!
            </template>
            <template v-else>
              No icons found
            </template>
          </div>

          <!-- Result Count -->
          <div class="text-xs text-muted text-center">
            {{ displayedIcons.length }} of {{ filteredIcons.length }} icons
            <span v-if="hasMore" class="ml-1">(scroll for more)</span>
          </div>
        </template>
      </div>
    </template>
  </UPopover>
</template>

<script setup lang="ts">
import type { DDIconPickerProps } from '../types/icon-picker'
import { useIconFavorites } from '../composables/useIconFavorites'

interface IconCollection {
  id: string
  name: string
  icons: string[]
}

interface IconCollectionResponse {
  collections: IconCollection[]
}

const props = withDefaults(defineProps<DDIconPickerProps>(), {
  modelValue: '',
  placeholder: 'Select an icon...',
  disabled: false,
  size: 'md'
})

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

// Favorites composable
const {
  favorites,
  fetchFavorites,
  addFavorite,
  removeFavorite,
  isFavorite
} = useIconFavorites()

// State
const searchQuery = ref('')
const collections = ref<IconCollection[]>([])
const allIcons = ref<string[]>([])
const loadingIcons = ref(false)
const errorMessage = ref('')
const hasFetched = ref(false)
const selectedCollectionId = ref<string | null>(null)

// Infinite scroll state
const PAGE_SIZE = 50
const displayCount = ref(PAGE_SIZE)
const scrollContainer = ref<HTMLElement | null>(null)

// Reset display count when search or collection changes
watch([searchQuery, selectedCollectionId], () => {
  displayCount.value = PAGE_SIZE
})

// Fetch icons when popover opens (lazy load)
function onPopoverOpen(isOpen: boolean) {
  if (isOpen && !hasFetched.value) {
    fetchIcons()
    fetchFavorites()
  }
  if (isOpen) {
    displayCount.value = PAGE_SIZE
  }
}

async function fetchIcons() {
  loadingIcons.value = true
  errorMessage.value = ''
  try {
    const response = await $fetch<IconCollectionResponse>('/api/icon-collections')
    collections.value = response.collections
    
    // Flatten all collections
    const iconSet = new Set<string>()
    for (const collection of response.collections) {
      for (const icon of collection.icons) {
        iconSet.add(icon)
      }
    }
    allIcons.value = Array.from(iconSet)
    hasFetched.value = true
  } catch (err) {
    console.error('Failed to fetch icons:', err)
    errorMessage.value = 'Failed to load icons'
  } finally {
    loadingIcons.value = false
  }
}

// Base icons (filtered by collection)
const collectionIcons = computed(() => {
  if (selectedCollectionId.value === 'favorites') {
    return favorites.value
  }
  if (selectedCollectionId.value === null) {
    return allIcons.value
  }
  const collection = collections.value.find((c) => c.id === selectedCollectionId.value)
  return collection?.icons || []
})

// Filtered icons based on search
const filteredIcons = computed(() => {
  if (!searchQuery.value) return collectionIcons.value
  const query = searchQuery.value.toLowerCase()
  return collectionIcons.value.filter((icon) => 
    icon.toLowerCase().includes(query)
  )
})

// Displayed icons (paginated)
const displayedIcons = computed(() => {
  return filteredIcons.value.slice(0, displayCount.value)
})

// Check if there are more icons to load
const hasMore = computed(() => {
  return displayCount.value < filteredIcons.value.length
})

// Infinite scroll handler
function onScroll(event: Event) {
  const target = event.target as HTMLElement
  const scrollBottom = target.scrollHeight - target.scrollTop - target.clientHeight
  if (scrollBottom < 50 && hasMore.value) {
    displayCount.value += PAGE_SIZE
  }
}

// Truncate long collection names
function truncateName(name: string): string {
  return name.length > 10 ? name.slice(0, 10) + '…' : name
}

// Format icon name for display
function formatIconName(icon: string): string {
  return icon
    .replace(/^i-/, '')
    .replace(/-/g, ' ')
    .replace(/\b\w/g, (c) => c.toUpperCase())
}

// Get selected icon label for display
const selectedLabel = computed(() => {
  if (!props.modelValue) return ''
  return formatIconName(props.modelValue)
})

// Select an icon
function selectIcon(value: string) {
  emit('update:modelValue', value)
  searchQuery.value = ''
}
</script>
