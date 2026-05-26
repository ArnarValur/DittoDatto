
<script setup lang="ts">
/**
 * BookingCard.vue
 * A card component to display a summary of a single booking.
 * Used on the '/profile/bookings' page.
 */
import type { Booking } from '@dittodatto/shared-types';

interface Props {
  booking: Booking;
}

const props = defineProps<Props>();

const emit = defineEmits<{
  (e: 'cancel', bookingId: string): void;
  (e: 'review', bookingId: string): void;
}>();

const isPast = computed(() => new Date(props.booking.startTime) < new Date());

// Formatters
const formattedDate = computed(() => {
    return new Date(props.booking.startTime).toLocaleDateString('en-US', {
        weekday: 'long',
        month: 'long',
        day: 'numeric',
    });
});

const formattedTime = computed(() => {
    return new Date(props.booking.startTime).toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
    });
});

</script>

<template>
  <div class="p-4 rounded-xl border border-default bg-white dark:bg-gray-800 shadow-sm transition-all hover:shadow-md">
    <div class="flex gap-4">
      <!-- Icon/Image Placeholder -->
      <div class="shrink-0 size-16 rounded-lg bg-muted/30 flex items-center justify-center">
        <!-- You can later bind an actual image here, e.g., from the store or service -->
        <UIcon name="i-lucide-store" class="size-8 text-muted" />
      </div>

      <!-- Booking Details -->
      <div class="flex-grow">
        <p class="font-bold text-lg text-gray-900 dark:text-white">{{ booking.serviceSnapshot.title }}</p>
        <p class="text-sm font-medium text-primary">{{ booking.storeSnapshot.name }}</p>
        <div class="mt-1 text-sm text-muted flex items-center gap-2">
            <UIcon name="i-lucide-calendar" class="size-4" />
            <span>{{ formattedDate }}</span>
            <span class="text-gray-300 dark:text-gray-600">•</span>
            <UIcon name="i-lucide-clock" class="size-4" />
            <span>{{ formattedTime }}</span>
        </div>
      </div>
    </div>
    
    <!-- Actions (Footer) -->
    <div v-if="!isPast" class="mt-4 pt-4 border-t border-default flex items-center justify-end gap-2">
        <UButton
            label="Cancel"
            color="warning"
            variant="outline"
            size="sm"
            disabled
            @click="emit('cancel', booking.id)"
        />
        <UButton
            label="Reschedule"
            color="neutral"
            variant="ghost"
            size="sm"
            disabled
        />
        <p class="text-xs text-muted mr-auto italic">Cancellation & Rescheduling coming soon</p>
    </div>
    
    <div v-if="isPast" class="mt-4 pt-4 border-t border-default flex items-center justify-end gap-2">
         <UButton
            label="Leave a Review"
            color="info"
            variant="outline"
            size="sm"
            icon="i-lucide-star"
            disabled
            @click="emit('review', booking.id)"
        />
        <UButton
            label="Book Again"
            color="primary"
            variant="solid"
            size="sm"
            disabled
        />
    </div>
  </div>
</template>
