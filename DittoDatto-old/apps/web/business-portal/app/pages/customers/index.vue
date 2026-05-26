<script setup lang="ts">
import type { TableColumn } from '@nuxt/ui'
import { upperFirst } from 'scule'
import { getPaginationRowModel } from '@tanstack/table-core'
import type { Row } from '@tanstack/table-core'
import type { Customer } from '@dittodatto/shared-types'

definePageMeta({
  layout: 'dashboard'
})

const UAvatar = resolveComponent('UAvatar')
const UButton = resolveComponent('UButton')
const UBadge = resolveComponent('UBadge')
const UDropdownMenu = resolveComponent('UDropdownMenu')
const UCheckbox = resolveComponent('UCheckbox')

const toast = useToast()
const table = useTemplateRef('table')

const columnFilters = ref([{
  id: 'email',
  value: ''
}])
const columnVisibility = ref()
const rowSelection = ref({})

// We use the new composable instead of mock data
const {
  customers: data,
  loading,
  storeFilter,
  statusFilter,
  searchQuery,
  storeOptions,
  isMultiStore,
  customerCountForStore,
  totalCustomerCount,
} = useCustomers()

// ---- Customer Detail Slideover ----
const selectedCustomer = ref<Customer | null>(null)
const detailSlideoverOpen = ref(false)

function openCustomerDetail(customer: Customer) {
  selectedCustomer.value = customer
  detailSlideoverOpen.value = true
}

// ---- New Appointment Modal ----
const newAppointmentOpen = ref(false)

function getRowItems(row: Row<Customer>) {
  return [
    {
      type: 'label',
      label: 'Actions'
    },
    {
      label: 'Copy customer ID',
      icon: 'i-lucide-copy',
      onSelect() {
        navigator.clipboard.writeText(row.original.id.toString())
        toast.add({
          title: 'Copied to clipboard',
          description: 'Customer ID copied to clipboard'
        })
      }
    },
    {
      type: 'separator'
    },
    {
      label: 'View customer details',
      icon: 'i-lucide-list',
      onSelect() {
        openCustomerDetail(row.original)
      }
    },
    {
      label: 'New appointment',
      icon: 'i-lucide-calendar-plus',
      onSelect() {
        selectedCustomer.value = row.original
        newAppointmentOpen.value = true
      }
    },
    {
      label: 'View customer payments',
      icon: 'i-lucide-wallet'
    },
    {
      type: 'separator'
    },
    {
      label: 'Delete customer',
      icon: 'i-lucide-trash',
      color: 'error',
      onSelect() {
        toast.add({
          title: 'Customer deleted',
          description: 'The customer has been deleted.'
        })
      }
    }
  ]
}

const statusColor: Record<string, string> = {
  active: 'success',
  inactive: 'error',
  new: 'neutral',
}

const columns: TableColumn<Customer>[] = [
  {
    id: 'select',
    header: ({ table }) =>
      h(UCheckbox, {
        'modelValue': table.getIsSomePageRowsSelected()
          ? 'indeterminate'
          : table.getIsAllPageRowsSelected(),
        'onUpdate:modelValue': (value: boolean | 'indeterminate') =>
          table.toggleAllPageRowsSelected(!!value),
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
    cell: ({ row }) => {
      // Show row number instead of raw Firestore ID
      return row.index + 1
    }
  },
  {
    accessorKey: 'name',
    header: 'Name',
    cell: ({ row }) => {
      const name = row.original.name || 'Unknown'
      const initials = name.substring(0, 2).toUpperCase()
      // Generate @handle from name (lowercase, no spaces)
      const handle = '@' + name.replace(/\s+/g, '').substring(0, 20)
      return h('div', { class: 'flex items-center gap-3' }, [
        h(UAvatar, {
          text: initials,
          size: 'lg',
        }),
        h('div', undefined, [
          h('p', { class: 'font-medium text-highlighted' }, name),
          h('p', { class: 'text-xs text-muted' }, handle)
        ])
      ])
    }
  },
  {
    accessorKey: 'email',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButton, {
        color: 'neutral',
        variant: 'ghost',
        label: 'Email',
        icon: isSorted
          ? isSorted === 'asc'
            ? 'i-lucide-arrow-up-narrow-wide'
            : 'i-lucide-arrow-down-wide-narrow'
          : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    },
    cell: ({ row }) => row.original.email || 'No email'
  },
  {
    id: 'visits',
    header: 'Visits',
    cell: ({ row }) => {
      const visits = row.original.totalVisits || 0
      return h('span', { class: 'font-medium tabular-nums' }, visits)
    }
  },
  {
    id: 'status',
    header: 'Status',
    cell: ({ row }) => {
      const status = (row.original as any).status || 'new'
      const label = status.charAt(0).toUpperCase() + status.slice(1)
      return h(UBadge, {
        color: statusColor[status] || 'neutral',
        variant: 'subtle',
        label,
      })
    }
  },
  {
    id: 'actions',
    cell: ({ row }) => {
      return h(
        'div',
        { class: 'text-right' },
        h(
          UDropdownMenu,
          {
            content: {
              align: 'end'
            },
            items: getRowItems(row)
          },
          () =>
            h(UButton, {
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

// Handlers for Filters are now all inside `useCustomers`
const pagination = ref({
  pageIndex: 0,
  pageSize: 10
})

function setStoreFilter(storeId: string | null) {
  storeFilter.value = storeId
}
</script>

<template>
  <UDashboardPanel id="customers">
    <template #header>
      <UDashboardNavbar title="Customers">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>

        <template #right>
          <!-- Customers are imported automatically; manual addition removed by design -->
        </template>
      </UDashboardNavbar>

      <UDashboardToolbar>
        <template #left>
          <!-- Search -->
          <UInput
            v-model="searchQuery"
            class="max-w-sm"
            icon="i-lucide-search"
            placeholder="Search name, phone, email..."
          />
        </template>

        <template #right>
          <div class="flex flex-wrap items-center gap-1.5">
            <!-- Batched Delete -->
            <CustomersDeleteModal :count="table?.tableApi?.getFilteredSelectedRowModel().rows.length">
              <UButton
                v-if="table?.tableApi?.getFilteredSelectedRowModel().rows.length"
                label="Delete"
                color="error"
                variant="subtle"
                icon="i-lucide-trash"
              >
                <template #trailing>
                  <UKbd>
                    {{ table?.tableApi?.getFilteredSelectedRowModel().rows.length }}
                  </UKbd>
                </template>
              </UButton>
            </CustomersDeleteModal>

            <!-- Status Filter -->
            <USelect
              v-model="statusFilter"
              :items="[
                { label: 'All Statuses', value: 'all' },
                { label: 'Active', value: 'active' },
                { label: 'New', value: 'new' },
                { label: 'Inactive', value: 'inactive' }
              ]"
              :ui="{ trailingIcon: 'group-data-[state=open]:rotate-180 transition-transform duration-200' }"
              placeholder="Filter status"
              class="min-w-36"
            />

            <!-- Column Display Toggles -->
            <UDropdownMenu
              :items="
                table?.tableApi
                  ?.getAllColumns()
                  .filter((column: any) => column.getCanHide())
                  .map((column: any) => ({
                    label: upperFirst(column.id),
                    type: 'checkbox' as const,
                    checked: column.getIsVisible(),
                    onUpdateChecked(checked: boolean) {
                      table?.tableApi?.getColumn(column.id)?.toggleVisibility(!!checked)
                    },
                    onSelect(e?: Event) {
                      e?.preventDefault()
                    }
                  }))
              "
              :content="{ align: 'end' }"
            >
              <UButton
                label="Display"
                color="neutral"
                variant="outline"
                trailing-icon="i-lucide-settings-2"
              />
            </UDropdownMenu>
          </div>
        </template>
      </UDashboardToolbar>
    </template>

    <template #body>
      <!-- Store Selector Tabs (Services page pattern) -->
      <div v-if="isMultiStore" class="px-6 pt-4 flex items-center gap-2">
        <UIcon name="i-lucide-building-2" class="size-4 text-muted shrink-0" />
        <div class="flex gap-1 flex-wrap">
          <UButton
            label="All"
            size="xs"
            :color="storeFilter === null ? 'primary' : 'neutral'"
            :variant="storeFilter === null ? 'subtle' : 'ghost'"
            @click="setStoreFilter(null)"
          >
            <template #trailing>
              <UBadge :label="String(totalCustomerCount)" size="xs" color="neutral" variant="subtle" />
            </template>
          </UButton>
          <UButton
            v-for="store in storeOptions"
            :key="store.value"
            :label="store.label"
            size="xs"
            :color="storeFilter === store.value ? 'primary' : 'neutral'"
            :variant="storeFilter === store.value ? 'subtle' : 'ghost'"
            @click="setStoreFilter(store.value)"
          >
            <template #trailing>
              <UBadge :label="String(customerCountForStore(store.value))" size="xs" color="neutral" variant="subtle" />
            </template>
          </UButton>
        </div>
      </div>

      <UTable
        ref="table"
        v-model:column-filters="columnFilters"
        v-model:column-visibility="columnVisibility"
        v-model:row-selection="rowSelection"
        v-model:pagination="pagination"
        :pagination-options="{
          getPaginationRowModel: getPaginationRowModel()
        }"
        class="shrink-0"
        :data="data"
        :columns="columns"
        :loading="loading"
        :ui="{
          base: 'table-fixed border-separate border-spacing-0',
          thead: '[&>tr]:bg-elevated/50 [&>tr]:after:content-none',
          tbody: '[&>tr]:last:[&>td]:border-b-0',
          th: 'py-2 first:rounded-l-lg last:rounded-r-lg border-y border-default first:border-l last:border-r',
          td: 'border-b border-default',
          separator: 'h-0'
        }"
      />

      <div class="px-4 py-3 sm:px-6 flex items-center justify-between gap-3 border-t border-default mt-auto">
        <div class="text-sm text-muted">
          {{ table?.tableApi?.getFilteredSelectedRowModel().rows.length || 0 }} of
          {{ table?.tableApi?.getFilteredRowModel().rows.length || 0 }} row(s) selected.
        </div>

        <div class="flex items-center gap-1.5">
          <UPagination
            v-if="table?.tableApi?.getFilteredRowModel().rows.length"
            :default-page="(table?.tableApi?.getState().pagination.pageIndex || 0) + 1"
            :items-per-page="table?.tableApi?.getState().pagination.pageSize || 10"
            :total="table?.tableApi?.getFilteredRowModel().rows.length || 0"
            @update:page="(p: number) => table?.tableApi?.setPageIndex(p - 1)"
          />
        </div>
      </div>
    </template>
  </UDashboardPanel>

  <!-- Customer Detail Slideover -->
  <CustomersCustomerDetailSlideover
    v-model:open="detailSlideoverOpen"
    :customer="selectedCustomer"
  />

  <!-- New Appointment Modal -->
  <CustomersCustomerNewAppointmentModal
    v-model:open="newAppointmentOpen"
    :customer="selectedCustomer"
  />
</template>
