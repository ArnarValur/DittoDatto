<script setup lang="ts">
import type { Service, ServiceGroup } from '@dittodatto/shared-types'

definePageMeta({
  layout: 'dashboard'
})

const { companyId } = useCompany()
const { services, loading, refresh: refreshServices } = useServices()
const { stores } = useStores()
const { isOwner, hasCapability } = useStaffPermissions()

const canEdit = computed(() => isOwner.value || hasCapability('can_manage_services'))

// ─── Store Selector (Bookings pattern) ──────────────────────────────────────
// Always requires a selection — no "All Stores" option
const selectedStoreId = ref<string | null>(null)
const isMultiStore = computed(() => (stores.value?.length ?? 0) > 1)

const storeOptions = computed(() =>
  (stores.value ?? []).map((s) => ({ label: s.name, value: s.id })),
)

// Auto-select first store or restore from localStorage
watch(
  stores,
  (val) => {
    if (!val?.length) return
    const saved = localStorage.getItem('dd_services_storeId')
    if (saved && val.some((s) => s.id === saved)) {
      selectedStoreId.value = saved
    } else {
      selectedStoreId.value = val[0].id
    }
  },
  { immediate: true },
)

// Persist selection
watch(selectedStoreId, (id) => {
  if (id) localStorage.setItem('dd_services_storeId', id)
})

// ─── Groups ─────────────────────────────────────────────────────────────────
const { groups: allGroups, loading: groupsLoading, refresh: refreshGroups } = useServiceGroups()

const groups = computed(() => {
  if (!selectedStoreId.value) return allGroups.value
  return allGroups.value.filter(g => g.storeId === selectedStoreId.value)
})

const selectedGroupId = ref<string | null>(null)

// Reset group filter when store changes
watch(selectedStoreId, () => {
  selectedGroupId.value = null
})

// ─── Slideover states ───────────────────────────────────────────────────────
const isServiceSlideoverOpen = ref(false)
const selectedService = ref<Service | undefined>(undefined)

const isGroupSlideoverOpen = ref(false)
const selectedGroup = ref<ServiceGroup | undefined>(undefined)

// ─── Filtered + Sorted Services ─────────────────────────────────────────────
const filteredServices = computed(() => {
  if (!services.value) return []
  let result = services.value

  // Always filter by store (mandatory selection)
  if (selectedStoreId.value) {
    result = result.filter(s => s.storeId === selectedStoreId.value)
  }

  // Filter by group
  if (selectedGroupId.value !== null) {
    result = result.filter(s => s.groupId === selectedGroupId.value)
  }

  // Sort: sortOrder → title
  return [...result].sort((a, b) => {
    const orderDiff = ((a as any).sortOrder ?? 0) - ((b as any).sortOrder ?? 0)
    if (orderDiff !== 0) return orderDiff
    return (a.title ?? '').localeCompare(b.title ?? '')
  })
})

const isEmpty = computed(() => !loading.value && filteredServices.value.length === 0)

// ─── Service count scoped to current store ──────────────────────────────────
const storeServiceCount = computed(() => {
  if (!services.value || !selectedStoreId.value) return services.value?.length ?? 0
  return services.value.filter(s => s.storeId === selectedStoreId.value).length
})

function getServiceCount(groupId: string) {
  return services.value?.filter(s => s.groupId === groupId).length ?? 0
}

// ─── Actions ────────────────────────────────────────────────────────────────
function openCreateService() {
  selectedService.value = undefined
  isServiceSlideoverOpen.value = true
}

function openEditService(service: Service) {
  selectedService.value = service
  isServiceSlideoverOpen.value = true
}

function openCreateGroup() {
  selectedGroup.value = undefined
  isGroupSlideoverOpen.value = true
}

function openEditGroup(group: ServiceGroup) {
  selectedGroup.value = group
  isGroupSlideoverOpen.value = true
}

function selectGroup(groupId: string | null) {
  selectedGroupId.value = groupId
}

// ─── Reactive refresh (no more window.location.reload!) ─────────────────────
async function onServiceChanged() {
  await refreshServices()
}

function onGroupChanged() {
  refreshGroups()
  isGroupSlideoverOpen.value = false
}

// ─── Format helpers ─────────────────────────────────────────────────────────
const formatPrice = (price: number, currency: string) => {
  return new Intl.NumberFormat('nb-NO', {
    style: 'currency',
    currency: currency || 'NOK'
  }).format(price)
}

const formatDuration = (minutes: number) => {
  if (minutes < 60) return `${minutes} min`
  const hours = Math.floor(minutes / 60)
  const mins = minutes % 60
  return mins > 0 ? `${hours}h ${mins}m` : `${hours}h`
}
</script>

<template>
  <UDashboardPanel id="services">
    <template #header>
      <UDashboardNavbar title="Services" :ui="{ right: 'gap-3' }">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>

        <template #right>
          <UButton
            v-if="canEdit"
            icon="i-lucide-folder-plus"
            label="Add Group"
            color="neutral"
            variant="outline"
            @click="openCreateGroup"
          />
          <UButton
            v-if="canEdit"
            icon="i-lucide-plus"
            label="Add Service"
            color="primary"
            @click="openCreateService"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6 space-y-6">
        <!-- Store Selector (Bookings pattern — mandatory, no "All Stores") -->
        <div v-if="isMultiStore" class="flex items-center gap-2">
          <UIcon name="i-lucide-building-2" class="size-4 text-muted shrink-0" />
          <div class="flex gap-1 flex-wrap">
            <UButton
              v-for="store in storeOptions"
              :key="store.value"
              :label="store.label"
              size="xs"
              :color="selectedStoreId === store.value ? 'primary' : 'neutral'"
              :variant="selectedStoreId === store.value ? 'subtle' : 'ghost'"
              @click="selectedStoreId = store.value"
            />
          </div>
        </div>

        <!-- Group Cards Section -->
        <div v-if="!groupsLoading && groups.length > 0" class="space-y-3">
          <div class="flex items-center justify-between">
            <h3 class="text-sm font-medium text-muted">
              Service Groups
            </h3>
          </div>

          <div class="flex gap-3 overflow-x-auto pb-2">
            <!-- All Services Card -->
            <button
              class="shrink-0 px-4 py-3 rounded-lg border transition-all text-left min-w-[140px]"
              :class="selectedGroupId === null
                ? 'border-primary-500 bg-primary-500/10 ring-1 ring-primary-500'
                : 'border-default bg-default hover:border-primary-500/50'"
              @click="selectGroup(null)"
            >
              <div class="flex items-center gap-2 mb-1">
                <UIcon name="i-lucide-layers" class="size-4" />
                <span class="font-medium">All Services</span>
              </div>
              <p class="text-sm text-muted">
                {{ storeServiceCount }} items
              </p>
            </button>

            <!-- Group Cards -->
            <div
              v-for="group in groups"
              :key="group.id"
              role="button"
              tabindex="0"
              class="shrink-0 px-4 py-3 rounded-lg border transition-all text-left min-w-[140px] group/card relative cursor-pointer outline-none focus-visible:ring-2 focus-visible:ring-primary-500"
              :class="selectedGroupId === group.id
                ? 'border-primary-500 bg-primary-500/10 ring-1 ring-primary-500'
                : 'border-default bg-default hover:border-primary-500/50'"
              @click="selectGroup(group.id)"
              @keydown.enter="selectGroup(group.id)"
              @keydown.space.prevent="selectGroup(group.id)"
            >
              <div class="flex items-center gap-2 mb-1">
                <UIcon name="i-lucide-folder" class="size-4" />
                <span class="font-medium truncate max-w-[120px]">{{ group.name }}</span>
              </div>
              <p class="text-sm text-muted">
                {{ getServiceCount(group.id) }} services
              </p>

              <!-- Edit button on hover -->
              <button
                class="absolute top-2 right-2 p-1 rounded opacity-0 group-hover/card:opacity-100 transition-opacity hover:bg-default focus:opacity-100"
                @click.stop="openEditGroup(group)"
              >
                <UIcon name="i-lucide-settings" class="size-4 text-muted" />
              </button>
            </div>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="space-y-4">
          <UCard v-for="i in 3" :key="i">
            <div class="flex items-center gap-4">
              <USkeleton class="size-10 rounded-lg" />
              <div class="flex-1 space-y-2">
                <USkeleton class="h-5 w-40" />
                <USkeleton class="h-4 w-24" />
              </div>
              <USkeleton class="h-6 w-16" />
            </div>
          </UCard>
        </div>

        <!-- Empty State -->
        <UCard v-else-if="isEmpty" class="text-center py-12">
          <UIcon name="i-lucide-briefcase" class="size-16 mx-auto mb-4 text-muted opacity-50" />
          <h3 class="text-lg font-semibold mb-2">
            {{ selectedGroupId ? 'No services in this group' : 'No services yet' }}
          </h3>
          <p class="text-muted mb-4">
            {{ selectedGroupId ? 'Add services to this group or select a different group.' : 'Add services to your stores to start accepting bookings.' }}
          </p>
          <UButton
            icon="i-lucide-plus"
            label="Add Service"
            color="primary"
            @click="openCreateService"
          />
        </UCard>

        <!-- Services List -->
        <div v-else class="space-y-4">
          <UCard
            v-for="service in filteredServices"
            :key="service.id"
            :class="canEdit ? 'cursor-pointer hover:bg-muted/50 transition-colors' : 'transition-colors'"
            @click="canEdit && openEditService(service)"
          >
            <div class="flex items-center gap-4">
              <!-- Cover Image Thumbnail -->
              <div class="shrink-0 size-12 rounded-lg overflow-hidden bg-primary-500/10 flex items-center justify-center">
                <img
                  v-if="service.coverImage"
                  :src="service.coverImage"
                  :alt="service.title"
                  class="w-full h-full object-cover"
                >
                <UIcon v-else name="i-lucide-briefcase" class="size-5 text-primary-500" />
              </div>
              <div class="flex-1 min-w-0">
                <div class="flex items-center gap-2">
                  <h3 class="font-semibold truncate">
                    {{ service.title }}
                  </h3>
                  <!-- Group badge -->
                  <UBadge
                    v-if="service.groupId && selectedGroupId === null"
                    color="info"
                    variant="subtle"
                    size="xs"
                  >
                    {{ groups.find(g => g.id === service.groupId)?.name || 'Group' }}
                  </UBadge>
                </div>
                <div class="flex items-center gap-3 text-sm text-muted">
                  <span class="flex items-center gap-1">
                    <UIcon name="i-lucide-clock" class="size-4" />
                    {{ formatDuration(service.duration) }}
                  </span>
                  <span v-if="service.bufferTime" class="flex items-center gap-1">
                    <UIcon name="i-lucide-timer" class="size-4" />
                    +{{ service.bufferTime }}m buffer
                  </span>
                </div>
              </div>
              <div class="text-right">
                <p class="font-semibold">
                  {{ formatPrice(service.price, service.currency) }}
                </p>
                <UBadge
                  :color="service.isActive ? 'success' : 'warning'"
                  variant="subtle"
                  size="xs"
                >
                  {{ service.isActive ? 'Active' : 'Inactive' }}
                </UBadge>
              </div>
            </div>
          </UCard>
        </div>
      </div>
    </template>
  </UDashboardPanel>

  <!-- Service Form Slideover -->
  <ServicesServiceFormSlideover
    v-model:open="isServiceSlideoverOpen"
    :service="selectedService"
    @saved="onServiceChanged"
    @deleted="onServiceChanged"
    @close="isServiceSlideoverOpen = false"
  />

  <!-- Service Group Form Slideover -->
  <ServicesServiceGroupFormSlideover
    v-if="selectedStoreId && companyId"
    v-model:open="isGroupSlideoverOpen"
    :group="selectedGroup"
    :store-id="selectedStoreId"
    :company-id="companyId"
    @saved="onGroupChanged"
    @deleted="onGroupChanged"
    @close="isGroupSlideoverOpen = false"
  />
</template>
