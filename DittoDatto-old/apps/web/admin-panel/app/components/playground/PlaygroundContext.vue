<script setup lang="ts">
/**
 * PlaygroundContext — Shared Company/Store/Service picker
 * Provides cascading selection for all playground tabs.
 */
import type { Company, Store } from '@dittodatto/shared-types'

const selectedCompany = defineModel<{ id: string, label: string } | undefined>('company')
const selectedStore = defineModel<{ id: string, label: string } | undefined>('store')
const selectedServiceIds = defineModel<string[]>('serviceIds', { default: () => [] })

// Expose derived IDs
const companyId = computed(() => selectedCompany.value?.id || '')
const storeId = computed(() => selectedStore.value?.id || '')

defineExpose({ companyId, storeId })

// ── Fetch companies ───────────────────────────────────────────────────
const { data: companiesData } = await useFetch<{ companies: Company[] }>('/api/companies/companies', {
  lazy: true,
  default: () => ({ companies: [] })
})

const companyOptions = computed(() => companiesData.value.companies.map(c => ({
  id: c.id,
  label: c.name
})))

// ── Fetch stores (filtered by company) ────────────────────────────────
const { data: storesData } = await useFetch<{ stores: Store[] }>('/api/stores/stores', {
  lazy: true,
  query: computed(() => ({ companyId: companyId.value })),
  default: () => ({ stores: [] })
})

const storeOptions = computed(() => storesData.value.stores.map(s => ({
  id: s.id,
  label: s.name
})))

// ── Fetch services (filtered by company + store) ──────────────────────
const services = ref<Array<{ id: string, title: string, duration: number, price: number }>>([])
const loadingServices = ref(false)

const serviceOptions = computed(() =>
  services.value.map(s => ({
    label: `${s.title} (${s.duration}min)`,
    value: s.id
  }))
)

async function fetchServices() {
  if (!companyId.value || !storeId.value) return
  loadingServices.value = true
  try {
    const response = await $fetch('/api/services/services', {
      query: { companyId: companyId.value, storeId: storeId.value }
    }) as { services: any[] }
    services.value = response.services || []
  } catch (e: any) {
    console.error('[PlaygroundContext] Failed to fetch services:', e)
    services.value = []
  } finally {
    loadingServices.value = false
  }
}

// Reset cascading on company change
watch(selectedCompany, () => {
  selectedStore.value = undefined
  services.value = []
  selectedServiceIds.value = []
})

// Fetch services on store change
watch(selectedStore, (val) => {
  services.value = []
  selectedServiceIds.value = []
  if (val?.id && companyId.value) {
    fetchServices()
  }
})
</script>

<template>
  <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
    <UFormField label="Company">
      <USelectMenu
        v-model="selectedCompany"
        :items="companyOptions"
        placeholder="Select company..."
        icon="i-lucide-building-2"
        searchable
      />
    </UFormField>

    <UFormField label="Store">
      <USelectMenu
        v-model="selectedStore"
        :items="storeOptions"
        placeholder="Select store..."
        icon="i-lucide-store"
        searchable
        :disabled="!selectedCompany"
      />
    </UFormField>

    <!-- Services slot — only rendered if parent wants it -->
    <div v-if="$slots.services || serviceOptions.length > 0 || loadingServices" class="sm:col-span-2">
      <slot name="services" :services="services" :service-options="serviceOptions" :loading="loadingServices">
        <UFormField label="Services">
          <div v-if="loadingServices" class="text-sm text-muted">
            Loading services...
          </div>
          <div v-else-if="serviceOptions.length === 0 && selectedStore" class="text-sm text-muted">
            No services found for this store.
          </div>
          <USelectMenu
            v-else-if="serviceOptions.length > 0"
            v-model="selectedServiceIds"
            :items="serviceOptions"
            multiple
            placeholder="Select services..."
            value-key="value"
          />
        </UFormField>
      </slot>
    </div>
  </div>
</template>
