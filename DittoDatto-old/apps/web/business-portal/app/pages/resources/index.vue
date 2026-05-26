<script setup lang="ts">
/**
 * Resources — Top-level page for managing resources across establishments.
 * Wraps the existing ResourceManager component with a store picker.
 */

definePageMeta({
  layout: 'dashboard',
})

const { companyId } = useCompany()
const { stores } = useStores()

// Store selection
const selectedStoreId = ref<string | null>(null)

// Auto-select first store or restore from localStorage
watch(
  stores,
  (val) => {
    if (!val?.length) return
    const saved = localStorage.getItem('dd_resources_storeId')
    if (saved && val.some((s) => s.id === saved)) {
      selectedStoreId.value = saved
    } else {
      selectedStoreId.value = val[0].id
    }
  },
  { immediate: true },
)

// Persist store selection
watch(selectedStoreId, (id) => {
  if (id) localStorage.setItem('dd_resources_storeId', id)
})

const isMultiStore = computed(() => (stores.value ?? []).length > 1)

const storeOptions = computed(() =>
  (stores.value ?? []).map((s) => ({ label: s.name, value: s.id })),
)

const selectedStoreName = computed(() =>
  (stores.value ?? []).find((s) => s.id === selectedStoreId.value)?.name ?? '',
)
</script>

<template>
  <UDashboardPanel id="resources">
    <template #header>
      <UDashboardNavbar title="Resources">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6">
        <!-- Store picker (multi-store only) -->
        <div v-if="isMultiStore" class="flex items-center gap-2 mb-6">
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

        <!-- ResourceManager (existing component) -->
        <ResourcesResourceManager
          v-if="selectedStoreId && companyId"
          :store-id="selectedStoreId"
          :company-id="companyId"
        />

        <!-- No stores fallback -->
        <div v-else class="py-16 text-center">
          <UIcon name="i-lucide-building-2" class="size-16 text-muted mx-auto mb-4" />
          <h3 class="text-xl font-semibold mb-2">No establishments</h3>
          <p class="text-muted">Create an establishment first to manage resources.</p>
        </div>
      </div>
    </template>
  </UDashboardPanel>
</template>
