<script setup lang="ts">
import { h, type Component } from 'vue'
import type { TableColumn } from '@nuxt/ui'
import type { Row } from '@tanstack/table-core'
import type { Booking, Company, Store } from '@dittodatto/shared-types'
import { UBadge, UButton, UDropdownMenu } from '#components'
import BookingDetailSlideover from '~/components/bookings/BookingDetailSlideover.vue'

definePageMeta({ layout: 'admin-dashboard' })

// ── Filters ────────────────────────────────────────────────────────────
const selectedCompany = ref<{ id: string, label: string } | undefined>(undefined)
const selectedStore = ref<{ id: string, label: string } | undefined>(undefined)
const selectedStatus = ref<{ id: string, label: string } | undefined>(undefined)

// Company dropdown
const { data: companiesData } = await useFetch<{ companies: Company[] }>('/api/companies/companies', {
  lazy: true,
  default: () => ({ companies: [] })
})

const companyOptions = computed(() => companiesData.value.companies.map(c => ({
  id: c.id,
  label: c.name
})))

// Store dropdown (cascading from company)
const { data: storesData } = await useFetch<{ stores: Store[] }>('/api/stores/stores', {
  lazy: true,
  query: computed(() => ({ companyId: selectedCompany.value?.id })),
  default: () => ({ stores: [] })
})

const storeOptions = computed(() => storesData.value.stores.map(s => ({
  id: s.id,
  label: s.name
})))

// Status dropdown
const statusOptions = [
  { id: 'confirmed', label: 'Confirmed' },
  { id: 'pending', label: 'Pending' },
  { id: 'completed', label: 'Completed' },
  { id: 'cancelled', label: 'Cancelled' },
  { id: 'no-show', label: 'No-show' }
]

// Reactive query filter for useDataTable
const queryFilter = reactive({
  companyId: undefined as string | undefined,
  storeId: undefined as string | undefined,
  status: undefined as string | undefined
})

watch(selectedCompany, (val) => {
  queryFilter.companyId = val?.id
  selectedStore.value = undefined
  queryFilter.storeId = undefined
})

watch(selectedStore, (val) => {
  queryFilter.storeId = val?.id
})

watch(selectedStatus, (val) => {
  queryFilter.status = val?.id
})

// ── Data Table ─────────────────────────────────────────────────────────
type BookingRow = Booking & { storeName?: string, companyName?: string }

const {
  search, page, pageCount,
  rows, total, isLoading, refresh
} = useDataTable<BookingRow>('/api/bookings/bookings', {
  query: queryFilter,
  transform: (response: any) => ({
    items: response.bookings || [],
    total: response.total || 0
  })
})

// ── Detail Slideover ───────────────────────────────────────────────────
const isDetailOpen = ref(false)
const selectedBooking = ref<BookingRow | null>(null)

function viewBooking(booking: BookingRow) {
  selectedBooking.value = booking
  isDetailOpen.value = true
}

// ── Helpers ────────────────────────────────────────────────────────────
const statusColorMap: Record<string, 'success' | 'warning' | 'info' | 'error' | 'neutral'> = {
  confirmed: 'success',
  pending: 'warning',
  completed: 'info',
  cancelled: 'error',
  'no-show': 'error'
}

function formatTime(iso: string) {
  if (!iso) return '—'
  const d = new Date(iso)
  return d.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' })
}

function formatDate(iso: string) {
  if (!iso) return '—'
  const d = new Date(iso)
  return d.toLocaleDateString('en-GB', { month: 'short', day: 'numeric', year: 'numeric' })
}

function getRowItems(row: Row<BookingRow>) {
  return [
    { type: 'label' as const, label: 'Actions' },
    {
      label: 'View Details',
      icon: 'i-lucide-eye',
      onSelect: () => viewBooking(row.original)
    },
    {
      label: 'Copy Booking ID',
      icon: 'i-lucide-copy',
      onSelect() {
        navigator.clipboard.writeText(row.original.id)
        useToast().add({ title: 'Copied', description: 'Booking ID copied.' })
      }
    },
    {
      label: 'Copy Payment ID',
      icon: 'i-lucide-credit-card',
      onSelect() {
        navigator.clipboard.writeText(row.original.paymentId || '')
        useToast().add({ title: 'Copied', description: 'Payment ID copied.' })
      }
    }
  ]
}

// ── Table Columns ──────────────────────────────────────────────────────
const columns: TableColumn<BookingRow>[] = [
  {
    accessorKey: 'serviceTitle',
    header: 'Service',
    cell: ({ row }) => h('div', { class: 'flex flex-col' }, [
      h('span', { class: 'font-medium' }, row.original.serviceTitle || '—'),
      h('span', { class: 'text-xs text-gray-400' }, `${row.original.duration || 0} min`)
    ])
  },
  {
    id: 'customer',
    header: 'Customer',
    cell: ({ row }) => h('div', { class: 'flex flex-col' }, [
      h('span', { class: 'font-medium text-sm' }, row.original.userName || '—'),
      h('span', { class: 'text-xs text-gray-400' }, row.original.userEmail || '')
    ])
  },
  {
    id: 'dateTime',
    header: 'Date & Time',
    cell: ({ row }) => h('div', { class: 'flex flex-col' }, [
      h('span', { class: 'font-medium text-sm' }, formatDate(row.original.startTime)),
      h('span', { class: 'text-xs text-gray-400' },
        `${formatTime(row.original.startTime)} – ${formatTime(row.original.endTime)}`)
    ])
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => h(UBadge, {
      color: statusColorMap[row.original.status] || 'neutral',
      variant: 'subtle',
      class: 'capitalize'
    }, () => row.original.status)
  },
  {
    id: 'price',
    header: 'Price',
    cell: ({ row }) => {
      const price = row.original.priceAtTimeOfBooking
      const currency = row.original.currency
      return h('span', { class: 'text-sm' }, price != null ? `${price} ${currency || ''}` : '—')
    }
  },
  {
    id: 'store',
    header: 'Store',
    cell: ({ row }) => h('span', { class: 'text-sm' },
      (row.original as any).storeName || row.original.storeId?.substring(0, 8) + '...')
  },
  {
    id: 'actions',
    cell: ({ row }) => h('div', { class: 'text-right' },
      h(UDropdownMenu as Component, { items: getRowItems(row) }, {
        default: () => h(UButton, {
          icon: 'i-lucide-ellipsis-vertical',
          color: 'neutral',
          variant: 'ghost',
          class: 'ml-auto'
        })
      })
    )
  }
]
</script>

<template>
  <UDashboardPanel id="bookings">
    <template #header>
      <UDashboardNavbar>
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            Bookings
          </div>
        </template>

        <template #right>
          <div class="flex gap-2">
            <!-- Company Filter -->
            <USelectMenu
              v-model="selectedCompany"
              :items="companyOptions"
              searchable
              placeholder="All Companies"
              icon="i-lucide-building-2"
              class="w-44"
            />
            <!-- Store Filter -->
            <USelectMenu
              v-model="selectedStore"
              :items="storeOptions"
              searchable
              placeholder="All Stores"
              icon="i-lucide-store"
              class="w-44"
              :disabled="!selectedCompany"
            />
            <!-- Status Filter -->
            <USelectMenu
              v-model="selectedStatus"
              :items="statusOptions"
              placeholder="All Statuses"
              icon="i-lucide-filter"
              class="w-40"
            />
          </div>
          <div class="flex gap-3 ml-4">
            <UInput
              v-model="search"
              icon="i-lucide-search"
              placeholder="Search bookings..."
              class="w-64"
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
          td: 'border-b border-default',
          separator: 'h-0'
        }"
      >
        <template #empty>
          <div class="flex flex-col items-center justify-center py-12 gap-3">
            <UIcon
              name="i-lucide-calendar-x"
              class="w-12 h-12 text-gray-400"
            />
            <span class="text-gray-500">No bookings found</span>
            <span v-if="!selectedCompany" class="text-xs text-gray-400">Select a company to view bookings</span>
          </div>
        </template>
      </UTable>
    </template>

    <template #footer>
      <div class="flex items-center justify-between px-4 py-3 border-t border-gray-200 dark:border-gray-800">
        <div class="text-sm text-gray-500">
          {{ total }} {{ total === 1 ? 'booking' : 'bookings' }}
        </div>

        <UPagination
          v-model:page="page"
          :items-per-page="pageCount"
          :total="total"
        />
      </div>
    </template>
  </UDashboardPanel>

  <BookingDetailSlideover
    v-model:open="isDetailOpen"
    :booking="selectedBooking"
  />
</template>
