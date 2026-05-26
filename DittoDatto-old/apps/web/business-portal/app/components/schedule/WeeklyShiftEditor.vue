<script setup lang="ts">
import type { WeeklyShift, DayShift, ShiftBlock } from '@dittodatto/shared-types'

const props = defineProps<{
  modelValue: WeeklyShift
}>()

const emit = defineEmits<{
  'update:modelValue': [value: WeeklyShift]
}>()

const dayLabels: { key: keyof WeeklyShift; label: string }[] = [
  { key: 'mon', label: 'Monday' },
  { key: 'tue', label: 'Tuesday' },
  { key: 'wed', label: 'Wednesday' },
  { key: 'thu', label: 'Thursday' },
  { key: 'fri', label: 'Friday' },
  { key: 'sat', label: 'Saturday' },
  { key: 'sun', label: 'Sunday' }
]

// Deep clone to avoid mutating props
const shifts = ref<WeeklyShift>(JSON.parse(JSON.stringify(props.modelValue)))

// Sync from parent when modelValue changes
watch(() => props.modelValue, (val) => {
  shifts.value = JSON.parse(JSON.stringify(val))
}, { deep: true })

// Emit on every change
function emitUpdate() {
  emit('update:modelValue', JSON.parse(JSON.stringify(shifts.value)))
}

// Toggle day working status
function toggleDay(key: keyof WeeklyShift) {
  const day = shifts.value[key]
  day.isWorking = !day.isWorking
  if (day.isWorking && day.blocks.length === 0) {
    day.blocks = [{ start: '09:00', end: '17:00' }]
  }
  emitUpdate()
}

// Add a new block to a day
function addBlock(key: keyof WeeklyShift) {
  const day = shifts.value[key]
  const lastBlock = day.blocks.length > 0 ? day.blocks[day.blocks.length - 1] : undefined
  const newStart = lastBlock?.end ?? '09:00'
  // Add a 2-hour block starting from the end of the last one
  const startMinutes = parseTime(newStart)
  const endMinutes = Math.min(startMinutes + 120, 23 * 60 + 45)
  day.blocks.push({
    start: newStart,
    end: minutesToTime(endMinutes)
  })
  emitUpdate()
}

// Remove a block from a day
function removeBlock(key: keyof WeeklyShift, index: number) {
  shifts.value[key].blocks.splice(index, 1)
  emitUpdate()
}

// Update block time
function updateBlockTime(key: keyof WeeklyShift, blockIndex: number, field: 'start' | 'end', value: string) {
  shifts.value[key].blocks[blockIndex][field] = value
  emitUpdate()
}

// Time helpers
function parseTime(t: string): number {
  const parts = t.split(':').map(Number)
  const h = parts[0] ?? 0
  const m = parts[1] ?? 0
  return h * 60 + m
}

function minutesToTime(m: number): string {
  const h = Math.floor(m / 60)
  const min = m % 60
  return `${String(h).padStart(2, '0')}:${String(min).padStart(2, '0')}`
}

// Generate time options (15-min increments)
const timeOptions = computed(() => {
  const options = []
  for (let m = 0; m <= 23 * 60 + 45; m += 15) {
    options.push({ label: minutesToTime(m), value: minutesToTime(m) })
  }
  return options
})

// Compute total weekly hours
const totalHours = computed(() => {
  let minutes = 0
  for (const day of dayLabels) {
    const d = shifts.value[day.key]
    if (d.isWorking) {
      for (const block of d.blocks) {
        const diff = parseTime(block.end) - parseTime(block.start)
        if (diff > 0) minutes += diff
      }
    }
  }
  return Math.round(minutes / 60 * 10) / 10
})
</script>

<template>
  <div class="space-y-3">
    <!-- Header with total hours -->
    <div class="flex items-center justify-between">
      <h4 class="text-sm font-medium text-muted uppercase tracking-wider">Weekly Schedule</h4>
      <span class="text-sm text-muted">
        <UIcon name="i-lucide-clock" class="size-3.5 inline mr-1" />
        {{ totalHours }}h / week
      </span>
    </div>

    <!-- Day rows -->
    <div
      v-for="day in dayLabels"
      :key="day.key"
      class="flex items-start gap-3 py-2 border-b border-default last:border-0"
    >
      <!-- Day toggle -->
      <div class="w-24 shrink-0 pt-1">
        <UCheckbox
          :model-value="shifts[day.key].isWorking"
          :label="day.label.slice(0, 3)"
          @update:model-value="toggleDay(day.key)"
        />
      </div>

      <!-- Blocks -->
      <div v-if="shifts[day.key].isWorking" class="flex-1 space-y-2">
        <div
          v-for="(block, i) in shifts[day.key].blocks"
          :key="i"
          class="flex items-center gap-2"
        >
          <USelectMenu
            :model-value="timeOptions.find(o => o.value === block.start)"
            :items="timeOptions"
            value-attribute="value"
            option-attribute="label"
            class="w-24"
            size="sm"
            @update:model-value="(val: any) => updateBlockTime(day.key, i, 'start', val?.value ?? block.start)"
          />
          <span class="text-muted text-xs">to</span>
          <USelectMenu
            :model-value="timeOptions.find(o => o.value === block.end)"
            :items="timeOptions"
            value-attribute="value"
            option-attribute="label"
            class="w-24"
            size="sm"
            @update:model-value="(val: any) => updateBlockTime(day.key, i, 'end', val?.value ?? block.end)"
          />
          <UButton
            v-if="shifts[day.key].blocks.length > 1"
            icon="i-lucide-x"
            size="xs"
            color="neutral"
            variant="ghost"
            @click="removeBlock(day.key, i)"
          />
        </div>
        <!-- Add block button -->
        <UButton
          icon="i-lucide-plus"
          label="Add block"
          size="xs"
          color="neutral"
          variant="ghost"
          class="mt-1"
          @click="addBlock(day.key)"
        />
      </div>

      <!-- Day off indicator -->
      <div v-else class="flex-1 pt-1">
        <span class="text-sm text-muted italic">Day off</span>
      </div>
    </div>
  </div>
</template>
