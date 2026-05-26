<script setup lang="ts">
import type { Resource, ResourceGroup } from '@dittodatto/shared-types'

/**
 * ResourceManager
 *
 * Full CRUD interface for managing resources and resource groups
 * within a specific establishment. Used inside the Establishment settings page
 * on the "Resources" tab.
 *
 * Layout:
 * - Header with "Add Group" and "Add Resource" buttons
 * - Resource Groups as collapsible sections
 * - Resources displayed as cards within their groups
 * - Ungrouped resources shown at the bottom
 */

const props = defineProps<{
  storeId: string
  companyId: string
}>()

const { allResources, loading: resourcesLoading, resourcesByStore, resourcesByGroup, fetchResources } = useResources()
const { allResourceGroups, loading: groupsLoading, groupsByStore, fetchGroups } = useResourceGroups()

// Computed: resources and groups for this specific store
const storeGroups = computed(() => groupsByStore(props.storeId))
const storeResources = computed(() => resourcesByStore(props.storeId))

const ungroupedResources = computed(() =>
  storeResources.value.filter(r => !r.resourceGroupId || !storeGroups.value.find(g => g.id === r.resourceGroupId))
)

const loading = computed(() => resourcesLoading.value || groupsLoading.value)

// Collapse state per group
const collapsedGroups = ref<Set<string>>(new Set())

function toggleGroup(groupId: string) {
  if (collapsedGroups.value.has(groupId)) {
    collapsedGroups.value.delete(groupId)
  } else {
    collapsedGroups.value.add(groupId)
  }
}

// Slideover states
const showGroupForm = ref(false)
const editingGroup = ref<(Partial<ResourceGroup> & { id?: string }) | undefined>()

const showResourceForm = ref(false)
const editingResource = ref<(Partial<Resource> & { id?: string }) | undefined>()

function openCreateGroup() {
  editingGroup.value = undefined
  showGroupForm.value = true
}

function openEditGroup(group: ResourceGroup) {
  editingGroup.value = { ...group }
  showGroupForm.value = true
}

function openCreateResource(groupId?: string) {
  editingResource.value = groupId ? { resourceGroupId: groupId } : undefined
  showResourceForm.value = true
}

function openEditResource(resource: Resource) {
  editingResource.value = { ...resource }
  showResourceForm.value = true
}

// After save/delete: close slideover → wait for animation → refetch
async function refreshData() {
  // 1. Close all slideoversfirst
  showGroupForm.value = false
  showResourceForm.value = false

  // 2. Clear editing refs to avoid stale data
  editingGroup.value = undefined
  editingResource.value = undefined

  // 3. Wait for slideover close animation (~300ms) + Firestore propagation
  await new Promise(resolve => setTimeout(resolve, 600))

  // 4. Re-fetch data
  await Promise.all([fetchResources(), fetchGroups()])
}

// Type display helpers
const typeConfig: Record<string, { icon: string; color: string; label: string }> = {
  table: { icon: 'i-lucide-armchair', color: 'text-amber-400', label: 'Table' },
  room: { icon: 'i-lucide-door-open', color: 'text-blue-400', label: 'Room' },
  station: { icon: 'i-lucide-scissors', color: 'text-purple-400', label: 'Station' },
  equipment: { icon: 'i-lucide-monitor', color: 'text-cyan-400', label: 'Equipment' },
  addon: { icon: 'i-lucide-package-plus', color: 'text-emerald-400', label: 'Add-on' },
}

function getTypeConfig(type: string) {
  return typeConfig[type] || { icon: 'i-lucide-box', color: 'text-gray-400', label: type }
}
</script>

<template>
  <div>
    <!-- Header -->
    <div class="flex items-center justify-between mb-6">
      <div>
        <h3 class="text-lg font-semibold">Resources</h3>
        <p class="text-sm text-muted">
          Manage tables, rooms, equipment, and add-ons for this establishment
        </p>
      </div>
      <div class="flex gap-2">
        <UButton
          icon="i-lucide-folder-plus"
          label="Add Group"
          color="neutral"
          variant="outline"
          @click="openCreateGroup"
        />
        <UButton
          icon="i-lucide-plus"
          label="Add Resource"
          color="primary"
          @click="openCreateResource()"
        />
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="space-y-4">
      <USkeleton class="h-16 w-full rounded-lg" />
      <USkeleton class="h-32 w-full rounded-lg" />
      <USkeleton class="h-32 w-full rounded-lg" />
    </div>

    <!-- Empty State -->
    <div
      v-else-if="storeResources.length === 0 && storeGroups.length === 0"
      class="py-16 text-center"
    >
      <UIcon name="i-lucide-boxes" class="size-16 text-muted mx-auto mb-4" />
      <h3 class="text-xl font-semibold mb-2">No resources yet</h3>
      <p class="text-muted mb-6 max-w-md mx-auto">
        Start by creating a resource group (e.g. "Main Dining") and then add individual resources like tables, rooms, or equipment.
      </p>
      <div class="flex gap-3 justify-center">
        <UButton
          icon="i-lucide-folder-plus"
          label="Create First Group"
          color="neutral"
          variant="outline"
          @click="openCreateGroup"
        />
        <UButton
          icon="i-lucide-plus"
          label="Create Resource"
          color="primary"
          @click="openCreateResource()"
        />
      </div>
    </div>

    <!-- Groups & Resources -->
    <div v-else class="space-y-4">
      <!-- Resource Groups -->
      <div
        v-for="group in storeGroups"
        :key="group.id"
        class="rounded-xl border border-default overflow-hidden"
      >
        <!-- Group Header -->
        <button
          type="button"
          class="w-full flex items-center justify-between p-4 bg-muted/30 hover:bg-muted/50 transition-colors"
          @click="toggleGroup(group.id)"
        >
          <div class="flex items-center gap-3">
            <UIcon
              name="i-lucide-chevron-down"
              class="size-4 transition-transform"
              :class="{ '-rotate-90': collapsedGroups.has(group.id) }"
            />
            <div class="text-left">
              <span class="font-semibold">{{ group.name }}</span>
              <span class="text-sm text-muted ml-2">
                ({{ resourcesByGroup(group.id).length }} resources)
              </span>
            </div>
          </div>
          <div class="flex items-center gap-2" @click.stop>
            <UButton
              icon="i-lucide-plus"
              label="Add"
              size="xs"
              color="primary"
              variant="outline"
              @click="openCreateResource(group.id)"
            />
            <UButton
              icon="i-lucide-pencil"
              size="xs"
              color="neutral"
              variant="ghost"
              title="Edit group"
              @click="openEditGroup(group)"
            />
          </div>
        </button>

        <!-- Group Resources -->
        <div v-if="!collapsedGroups.has(group.id)" class="p-4">
          <div
            v-if="resourcesByGroup(group.id).length === 0"
            class="py-6 text-center text-muted text-sm"
          >
            No resources in this group.
            <UButton
              label="Add one"
              variant="link"
              color="primary"
              size="xs"
              @click="openCreateResource(group.id)"
            />
          </div>

          <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
            <button
              v-for="resource in resourcesByGroup(group.id)"
              :key="resource.id"
              type="button"
              class="p-4 rounded-lg border border-default hover:border-primary-500/50 hover:bg-primary-500/5 transition-all text-left"
              @click="openEditResource(resource)"
            >
              <div class="flex items-start justify-between mb-2">
                <div class="flex items-center gap-2">
                  <UIcon
                    :name="getTypeConfig(resource.type).icon"
                    class="size-5"
                    :class="getTypeConfig(resource.type).color"
                  />
                  <span class="font-medium">{{ resource.name }}</span>
                </div>
                <UBadge
                  :color="resource.isBookable ? 'success' : 'neutral'"
                  variant="subtle"
                  size="xs"
                >
                  {{ resource.isBookable ? 'Active' : 'Offline' }}
                </UBadge>
              </div>

              <!-- Meta info -->
              <div class="flex items-center gap-3 text-xs text-muted">
                <span class="flex items-center gap-1">
                  <UIcon :name="getTypeConfig(resource.type).icon" class="size-3" />
                  {{ getTypeConfig(resource.type).label }}
                </span>
                <span v-if="resource.type === 'table' || resource.type === 'room'" class="flex items-center gap-1">
                  <UIcon name="i-lucide-users" class="size-3" />
                  {{ resource.minCapacity }}–{{ resource.maxCapacity }}
                </span>
                <span v-if="resource.type === 'addon' && resource.price" class="flex items-center gap-1">
                  <UIcon name="i-lucide-banknote" class="size-3" />
                  {{ resource.price }} {{ resource.currency || 'NOK' }}
                </span>
                <span v-if="resource.priority !== 'normal'" class="flex items-center gap-1">
                  <UIcon name="i-lucide-signal" class="size-3" />
                  {{ resource.priority }}
                </span>
              </div>
            </button>
          </div>
        </div>
      </div>

      <!-- Ungrouped Resources -->
      <div v-if="ungroupedResources.length > 0" class="rounded-xl border border-default overflow-hidden">
        <div class="p-4 bg-muted/30">
          <span class="font-semibold text-muted">Ungrouped</span>
          <span class="text-sm text-muted ml-2">({{ ungroupedResources.length }})</span>
        </div>
        <div class="p-4">
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
            <button
              v-for="resource in ungroupedResources"
              :key="resource.id"
              type="button"
              class="p-4 rounded-lg border border-default hover:border-primary-500/50 hover:bg-primary-500/5 transition-all text-left"
              @click="openEditResource(resource)"
            >
              <div class="flex items-start justify-between mb-2">
                <div class="flex items-center gap-2">
                  <UIcon
                    :name="getTypeConfig(resource.type).icon"
                    class="size-5"
                    :class="getTypeConfig(resource.type).color"
                  />
                  <span class="font-medium">{{ resource.name }}</span>
                </div>
                <UBadge
                  :color="resource.isBookable ? 'success' : 'neutral'"
                  variant="subtle"
                  size="xs"
                >
                  {{ resource.isBookable ? 'Active' : 'Offline' }}
                </UBadge>
              </div>
              <div class="flex items-center gap-3 text-xs text-muted">
                <span class="flex items-center gap-1">
                  <UIcon :name="getTypeConfig(resource.type).icon" class="size-3" />
                  {{ getTypeConfig(resource.type).label }}
                </span>
                <span v-if="resource.type === 'table' || resource.type === 'room'" class="flex items-center gap-1">
                  <UIcon name="i-lucide-users" class="size-3" />
                  {{ resource.minCapacity }}–{{ resource.maxCapacity }}
                </span>
                <span v-if="resource.type === 'addon' && resource.price" class="flex items-center gap-1">
                  <UIcon name="i-lucide-banknote" class="size-3" />
                  {{ resource.price }} {{ resource.currency || 'NOK' }}
                </span>
              </div>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Slideovers -->
    <ResourcesResourceGroupFormSlideover
      v-model:open="showGroupForm"
      :group="editingGroup"
      :store-id="storeId"
      :company-id="companyId"
      @saved="refreshData"
      @deleted="refreshData"
      @close="() => { showGroupForm = false; editingGroup = undefined }"
    />

    <ResourcesResourceFormSlideover
      v-model:open="showResourceForm"
      :resource="editingResource"
      :store-id="storeId"
      :company-id="companyId"
      :groups="storeGroups"
      @saved="refreshData"
      @deleted="refreshData"
      @close="() => { showResourceForm = false; editingResource = undefined }"
    />
  </div>
</template>
