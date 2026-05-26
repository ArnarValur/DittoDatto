<script setup lang="ts">
import type { StaffMember } from '@dittodatto/shared-types'

definePageMeta({
  layout: 'dashboard',
})

const {
  staff,
  stats,
  loading,
  isEmpty,
  statusFilter,
  storeFilter,
  searchQuery,
} = useStaff()
const { stores } = useStores()
const { isOwner, hasCapability } = useStaffPermissions()

const canManageStaff = computed(() => isOwner.value || hasCapability('can_manage_staff'))

// Invite slideover state (create only)
const showSlideover = ref(false)

function openCreate() {
  showSlideover.value = true
}

function onSaved() {
  showSlideover.value = false
}

// Navigate to detail page
function openDetail(member: StaffMember) {
  navigateTo(`/staff/${member.id}`)
}

// Status tabs
const statusTabs = computed(() => [
  { label: 'All', value: 'all' as const, count: stats.value.total },
  { label: 'Active', value: 'active' as const, count: stats.value.active },
  { label: 'Invited', value: 'invited' as const, count: stats.value.invited },
])

// Store filter options
const storeFilterOptions = computed(() => [
  { label: 'All Stores', value: null },
  ...(stores.value ?? []).map((s) => ({ label: s.name, value: s.id })),
])

// Status badge colors
const statusColors: Record<string, 'success' | 'info' | 'warning' | 'error' | 'neutral'> = {
  active: 'success',
  invited: 'info',
  suspended: 'warning',
  removed: 'error',
}

// Resolve store names for display
function getStoreNames(storeIds: string[]): string {
  if (!storeIds?.length) return 'No stores assigned'
  return storeIds
    .map((id) => stores.value?.find((s) => s.id === id)?.name ?? id)
    .join(', ')
}
</script>

<template>
  <UDashboardPanel id="staff">
    <template #header>
      <UDashboardNavbar title="Staff" :ui="{ right: 'gap-3' }">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>

        <template #right>
          <UButton
            v-if="canManageStaff"
            icon="i-lucide-user-plus"
            label="Invite Staff"
            color="primary"
            @click="openCreate"
          />
        </template>
      </UDashboardNavbar>

      <!-- Toolbar: Stats + Filters -->
      <UDashboardToolbar v-if="!loading && !isEmpty">
        <template #left>
          <div class="flex items-center gap-4 text-sm">
            <span class="flex items-center gap-1.5">
              <UIcon name="i-lucide-users" class="size-4 text-primary-500" />
              <span class="font-medium">{{ stats.total }}</span>
              <span class="text-muted">Total</span>
            </span>
            <span class="flex items-center gap-1.5">
              <UIcon name="i-lucide-user-check" class="size-4 text-success-500" />
              <span class="font-medium">{{ stats.active }}</span>
              <span class="text-muted">Active</span>
            </span>
            <span v-if="stats.invited > 0" class="flex items-center gap-1.5">
              <UIcon name="i-lucide-mail" class="size-4 text-info-500" />
              <span class="font-medium">{{ stats.invited }}</span>
              <span class="text-muted">Invited</span>
            </span>
          </div>
        </template>

        <template #right>
          <USelectMenu
            :model-value="storeFilterOptions.find((o) => o.value === storeFilter)"
            :items="storeFilterOptions"
            value-attribute="value"
            option-attribute="label"
            class="w-40"
            @update:model-value="(val: any) => (storeFilter = val?.value ?? null)"
          />
          <UButton
            v-if="stats.archived > 0"
            icon="i-lucide-archive"
            :label="`Archive (${stats.archived})`"
            color="neutral"
            variant="ghost"
            size="sm"
            to="/staff/archive"
          />
        </template>
      </UDashboardToolbar>
    </template>

    <template #body>
      <div class="p-6">
        <!-- Loading State -->
        <div v-if="loading" class="space-y-4">
          <UCard v-for="i in 4" :key="i">
            <div class="flex items-center gap-4">
              <USkeleton class="size-12 rounded-full" />
              <div class="flex-1 space-y-2">
                <USkeleton class="h-5 w-48" />
                <USkeleton class="h-4 w-32" />
              </div>
              <USkeleton class="h-6 w-20" />
            </div>
          </UCard>
        </div>

        <!-- Empty State -->
        <UCard v-else-if="isEmpty" class="text-center py-12">
          <UIcon
            name="i-lucide-users"
            class="size-16 mx-auto mb-4 text-muted opacity-50"
          />
          <h3 class="text-lg font-semibold mb-2">No staff members yet</h3>
          <p class="text-muted mb-6">
            Invite your team members to manage bookings, services, and more.
          </p>
          <UButton
            label="Invite your first team member"
            icon="i-lucide-user-plus"
            color="primary"
            @click="openCreate"
          />
        </UCard>

        <!-- Staff List -->
        <div v-else class="space-y-4">
          <!-- Search + Tab Filters -->
          <div class="flex flex-col sm:flex-row items-start sm:items-center gap-3">
            <UInput
              v-model="searchQuery"
              placeholder="Search by name, email, or position..."
              icon="i-lucide-search"
              class="w-full sm:w-80"
            />
            <div class="flex gap-1">
              <UButton
                v-for="tab in statusTabs"
                :key="tab.value"
                :label="`${tab.label} (${tab.count})`"
                size="sm"
                :color="statusFilter === tab.value ? 'primary' : 'neutral'"
                :variant="statusFilter === tab.value ? 'solid' : 'ghost'"
                @click="statusFilter = tab.value"
              />
            </div>
          </div>

          <!-- Staff Cards -->
          <div class="space-y-3">
            <UCard
              v-for="member in staff"
              :key="member.id"
              class="cursor-pointer hover:bg-muted/50 transition-colors group"
              @click="openDetail(member)"
            >
              <div class="flex items-center gap-4">
                <!-- Avatar -->
                <UAvatar
                  :src="member.avatarUrl"
                  :alt="member.displayName"
                  size="lg"
                  :icon="'i-lucide-user'"
                />

                <!-- Info -->
                <div class="flex-1 min-w-0">
                  <div class="flex items-center gap-2">
                    <h4 class="font-semibold truncate">
                      {{ member.displayName }}
                    </h4>
                    <UBadge
                      :color="statusColors[member.status] || 'neutral'"
                      variant="subtle"
                      size="xs"
                      class="capitalize"
                    >
                      {{ member.status }}
                    </UBadge>
                  </div>
                  <p class="text-sm text-muted truncate">
                    {{ member.email }}
                    <span v-if="member.position"> · {{ member.position }}</span>
                  </p>
                  <div class="flex items-center gap-2 mt-1">
                    <span class="text-xs text-muted flex items-center gap-1">
                      <UIcon name="i-lucide-store" class="size-3" />
                      {{ getStoreNames(member.storeIds) }}
                    </span>
                  </div>
                </div>

                <!-- Right side: capabilities count + bookable -->
                <div class="text-right shrink-0 space-y-1">
                  <UIcon name="i-lucide-chevron-right" class="size-4 text-muted opacity-0 group-hover:opacity-100 transition-opacity" />
                  <UBadge
                    v-if="member.isBookable"
                    color="primary"
                    variant="subtle"
                    size="xs"
                  >
                    <UIcon name="i-lucide-calendar-check" class="size-3 mr-1" />
                    Bookable
                  </UBadge>
                  <p class="text-xs text-muted">
                    {{ member.defaultCapabilities?.length ?? 0 }} permissions
                  </p>
                </div>
              </div>
            </UCard>
          </div>

          <!-- No results from filters -->
          <div
            v-if="staff.length === 0 && !isEmpty"
            class="text-center py-8 text-muted"
          >
            <UIcon name="i-lucide-search-x" class="size-10 mx-auto mb-2 opacity-50" />
            <p>No staff members match your filters.</p>
          </div>
        </div>
      </div>
    </template>
  </UDashboardPanel>

  <!-- Invite Slideover (create only, no edit) -->
  <StaffFormSlideover
    v-model:open="showSlideover"
    @saved="onSaved"
    @close="showSlideover = false"
  />
</template>
