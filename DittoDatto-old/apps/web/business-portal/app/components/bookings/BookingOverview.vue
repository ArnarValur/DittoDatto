<script setup lang="ts">
/**
 * BookingOverview — Time-grid staff × time calendar.
 *
 * - Time gutter on the left
 * - Staff columns with booking blocks positioned by time
 * - Blocks sized proportionally to duration
 * - Grid lines at configurable intervals
 * - Current-time indicator (today only)
 * - Auto-scroll to current time
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

export interface StaffMember {
  id: string;
  name: string;
  avatar: string | null;
  color: string;
}

const props = withDefaults(
  defineProps<{
    bookings: BookingSlot[];
    staff: StaffMember[];
    date: Date;
    slotInterval?: number;
    pixelsPerMinute?: number;
    dayStartHour?: number;
    dayEndHour?: number;
  }>(),
  { slotInterval: 30, pixelsPerMinute: 2, dayStartHour: 8, dayEndHour: 20 },
);

const emit = defineEmits<{
  "booking-click": [booking: BookingSlot];
  "date-change": [date: Date];
  "slot-click": [payload: { staffId: string; hour: number; minute: number }];
}>();

const scrollRef = ref<HTMLElement | null>(null);

// ---- Date ----
const formattedDate = computed(() =>
  props.date.toLocaleDateString("nb-NO", {
    weekday: "long", day: "numeric", month: "long", year: "numeric",
  }),
);
const isToday = computed(() => {
  const n = new Date();
  return props.date.getFullYear() === n.getFullYear() &&
    props.date.getMonth() === n.getMonth() &&
    props.date.getDate() === n.getDate();
});
function goToday() { emit("date-change", new Date()); }
function goPrev() { const d = new Date(props.date); d.setDate(d.getDate() - 1); emit("date-change", d); }
function goNext() { const d = new Date(props.date); d.setDate(d.getDate() + 1); emit("date-change", d); }

// ---- Time grid ----
const totalMinutes = computed(() => (props.dayEndHour - props.dayStartHour) * 60);
const totalHeight = computed(() => totalMinutes.value * props.pixelsPerMinute);

const timeSlots = computed(() => {
  const slots: Array<{ label: string; top: number; isHour: boolean }> = [];
  for (let h = props.dayStartHour; h < props.dayEndHour; h++) {
    for (let m = 0; m < 60; m += props.slotInterval) {
      slots.push({
        label: `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}`,
        top: ((h - props.dayStartHour) * 60 + m) * props.pixelsPerMinute,
        isHour: m === 0,
      });
    }
  }
  return slots;
});

const gridCols = computed(() => ({
  gridTemplateColumns: `56px repeat(${Math.max(props.staff.length, 1)}, minmax(140px, 1fr))`,
}));

// ---- Bookings by staff ----
const bookingsByStaff = computed(() => {
  const map: Record<string, BookingSlot[]> = {};
  for (const s of props.staff) map[s.id] = [];
  
  // Filter out cancelled bookings from the daily schedule grid to prevent visual stacking
  const activeBookings = props.bookings.filter(b => b.status !== "cancelled");

  for (const b of activeBookings) {
    if (map[b.staffId]) {
      map[b.staffId].push(b);
    } else if (map['_unassigned']) {
      // Booking references a staffId not in current columns — keep it visible
      map['_unassigned'].push(b);
    }
  }
  for (const k of Object.keys(map)) map[k].sort((a, b) => a.startTime.localeCompare(b.startTime));
  return map;
});

// ---- Block positioning ----
function extractMin(iso: string): number {
  const m = iso.match(/T(\d{2}):(\d{2})/);
  return m ? parseInt(m[1]) * 60 + parseInt(m[2]) : 0;
}
function extractHHMM(iso: string): string {
  const m = iso.match(/T(\d{2}:\d{2})/);
  return m ? m[1] : "—";
}
function hexToRgba(hex: string, a: number): string {
  const r = parseInt(hex.slice(1, 3), 16), g = parseInt(hex.slice(3, 5), 16), b = parseInt(hex.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${a})`;
}
function blockStyle(b: BookingSlot, color: string) {
  const s = Math.max(0, extractMin(b.startTime) - props.dayStartHour * 60);
  const e = Math.min(totalMinutes.value, extractMin(b.endTime) - props.dayStartHour * 60);
  return {
    top: `${s * props.pixelsPerMinute}px`,
    height: `${Math.max((e - s) * props.pixelsPerMinute, 28)}px`,
    borderLeftColor: color,
    backgroundColor: hexToRgba(color, 0.13),
  };
}

// ---- Now indicator ----
const nowTop = ref<number | null>(null);
function updateNow() {
  if (!isToday.value) { nowTop.value = null; return; }
  const n = new Date();
  const m = n.getHours() * 60 + n.getMinutes() - props.dayStartHour * 60;
  nowTop.value = (m >= 0 && m <= totalMinutes.value) ? m * props.pixelsPerMinute : null;
}
let nowTimer: ReturnType<typeof setInterval> | null = null;
onMounted(() => {
  updateNow();
  nowTimer = setInterval(updateNow, 60_000);
  nextTick(() => {
    if (!scrollRef.value) return;
    scrollRef.value.scrollTop = nowTop.value !== null
      ? Math.max(0, nowTop.value - 120)
      : 60 * props.pixelsPerMinute;
  });
});
onUnmounted(() => { if (nowTimer) clearInterval(nowTimer); });

// ---- Stats ----
const stats = computed(() => ({
  total: props.bookings.length,
  confirmed: props.bookings.filter((b) => b.status === "confirmed").length,
}));

function statusColor(s: string) {
  return { confirmed: "primary", completed: "success", pending: "warning", "no-show": "error", cancelled: "error" }[s] || "neutral";
}
function formatPrice(a: number | undefined, c?: string): string {
  if (!a) return "";
  return new Intl.NumberFormat("nb-NO", { style: "currency", currency: c || "NOK" }).format(a);
}
</script>

<template>
  <div class="booking-overview">
    <!-- Top bar -->
    <div class="flex items-center justify-between flex-wrap gap-3 mb-4">
      <div class="flex items-center gap-2">
        <button class="bo-nav-btn" :class="{ 'bo-nav-btn--active': isToday }" @click="goToday">I dag</button>
        <button class="bo-nav-btn" @click="goPrev">‹</button>
        <button class="bo-nav-btn" @click="goNext">›</button>
        <span class="bo-date-label">{{ formattedDate }}</span>
      </div>
      <div class="flex items-center gap-4 text-sm text-muted">
        <span><span class="font-bold text-default">{{ stats.total }}</span> totalt</span>
        <span><span class="font-bold text-green-500">{{ stats.confirmed }}</span> bekreftet</span>
      </div>
    </div>

    <!-- Schedule grid -->
    <div class="bo-schedule">
      <div v-if="!staff.length && !bookings.length" class="text-center py-12 text-muted">
        <span class="text-3xl mb-3 block">📅</span>
        <p class="font-medium">Ingen bestillinger for denne dagen</p>
      </div>

      <template v-else>
        <div ref="scrollRef" class="bo-scroll">
          <!-- Sticky header -->
          <div class="bo-header" :style="gridCols">
            <div class="bo-header__gutter"></div>
            <div v-for="m in staff" :key="'h-' + m.id" class="bo-header__col">
              <div class="bo-avatar" :style="{ backgroundColor: hexToRgba(m.color, 0.15), color: m.color }">
                <img v-if="m.avatar" :src="m.avatar" :alt="m.name" class="bo-avatar__img" />
                <span v-else class="bo-avatar__initials">
                  {{ m.name.split(' ').map((n: string) => n[0]).join('').slice(0, 2).toUpperCase() }}
                </span>
              </div>
              <span class="bo-header__name">{{ m.name }}</span>
              <UBadge
                v-if="bookingsByStaff[m.id]?.length"
                :color="m.id === '_unassigned' ? 'warning' : 'primary'"
                variant="subtle" size="xs"
              >{{ bookingsByStaff[m.id].length }}</UBadge>
            </div>
          </div>

          <!-- Grid body -->
          <div class="bo-body" :style="{ height: totalHeight + 'px' }">
            <!-- Grid lines -->
            <div class="bo-gridlines">
              <div
                v-for="(slot, i) in timeSlots" :key="'gl-' + i"
                class="bo-gridline" :class="{ 'bo-gridline--hour': slot.isHour }"
                :style="{ top: slot.top + 'px' }"
              />
            </div>

            <!-- Columns -->
            <div class="bo-columns" :style="gridCols">
              <div class="bo-gutter">
                <div
                  v-for="(slot, i) in timeSlots" :key="'tl-' + i"
                  class="bo-gutter__label" :class="{ 'bo-gutter__label--hour': slot.isHour }"
                  :style="{ top: slot.top + 'px' }"
                >{{ slot.label }}</div>
              </div>
              <div v-for="m in staff" :key="'col-' + m.id" class="bo-col">
                <div
                  v-for="b in bookingsByStaff[m.id]" :key="b.id"
                  class="bo-block" :style="blockStyle(b, m.color)"
                  @click="emit('booking-click', b)"
                >
                  <div class="bo-block__top">
                    <span class="bo-block__time">{{ extractHHMM(b.startTime) }}–{{ extractHHMM(b.endTime) }}</span>
                    <UBadge :color="statusColor(b.status)" variant="subtle" size="xs">{{ b.status }}</UBadge>
                  </div>
                  <div class="bo-block__title">{{ b.serviceTitle }}</div>
                  <div class="bo-block__customer">{{ b.customerName }}</div>
                  <div v-if="b.price" class="bo-block__meta">
                    <span>{{ b.duration }} min</span>
                    <span class="bo-block__price">{{ formatPrice(b.price, b.currency) }}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Now line -->
            <div v-if="nowTop !== null" class="bo-now" :style="{ top: nowTop + 'px' }">
              <div class="bo-now__dot" />
              <div class="bo-now__line" />
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<style scoped>
.booking-overview { width: 100%; flex: 1; display: flex; flex-direction: column; min-height: 0; }

/* ---- Nav ---- */
.bo-nav-btn {
  display: inline-flex; align-items: center; justify-content: center;
  min-width: 32px; height: 32px; padding: 0 10px;
  border: 1px solid var(--ui-border-color, rgba(255,255,255,0.1));
  border-radius: 6px; background: transparent;
  color: var(--ui-text-muted, #999); font-size: 0.8rem; font-weight: 500;
  cursor: pointer; transition: all 0.15s ease; font-family: inherit;
}
.bo-nav-btn:hover {
  background: var(--ui-bg-elevated, rgba(255,255,255,0.05));
  border-color: rgba(255,255,255,0.15);
}
.bo-nav-btn--active {
  background: var(--color-primary-DEFAULT, #6366f1);
  color: white; border-color: var(--color-primary-DEFAULT, #6366f1);
}
.bo-date-label { font-size: 0.9rem; font-weight: 600; margin-left: 8px; text-transform: capitalize; }

/* ---- Schedule frame ---- */
.bo-schedule {
  border: 1px solid var(--ui-border-color, rgba(255,255,255,0.08));
  border-radius: 12px; overflow: hidden;
  background: var(--ui-bg, #0a0a0a);
  flex: 1; display: flex; flex-direction: column; min-height: 0;
}
.bo-scroll { overflow: auto; flex: 1; min-height: 0; }

/* ---- Header ---- */
.bo-header {
  display: grid; position: sticky; top: 0; z-index: 10;
  background: var(--ui-bg-elevated, #141414);
  border-bottom: 1px solid var(--ui-border-color, rgba(255,255,255,0.1));
}
.bo-header__gutter {
  border-right: 1px solid var(--ui-border-color, rgba(255,255,255,0.08));
}
.bo-header__col {
  display: flex; align-items: center; gap: 8px; padding: 10px 12px;
  border-right: 1px solid var(--ui-border-color, rgba(255,255,255,0.06));
  min-width: 0;
}
.bo-header__col:last-child { border-right: none; }
.bo-header__name {
  font-size: 0.8rem; font-weight: 600;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.bo-avatar {
  width: 28px; height: 28px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0; overflow: hidden;
}
.bo-avatar__img { width: 100%; height: 100%; object-fit: cover; }
.bo-avatar__initials { font-size: 10px; font-weight: 700; }

/* ---- Grid body ---- */
.bo-body { position: relative; }

/* ---- Grid lines ---- */
.bo-gridlines { position: absolute; inset: 0; z-index: 0; pointer-events: none; }
.bo-gridline {
  position: absolute; left: 56px; right: 0; height: 0;
  border-top: 1px solid var(--ui-border-color, rgba(255,255,255,0.04));
}
.bo-gridline--hour { border-top-color: rgba(255,255,255,0.1); }

/* ---- Columns ---- */
.bo-columns { display: grid; position: absolute; inset: 0; z-index: 1; }

/* ---- Time gutter ---- */
.bo-gutter {
  position: relative;
  border-right: 1px solid var(--ui-border-color, rgba(255,255,255,0.08));
}
.bo-gutter__label {
  position: absolute; right: 8px; transform: translateY(-50%);
  font-size: 0.65rem; font-weight: 400;
  color: var(--ui-text-muted, rgba(255,255,255,0.25));
  white-space: nowrap; line-height: 1;
}
.bo-gutter__label--hour {
  font-size: 0.7rem; font-weight: 600;
  color: var(--ui-text-muted, rgba(255,255,255,0.5));
}

/* ---- Staff column ---- */
.bo-col {
  position: relative;
  border-right: 1px solid var(--ui-border-color, rgba(255,255,255,0.04));
}
.bo-col:last-child { border-right: none; }

/* ---- Booking block ---- */
.bo-block {
  position: absolute; left: 3px; right: 3px;
  border-radius: 6px; border-left: 3px solid;
  padding: 4px 8px; cursor: pointer; overflow: hidden;
  transition: box-shadow 0.15s ease, transform 0.1s ease;
  z-index: 1;
}
.bo-block:hover {
  box-shadow: 0 2px 12px rgba(0,0,0,0.35);
  transform: translateX(1px); z-index: 3;
}
.bo-block__top { display: flex; align-items: center; justify-content: space-between; gap: 4px; }
.bo-block__time { font-size: 0.75rem; font-weight: 600; white-space: nowrap; }
.bo-block__title {
  font-size: 0.7rem; font-weight: 500;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 1px;
}
.bo-block__customer {
  font-size: 0.65rem; color: var(--ui-text-muted, #888);
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.bo-block__meta {
  display: flex; justify-content: space-between;
  font-size: 0.65rem; color: var(--ui-text-muted, #888); margin-top: 2px;
}
.bo-block__price { font-weight: 600; color: var(--color-primary-DEFAULT, #10b981); }

/* ---- Now indicator ---- */
.bo-now {
  position: absolute; left: 56px; right: 0;
  z-index: 5; pointer-events: none; display: flex; align-items: center;
}
.bo-now__dot {
  width: 10px; height: 10px; border-radius: 50%;
  background: var(--color-primary-DEFAULT, #10b981);
  margin-left: -5px; flex-shrink: 0;
  box-shadow: 0 0 6px var(--color-primary-DEFAULT, #10b981);
}
.bo-now__line {
  flex: 1; height: 2px;
  background: var(--color-primary-DEFAULT, #10b981); opacity: 0.6;
}

@media (max-width: 768px) {
  .bo-date-label { font-size: 0.8rem; }
}
</style>
