<script setup lang="ts">
import type { DateOverride, ShiftBlock } from '@dittodatto/shared-types'

const props = defineProps<{
  modelValue: DateOverride[]
}>()

const emit = defineEmits<{
  'update:modelValue': [value: DateOverride[]]
}>()

// Local copy
const overrides = ref<DateOverride[]>(JSON.parse(JSON.stringify(props.modelValue)))

watch(() => props.modelValue, (val) => {
  overrides.value = JSON.parse(JSON.stringify(val))
}, { deep: true })

// New override form
const showForm = ref(false)
const newDate = ref('')
const newType = ref<'off' | 'sick' | 'custom'>('off')
const newReason = ref('')
const newBlocks = ref<ShiftBlock[]>([{ start: '09:00', end: '13:00' }])

const typeOptions = [
  { label: 'Day Off', value: 'off' },
  { label: 'Sick Day', value: 'sick' },
  { label: 'Custom Hours', value: 'custom' }
]

function addOverride() {
  if (!newDate.value) return

  const override: DateOverride = {
    date: newDate.value,
    type: newType.value,
    reason: newReason.value || undefined,
    blocks: newType.value === 'custom' ? [...newBlocks.value] : undefined
  }

  // Replace if same date exists
  const filtered = overrides.value.filter(o => o.date !== override.date)
  filtered.push(override)
  filtered.sort((a, b) => a.date.localeCompare(b.date))

  overrides.value = filtered
  emit('update:modelValue', filtered)

  // Reset form
  showForm.value = false
  newDate.value = ''
  newType.value = 'off'
  newReason.value = ''
  newBlocks.value = [{ start: '09:00', end: '13:00' }]
}

function removeOverride(date: string) {
  const filtered = overrides.value.filter(o => o.date !== date)
  overrides.value = filtered
  emit('update:modelValue', filtered)
}

// Type badge colors
const typeColors: Record<string, 'error' | 'warning' | 'info'> = {
  off: 'info',
  sick: 'error',
  custom: 'warning'
}

const typeLabels: Record<string, string> = {
  off: 'Day Off',
  sick: 'Sick',
  custom: 'Custom'
}

function formatDate(dateStr: string) {
  const d = new Date(dateStr + 'T00:00:00')
  return d.toLocaleDateString('en-GB', { weekday: 'short', month: 'short', day: 'numeric' })
}
</script>

<template>
  <div class="space-y-3">
    <div class="flex items-center justify-between">
      <h4 class="text-sm font-medium text-muted uppercase tracking-wider">Date Overrides</h4>
      <UButton
        icon="i-lucide-plus"
        label="Add"
        size="xs"
        color="neutral"
        variant="ghost"
        @click="showForm = !showForm"
      />
    </div>

    <!-- Add form -->
    <div v-if="showForm" class="p-3 rounded-lg bg-muted/30 space-y-3">
      <div class="flex items-center gap-3">
        <UInput
          v-model="newDate"
          type="date"
          class="w-40"
          size="sm"
        />
        <USelectMenu
          :model-value="typeOptions.find(o => o.value === newType)"
          :items="typeOptions"
          value-attribute="value"
          option-attribute="label"
          class="w-32"
          size="sm"
          @update:model-value="(val: any) => (newType = val?.value ?? 'off')"
        />
      </div>
      <UInput
        v-model="newReason"
        placeholder="Reason (optional)"
        size="sm"
      />
      <!-- Custom blocks -->
      <div v-if="newType === 'custom'" class="space-y-2">
        <div v-for="(block, i) in newBlocks" :key="i" class="flex items-center gap-2">
          <UInput v-model="block.start" type="time" size="sm" class="w-28" />
          <span class="text-xs text-muted">to</span>
          <UInput v-model="block.end" type="time" size="sm" class="w-28" />
          <UButton
            v-if="newBlocks.length > 1"
            icon="i-lucide-x"
            size="xs"
            color="neutral"
            variant="ghost"
            @click="newBlocks.splice(i, 1)"
          />
        </div>
        <UButton
          icon="i-lucide-plus"
          label="Add block"
          size="xs"
          color="neutral"
          variant="ghost"
          @click="newBlocks.push({ start: '14:00', end: '18:00' })"
        />
      </div>
      <div class="flex gap-2">
        <UButton label="Save" size="sm" color="primary" @click="addOverride" />
        <UButton label="Cancel" size="sm" color="neutral" variant="ghost" @click="showForm = false" />
      </div>
    </div>

    <!-- Overrides list -->
    <div v-if="overrides.length" class="space-y-2">
      <div
        v-for="override in overrides"
        :key="override.date"
        class="flex items-center justify-between py-2 border-b border-default last:border-0"
      >
        <div class="flex items-center gap-2">
          <UBadge :color="typeColors[override.type]" variant="subtle" size="xs">
            {{ typeLabels[override.type] }}
          </UBadge>
          <span class="text-sm font-medium">{{ formatDate(override.date) }}</span>
          <span v-if="override.reason" class="text-xs text-muted">— {{ override.reason }}</span>
        </div>
        <div class="flex items-center gap-2">
          <span v-if="override.blocks?.length" class="text-xs text-muted">
            {{ override.blocks.map(b => `${b.start}–${b.end}`).join(', ') }}
          </span>
          <UButton
            icon="i-lucide-trash-2"
            size="xs"
            color="neutral"
            variant="ghost"
            @click="removeOverride(override.date)"
          />
        </div>
      </div>
    </div>

    <p v-else class="text-sm text-muted italic">No date overrides set.</p>
  </div>
</template>
