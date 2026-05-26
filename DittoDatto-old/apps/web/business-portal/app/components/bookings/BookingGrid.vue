<script setup lang="ts">
/**
 * BookingGrid — CSS Grid with time gutter + staff columns.
 * Inner Y-axis scroll, sticky staff headers, booking cards positioned absolutely.
 */
import type { BookingSlot } from "./BookingCard.vue";

export interface StaffMember {
  id: string;
  name: string;
  avatar?: string | null;
  color?: string;
}

const props = withDefaults(
  defineProps<{
    bookings: BookingSlot[];
    staff: StaffMember[];
    startHour: number;
    endHour: number;
    slotInterval?: number;
    pixelsPerMinute?: number;
    currentTimeMinutes?: number | null;
  }>(),
  {
    slotInterval: 30,
    pixelsPerMinute: 1.6,
    currentTimeMinutes: null,
  },
);

const emit = defineEmits<{
  "booking-click": [booking: BookingSlot];
  "slot-click": [payload: { staffId: string; hour: number; minute: number }];
}>();

// Generate time slot labels
const timeSlots = computed(() => {
  const slots: { hour: number; minute: number; label: string }[] = [];
  for (let h = props.startHour; h <= props.endHour; h++) {
    for (let m = 0; m < 60; m += props.slotInterval) {
      if (h === props.endHour && m > 0) break;
      slots.push({
        hour: h,
        minute: m,
        label: `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}`,
      });
    }
  }
  return slots;
});

// Total grid height
const totalMinutes = computed(() => (props.endHour - props.startHour) * 60);
const gridHeight = computed(() => totalMinutes.value * props.pixelsPerMinute);

// Slot height for gridline spacing
const slotHeightPx = computed(() => props.slotInterval * props.pixelsPerMinute);

// Group bookings by staffId
const bookingsByStaff = computed(() => {
  const map: Record<string, BookingSlot[]> = {};
  for (const s of props.staff) {
    map[s.id] = [];
  }
  for (const b of props.bookings) {
    if (map[b.staffId]) {
      map[b.staffId].push(b);
    }
  }
  return map;
});

// Staff color from palette (fallback)
const DEFAULT_PALETTE = [
  "#97a4e2", // moody-blue-400
  "#abbbce", // pickled-bluewood-300
  "#6ee7bf", // mountain-meadow-300
  "#fdba74", // orange-peel-300
  "#fea4b3", // radical-red-300
  "#b5c2ec", // moody-blue-300
];

function getStaffColor(staff: StaffMember, index: number): string {
  return staff.color || DEFAULT_PALETTE[index % DEFAULT_PALETTE.length];
}

// Current time indicator position
const currentTimeTop = computed(() => {
  if (props.currentTimeMinutes == null) return null;
  const gridStartMinutes = props.startHour * 60;
  const offset = props.currentTimeMinutes - gridStartMinutes;
  if (offset < 0 || offset > totalMinutes.value) return null;
  return offset * props.pixelsPerMinute;
});

// Grid columns template
const gridColumnStyle = computed(() => ({
  gridTemplateColumns: `3.5rem repeat(${props.staff.length}, 1fr)`,
}));

// Initials fallback
function getInitials(name: string): string {
  return name
    .split(" ")
    .map((w) => w[0])
    .join("")
    .toUpperCase()
    .slice(0, 2);
}
</script>

<template>
  <div class="booking-grid">
    <!-- Sticky staff header row -->
    <div class="booking-grid__header" :style="gridColumnStyle">
      <!-- Empty gutter cell -->
      <div class="booking-grid__gutter-header" />
      <!-- Staff column headers -->
      <div
        v-for="(member, i) in staff"
        :key="member.id"
        class="booking-grid__staff-header"
      >
        <div
          class="booking-grid__avatar"
          :style="{ backgroundColor: getStaffColor(member, i) + '44' }"
        >
          <img
            v-if="member.avatar"
            :src="member.avatar"
            :alt="member.name"
            class="booking-grid__avatar-img"
          />
          <span v-else class="booking-grid__avatar-initials">
            {{ getInitials(member.name) }}
          </span>
        </div>
        <span class="booking-grid__staff-name">{{ member.name }}</span>
      </div>
    </div>

    <!-- Scrollable time body -->
    <div class="booking-grid__body" :style="gridColumnStyle">
      <!-- Time gutter column -->
      <div class="booking-grid__gutter" :style="{ height: `${gridHeight}px` }">
        <div
          v-for="slot in timeSlots"
          :key="`${slot.hour}-${slot.minute}`"
          class="booking-grid__time-label"
          :style="{
            top: `${((slot.hour - startHour) * 60 + slot.minute) * pixelsPerMinute}px`,
            height: `${slotHeightPx}px`,
          }"
        >
          <span>{{ slot.label }}</span>
        </div>
      </div>

      <!-- Staff columns -->
      <div
        v-for="(member, i) in staff"
        :key="member.id"
        class="booking-grid__column"
        :style="{ height: `${gridHeight}px` }"
      >
        <!-- Gridlines -->
        <div
          v-for="slot in timeSlots"
          :key="`line-${slot.hour}-${slot.minute}`"
          class="booking-grid__gridline"
          :class="{ 'booking-grid__gridline--hour': slot.minute === 0 }"
          :style="{
            top: `${((slot.hour - startHour) * 60 + slot.minute) * pixelsPerMinute}px`,
          }"
          @click="
            emit('slot-click', {
              staffId: member.id,
              hour: slot.hour,
              minute: slot.minute,
            })
          "
        />

        <!-- Booking cards -->
        <BookingsBookingCard
          v-for="booking in bookingsByStaff[member.id]"
          :key="booking.id"
          :booking="booking"
          :color="getStaffColor(member, i)"
          :pixels-per-minute="pixelsPerMinute"
          :grid-start-hour="startHour"
          @click="emit('booking-click', $event)"
        />
      </div>

      <!-- Current time indicator -->
      <div
        v-if="currentTimeTop != null"
        class="booking-grid__now-line"
        :style="{
          top: `${currentTimeTop}px`,
          gridColumn: `1 / -1`,
        }"
      >
        <div class="booking-grid__now-dot" />
        <div class="booking-grid__now-rule" />
      </div>
    </div>
  </div>
</template>

<style scoped>
.booking-grid {
  display: flex;
  flex-direction: column;
  min-width: 0;
  overflow: hidden;
  border: 1px solid var(--color-jumbo-200);
  border-radius: 8px;
  background: var(--ui-bg, #fafafa);
}

.dark .booking-grid {
  border-color: var(--color-jumbo-700);
  background: var(--color-jumbo-900);
}

/* ---- Header ---- */
.booking-grid__header {
  display: grid;
  position: sticky;
  top: 0;
  z-index: 10;
  border-bottom: 1px solid var(--color-jumbo-200);
  background: var(--ui-bg, #fafafa);
}

.dark .booking-grid__header {
  border-bottom-color: var(--color-jumbo-700);
  background: var(--color-jumbo-900);
}

.booking-grid__gutter-header {
  /* empty top-left corner */
}

.booking-grid__staff-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 10px 4px 8px;
  border-left: 1px solid var(--color-jumbo-200);
}

.dark .booking-grid__staff-header {
  border-left-color: var(--color-jumbo-700);
}

.booking-grid__avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  font-size: 0.7rem;
  font-weight: 700;
}

.booking-grid__avatar-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.booking-grid__avatar-initials {
  color: var(--color-jumbo-700);
}

.dark .booking-grid__avatar-initials {
  color: var(--color-jumbo-200);
}

.booking-grid__staff-name {
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--color-jumbo-800);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}

.dark .booking-grid__staff-name {
  color: var(--color-jumbo-200);
}

/* ---- Body (scrollable) ---- */
.booking-grid__body {
  display: grid;
  position: relative;
  overflow-y: auto;
  overflow-x: hidden;
  max-height: calc(100vh - 220px);
  scrollbar-width: thin;
}

/* ---- Time Gutter ---- */
.booking-grid__gutter {
  position: relative;
  border-right: 1px solid var(--color-jumbo-200);
}

.dark .booking-grid__gutter {
  border-right-color: var(--color-jumbo-700);
}

.booking-grid__time-label {
  position: absolute;
  left: 0;
  right: 0;
  display: flex;
  align-items: flex-start;
  justify-content: flex-end;
  padding: 0 6px;
}

.booking-grid__time-label span {
  font-size: 0.65rem;
  font-weight: 500;
  color: var(--color-jumbo-400);
  transform: translateY(-0.4em);
  user-select: none;
}

/* ---- Staff Columns ---- */
.booking-grid__column {
  position: relative;
  border-left: 1px solid var(--color-jumbo-200);
  min-width: 120px;
}

.dark .booking-grid__column {
  border-left-color: var(--color-jumbo-700);
}

/* ---- Gridlines ---- */
.booking-grid__gridline {
  position: absolute;
  left: 0;
  right: 0;
  height: 1px;
  border-top: 1px dashed var(--color-jumbo-100);
  cursor: pointer;
}

.booking-grid__gridline--hour {
  border-top: 1px solid var(--color-jumbo-200);
}

.dark .booking-grid__gridline {
  border-top-color: var(--color-jumbo-800);
}

.dark .booking-grid__gridline--hour {
  border-top-color: var(--color-jumbo-700);
}

/* ---- Now Line ---- */
.booking-grid__now-line {
  position: absolute;
  left: 0;
  right: 0;
  z-index: 8;
  display: flex;
  align-items: center;
  pointer-events: none;
}

.booking-grid__now-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--color-radical-red-500);
  flex-shrink: 0;
  margin-left: 3rem;
}

.booking-grid__now-rule {
  flex: 1;
  height: 2px;
  background: var(--color-radical-red-500);
  opacity: 0.7;
}

/* ---- Responsive ---- */
@media (max-width: 768px) {
  .booking-grid__body {
    overflow-x: auto;
    max-height: calc(100vh - 200px);
  }

  .booking-grid__column {
    min-width: 100px;
  }

  .booking-grid__avatar {
    width: 28px;
    height: 28px;
    font-size: 0.6rem;
  }

  .booking-grid__staff-name {
    font-size: 0.65rem;
  }
}
</style>
