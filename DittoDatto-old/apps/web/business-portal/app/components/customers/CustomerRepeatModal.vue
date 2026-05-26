<script setup lang="ts">
import { z } from 'zod'
import { format } from 'date-fns'

const props = defineProps<{
  modelValue: boolean
  defaultEndsAt?: Date
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
  (e: 'confirm', data: { frequency: string, endsAt: Date }): void
}>()

const isOpen = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const frequencies = [
  { label: 'Never', value: 'never' },
  { label: 'Every week', value: 'weekly' },
  { label: 'Every 2 weeks', value: 'biweekly' },
  { label: 'Every 4 weeks', value: 'monthly' },
  { label: 'Every year', value: 'yearly' },
  { label: 'Custom', value: 'custom' },
]

const selectedFrequency = ref('weekly')
const endsAt = ref<Date>(props.defaultEndsAt || new Date(Date.now() + 1000 * 60 * 60 * 24 * 30 * 6)) // default 6 months

function onConfirm() {
  emit('confirm', {
    frequency: selectedFrequency.value,
    endsAt: endsAt.value
  })
  isOpen.value = false
}
</script>

<template>
  <UModal v-model="isOpen" :ui="{ width: 'sm:max-w-md' }">
    <UCard :ui="{ base: 'flex flex-col', body: 'space-y-4' }">
      <template #header>
        <div class="flex items-center justify-between">
          <h3 class="text-lg font-semibold">Repeat appointment</h3>
          <UButton
            color="neutral"
            variant="ghost"
            icon="i-lucide-x"
            @click="isOpen = false"
          />
        </div>
      </template>

      <!-- Frequency List -->
      <div class="flex flex-col border border-default rounded-xl bg-elevated/20 overflow-hidden text-sm">
        <button
          v-for="(freq, index) in frequencies"
          :key="freq.value"
          class="flex items-center justify-between p-4 bg-background transition-colors"
          :class="[
            index !== frequencies.length - 1 ? 'border-b border-default' : '',
            selectedFrequency === freq.value ? 'font-medium' : 'text-muted hover:bg-elevated/50'
          ]"
          @click="selectedFrequency = freq.value"
        >
          <span>{{ freq.label }}</span>
          <UIcon 
            v-if="selectedFrequency === freq.value" 
            name="i-lucide-check" 
            class="text-primary-500 size-4" 
          />
          <UIcon 
            v-else-if="freq.value === 'custom'" 
            name="i-lucide-chevron-right" 
            class="size-4" 
          />
        </button>
      </div>

      <!-- Ends Date -->
      <div v-if="selectedFrequency !== 'never'" class="flex items-center justify-between p-4 border border-default rounded-xl bg-background mt-4">
        <span class="text-sm font-medium">Ends</span>
        
        <!-- Dummy popover button for Date Picker right now -->
        <UPopover>
          <UButton
            color="neutral"
            variant="ghost"
            :label="format(endsAt, 'd MMM yyyy')"
            icon="i-lucide-chevron-down"
            trailing
            class="font-normal text-muted"
          />
          <template #content>
            <div class="p-4 bg-elevated text-sm text-center">
              Date Picker Component Here
            </div>
          </template>
        </UPopover>
      </div>

      <template #footer>
        <div class="flex justify-between gap-3 p-2">
          <UButton
            label="Cancel"
            color="neutral"
            variant="outline"
            class="flex-1 justify-center rounded-xl py-2.5"
            @click="isOpen = false"
          />
          <UButton
            label="Confirm"
            color="primary"
            class="flex-1 justify-center rounded-xl py-2.5"
            @click="onConfirm"
          />
        </div>
      </template>
    </UCard>
  </UModal>
</template>
