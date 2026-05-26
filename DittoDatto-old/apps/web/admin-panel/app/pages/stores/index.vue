<script setup lang="ts">
import { h } from 'vue'
import type { TableColumn } from '@nuxt/ui'
import type { Row } from '@tanstack/table-core'
import type { Store, Company } from '@dittodatto/shared-types'
import { UBadge, UButton, UDropdownMenu } from '#components'
import StoreFormSlideover from '~/components/stores/StoreFormSlideover.vue'

definePageMeta({ layout: 'admin-dashboard' })

// Company Filter State ---
const selectedCompany = ref<{ id: string, label: string, tier: 'free' | 'premium' } | undefined>(undefined)

// Helper to clear filter
const clearFilter = () => { selectedCompany.value = undefined }

// Fetch companies for the dropdown (simple list for search)
const { data: companiesData } = await useFetch<{ companies: Company[] }>('/api/companies/companies', {
  lazy: true,
  default: () => ({ companies: [] })
})

const companyOptions = computed(() => companiesData.value.companies.map(c => ({
  id: c.id,
  label: c.name,
  // Add extras for custom display if needed
  tier: c.tier
})))

// Query filter - automatically triggers refresh when selectedCompany changes
const queryFilter = reactive({
  companyId: undefined as string | undefined
})

watch(selectedCompany, (newValue) => {
  queryFilter.companyId = newValue?.id
})

const {
  search, page, pageCount, isFormOpen, selectedItem,
  rows, total, isLoading, refresh, handleCreate
} = useDataTable<Store>('/api/stores/stores', { query: queryFilter })

async function handleDelete(store: Store) {
  if (!confirm(`Are you sure you want to delete store "${store.name}"?`)) return

  try {
    await $fetch('/api/stores/stores', {
      method: 'DELETE',
      body: {
        id: store.id,
        companyId: store.companyId
      }
    })

    useToast().add({ title: 'Deleted', description: 'Store deleted successfully.', color: 'success' })
    refresh()
  } catch (error: any) {
    useToast().add({ title: 'Error', description: error.message || 'Failed to delete', color: 'error' })
  }
}

function getRowItems(row: Row<Store>) {
  return [
    { type: 'label', label: 'Actions' },
    {
      label: 'Copy store ID',
      icon: 'i-lucide-copy',
      onSelect() {
        navigator.clipboard.writeText(row.original.id)
        useToast().add({ title: 'Copied', description: 'ID copied.' })
      }
    },
    { type: 'separator' },
    {
      label: 'View Overview',
      disabled: true,
      icon: 'i-lucide-file-user',
      onSelect: () => navigateTo(`/stores/${row.original.id}`)
    },
    {
      label: 'Edit store',
      icon: 'i-lucide-pencil',
      onSelect: () => {
        selectedItem.value = row.original
        isFormOpen.value = true
      }
    },
    { type: 'separator' },
    {
      label: 'Delete store',
      icon: 'i-lucide-trash-2',
      class: 'text-red-500 hover:text-red-600',
      onSelect: () => handleDelete(row.original)
    }
  ]
}

const columns: TableColumn<Store>[] = [
  {
    accessorKey: 'name',
    header: 'Store Name'
  },
  {
    accessorKey: 'city',
    header: 'City'
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
    cell: ({ row }) => {
      return h('div', { class: 'text-right' },
        h(UDropdownMenu as any, {
          items: getRowItems(row)
        }, {
          default: ({ open }: { open: boolean }) => h(UButton, {
            icon: 'i-lucide-ellipsis-vertical',
            color: 'neutral',
            variant: 'ghost',
            class: 'ml-auto'
          })
        }
        )
      )
    }
  }

]
</script>

<template>
  <UDashboardPanel id="stores">
    <template #header>
      <UDashboardNavbar title="Stores">
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            Stores
          </div>
        </template>

        <template #right>
          <div class="flex gap-2 min-w-0">
            <USelectMenu
              v-model="selectedCompany"
              :items="companyOptions"
              searchable
              searchable-placeholder="Search company..."
              placeholder="All Companies"
              icon="i-lucide-building4"
              class="w-48 lg:w-64"
              option-attribute="label"
            />
          </div>
          <div class="flex gap-3">
            <UInput
              v-model="search"
              icon="i-lucide-search"
              placeholder="Search stores..."
            />
            <UButton
              icon="i-lucide-plus"
              label="Add Store"
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
        class="flex-1 border border-gray-200 dark:border-gray-800"
        :ui="{
          base: 'table-fixed border-separate border-spacing-0',
          thead: '[&>tr]:bg-elevated/50 [&>tr]:after:content-none',
          tbody: '[&>tr]:last:[&>td]:border-b-0',
          th: '',
          td: 'border-b border-default',
          separator: 'h-0'
        }"
      >
        <template #empty>
          <div class="flex flex-col items-center justify-center py-12 gap-3">
            <UIcon
              name="i-lucide-database"
              class="w-12 h-12 text-gray-400"
            />
            <span class="text-gray-500">No stores found</span>
          </div>
        </template>
      </UTable>
    </template>

    <template #footer>
      <div class="flex items-center justify-between px-4 py-3 border-t border-gray-200 dark:border-gray-800">
        <div class="text-sm text-gray-500">
          {{ total }} results
        </div>

        <!--
        -- TODO: Fix UPagination
        -->

        <UPagination
          v-model:page="page"
          :items-per-page="pageCount"
          :total="total"
        />
      </div>
    </template>
  </UDashboardPanel>

  <StoreFormSlideover
    v-model:open="isFormOpen"
    :store="selectedItem"
    @saved="refresh"
  />
</template>
