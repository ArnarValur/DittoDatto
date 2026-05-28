<script setup lang="ts">
import { h, resolveComponent } from 'vue'
import { useSearchAnalytics, type TopQuery, type ZeroResultQuery } from '~/composables/useSearchAnalytics'
import type { TableColumn } from '@nuxt/ui'

definePageMeta({
  title: 'Dashboard Overview',
  layout: 'dashboard'
})

const { metrics, topQueries, zeroResultQueries, isLoading } = useSearchAnalytics()

const UIcon = resolveComponent('UIcon')
const UBadge = resolveComponent('UBadge')
const UButton = resolveComponent('UButton')

const topQueriesColumns: TableColumn<TopQuery>[] = [
  { accessorKey: 'query', header: 'Search Query' },
  { accessorKey: 'count', header: 'Volume' },
  {
    accessorKey: 'trend',
    header: 'Trend (30d)',
    cell: ({ row }) => {
      const trend = row.getValue('trend') as number
      const isPositive = trend > 0
      return h('div', { class: ['flex items-center gap-1.5', isPositive ? 'text-primary' : 'text-error'] }, [
        h(UIcon, { name: isPositive ? 'i-lucide-trending-up' : 'i-lucide-trending-down', class: 'w-4 h-4' }),
        h('span', { class: 'font-medium' }, `${Math.abs(trend)}%`)
      ])
    }
  },
  {
    accessorKey: 'conversionRate',
    header: 'CTR',
    cell: ({ row }) => h(UBadge, { color: 'neutral', variant: 'subtle' }, () => row.getValue('conversionRate'))
  }
]

const zeroResultColumns: TableColumn<ZeroResultQuery>[] = [
  {
    accessorKey: 'query',
    header: 'Unmet Demand Query',
    cell: ({ row }) => {
      return h('span', { class: 'font-medium text-gray-900 dark:text-white' }, row.getValue('query') as string)
    }
  },
  { accessorKey: 'count', header: 'Failed Searches' },
  { accessorKey: 'lastSeen', header: 'Last Seen' }
]
</script>

<template>
  <div class="flex flex-col gap-8 max-w-7xl mx-auto">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-white mb-1">
          Search Keyword Intelligence
        </h1>
        <p class="text-gray-500 dark:text-gray-400">
          Discover zero-result queries, analyze search volume, and understand user intent across the DittoDatto LUI.
        </p>
      </div>
    </div>

    <!-- KPIs Row -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <DashboardStatCard
        v-for="metric in metrics"
        :key="metric.title"
        :title="metric.title"
        :value="metric.value"
        :icon="metric.icon"
        :trend="metric.trend"
      />
    </div>

    <!-- Data Tables Row -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
      <DashboardEventTable
        title="Top Converting Queries"
        description="Most frequent searches that lead to store visits."
        :columns="topQueriesColumns"
        :data="topQueries"
        :loading="isLoading"
      >
        <template #actions>
          <UButton
            color="neutral"
            variant="ghost"
            icon="i-lucide-external-link"
            to="/dashboard/keywords"
          >
            View Full Report
          </UButton>
        </template>
      </DashboardEventTable>

      <DashboardEventTable
        title="Zero-Result Opportunities"
        description="Searches with absolute zero results. Huge potential for new categories."
        :columns="zeroResultColumns"
        :data="zeroResultQueries"
        :loading="isLoading"
      >
        <template #actions>
          <UButton
            color="neutral"
            variant="soft"
            icon="i-lucide-external-link"
            to="/dashboard/zero-results"
          >
            View Full Report
          </UButton>
        </template>
      </DashboardEventTable>
    </div>
  </div>
</template>
