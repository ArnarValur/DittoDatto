<script setup lang="ts">
/**
 * StepDateSelect
 * Horizontal 14-day date picker with closed-day detection.
 * Extracted from both StandardBookingFlow and ReservationBookingFlow.
 */

import type { OpeningSchedule } from '../booking.types'
import {
  isDayClosed,
  isSameDay,
  isToday,
  formatDateShort,
  formatDateNum,
  generateDateRange,
} from '../booking.utils'

interface Props {
  modelValue: Date
  openingSchedule?: OpeningSchedule
}

const props = defineProps<Props>()
const emit = defineEmits<{
  (e: 'update:modelValue', value: Date): void
}>()

const baseDate = ref(new Date())

const availableDates = computed(() => generateDateRange(baseDate.value, 14))

function selectDate(date: Date) {
  if (!isDayClosed(date, props.openingSchedule)) {
    emit('update:modelValue', date)
  }
}
</script>

<template>
  <div class="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
    <button
      v-for="date in availableDates"
      :key="date.toISOString()"
      class="shrink-0 w-16 py-3 rounded-xl border transition-all text-center"
      :class="[
        isDayClosed(date, openingSchedule)
          ? 'opacity-40 cursor-not-allowed bg-muted/20 border-transparent'
          : isSameDay(date, modelValue)
            ? 'bg-primary text-white border-primary shadow-lg scale-105'
            : 'bg-muted/10 border-default hover:border-primary/50',
      ]"
      :disabled="isDayClosed(date, openingSchedule)"
      @click="selectDate(date)"
    >
      <span
        class="text-xs uppercase font-medium"
        :class="isSameDay(date, modelValue) ? 'text-white/80' : 'text-muted'"
      >
        {{ isToday(date) ? 'Today' : formatDateShort(date) }}
      </span>
      <span class="block text-xl font-bold mt-1">{{ formatDateNum(date) }}</span>
      <span v-if="isDayClosed(date, openingSchedule)" class="text-[10px] text-muted">Closed</span>
    </button>
  </div>
</template>

<style scoped>
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
</style>
