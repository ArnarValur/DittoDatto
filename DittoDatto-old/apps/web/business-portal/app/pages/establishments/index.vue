<script setup lang="ts">
/**
 * Unified Establishments Page
 * Shows ALL establishments (stores, restaurants, venues) with tab filtering.
 */
import type { Store } from '@dittodatto/shared-types'
import StoreFormSlideover from '~/components/stores/StoreFormSlideover.vue'

definePageMeta({
  layout: 'dashboard'
})

const { stores, loading, canAddMoreStores, canCreateStores } = useStores()
const { company } = useCompany()

// Tab filtering - only show tabs that have establishments
const activeTab = ref('all')
const tabs = computed(() => {
  const baseTabs = [
    { id: 'all', label: 'All', icon: 'i-lucide-layout-grid' }
  ]

  if (!stores.value) return baseTabs

  // Count establishments by type
  const hasRestaurants = stores.value.some(s => s.storeType === 'restaurant')
  const hasStores = stores.value.some(s => s.storeType === 'store' || !s.storeType)
  const hasVenues = stores.value.some(s => s.storeType === 'venue')

  // Only show tabs that have establishments
  if (hasRestaurants) {
    baseTabs.push({ id: 'restaurant', label: 'Restaurants', icon: 'i-lucide-utensils' })
  }

  if (hasStores) {
    baseTabs.push({ id: 'store', label: 'Stores', icon: 'i-lucide-store' })
  }

  if (hasVenues) {
    baseTabs.push({ id: 'venue', label: 'Venues', icon: 'i-lucide-building-2' })
  }

  return baseTabs
})

// Filtered establishments based on active tab (using storeType field)
const filteredEstablishments = computed(() => {
  if (!stores.value) return []

  switch (activeTab.value) {
    case 'restaurant':
      return stores.value.filter(s => s.storeType === 'restaurant')
    case 'store':
      return stores.value.filter(s => s.storeType === 'store' || !s.storeType)
    case 'venue':
      return stores.value.filter(s => s.storeType === 'venue')
    default:
      return stores.value
  }
})

const isEmpty = computed(() => !loading.value && filteredEstablishments.value.length === 0)

// Get icon and color based on storeType
function getTypeIcon(storeType?: string): string {
  switch (storeType) {
    case 'restaurant': return 'i-lucide-utensils'
    case 'venue': return 'i-lucide-building-2'
    default: return 'i-lucide-store'
  }
}

function getTypeLabel(storeType?: string): string {
  switch (storeType) {
    case 'restaurant': return 'Restaurant'
    case 'venue': return 'Venue'
    default: return 'Store'
  }
}

function getTypeColor(storeType?: string): string {
  switch (storeType) {
    case 'restaurant': return 'text-amber-500'
    case 'venue': return 'text-purple-500'
    default: return 'text-primary-500'
  }
}

function getTypeBgColor(storeType?: string): string {
  switch (storeType) {
    case 'restaurant': return 'bg-amber-500/10'
    case 'venue': return 'bg-purple-500/10'
    default: return 'bg-primary-500/10'
  }
}

// Slideover state
const isCreateOpen = ref(false)
const storeToEdit = ref<Partial<Store> & { id?: string } | undefined>(undefined)

// Default storeType based on active tab
const newStoreDefaults = computed((): Pick<Store, 'storeType'> => {
  switch (activeTab.value) {
    case 'restaurant':
      return { storeType: 'restaurant' }
    case 'venue':
      return { storeType: 'venue' }
    default:
      return { storeType: 'store' }
  }
})

function handleAddClick() {
  storeToEdit.value = newStoreDefaults.value
  isCreateOpen.value = true
}

function handleCardClick(store: Store) {
  // Use slug if available, fallback to id
  navigateTo(`/establishments/${store.slug || store.id}`)
}

function onSaved() {
  // Reactive fetch handles refresh
}
</script>

<template>
  <UDashboardPanel id="establishments">
    <template #header>
      <UDashboardNavbar title="Establishments" :ui="{ right: 'gap-3' }">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>

        <template #right>
          <UButton
            v-if="canCreateStores && canAddMoreStores"
            icon="i-lucide-plus"
            label="Add Establishment"
            color="primary"
            @click="handleAddClick"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6 space-y-6">
        <!-- Tab Navigation -->
        <div class="flex gap-2 border-b border-default pb-4">
          <UButton
            v-for="tab in tabs"
            :key="tab.id"
            :icon="tab.icon"
            :label="tab.label"
            :color="activeTab === tab.id ? 'primary' : 'neutral'"
            :variant="activeTab === tab.id ? 'soft' : 'ghost'"
            size="sm"
            @click="activeTab = tab.id"
          />
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <UCard v-for="i in 3" :key="i">
            <div class="flex items-start gap-4">
              <USkeleton class="size-12 rounded-lg" />
              <div class="flex-1 space-y-2">
                <USkeleton class="h-5 w-32" />
                <USkeleton class="h-4 w-48" />
              </div>
            </div>
          </UCard>
        </div>

        <!-- Empty State -->
        <UCard v-else-if="isEmpty" class="text-center py-12">
          <UIcon name="i-lucide-building-2" class="size-16 mx-auto mb-4 text-muted opacity-50" />
          <h3 class="text-lg font-semibold mb-2">
            No {{ activeTab === 'all' ? 'establishments' : activeTab + 's' }} yet
          </h3>
          <p class="text-muted mb-4">
            {{ activeTab === 'restaurant'
              ? 'Add your dining establishment to manage table reservations.'
              : activeTab === 'venue'
                ? 'Add a venue to sell tickets and manage events.'
                : 'Add your first establishment to get started.'
            }}
          </p>
          <UButton
            v-if="canCreateStores && canAddMoreStores"
            icon="i-lucide-plus"
            label="Add Establishment"
            color="primary"
            @click="handleAddClick"
          />
        </UCard>

        <!-- Establishments Grid -->
        <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <UCard
            v-for="store in filteredEstablishments"
            :key="store.id"
            class="cursor-pointer hover:bg-muted/50 transition-colors group"
            @click="handleCardClick(store)"
          >
            <div class="flex items-start gap-4">
              <!-- Icon with type-based styling -->
              <div
                class="shrink-0 size-12 rounded-lg flex items-center justify-center transition-colors"
                :class="getTypeBgColor(store.storeType)"
              >
                <UIcon
                  :name="getTypeIcon(store.storeType)"
                  class="size-6"
                  :class="getTypeColor(store.storeType)"
                />
              </div>

              <div class="flex-1 min-w-0">
                <h3 class="font-semibold truncate group-hover:text-primary transition-colors">
                  {{ store.name }}
                </h3>
                <p class="text-sm text-muted truncate">
                  {{ store.address }}, {{ store.city }}
                </p>
                <div class="flex items-center gap-2 mt-2">
                  <UBadge color="neutral" variant="subtle" size="xs">
                    {{ getTypeLabel(store.storeType) }}
                  </UBadge>
                  <UBadge
                    :color="store.isPublished ? 'success' : 'warning'"
                    variant="subtle"
                    size="xs"
                  >
                    {{ store.isPublished ? 'Live' : 'Draft' }}
                  </UBadge>
                </div>
              </div>

              <!-- Preview Link -->
              <UButton
                icon="i-lucide-eye"
                color="neutral"
                variant="ghost"
                size="xs"
                class="opacity-0 group-hover:opacity-100 transition-opacity"
                :to="`/establishments/${store.slug || store.id}/preview`"
                @click.stop
              />
            </div>
          </UCard>
        </div>
      </div>

      <!-- Store Form Slideover -->
      <StoreFormSlideover
        v-model:open="isCreateOpen"
        :store="storeToEdit"
        @saved="onSaved"
      />
    </template>
  </UDashboardPanel>
</template>
