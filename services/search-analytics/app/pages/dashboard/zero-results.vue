<script setup lang="ts">
import { h, resolveComponent } from 'vue'
import { useSearchAnalytics, type ZeroResultQuery } from '~/composables/useSearchAnalytics'
import type { TableColumn } from '@nuxt/ui'

definePageMeta({
  title: 'Zero-Results',
  layout: 'dashboard'
})

const { zeroResultQueries, isLoading } = useSearchAnalytics()

const UIcon = resolveComponent('UIcon')
const UButton = resolveComponent('UButton')

const zeroResultColumns: TableColumn<ZeroResultQuery>[] = [
  {
    accessorKey: 'query',
    header: 'Unmet Demand Query',
    cell: ({ row }) => {
      return h('span', { class: 'font-medium text-gray-900 dark:text-white' }, row.getValue('query') as string)
    }
  },
  { accessorKey: 'count', header: 'Total Failed Searches (30d)' },
  { accessorKey: 'lastSeen', header: 'Last Seen Date' }
]
</script>

<template>
  <div class="flex flex-col gap-8 max-w-7xl mx-auto">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-white mb-1">
          Zero-Results Pipeline
        </h1>
        <p class="text-gray-500 dark:text-gray-400">
          Identify exact queries where users are looking for services that do not yet exist or are poorly tagged on the platform.
        </p>
      </div>
    </div>

    <!-- Data Tables Row -->
    <DashboardEventTable
      title="Prioritized Zero-Result Searches"
      description="Ranked by frequency. Adding new service categories for these will instantly capture lost demand."
      :columns="zeroResultColumns"
      :data="zeroResultQueries"
      :loading="isLoading"
    />
  </div>
</template>
