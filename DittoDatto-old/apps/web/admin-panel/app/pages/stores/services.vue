<script setup lang="ts">
import { h } from 'vue'
import type { TableColumn } from '@nuxt/ui'
import type { Row } from '@tanstack/table-core'
import type { Service, Store, Company } from '@dittodatto/shared-types'
import { UBadge, UButton, UDropdownMenu } from '#components'
import ServiceFormSlideover from '~/components/stores/ServiceFormSlideover.vue'

definePageMeta({ layout: 'admin-dashboard' })

// Filters ---
const selectedCompany = ref<{ id: string, label: string } | undefined>(undefined)
const selectedStore = ref<{ id: string, label: string } | undefined>(undefined)

// Lookups for Filters
const { data: companiesData } = await useFetch<{ companies: Company[] }>('/api/companies/companies', {
  lazy: true,
  default: () => ({ companies: [] })
})

const companyOptions = computed(() => companiesData.value.companies.map(c => ({
  id: c.id,
  label: c.name
})))

// Fetch stores based on selected company
const { data: storesData } = await useFetch<{ stores: Store[] }>('/api/stores/stores', {
  lazy: true,
  query: computed(() => ({ companyId: selectedCompany.value?.id })),
  default: () => ({ stores: [] })
})

const storeOptions = computed(() => storesData.value.stores.map(s => ({
  id: s.id,
  label: s.name
})))

// Reactive Query for useDataTable
const queryFilter = reactive({
  companyId: undefined as string | undefined,
  storeId: undefined as string | undefined
})

watch(selectedCompany, (val) => {
  queryFilter.companyId = val?.id
  selectedStore.value = undefined // Reset store filter when company changes
  queryFilter.storeId = undefined
})

watch(selectedStore, (val) => {
  queryFilter.storeId = val?.id
})

// Main Data Table
const {
  search, page, pageCount, isFormOpen, selectedItem,
  rows, total, isLoading, refresh, handleCreate
} = useDataTable<Service & { companyId: string }>('/api/services/services', { query: queryFilter })

// Action handlers
async function handleDelete(service: any) {
  if (!confirm(`Delete service "${service.title}"?`)) return

  try {
    await $fetch('/api/services/services', {
      method: 'DELETE',
      body: {
        id: service.id,
        companyId: service.companyId,
        storeId: service.storeId
      }
    })
    useToast().add({ title: 'Deleted', color: 'success' })
    refresh()
  } catch (error: any) {
    useToast().add({ title: 'Error', description: error.message, color: 'error' })
  }
}

function getRowItems(row: Row<any>) {
  return [
    { type: 'label', label: 'Actions' },
    {
      label: 'Copy ID',
      icon: 'i-lucide-copy',
      onSelect() {
        navigator.clipboard.writeText(row.original.id)
        useToast().add({ title: 'Copied' })
      }
    },
    {
      label: 'Edit Service',
      icon: 'i-lucide-pencil',
      onSelect: () => {
        selectedItem.value = row.original
        isFormOpen.value = true
      }
    },
    { type: 'separator' },
    {
      label: 'Delete Service',
      icon: 'i-lucide-trash-2',
      class: 'text-red-500',
      onSelect: () => handleDelete(row.original)
    }
  ]
}

// Columns
const columns: TableColumn<any>[] = [
  {
    accessorKey: 'title',
    header: 'Service'
  },
  {
    id: 'store',
    header: 'Store',
    cell: ({ row }) => row.original.storeName || row.original.storeId
  },
  {
    accessorKey: 'price',
    header: 'Price',
    cell: ({ row }) => `${row.original.price} ${row.original.currency}`
  },
  {
    accessorKey: 'duration',
    header: 'Duration',
    cell: ({ row }) => `${row.original.duration} min`
  },
  {
    accessorKey: 'isActive',
    header: 'Status',
    cell: ({ row }) => h(UBadge, {
      color: row.original.isActive ? 'success' : 'neutral',
      variant: 'subtle'
    }, () => row.original.isActive ? 'Active' : 'Inactive')
  },
  {
    id: 'actions',
    cell: ({ row }) => h('div', { class: 'text-right' },
      h(UDropdownMenu as any, { items: getRowItems(row) }, {
        default: () => h(UButton, {
          icon: 'i-lucide-ellipsis-vertical',
          color: 'neutral',
          variant: 'ghost'
        })
      })
    )
  }
]
</script>

<template>
  <UDashboardPanel id="services">
    <template #header>
      <UDashboardNavbar title="Service Management">
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            Services
          </div>
        </template>

        <template #right>
          <div class="flex gap-2">
            <!-- Company Filter -->
            <USelectMenu
              v-model="selectedCompany"
              :items="companyOptions"
              searchable
              placeholder="Filter Company"
              icon="i-lucide-building3"
              class="w-48"
            />
            <!-- Store Filter -->
            <USelectMenu
              v-model="selectedStore"
              :items="storeOptions"
              searchable
              placeholder="Filter Store"
              icon="i-lucide-store"
              class="w-48"
              :disabled="!selectedCompany"
            />
          </div>
          <div class="flex gap-3 ml-4">
            <UInput
              v-model="search"
              icon="i-lucide-search"
              placeholder="Search services..."
            />
            <UButton
              icon="i-lucide-plus"
              label="Add Service"
              color="neutral"
              @click="handleCreate"
            />
          </div>
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <UTable
        :columns="columns"
        :data="rows"
        :loading="isLoading"
        class="flex-1 border-t border-gray-200 dark:border-gray-800"
      >
        <template #empty>
          <div class="flex flex-col items-center justify-center py-12 gap-3">
            <UIcon
              name="i-lucide-briefcase"
              class="w-12 h-12 text-gray-400"
            />
            <span class="text-gray-500">No services found</span>
          </div>
        </template>
      </UTable>
    </template>

    <template #footer>
      <div class="flex items-center justify-between px-4 py-3">
        <div class="text-sm text-gray-500">
          {{ total }} results
        </div>
        <UPagination
          v-model:page="page"
          :items-per-page="pageCount"
          :total="total"
        />
      </div>
    </template>
  </UDashboardPanel>

  <ServiceFormSlideover
    v-model:open="isFormOpen"
    :service="selectedItem"
    @saved="refresh"
  />
</template>
