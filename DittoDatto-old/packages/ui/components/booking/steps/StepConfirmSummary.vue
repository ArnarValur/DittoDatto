<script setup lang="ts">
/**
 * StepConfirmSummary
 * Generic confirmation summary card.
 * Renders a store header + a list of icon/label/value rows.
 *
 * Used by both StandardBookingFlow (confirm) and ReservationBookingFlow (confirm).
 */

import type { ConfirmSummaryRow } from '../booking.types'

interface Props {
  storeName: string
  storeAddress?: string
  storeLogo?: string
  /** Icon to show when no logo — e.g. 'i-lucide-store' or 'i-lucide-utensils' */
  storeIcon?: string
  rows: ConfirmSummaryRow[]
}

withDefaults(defineProps<Props>(), {
  storeIcon: 'i-lucide-store',
})
</script>

<template>
  <div class="space-y-6">
    <!-- Store header -->
    <div class="flex items-center gap-4 p-4 rounded-xl bg-muted/20 border border-default">
      <NuxtImg
        v-if="storeLogo"
        :src="storeLogo"
        :alt="storeName"
        class="size-16 rounded-xl object-cover"
        loading="lazy"
        sizes="64px"
      />
      <div v-else class="size-16 rounded-xl bg-muted/50 flex items-center justify-center">
        <UIcon :name="storeIcon" class="size-8 text-muted" />
      </div>
      <div>
        <h3 class="font-semibold text-lg">{{ storeName }}</h3>
        <p v-if="storeAddress" class="text-sm text-muted">{{ storeAddress }}</p>
      </div>
    </div>

    <!-- Detail rows -->
    <div class="p-4 rounded-xl border border-default space-y-4">
      <template v-for="(row, index) in rows" :key="index">
        <USeparator v-if="index > 0" />
        <div class="flex items-center gap-3">
          <div class="size-10 rounded-lg bg-primary/10 flex items-center justify-center">
            <UIcon :name="row.icon" class="size-5 text-primary" />
          </div>
          <div>
            <p class="text-sm text-muted">{{ row.label }}</p>
            <p v-if="!row.secondaryValues" class="font-semibold">{{ row.value }}</p>
            <div v-else class="space-y-0.5">
              <p v-for="(sv, si) in row.secondaryValues" :key="si" class="font-medium text-sm">
                {{ sv }}
              </p>
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>
