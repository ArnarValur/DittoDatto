<script setup lang="ts">
/**
 * StepGuestCount
 * Interactive guest counter with large-party handling.
 * Extracted from ReservationBookingFlow.vue lines 259–336.
 */

import { nextTick } from 'vue'

interface Props {
  modelValue: number
  maxGuests?: number
  largePartyHandling?: 'email' | 'call' | 'datto' | 'disabled'
  largePartyContact?: string
}

const props = withDefaults(defineProps<Props>(), {
  maxGuests: 8,
  largePartyHandling: 'call',
})

const emit = defineEmits<{
  (e: 'update:modelValue', value: number): void
}>()

const isEditing = ref(false)
const inputRef = ref<HTMLInputElement>()

const hasLimit = computed(() => props.maxGuests < 500)
const showLargePartyMessage = computed(
  () => hasLimit.value && props.modelValue > props.maxGuests
)

function startEditing() {
  isEditing.value = true
  nextTick(() => inputRef.value?.select())
}

function finishEditing() {
  isEditing.value = false
  if (props.modelValue < 1) emit('update:modelValue', 1)
}

function handleInput(e: Event) {
  const val = parseInt((e.target as HTMLInputElement).value) || 1
  emit('update:modelValue', Math.max(1, val))
}

function decrement() {
  emit('update:modelValue', Math.max(1, props.modelValue - 1))
}

function increment() {
  emit('update:modelValue', props.modelValue + 1)
}
</script>

<template>
  <div class="space-y-6">
    <div class="text-center space-y-2">
      <h3 class="text-xl font-semibold">How many guests?</h3>
      <p class="text-muted text-sm">Select the number of people for your reservation</p>
    </div>

    <!-- Guest Counter -->
    <div class="flex items-center justify-center gap-6 py-8">
      <UButton
        icon="i-lucide-minus"
        color="neutral"
        variant="outline"
        size="xl"
        :disabled="modelValue <= 1"
        class="rounded-full size-14"
        @click="decrement"
      />

      <div class="text-center min-w-[100px]">
        <input
          v-if="isEditing"
          ref="inputRef"
          type="number"
          :value="modelValue"
          min="1"
          class="text-5xl font-bold text-center w-24 bg-transparent border-b-2 border-primary outline-none"
          @input="handleInput"
          @blur="finishEditing"
          @keydown.enter="finishEditing"
        />
        <span
          v-else
          class="text-5xl font-bold cursor-pointer hover:text-primary transition-colors"
          title="Click to edit"
          @click="startEditing"
        >
          {{ modelValue }}
        </span>
        <p class="text-sm text-muted mt-1">
          {{ modelValue === 1 ? 'Guest' : 'Guests' }}
          <span v-if="hasLimit" class="text-xs">(max {{ maxGuests }})</span>
        </p>
      </div>

      <UButton
        icon="i-lucide-plus"
        color="neutral"
        variant="outline"
        size="xl"
        class="rounded-full size-14"
        @click="increment"
      />
    </div>

    <!-- Large Party Message -->
    <div
      v-if="showLargePartyMessage"
      class="p-4 rounded-xl bg-amber-500/10 border border-amber-500/30 text-center space-y-2"
    >
      <UIcon name="i-lucide-users" class="size-8 text-amber-500 mx-auto" />
      <p class="font-medium text-amber-700 dark:text-amber-400">
        For parties of {{ maxGuests + 1 }}+ guests
      </p>
      <p class="text-sm text-muted">
        {{
          largePartyHandling === 'email'
            ? 'Please email us to arrange your reservation'
            : 'Please call us to arrange your reservation'
        }}
      </p>
    </div>
  </div>
</template>

<style scoped>
input[type='number']::-webkit-inner-spin-button,
input[type='number']::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
input[type='number'] {
  -moz-appearance: textfield;
}
</style>
