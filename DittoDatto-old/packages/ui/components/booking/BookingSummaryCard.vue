<script setup lang="ts">
import { format } from 'date-fns'

/**
 * Booking Summary Card
 * Sticky sidebar summary shown during the booking flow.
 */

interface Props {
  restaurantName: string
  address: string
  logo?: string
  guestCount?: number
  date?: Date
  time?: string
}

const props = defineProps<Props>()
</script>

<template>
  <div class="bg-gray-900 rounded-xl p-6 shadow-xl border border-gray-800 sticky top-4">
    <!-- Header -->
    <div class="flex items-start gap-4 mb-6 pb-6 border-b border-gray-800">
      <div class="size-16 rounded-lg bg-white overflow-hidden shrink-0">
        <NuxtImg 
          v-if="logo" 
          :src="logo" 
          :alt="restaurantName"
          class="w-full h-full object-cover"
          loading="lazy"
          sizes="64px"
        />
        <div v-else class="w-full h-full flex items-center justify-center bg-gray-100 text-gray-500 font-bold text-xl">
          {{ restaurantName.charAt(0) }}
        </div>
      </div>
      <div>
        <h3 class="font-bold text-white text-lg leading-tight mb-1">
          {{ restaurantName }}
        </h3>
        <p class="text-sm text-gray-400">
          {{ address }}
        </p>
      </div>
    </div>

    <!-- Details -->
    <div class="space-y-4">
      <!-- Guests -->
      <div class="flex justify-between items-center text-sm">
        <span class="text-gray-400 font-medium">Guests</span>
        <span class="text-white font-bold text-lg">
          {{ guestCount || '-' }}
        </span>
      </div>

      <!-- Date -->
      <div class="flex justify-between items-center text-sm">
        <span class="text-gray-400 font-medium">Date</span>
        <span class="text-white font-medium text-right">
          {{ date ? format(date, 'EEE. d. MMM.') : '-' }}
        </span>
      </div>

      <!-- Time -->
      <div v-if="time" class="flex justify-between items-center text-sm">
        <span class="text-gray-400 font-medium">Time</span>
        <span class="text-white font-medium">
          {{ time }}
        </span>
      </div>
    </div>
  </div>
</template>
