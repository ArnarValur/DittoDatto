<script setup lang="ts">
/**
 * ServiceGrid
 * Displays services as image cards in a grid layout.
 * Multi-select groups appear as a single group card instead of individual services.
 * Clicking a card emits 'book' to open the booking slideover.
 * Clicking a group card emits 'book-group' to open the slideover pre-expanded.
 */

const { t } = useI18n()

interface ServiceItem {
  id: string
  title: string
  description?: string
  coverImage?: string
  gallery?: string[]
  price: number
  currency: string
  duration: number
  capacity?: number
  bookingMode?: 'standard' | 'tableReservation' | 'ticketSystem'
  groupId?: string
}

interface ServiceGroupItem {
  id: string
  name: string
  sortOrder?: number
  showOnBookingPanel?: boolean
  multiSelect?: boolean
}

const props = defineProps<{
  services: ServiceItem[]
  serviceGroups?: ServiceGroupItem[]
}>()

const emit = defineEmits<{
  (e: 'select', service: ServiceItem): void
  (e: 'book', service: ServiceItem): void
  (e: 'book-group', groupId: string): void
}>()

// Compute display items: individual services + group cards for multiSelect groups
const displayItems = computed(() => {
  const groups = props.serviceGroups ?? []
  const services = props.services ?? []

  // Find multi-select group IDs
  const multiSelectGroupIds = new Set(
    groups.filter(g => g.multiSelect && g.showOnBookingPanel !== false).map(g => g.id)
  )

  const items: Array<
    | { type: 'service'; service: ServiceItem }
    | { type: 'group'; group: ServiceGroupItem; services: ServiceItem[]; coverImage?: string; priceRange: string }
  > = []

  // Add individual services that are NOT in multi-select groups
  for (const service of services) {
    if (!service.groupId || !multiSelectGroupIds.has(service.groupId)) {
      items.push({ type: 'service', service })
    }
  }

  // Add group cards for multi-select groups
  for (const group of groups) {
    if (!multiSelectGroupIds.has(group.id)) continue
    const groupServices = services.filter(s => s.groupId === group.id)
    if (groupServices.length === 0) continue

    // Use first service's cover image as group cover
    const coverImage = groupServices.find(s => s.coverImage)?.coverImage
    const prices = groupServices.map(s => s.price).filter(p => p !== undefined)
    const minPrice = Math.min(...prices)
    const maxPrice = Math.max(...prices)
    const currency = groupServices[0]?.currency || 'NOK'
    const priceRange = minPrice === maxPrice
      ? formatPrice(minPrice, currency)
      : `${formatPrice(minPrice, currency)} – ${formatPrice(maxPrice, currency)}`

    items.push({
      type: 'group',
      group,
      services: groupServices,
      coverImage,
      priceRange,
    })
  }

  return items
})

function handleCardClick(service: ServiceItem) {
  emit('book', service)
}

function handleGroupClick(groupId: string) {
  emit('book-group', groupId)
}

function formatPrice(price: number, currency: string) {
  if (price === 0) return t('establishment.free')
  return new Intl.NumberFormat('nb-NO', {
    style: 'currency',
    currency: currency || 'NOK'
  }).format(price)
}

function formatTimeRange(start?: string, end?: string) {
  if (!start || !end) return ''
  return `${start} - ${end}`
}
</script>

<template>
  <div class="space-y-6">
    <!-- Service Grid -->
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
      <template v-for="item in displayItems" :key="item.type === 'service' ? item.service.id : item.group.id">
        <!-- Individual Service Card -->
        <button
          v-if="item.type === 'service'"
          class="group text-left rounded-xl overflow-hidden bg-card border border-default hover:border-primary transition-all duration-300 hover:shadow-lg hover:shadow-primary/10"
          @click="handleCardClick(item.service)"
        >
          <!-- Cover Image -->
          <div class="aspect-4/3 bg-muted relative overflow-hidden">
            <NuxtImg
              v-if="item.service.coverImage"
              :src="item.service.coverImage"
              :alt="item.service.title"
              class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
              loading="lazy"
              sizes="(max-width: 640px) 50vw, (max-width: 1024px) 33vw, 25vw"
              placeholder
            />
            <div
              v-else
              class="w-full h-full flex items-center justify-center bg-linear-to-br from-primary/20 to-primary/5"
            >
              <UIcon name="i-lucide-briefcase" class="size-12 text-primary/50" />
            </div>
          </div>

          <!-- Card Info -->
          <div class="p-3 space-y-1">
            <h3 class="font-semibold text-sm line-clamp-1 group-hover:text-primary transition-colors">
              {{ item.service.title }}
            </h3>

            <p class="text-sm font-medium" :class="item.service.price === 0 ? 'text-green-500' : 'text-primary'">
              {{ formatPrice(item.service.price, item.service.currency) }}
            </p>
          </div>
        </button>

        <!-- Multi-Select Group Card -->
        <button
          v-else
          class="group text-left rounded-xl overflow-hidden bg-card border border-default hover:border-primary transition-all duration-300 hover:shadow-lg hover:shadow-primary/10 relative"
          @click="handleGroupClick(item.group.id)"
        >
          <!-- Cover Image (collage of first few services) -->
          <div class="aspect-4/3 bg-muted relative overflow-hidden">
            <!-- 2x2 grid of service images -->
            <div v-if="item.services.filter(s => s.coverImage).length >= 4" class="w-full h-full grid grid-cols-2 grid-rows-2">
              <NuxtImg
                v-for="(s, i) in item.services.filter(s => s.coverImage).slice(0, 4)"
                :key="s.id"
                :src="s.coverImage!"
                :alt="s.title"
                class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                loading="lazy"
              />
            </div>
            <!-- Single cover fallback -->
            <NuxtImg
              v-else-if="item.coverImage"
              :src="item.coverImage"
              :alt="item.group.name"
              class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
              loading="lazy"
              sizes="(max-width: 640px) 50vw, (max-width: 1024px) 33vw, 25vw"
              placeholder
            />
            <div
              v-else
              class="w-full h-full flex items-center justify-center bg-linear-to-br from-primary/20 to-primary/5"
            >
              <UIcon name="i-lucide-layers" class="size-12 text-primary/50" />
            </div>

            <!-- Service count badge -->
            <div class="absolute top-2 right-2 bg-black/60 backdrop-blur-sm text-white text-xs font-medium px-2 py-1 rounded-full">
              {{ t('establishment.serviceCount', { count: item.services.length }) }}
            </div>
          </div>

          <!-- Card Info -->
          <div class="p-3 space-y-1">
            <h3 class="font-semibold text-sm line-clamp-1 group-hover:text-primary transition-colors">
              {{ item.group.name }}
            </h3>
            <p class="text-xs text-muted">
              {{ t('establishment.fromPrice', { price: item.priceRange }) }}
            </p>
          </div>
        </button>
      </template>
    </div>

    <!-- Empty State -->
    <div
      v-if="services.length === 0"
      class="text-center py-12 text-muted"
    >
      <UIcon name="i-lucide-briefcase" class="size-12 mx-auto mb-4" />
      <p>No services available yet.</p>
    </div>
  </div>
</template>
