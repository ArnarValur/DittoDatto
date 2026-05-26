<script setup lang="ts">
import type { TableColumn } from '@nuxt/ui'
import type { Row } from '@tanstack/table-core'
import type { Company } from '@dittodatto/shared-types'
import { h, type Component } from 'vue'
import { UCheckbox, UAvatar, UButton, UBadge, UDropdownMenu } from '#components'
import CompanyFormSlideover from '~/components/companies/CompanyFormSlideover.vue'

definePageMeta({
  layout: 'admin-dashboard'
})

const {
  search, page, pageCount, isFormOpen,
  selectedItem: selectedCompany,
  rows, total, isLoading, refresh, handleCreate
} = useDataTable<Company>('/api/companies/companies')

async function handleDelete(company: Company) {
  try {
    await $fetch('/api/companies/companies', {
      method: 'DELETE',
      query: { id: company.id }
    })

    useToast().add({ title: 'Deleted', description: 'Company deleted successfully.', color: 'success' })
    refresh()
  } catch (error) {
    console.error('Delete error:', error)
    useToast().add({ title: 'Error', description: error as string || 'Failed to delete', color: 'error' })
  }
}

function getRowItems(row: Row<Company>) {
  return [
    { type: 'label', label: 'Actions' },
    {
      label: 'Copy Company ID',
      icon: 'i-lucide-copy',
      onSelect() {
        navigator.clipboard.writeText(row.original.id)
        useToast().add({ title: 'Copied', description: 'ID copied.' })
      }
    },
    { type: 'separator' },
    {
      label: 'View Overview',
      icon: 'i-lucide-file-user',
      disabled: true,
      onSelect: () => navigateTo(`/companies/${row.original.id}`)
    },
    {
      label: 'Edit company',
      icon: 'i-lucide-pencil',
      onSelect: () => {
        selectedCompany.value = row.original
        isFormOpen.value = true
      }
    },
    { type: 'separator' },
    {
      label: 'Delete company',
      icon: 'i-lucide-trash-2',
      class: 'text-red-500 hover:text-red-600',
      onSelect: () => handleDelete(row.original)
    }
  ]
}

const columns: TableColumn<Company>[] = [
  {
    id: 'select',
    header: ({ table }) =>
      h(UCheckbox, {
        'modelValue': table.getIsSomePageRowsSelected() ? 'indeterminate' : table.getIsAllPageRowsSelected(),
        'onUpdate:modelValue': (value: boolean | 'indeterminate') => table.toggleAllPageRowsSelected(!!value),
        'ariaLabel': 'Select all'
      }),
    cell: ({ row }) =>
      h(UCheckbox, {
        'modelValue': row.getIsSelected(),
        'onUpdate:modelValue': (value: boolean | 'indeterminate') => row.toggleSelected(!!value),
        'ariaLabel': 'Select row'
      })
  },
  {
    accessorKey: 'id',
    header: 'ID',
    cell: ({ row }) => h('span', { class: 'font-mono text-xs' }, row.original.id.substring(0, 8) + '...')
  },
  {
    accessorKey: 'name',
    header: 'Name',
    cell: ({ row }) => {
      // Fallback to email if display name is missing
      const name = row.original.name || 'No Name'
      const email = row.original.ownerEmail || 'No Owner Email'

      return h('div', { class: 'flex items-center gap-3' }, [
        h(UAvatar, {
          src: row.original.logoUrl || undefined,
          alt: name,
          size: 'lg'
        }),
        h('div', undefined, [
          h('p', { class: 'font-medium text-highlighted' }, name),
          h('p', { class: 'text-muted text-xs' }, email)
        ])
      ])
    }
  },
  {
    accessorKey: 'ownerEmail',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButton, {
        color: 'neutral',
        variant: 'ghost',
        label: 'Email',
        icon: isSorted ? (isSorted === 'asc' ? 'i-lucide-arrow-up-narrow-wide' : 'i-lucide-arrow-down-wide-narrow') : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    }
  },
  {
    accessorKey: 'phone',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButton, {
        color: 'neutral',
        variant: 'ghost',
        label: 'Phone',
        icon: isSorted ? (isSorted === 'asc' ? 'i-lucide-arrow-up-narrow-wide' : 'i-lucide-arrow-down-wide-narrow') : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    }
  },
  {
    accessorKey: 'tier',
    header: 'Tier',
    filterFn: 'equals',
    cell: ({ row }) => {
      const colour = {
        free: 'warning' as const,
        premium: 'secondary' as const
      }[row.original.tier as string] || 'neutral'

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color: colour }, () => row.original.tier || 'user')
    }
  },
  {
    id: 'actions',
    cell: ({ row }) => {
      return h('div', { class: 'text-right' },
        h(UDropdownMenu as Component, {
          items: getRowItems(row)
        }, {
          default: ({ open: _open }: { open: boolean }) => h(UButton, {
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
  <!-- eslint-disable vue/no-multiple-template-root -->
  <UDashboardPanel id="companies">
    <template #header>
      <UDashboardNavbar>
        <!-- RESTORED: Sidebar Collapse Button -->
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            Companies
          </div>
        </template>

        <!-- Search and Add Company moved to #right slot -->
        <template #right>
          <div class="flex gap-3">
            <UInput
              v-model="search"
              icon="i-lucide-search"
              placeholder="Search companies..."
              class="w-64"
            />
            <UButton
              icon="i-lucide-plus"
              label="Add Company"
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
            <span class="text-gray-500">No companies found</span>
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

  <CompanyFormSlideover
    v-if="isFormOpen"
    v-model:open="isFormOpen"
    :company="selectedCompany"
    @saved="refresh"
  />
</template>
