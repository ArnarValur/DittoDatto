<script setup lang="ts">
/**
 * StepStaffSelect
 * Staff selection list with "Anyone" option.
 * Extracted from StandardBookingFlow.vue lines 423–470.
 */

import type { StaffMember } from '../booking.types'

interface Props {
  staff: StaffMember[]
  modelValue: StaffMember | null
}

defineProps<Props>()
const emit = defineEmits<{
  (e: 'update:modelValue', value: StaffMember | null): void
}>()

function getInitials(name: string): string {
  return name
    .split(' ')
    .map((n: string) => n[0])
    .join('')
    .slice(0, 2)
    .toUpperCase()
}
</script>

<template>
  <div class="space-y-3">
    <div class="mb-4">
      <p class="text-sm text-muted">Who would you like to book with?</p>
    </div>

    <!-- "Anyone" Option -->
    <div
      class="flex items-center gap-4 p-4 rounded-xl border transition-all cursor-pointer"
      :class="
        modelValue === null
          ? 'bg-primary/5 border-primary/50'
          : 'bg-muted/20 border-default hover:border-primary/50'
      "
      @click="emit('update:modelValue', null)"
    >
      <div
        class="size-12 rounded-full overflow-hidden shrink-0 bg-primary/10 flex items-center justify-center border border-primary/20"
      >
        <UIcon name="i-lucide-users" class="size-5 text-primary" />
      </div>
      <div class="flex-1 min-w-0">
        <h3 class="font-medium">Anyone</h3>
        <p class="text-sm text-muted">Ingen preferanse</p>
      </div>
      <UIcon name="i-lucide-chevron-right" class="size-5 text-muted" />
    </div>

    <!-- Staff List -->
    <div
      v-for="s in staff"
      :key="s.id"
      class="flex items-center gap-4 p-4 rounded-xl border transition-all cursor-pointer"
      :class="
        modelValue?.id === s.id
          ? 'bg-primary/5 border-primary/50'
          : 'bg-muted/20 border-default hover:border-primary/50'
      "
      @click="emit('update:modelValue', s)"
    >
      <div class="size-12 rounded-full overflow-hidden shrink-0 bg-muted border border-default">
        <img
          v-if="s.avatarUrl"
          :src="s.avatarUrl"
          :alt="s.displayName"
          class="object-cover w-full h-full"
        />
        <div
          v-else
          class="w-full h-full flex items-center justify-center text-muted font-semibold"
        >
          {{ getInitials(s.displayName) }}
        </div>
      </div>
      <div class="flex-1 min-w-0">
        <h3 class="font-medium">{{ s.displayName }}</h3>
        <p v-if="s.title" class="text-sm text-muted">{{ s.title }}</p>
      </div>
      <UIcon name="i-lucide-chevron-right" class="size-5 text-muted" />
    </div>
  </div>
</template>
