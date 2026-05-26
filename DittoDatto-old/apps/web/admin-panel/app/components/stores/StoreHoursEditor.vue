<script setup lang="ts">
/**
 * StoreHoursEditor
 * A visual editor for configuring store opening hours.
 * Used by business owners to set their weekly schedule.
 */
import type { OpeningSchedule, DaySchedule } from '@dittodatto/shared-types'

interface Props {
  modelValue: OpeningSchedule
}

const props = defineProps<Props>()
const emit = defineEmits<{
  'update:modelValue': [schedule: OpeningSchedule]
}>()

// Day labels for display
const days = [
  { key: 'mon' as const, label: 'Monday' },
  { key: 'tue' as const, label: 'Tuesday' },
  { key: 'wed' as const, label: 'Wednesday' },
  { key: 'thu' as const, label: 'Thursday' },
  { key: 'fri' as const, label: 'Friday' },
  { key: 'sat' as const, label: 'Saturday' },
  { key: 'sun' as const, label: 'Sunday' }
]

// Time slot options (15-minute increments)
const timeOptions = computed(() => {
  const options = []
  for (let h = 0; h < 24; h++) {
    for (let m = 0; m < 60; m += 15) {
      const time = `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}`
      options.push({ label: time, value: time })
    }
  }
  return options
})

// Update a specific day's schedule
const updateDay = (dayKey: keyof OpeningSchedule, field: keyof DaySchedule, value: string) => {
  const newSchedule = {
    ...props.modelValue,
    [dayKey]: {
      ...props.modelValue[dayKey],
      [field]: value
    }
  }
  emit('update:modelValue', newSchedule)
}

// Quick action: Copy to all weekdays
const copyToWeekdays = (sourceDay: keyof OpeningSchedule) => {
  const source = props.modelValue[sourceDay]
  const weekdays: (keyof OpeningSchedule)[] = ['mon', 'tue', 'wed', 'thu', 'fri']
  const newSchedule = { ...props.modelValue }
  weekdays.forEach((day) => {
    newSchedule[day] = { ...source }
  })
  emit('update:modelValue', newSchedule)
}

// Quick action: Set as closed
const setDayClosed = (dayKey: keyof OpeningSchedule) => {
  updateDay(dayKey, 'isOpen', false)
}
</script>

<template>
  <div class="space-y-4">
    <!-- Header with quick actions -->
    <div class="flex items-center justify-between">
      <h3 class="text-lg font-semibold">
        Opening Hours
      </h3>
      <UDropdownMenu
        :items="[[
          { label: 'Copy Monday to weekdays', onSelect: () => copyToWeekdays('mon') },
          { label: 'Close all weekends', onSelect: () => { setDayClosed('sat'); setDayClosed('sun') } }
        ]]"
      >
        <UButton
          icon="i-lucide-wand-2"
          color="neutral"
          variant="ghost"
          size="sm"
        >
          Quick Actions
        </UButton>
      </UDropdownMenu>
    </div>

    <!-- Day rows -->
    <div class="space-y-3">
      <div
        v-for="day in days"
        :key="day.key"
        class="flex items-center gap-4 p-3 rounded-lg border border-gray-200 dark:border-gray-800"
        :class="{ 'bg-gray-50 dark:bg-gray-900/50': !modelValue[day.key].isOpen }"
      >
        <!-- Day name -->
        <div class="w-28 font-medium">
          {{ day.label }}
        </div>

        <!-- Open toggle -->
        <UToggle
          :model-value="modelValue[day.key].isOpen"
          @update:model-value="updateDay(day.key, 'isOpen', $event)"
        />

        <!-- Time selectors (only show if open) -->
        <template v-if="modelValue[day.key].isOpen">
          <USelectMenu
            :model-value="modelValue[day.key].open"
            :items="timeOptions"
            value-key="value"
            class="w-28"
            @update:model-value="updateDay(day.key, 'open', $event)"
          />

          <span class="text-gray-500">to</span>

          <USelectMenu
            :model-value="modelValue[day.key].close"
            :items="timeOptions"
            value-key="value"
            class="w-28"
            @update:model-value="updateDay(day.key, 'close', $event)"
          />

          <!-- Total hours display -->
          <span class="text-sm text-gray-500 ml-auto">
            {{ calculateHours(modelValue[day.key]) }}
          </span>
        </template>

        <!-- Closed label -->
        <span
          v-else
          class="text-gray-400 italic"
        >
          Closed
        </span>
      </div>
    </div>

    <!-- Weekly summary -->
    <div class="p-4 bg-gray-50 dark:bg-gray-900 rounded-lg">
      <div class="text-sm text-gray-600 dark:text-gray-400">
        <strong>Weekly total:</strong> {{ totalWeeklyHours }} hours
      </div>
    </div>
  </div>
</template>

<script lang="ts">
// Helper function to calculate hours for a day
function calculateHours(day: DaySchedule): string {
  if (!day.isOpen) return ''

  const [openH, openM] = day.open.split(':').map(Number)
  const [closeH, closeM] = day.close.split(':').map(Number)

  const openMinutes = openH * 60 + openM
  const closeMinutes = closeH * 60 + closeM
  const diff = closeMinutes - openMinutes

  if (diff <= 0) return '0h'

  const hours = Math.floor(diff / 60)
  const mins = diff % 60

  return mins > 0 ? `${hours}h ${mins}m` : `${hours}h`
}
</script>

<script setup lang="ts">
// Computed: Total weekly hours
const totalWeeklyHours = computed(() => {
  let totalMinutes = 0

  Object.values(props.modelValue).forEach((day: DaySchedule) => {
    if (!day.isOpen) return

    const [openH, openM] = day.open.split(':').map(Number)
    const [closeH, closeM] = day.close.split(':').map(Number)

    const openMins = openH * 60 + openM
    const closeMins = closeH * 60 + closeM

    if (closeMins > openMins) {
      totalMinutes += closeMins - openMins
    }
  })

  return Math.round(totalMinutes / 60 * 10) / 10  // Round to 1 decimal
})
</script>
