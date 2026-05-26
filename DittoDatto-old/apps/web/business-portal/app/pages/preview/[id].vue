<script setup lang="ts">
/**
 * Store Preview Page
 * Shows the public-facing view of a store with real data.
 */

definePageMeta({
  layout: 'visual-preview'
})

const route = useRoute()
const storeIdOrSlug = computed(() => route.params.id as string)

// const { companyId } = useCompany()
const { stores, loading } = useStores()

// Find the current store by ID or slug
const store = computed(() => {
  const param = storeIdOrSlug.value
  return stores.value?.find(s => s.id === param || s.slug === param)
})

// State
const bookingOpen = ref(false)
const activeTab = ref(0)

const tabs = [
  { label: 'Menu / Services' },
  { label: 'About Us' }
]

// Format hours for display
const hoursDisplay = computed(() => {
  if (!store.value?.openingSchedule) return 'Hours not set'
  const today = new Date().toLocaleDateString('en-US', { weekday: 'short' }).toLowerCase().slice(0, 3)
  const schedule = store.value.openingSchedule[today as keyof typeof store.value.openingSchedule]
  if (!schedule?.isOpen) return 'Closed today'
  return `${schedule.open} - ${schedule.close}`
})

// Build restaurant data shape for booking modal
const restaurantData = computed(() => ({
  name: store.value?.name || '',
  address: `${store.value?.address || ''}, ${store.value?.city || ''}`,
  logo: store.value?.images?.logo,
  experiences: [] // TODO: Connect to services
}))

function handleBook() {
  bookingOpen.value = true
}
</script>

<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8 pb-32">
    <!-- Loading State -->
    <div v-if="loading" class="space-y-6">
      <USkeleton class="h-80 w-full rounded-xl" />
      <USkeleton class="h-24 w-full" />
      <USkeleton class="h-48 w-full" />
    </div>

    <!-- Not Found -->
    <div v-else-if="!store" class="text-center py-20">
      <UIcon name="i-lucide-store" class="size-16 text-muted mx-auto mb-4" />
      <h2 class="text-2xl font-bold mb-2">
        Store not found
      </h2>
      <p class="text-muted mb-6">
        This store doesn't exist or you don't have access.
      </p>
      <UButton to="/stores" label="Back to stores" />
    </div>

    <!-- Store Content -->
    <template v-else>
      <!-- 1. Hero Gallery -->
      <DDEstablishmentImageGallery
        :images="store.images.gallery || []"
        :layout-mode="store.coverLayoutMode || 'bento'"
      />

      <!-- 2. Info Bar -->
      <DDEstablishmentInfoBar
        :name="store.name"
        :logo="store.images.logo"
        :address="store.address"
        :city="store.city"
        :hours-display="hoursDisplay"
        @book="handleBook"
        @favorite="() => {}"
        @more="() => {}"
      />

      <!-- 3. Tabs Navigation -->
      <div class="border-b border-default">
        <div class="flex gap-8">
          <button
            v-for="(tab, index) in tabs"
            :key="index"
            class="pb-4 text-sm font-semibold border-b-2 transition-colors duration-200"
            :class="[
              activeTab === index
                ? 'border-primary text-primary'
                : 'border-transparent text-muted hover:text-default'
            ]"
            @click="activeTab = index"
          >
            {{ tab.label }}
          </button>
        </div>
      </div>

      <!-- 4. Tab Content -->
      <div class="min-h-[400px]">
        <!-- Services Tab -->
        <div v-if="activeTab === 0" class="animate-fade-in">
          <h2 class="text-xl font-bold mb-6">
            Menu / Services
          </h2>

          <div v-if="!store.images?.gallery?.length" class="text-center py-12 text-muted">
            <UIcon name="i-lucide-image" class="size-12 mx-auto mb-4" />
            <p>No services configured yet.</p>
            <p class="text-sm">
              Add services in the store management page.
            </p>
          </div>
        </div>

        <!-- About Tab -->
        <div v-else class="animate-fade-in">
          <h2 class="text-xl font-bold mb-6">
            About Us
          </h2>
          <DDEstablishmentAboutSection
            :description="store.about || 'No description available.'"
            :address="store.address"
            :city="store.city"
            :lat="store.gmapCoord?.lat"
            :lng="store.gmapCoord?.lng"
          />
        </div>
      </div>

      <!-- Booking Modal -->
      <DDBookingModal
        v-model:open="bookingOpen"
        :store-name="store.name"
        :store-address="store.address"
        :store-logo="store.images.logo"
        :services="[]"
        :opening-schedule="store.openingSchedule"
      />
    </template>
  </div>
</template>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.4s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
