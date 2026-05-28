<script setup lang="ts">
import { h, resolveComponent } from 'vue'
import { useSearchAnalytics, type TopQuery } from '~/composables/useSearchAnalytics'
import type { TableColumn } from '@nuxt/ui'

definePageMeta({
  title: 'Keyword Analysis',
  layout: 'dashboard'
})

const { topQueries, isLoading } = useSearchAnalytics()

const UIcon = resolveComponent('UIcon')
const UBadge = resolveComponent('UBadge')
const UButton = resolveComponent('UButton')

const topQueriesColumns: TableColumn<TopQuery>[] = [
  { accessorKey: 'query', header: 'Search Query' },
  { accessorKey: 'count', header: 'Search Volume (30d)' },
  {
    accessorKey: 'trend',
    header: 'Trend',
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
    header: 'Click-Through Rate',
    cell: ({ row }) => h(UBadge, { color: 'neutral', variant: 'subtle' }, () => row.getValue('conversionRate'))
  }
]
</script>

<template>
  <div class="flex flex-col gap-8 max-w-7xl mx-auto">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-white mb-1">
          Keywords Analysis
        </h1>
        <p class="text-gray-500 dark:text-gray-400">
          Deep dive into the top performing queries, their relative search volumes, and conversion trajectories to bookable services.
        </p>
      </div>
    </div>

    <!-- Data Tables Row -->
    <DashboardEventTable
      title="All Converting Queries"
      description="Extracted and normalized search strings that lead to successful click-throughs on DittoDatto."
      :columns="topQueriesColumns"
      :data="topQueries"
      :loading="isLoading"
    />
  </div>
</template>
