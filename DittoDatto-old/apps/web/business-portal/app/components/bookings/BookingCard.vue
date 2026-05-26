<script setup lang="ts">
/**
 * BookingCard — Individual appointment block in the schedule grid.
 * Positioned absolutely by the parent column based on startTime/duration.
 */
export interface BookingSlot {
  id: string;
  staffId: string;
  customerName: string;
  serviceTitle: string;
  startTime: string;
  endTime: string;
  duration: number;
  status: "confirmed" | "pending" | "completed" | "cancelled" | "no-show";
  price?: number;
  currency?: string;
}

const props = defineProps<{
  booking: BookingSlot;
  color: string;
  pixelsPerMinute: number;
  gridStartHour: number;
}>();

const emit = defineEmits<{
  click: [booking: BookingSlot];
}>();

// Position calculations
const topPx = computed(() => {
  const d = new Date(props.booking.startTime);
  const minutesFromGridStart =
    (d.getHours() - props.gridStartHour) * 60 + d.getMinutes();
  return minutesFromGridStart * props.pixelsPerMinute;
});

const heightPx = computed(() => {
  return Math.max(props.booking.duration * props.pixelsPerMinute, 24);
});

const timeLabel = computed(() => {
  const d = new Date(props.booking.startTime);
  return d.toLocaleTimeString("nb-NO", { hour: "2-digit", minute: "2-digit" });
});

const isCompact = computed(() => heightPx.value < 48);
const isCancelled = computed(
  () =>
    props.booking.status === "cancelled" || props.booking.status === "no-show",
);

const cardStyle = computed(() => {
  const alpha = isCancelled.value ? "30" : "88";
  return {
    top: `${topPx.value}px`,
    height: `${heightPx.value}px`,
    backgroundColor: `${props.color}${alpha}`,
    borderLeftColor: props.color,
  };
});
</script>

<template>
  <button
    class="booking-card"
    :class="{
      'booking-card--compact': isCompact,
      'booking-card--cancelled': isCancelled,
    }"
    :style="cardStyle"
    @click="emit('click', booking)"
  >
    <div class="booking-card__content">
      <span class="booking-card__name">{{ booking.customerName }}</span>
      <span v-if="!isCompact" class="booking-card__meta">
        {{ timeLabel }} ({{ booking.duration }}m)
      </span>
      <span v-if="!isCompact && heightPx > 60" class="booking-card__service">
        {{ booking.serviceTitle }}
      </span>
    </div>

    <!-- Status dot for non-confirmed -->
    <span
      v-if="booking.status !== 'confirmed'"
      class="booking-card__status-dot"
      :class="`booking-card__status-dot--${booking.status}`"
      :title="booking.status"
    />
  </button>
</template>

<style scoped>
.booking-card {
  position: absolute;
  left: 2px;
  right: 2px;
  border-left: 3px solid;
  border-radius: 6px;
  padding: 4px 8px;
  cursor: pointer;
  overflow: hidden;
  z-index: 1;
  transition:
    box-shadow 0.15s ease,
    transform 0.1s ease;
  text-align: left;
  font-family: inherit;
  border-top: none;
  border-right: none;
  border-bottom: none;
}

.booking-card:hover {
  z-index: 5;
  box-shadow: 0 3px 12px rgba(0, 0, 0, 0.2);
  transform: scale(1.02);
}

.booking-card:active {
  transform: scale(0.99);
}

.booking-card--cancelled {
  opacity: 0.5;
  text-decoration: line-through;
}

.booking-card__content {
  display: flex;
  flex-direction: column;
  gap: 1px;
  min-width: 0;
}

.booking-card--compact .booking-card__content {
  flex-direction: row;
  align-items: center;
  gap: 6px;
}

.booking-card__name {
  font-size: 0.8rem;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  color: var(--color-jumbo-950);
}

.dark .booking-card__name {
  color: var(--color-jumbo-50);
}

.booking-card__meta {
  font-size: 0.7rem;
  font-weight: 500;
  opacity: 0.85;
  white-space: nowrap;
  color: var(--color-jumbo-800);
}

.dark .booking-card__meta {
  color: var(--color-jumbo-200);
}

.booking-card__service {
  font-size: 0.625rem;
  opacity: 0.65;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  color: var(--color-jumbo-700);
}

.dark .booking-card__service {
  color: var(--color-jumbo-300);
}

.booking-card__status-dot {
  position: absolute;
  top: 4px;
  right: 4px;
  width: 6px;
  height: 6px;
  border-radius: 50%;
}

.booking-card__status-dot--pending {
  background-color: var(--color-orange-peel-500);
}

.booking-card__status-dot--completed {
  background-color: var(--color-mountain-meadow-500);
}

.booking-card__status-dot--cancelled {
  background-color: var(--color-radical-red-500);
}

.booking-card__status-dot--no-show {
  background-color: var(--color-radical-red-400);
}
</style>
