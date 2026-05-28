<script setup lang="ts">
defineProps<{
  title: string
  value: string | number
  trend?: {
    value: string
    isPositive: boolean
  }
  icon?: string
}>()
</script>

<template>
  <UCard
    :ui="{
      root: 'backdrop-blur-md overflow-hidden relative group'
    }"
  >
    <div class="flex justify-between items-start mb-2">
      <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">
        {{ title }}
      </h3>
      <UIcon
        v-if="icon"
        :name="icon"
        class="w-5 h-5 text-gray-400 dark:text-gray-500 group-hover:text-primary transition-colors duration-300"
      />
    </div>

    <div class="flex items-baseline gap-2">
      <span class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">
        {{ value }}
      </span>

      <UIcon
        v-if="trend"
        :name="
          trend.isPositive
            ? 'i-lucide-arrow-up-right'
            : 'i-lucide-arrow-down-right'
        "
        class="w-4 h-4"
        :class="trend.isPositive ? 'text-green-500' : 'text-red-500'"
      />
      <span
        v-if="trend"
        class="text-sm font-medium"
        :class="trend.isPositive ? 'text-green-500' : 'text-red-500'"
      >
        {{ trend.value }}
      </span>
    </div>

    <!-- Subtle background decoration -->
    <div
      class="absolute -bottom-6 -right-6 w-24 h-24 bg-primary/5 rounded-full blur-2xl group-hover:bg-primary/20 transition-all duration-500 pointer-events-none"
    />
  </UCard>
</template>
