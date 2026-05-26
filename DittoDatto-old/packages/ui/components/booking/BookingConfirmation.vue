
<script setup lang="ts">
/**
 * BookingConfirmation.vue
 * A modal that displays the summary of a successfully created booking.
 */

export interface BookingDetails {
  id: string;
  serviceTitle: string;
  storeName: string;
  storeAddress?: string;
  startTime: string; // ISO string format
  endTime: string;   // ISO string format
  price: number;
  currency: string;
}

interface Props {
  booking: BookingDetails;
}

const props = defineProps<Props>();

const emit = defineEmits<{
  (e: 'view-bookings'): void;
  (e: 'done'): void;
}>();

/**
 * Generates a Google Calendar link for the booking.
 */
function generateCalendarUrl(booking: BookingDetails): string {
  try {
    const toISO = (val: string | Date) => {
      const d = val instanceof Date ? val : new Date(val)
      return d.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z'
    }
    
    const params = new URLSearchParams({
      action: 'TEMPLATE',
      text: `${booking.serviceTitle || 'Booking'} at ${booking.storeName || ''}`,
      dates: `${toISO(booking.startTime)}/${toISO(booking.endTime)}`,
      location: booking.storeAddress || '',
      details: `Booking Reference: #${(booking.id || '').substring(0, 8).toUpperCase()}`
    });
    
    return `https://calendar.google.com/calendar/render?${params}`;
  } catch {
    return '#'
  }
}

// Formatted properties for display
const formattedDate = computed(() => {
  try {
    const d = props.booking.startTime instanceof Date 
      ? props.booking.startTime 
      : new Date(props.booking.startTime)
    return d.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  } catch { return '' }
});

const formattedTime = computed(() => {
  try {
    const toTime = (val: string | Date) => {
      const d = val instanceof Date ? val : new Date(val)
      return d.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: false })
    }
    return `${toTime(props.booking.startTime)} - ${toTime(props.booking.endTime)}`;
  } catch { return '' }
});

const formattedPrice = computed(() => {
  try {
    return new Intl.NumberFormat('en-US', { style: 'currency', currency: props.booking.currency || 'USD' }).format(props.booking.price || 0);
  } catch { return '' }
});

const calendarLink = computed(() => generateCalendarUrl(props.booking));
const bookingReference = computed(() => (props.booking.id || '').substring(0, 8).toUpperCase());

</script>

<template>
  <div class="p-6 text-center">
    <!-- Icon and Title -->
    <div class="mb-4">
      <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100">
        <UIcon name="i-lucide-check" class="h-6 w-6 text-green-600" />
      </div>
      <h3 class="mt-4 text-2xl font-semibold leading-6 text-gray-900 dark:text-white">Booking Confirmed!</h3>
    </div>

    <!-- Store Info -->
    <div class="p-4 my-5 rounded-xl bg-muted/30 border border-default text-left">
        <p class="font-bold text-lg">{{ booking.storeName }}</p>
        <p v-if="booking.storeAddress" class="text-sm text-muted">{{ booking.storeAddress }}</p>
    </div>

    <!-- Booking Details -->
    <div class="space-y-3 text-left">
      <div class="flex items-center">
        <UIcon name="i-lucide-calendar-days" class="size-5 text-muted mr-3" />
        <span class="font-medium">{{ formattedDate }}</span>
      </div>
      <div class="flex items-center">
        <UIcon name="i-lucide-clock" class="size-5 text-muted mr-3" />
        <span class="font-medium">{{ formattedTime }}</span>
      </div>
      <div class="flex items-center">
        <UIcon name="i-lucide-scissors" class="size-5 text-muted mr-3" />
        <span class="font-medium">{{ booking.serviceTitle }}</span>
      </div>
      <div class="flex items-center">
        <UIcon name="i-lucide-tag" class="size-5 text-muted mr-3" />
        <span class="font-medium">{{ formattedPrice }}</span>
      </div>
    </div>
    
    <UDivider class="my-5" />

    <!-- Booking Reference -->
    <div class="text-sm text-muted">
      Booking Reference: <span class="font-mono bg-muted/40 px-2 py-1 rounded">{{ bookingReference }}</span>
    </div>

    <!-- Actions -->
    <div class="mt-8 space-y-3">
        <UButton
            :to="calendarLink"
            external
            target="_blank"
            block
            size="lg"
            color="primary"
            variant="solid"
            icon="i-lucide-calendar-plus"
            label="Add to Calendar"
        />
        <UButton
            block
            size="lg"
            color="primary"
            variant="outline"
            label="View My Bookings"
            @click="emit('view-bookings')"
        />
        <UButton
            block
            size="lg"
            color="neutral"
            variant="ghost"
            label="Done"
            @click="emit('done')"
        />
    </div>
  </div>
</template>
