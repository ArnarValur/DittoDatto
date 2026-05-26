<script setup lang="ts">
/**
 * BookingPolicyCard
 * Cancellation & reschedule policy controls for a store.
 * Uses v-model for two-way binding with the parent's bookingPolicy state.
 */

interface BookingPolicyState {
  clientCancelEnabled: boolean
  minCancelNoticeHours: number
  clientRescheduleEnabled: boolean
  minRescheduleNoticeHours: number
}

const policy = defineModel<BookingPolicyState>({ required: true })
</script>

<template>
  <USeparator label="Booking Policy" class="my-6" />

  <div class="p-4 rounded-lg border border-default bg-muted/30 space-y-5">
    <div class="flex items-center gap-2 mb-1">
      <UIcon name="i-lucide-shield-check" class="size-5 text-primary" />
      <h3 class="font-semibold">
        Cancellation & Reschedule Rules
      </h3>
    </div>
    <p class="text-sm text-muted">
      Control how far in advance customers must cancel or reschedule their bookings.
    </p>

    <!-- Client Cancel Toggle -->
    <div class="flex items-center justify-between p-3 rounded-lg border border-default">
      <div>
        <p class="font-medium">Allow Customer Cancellation</p>
        <p class="text-sm text-muted">Customers can cancel their own bookings</p>
      </div>
      <USwitch v-model="policy.clientCancelEnabled" />
    </div>

    <!-- Min Cancel Notice -->
    <div v-if="policy.clientCancelEnabled" class="pl-4 border-l-2 border-primary/30">
      <UFormField label="Minimum Cancel Notice" hint="Hours before the appointment">
        <div class="flex items-center gap-3">
          <UInput
            v-model.number="policy.minCancelNoticeHours"
            type="number"
            :min="0"
            :max="168"
            class="w-24"
          />
          <span class="text-sm text-muted">hours</span>
        </div>
        <p class="text-xs text-muted mt-1">
          {{ policy.minCancelNoticeHours === 0
            ? 'Customers can cancel at any time'
            : policy.minCancelNoticeHours >= 24
              ? `Customers must cancel at least ${Math.floor(policy.minCancelNoticeHours / 24)} day(s) before`
              : `Customers must cancel at least ${policy.minCancelNoticeHours} hour(s) before`
          }}
        </p>
      </UFormField>
    </div>

    <!-- Client Reschedule Toggle -->
    <div class="flex items-center justify-between p-3 rounded-lg border border-default">
      <div>
        <p class="font-medium">Allow Customer Reschedule</p>
        <p class="text-sm text-muted">Customers can move their bookings to a different time</p>
      </div>
      <USwitch v-model="policy.clientRescheduleEnabled" />
    </div>

    <!-- Min Reschedule Notice -->
    <div v-if="policy.clientRescheduleEnabled" class="pl-4 border-l-2 border-primary/30">
      <UFormField label="Minimum Reschedule Notice" hint="Hours before the appointment">
        <div class="flex items-center gap-3">
          <UInput
            v-model.number="policy.minRescheduleNoticeHours"
            type="number"
            :min="0"
            :max="168"
            class="w-24"
          />
          <span class="text-sm text-muted">hours</span>
        </div>
        <p class="text-xs text-muted mt-1">
          {{ policy.minRescheduleNoticeHours === 0
            ? 'Customers can reschedule at any time'
            : policy.minRescheduleNoticeHours >= 24
              ? `Customers must reschedule at least ${Math.floor(policy.minRescheduleNoticeHours / 24)} day(s) before`
              : `Customers must reschedule at least ${policy.minRescheduleNoticeHours} hour(s) before`
          }}
        </p>
      </UFormField>
    </div>
  </div>
</template>
