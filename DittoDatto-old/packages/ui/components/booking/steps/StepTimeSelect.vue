<script setup lang="ts">
/**
 * StepTimeSelect
 * Time slot grid with loading, error, hold-expired, and empty states.
 * Extracted from both StandardBookingFlow and ReservationBookingFlow.
 */

interface Props {
  slots: string[]
  modelValue?: string
  loading?: boolean
  error?: string | null
  /** Whether a hold expired and user must re-select */
  holdExpired?: boolean
}

defineProps<Props>()
const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
  (e: 'retry'): void
}>()
</script>

<template>
  <div class="space-y-4">
    <!-- Loading state -->
    <div v-if="loading" class="flex items-center justify-center py-8">
      <UIcon name="i-lucide-loader-2" class="size-6 animate-spin text-primary" />
      <span class="ml-2 text-muted">Loading available times...</span>
    </div>

    <!-- Error state -->
    <div v-else-if="error" class="text-center py-8 space-y-3">
      <UIcon name="i-lucide-wifi-off" class="size-10 text-red-400 mx-auto" />
      <p class="text-sm font-medium text-red-400">{{ error }}</p>
      <p class="text-xs text-muted">Check your connection and try again.</p>
      <UButton
        label="Retry"
        color="neutral"
        variant="soft"
        size="sm"
        icon="i-lucide-refresh-cw"
        @click="emit('retry')"
      />
    </div>

    <template v-else>
      <!-- Hold expired notice -->
      <div
        v-if="holdExpired"
        class="mb-4 p-3 rounded-lg bg-amber-500/10 border border-amber-500/30 flex items-center gap-3"
      >
        <UIcon name="i-lucide-clock" class="size-5 text-amber-500 shrink-0" />
        <p class="text-sm text-amber-400">Your hold has expired. Please select a new time slot.</p>
      </div>

      <!-- No slots available -->
      <div v-if="slots.length === 0" class="text-center py-8">
        <UIcon name="i-lucide-calendar-x" class="size-8 text-muted mx-auto mb-2" />
        <p class="text-sm text-muted">No available times for this date</p>
        <p class="text-xs text-muted mt-1">Try selecting a different date.</p>
      </div>

      <!-- Time slots grid -->
      <div v-else class="grid grid-cols-4 gap-2">
        <button
          v-for="slot in slots"
          :key="slot"
          class="py-3 px-2 rounded-lg border text-center font-medium transition-all"
          :class="
            modelValue === slot
              ? 'bg-primary text-white border-primary'
              : 'bg-muted/10 border-default hover:border-primary/50'
          "
          @click="emit('update:modelValue', slot)"
        >
          {{ slot }}
        </button>
      </div>
    </template>
  </div>
</template>
