<script setup lang="ts">
/**
 * StepProgressIndicator
 * Displays a numbered step progress bar (1 — 2 — 3 — ...).
 * Pure presentational — no business logic.
 */

interface Props {
  /** Total step labels (used for count) */
  steps: readonly string[]
  /** Zero-based index of the current active step */
  currentIndex: number
}

defineProps<Props>()
</script>

<template>
  <div class="flex items-center justify-center gap-2">
    <div v-for="(_step, index) in steps" :key="index" class="flex items-center">
      <div
        class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium transition-all"
        :class="index <= currentIndex ? 'bg-primary text-white' : 'bg-muted/30 text-muted'"
      >
        {{ index + 1 }}
      </div>
      <div
        v-if="index < steps.length - 1"
        class="w-8 h-0.5 transition-all"
        :class="index < currentIndex ? 'bg-primary' : 'bg-muted/30'"
      />
    </div>
  </div>
</template>
