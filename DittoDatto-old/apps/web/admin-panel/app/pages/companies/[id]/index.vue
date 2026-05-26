<script setup lang="ts">
// apps/admin-panel/app/pages/companies/[id]

import type { TableColumn } from '@nuxt/ui'
import type { Row } from '@tanstack/table-core'
import type { Company, FirebaseUser } from '@dittodatto/shared-types'
import { upperFirst } from 'scule'
import { getPaginationRowModel } from '@tanstack/table-core'

// Modals

// Define the shape of the data COMING from the API (Firebase structure)

// // TODO: Move to Schema
// interface UserApiResponse {
//   users: FirebaseUser[]
//   pageToken?: string
// }

// Modal State:
const isAddOpen = ref(false)
const isEditOpen = ref(false)
const isDeleteOpen = ref(false)
const selectedCompany = ref<Company | null>(null) // the user on the anvil

definePageMeta({
  layout: 'admin-dashboard'
})

const UAvatar = resolveComponent('UAvatar')
const UButton = resolveComponent('UButton')
const UBadge = resolveComponent('UBadge')
const UDropdownMenu = resolveComponent('UDropdownMenu')
const UCheckbox = resolveComponent('UCheckbox')

// const toast = useAppToast()
const table = useTemplateRef('table')

const columnFilters = ref([{ id: 'email', value: '' }])
const columnVisibility = ref()
const rowSelection = ref({})

// 1. Fetch the data with the correct type wrapper
const { data: response, pending, status, refresh } = await useFetch<Company[]>('/api/companies', {
  lazy: true
})

// 2. Extract the array reactively. If response is null, return empty array.
const data = computed(() => response.value || [])

function getRowItems(row: Row<Company>) {
  return [
    { type: 'label', label: 'Actions' },
    {
      label: 'Copy company ID',
      icon: 'i-lucide-copy',
      onSelect() {
        navigator.clipboard.writeText(row.original.id)
        // toast.add({ title: 'Copied', description: 'ID copied.' })
      }
    },
    { type: 'separator' },
    {
      label: 'View Overview',
      icon: 'i-lucide-file-user',
      onSelect: () => navigateTo(`/companies/${row.original.id}`)
    },
    {
      label: 'Edit company',
      icon: 'i-lucide-pencil',
      onSelect: () => {
        selectedCompany.value = row.original
        isEditOpen.value = true
      }
    },
    { type: 'separator' },
    {
      label: 'Delete company',
      icon: 'i-lucide-trash-2',
      class: 'text-red-500 hover:text-red-600',
      onSelect: () => {
        selectedCompany.value = row.original
        isDeleteOpen.value = true
      }
    }
  ]
}

// 3. Columns mapped to ACTUAL API keys (uid, displayName, photoURL)
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
    header: 'Company name',
    cell: ({ row }) => {
      // Fallback to email if display name is missing
      const name = row.original.name || 'No Name'
      const email = row.original.ownerEmail

      return h('div', { class: 'flex items-center gap-3' }, [
        h(UAvatar, {
          src: row.original.logoUrl || undefined,
          alt: name,
          size: 'lg'
        }),
        h('div', undefined, [
          h('p', { class: 'font-medium text-highlighted' }, name),
          h('p', { class: 'text-muted text-xs' }, email) // Changed to email as handle
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
    accessorKey: 'tier',
    header: 'Tier',
    cell: ({ row }) => {
      return h(UBadge, { class: 'capitalize', variant: 'subtle', color: 'neutral' }, () => row.original.tier || 'owner')
    }
  },
  {
    id: 'actions',
    cell: ({ row }) => {
      return h('div', { class: 'text-right' },
        h(UDropdownMenu, {
          content: { align: 'end' },
          items: getRowItems(row)
        }, () => h(UButton, {
          icon: 'i-lucide-ellipsis-vertical',
          color: 'neutral',
          variant: 'ghost',
          class: 'ml-auto'
        })
        )
      )
    }
  }
]

// ... (Rest of your pagination/filter logic remains mostly valid, ensured email filter uses computed)

const email = computed({
  get: (): string => (table.value?.tableApi?.getColumn('ownerEmail')?.getFilterValue() as string) || '',
  set: (value: string) => table.value?.tableApi?.getColumn('ownerEmail')?.setFilterValue(value || undefined)
})
</script>

<template>
  <div class="flex flex-col gap-4">
    <UTable
      ref="table"
      :data="data"
      :columns="columns"
      :column-filters="columnFilters"
      :column-visibility="columnVisibility"
      :row-selection="rowSelection"
      :pagination-row-model="getPaginationRowModel()"
    />
  </div>
</template>
