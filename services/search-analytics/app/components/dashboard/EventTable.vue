<script setup lang="ts">
import type { TableColumn } from '@nuxt/ui'

// Generics for the Table item type aren't fully supported in Nuxt UI v4 props easily without complex types,
// so we'll accept an array of any object
defineProps<{
  title: string
  description?: string
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  columns: TableColumn<any>[]
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  data: any[]
  loading?: boolean
}>()
</script>

<template>
  <UCard
    :ui="{
      header: 'px-4 py-4 sm:px-6 flex flex-col sm:flex-row sm:items-start sm:justify-between gap-4',
      body: 'p-0 sm:p-0 overflow-x-auto'
    }"
  >
    <template #header>
      <div class="flex flex-col">
        <h3 class="text-base font-semibold text-gray-900 dark:text-white">
          {{ title }}
        </h3>
        <p
          v-if="description"
          class="text-sm text-gray-500 dark:text-gray-400 mt-1"
        >
          {{ description }}
        </p>
      </div>
      <div class="flex justify-end gap-2 shrink-0">
        <slot name="actions" />
      </div>
    </template>

    <UTable
      :columns="columns"
      :data="data"
      :loading="loading"
    >
      <!-- We expose dynamic slots from UTable up to the parent using a scoped slot mapping -->
      <template
        v-for="(_, slotName) in $slots"
        #[slotName]="slotProps"
        :key="slotName"
      >
        <slot
          :name="slotName"
          v-bind="slotProps || {}"
        />
      </template>
    </UTable>
  </UCard>
</template>
