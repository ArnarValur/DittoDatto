<script setup lang="ts">
/**
 * ReservationOverview — Horizontal Gantt-style resource calendar.
 *
 * Inspired by Noona HQ's reservation view:
 * - Rows = tables/resources (grouped by room/area)
 * - Horizontal axis = time
 * - Booking blocks positioned horizontally by time range
 * - Room groups are collapsible sections
 * - Now-indicator as vertical line
 */

export interface ReservationSlot {
  id: string;
  resourceId: string;
  customerName: string;
  serviceTitle: string;
  startTime: string;
  endTime: string;
  duration: number;
  status: "confirmed" | "pending" | "completed" | "cancelled" | "no-show";
  partySize?: number;
  price?: number;
  currency?: string;
}

export interface ResourceColumn {
  id: string;
  name: string;
  type: string;
  color: string;
  groupId?: string;
  capacity: { min: number; max: number };
}

export interface ResourceGroupInfo {
  id: string;
  name: string;
  resourceCount: number;
}

const props = withDefaults(
  defineProps<{
    bookings: ReservationSlot[];
    resources: ResourceColumn[];
    groups: ResourceGroupInfo[];
    date: Date;
    pixelsPerMinute?: number;
    dayStartHour?: number;
    dayEndHour?: number;
  }>(),
  { pixelsPerMinute: 2.5, dayStartHour: 10, dayEndHour: 23 },
);

const emit = defineEmits<{
  "booking-click": [booking: ReservationSlot];
  "date-change": [date: Date];
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

// ---- Time calculations ----
const totalMinutes = computed(() => (props.dayEndHour - props.dayStartHour) * 60);
const totalWidth = computed(() => totalMinutes.value * props.pixelsPerMinute);

const ROW_HEIGHT = 44;
const GROUP_HEADER_HEIGHT = 36;
const SIDEBAR_WIDTH = 160;

// Hour markers for the top ruler
const hourMarkers = computed(() => {
  const markers: Array<{ label: string; left: number; isHour: boolean }> = [];
  for (let h = props.dayStartHour; h <= props.dayEndHour; h++) {
    markers.push({
      label: `${String(h).padStart(2, "0")}:00`,
      left: (h - props.dayStartHour) * 60 * props.pixelsPerMinute,
      isHour: true,
    });
  }
  return markers;
});

// ---- Group collapse ----
const collapsedGroups = ref<Set<string>>(new Set());
function toggleGroup(groupId: string) {
  const next = new Set(collapsedGroups.value);
  if (next.has(groupId)) next.delete(groupId);
  else next.add(groupId);
  collapsedGroups.value = next;
}

// ---- Resources grouped by room ----
const groupedResources = computed(() => {
  const result: Array<{
    group: ResourceGroupInfo | null;
    resources: ResourceColumn[];
  }> = [];

  // Resources with groups
  for (const g of props.groups) {
    const members = props.resources.filter((r) => r.groupId === g.id);
    if (members.length > 0) {
      result.push({ group: g, resources: members });
    }
  }

  // Ungrouped resources
  const grouped = new Set(props.groups.map((g) => g.id));
  const ungrouped = props.resources.filter(
    (r) => !r.groupId || !grouped.has(r.groupId),
  );
  if (ungrouped.length > 0) {
    result.push({ group: null, resources: ungrouped });
  }

  return result;
});

// ---- Bookings by resource ----
const bookingsByResource = computed(() => {
  const map: Record<string, ReservationSlot[]> = {};
  for (const r of props.resources) map[r.id] = [];
  for (const b of props.bookings) {
    if (map[b.resourceId]) map[b.resourceId].push(b);
  }
  return map;
});

// ---- Block positioning (horizontal) ----
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

function blockStyle(b: ReservationSlot, color: string) {
  const startMin = Math.max(0, extractMin(b.startTime) - props.dayStartHour * 60);
  const endMin = Math.min(totalMinutes.value, extractMin(b.endTime) - props.dayStartHour * 60);
  const left = startMin * props.pixelsPerMinute;
  const width = Math.max((endMin - startMin) * props.pixelsPerMinute, 40);
  return {
    left: `${left}px`,
    width: `${width}px`,
    borderLeftColor: color,
    backgroundColor: hexToRgba(color, 0.18),
    color: color,
  };
}

// ---- Status colors ----
const statusColors: Record<string, string> = {
  confirmed: "#10b981",
  pending: "#f59e0b",
  completed: "#6366f1",
  cancelled: "#ef4444",
  "no-show": "#ef4444",
};
function getStatusColor(status: string): string {
  return statusColors[status] || "#a1a1aa";
}

// ---- Now indicator ----
const nowLeft = ref<number | null>(null);
function updateNow() {
  if (!isToday.value) { nowLeft.value = null; return; }
  const n = new Date();
  const m = n.getHours() * 60 + n.getMinutes() - props.dayStartHour * 60;
  nowLeft.value = (m >= 0 && m <= totalMinutes.value) ? m * props.pixelsPerMinute : null;
}
let nowTimer: ReturnType<typeof setInterval> | null = null;
onMounted(() => {
  updateNow();
  nowTimer = setInterval(updateNow, 60_000);
  nextTick(() => {
    if (!scrollRef.value || nowLeft.value === null) return;
    scrollRef.value.scrollLeft = Math.max(0, nowLeft.value - 300);
  });
});
onUnmounted(() => { if (nowTimer) clearInterval(nowTimer); });

// ---- Stats ----
const stats = computed(() => ({
  total: props.bookings.length,
  confirmed: props.bookings.filter((b) => b.status === "confirmed").length,
}));

// ---- Type icons ----
const typeIcons: Record<string, string> = {
  table: "i-lucide-armchair",
  room: "i-lucide-door-open",
  station: "i-lucide-monitor",
  equipment: "i-lucide-wrench",
  addon: "i-lucide-package-plus",
};
</script>

<template>
  <div class="ro">
    <!-- Top bar -->
    <div class="flex items-center justify-between flex-wrap gap-3 mb-4">
      <div class="flex items-center gap-2">
        <button class="ro-nav-btn" :class="{ 'ro-nav-btn--active': isToday }" @click="goToday">I dag</button>
        <button class="ro-nav-btn" @click="goPrev">‹</button>
        <button class="ro-nav-btn" @click="goNext">›</button>
        <span class="ro-date-label">{{ formattedDate }}</span>
      </div>
      <div class="flex items-center gap-4 text-sm text-muted">
        <span><span class="font-bold text-default">{{ stats.total }}</span> reservasjoner</span>
        <span><span class="font-bold text-green-500">{{ stats.confirmed }}</span> bekreftet</span>
      </div>
    </div>

    <!-- Empty state -->
    <div v-if="!resources.length && !bookings.length" class="ro-empty">
      <span class="text-3xl mb-3 block">🪑</span>
      <p class="font-medium">Ingen reservasjoner for denne dagen</p>
    </div>

    <!-- Gantt layout -->
    <div v-else class="ro-gantt">
      <!-- Fixed sidebar (table names) -->
      <div class="ro-sidebar">
        <!-- Ruler gutter (corner) -->
        <div class="ro-sidebar__corner">
          <UIcon name="i-lucide-clock" class="size-3.5 text-muted" />
        </div>

        <!-- Table rows in sidebar -->
        <template v-for="section in groupedResources" :key="section.group?.id || '_ungrouped'">
          <!-- Group header -->
          <button
            v-if="section.group"
            class="ro-group-header"
            @click="toggleGroup(section.group.id)"
          >
            <UIcon
              :name="collapsedGroups.has(section.group.id) ? 'i-lucide-chevron-right' : 'i-lucide-chevron-down'"
              class="size-3.5 text-muted shrink-0"
            />
            <span class="ro-group-header__name">{{ section.group.name }}</span>
            <span class="ro-group-header__count">({{ section.resources.length }})</span>
          </button>
          <div v-else class="ro-group-header ro-group-header--plain">
            <span class="ro-group-header__name">Ubundet</span>
            <span class="ro-group-header__count">({{ section.resources.length }})</span>
          </div>

          <!-- Table rows (collapsible) -->
          <template v-if="!section.group || !collapsedGroups.has(section.group.id)">
            <div
              v-for="r in section.resources"
              :key="r.id"
              class="ro-sidebar__row"
            >
              <div class="ro-sidebar__icon" :style="{ backgroundColor: hexToRgba(r.color, 0.15), color: r.color }">
                <UIcon :name="typeIcons[r.type] || 'i-lucide-box'" class="size-3" />
              </div>
              <div class="ro-sidebar__info">
                <span class="ro-sidebar__name">{{ r.name }}</span>
                <span class="ro-sidebar__cap">{{ r.capacity.min }}–{{ r.capacity.max }}</span>
              </div>
              <span class="ro-sidebar__badge" v-if="bookingsByResource[r.id]?.length">
                {{ bookingsByResource[r.id].length }}
              </span>
            </div>
          </template>
        </template>
      </div>

      <!-- Scrollable timeline area -->
      <div ref="scrollRef" class="ro-timeline">
        <!-- Time ruler (sticky top) -->
        <div class="ro-ruler" :style="{ width: totalWidth + 'px' }">
          <div
            v-for="(m, i) in hourMarkers"
            :key="'h-' + i"
            class="ro-ruler__mark"
            :style="{ left: m.left + 'px' }"
          >
            {{ m.label }}
          </div>
          <!-- Now indicator in ruler -->
          <div v-if="nowLeft !== null" class="ro-ruler__now" :style="{ left: nowLeft + 'px' }">
            {{ new Date().toLocaleTimeString("nb-NO", { hour: "2-digit", minute: "2-digit" }) }}
          </div>
        </div>

        <!-- Rows area -->
        <div class="ro-rows" :style="{ width: totalWidth + 'px' }">
          <template v-for="section in groupedResources" :key="'s-' + (section.group?.id || '_ungrouped')">
            <!-- Group header spacer -->
            <div class="ro-rows__group-spacer" />

            <!-- Resource rows -->
            <template v-if="!section.group || !collapsedGroups.has(section.group.id)">
              <div
                v-for="r in section.resources"
                :key="'row-' + r.id"
                class="ro-row"
              >
                <!-- Hour grid lines -->
                <div
                  v-for="(m, i) in hourMarkers"
                  :key="'vl-' + i"
                  class="ro-row__vline"
                  :style="{ left: m.left + 'px' }"
                />

                <!-- Booking blocks -->
                <div
                  v-for="b in bookingsByResource[r.id]"
                  :key="b.id"
                  class="ro-block"
                  :style="blockStyle(b, r.color)"
                  @click="emit('booking-click', b)"
                >
                  <span class="ro-block__name">{{ b.customerName }}</span>
                  <span class="ro-block__time">{{ extractHHMM(b.startTime) }}</span>
                  <span v-if="b.partySize" class="ro-block__party">
                    <UIcon name="i-lucide-users" class="size-2.5" />{{ b.partySize }}
                  </span>
                  <span
                    class="ro-block__dot"
                    :style="{ backgroundColor: getStatusColor(b.status) }"
                  />
                </div>

                <!-- Now vertical line -->
                <div v-if="nowLeft !== null" class="ro-row__now" :style="{ left: nowLeft + 'px' }" />
              </div>
            </template>
          </template>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.ro { width: 100%; flex: 1; display: flex; flex-direction: column; min-height: 0; }

/* ---- Nav ---- */
.ro-nav-btn {
  display: inline-flex; align-items: center; justify-content: center;
  min-width: 32px; height: 32px; padding: 0 10px;
  border: 1px solid var(--ui-border-color, rgba(255,255,255,0.1));
  border-radius: 6px; background: transparent;
  color: var(--ui-text-muted, #999); font-size: 0.8rem; font-weight: 500;
  cursor: pointer; transition: all 0.15s ease; font-family: inherit;
}
.ro-nav-btn:hover {
  background: var(--ui-bg-elevated, rgba(255,255,255,0.05));
  border-color: rgba(255,255,255,0.15);
}
.ro-nav-btn--active {
  background: var(--color-primary-DEFAULT, #6366f1);
  color: white; border-color: var(--color-primary-DEFAULT, #6366f1);
}
.ro-date-label { font-size: 0.9rem; font-weight: 600; margin-left: 8px; text-transform: capitalize; }

.ro-empty {
  border: 1px solid var(--ui-border-color, rgba(255,255,255,0.08));
  border-radius: 12px; padding: 4rem; text-align: center;
  color: var(--ui-text-muted, #888);
}

/* ---- Gantt container ---- */
.ro-gantt {
  display: flex; flex: 1; min-height: 0;
  border: 1px solid var(--ui-border-color, rgba(255,255,255,0.08));
  border-radius: 12px; overflow: hidden;
  background: var(--ui-bg, #0a0a0a);
}

/* ---- Sidebar (fixed left) ---- */
.ro-sidebar {
  width: v-bind('SIDEBAR_WIDTH + "px"');
  min-width: v-bind('SIDEBAR_WIDTH + "px"');
  border-right: 1px solid var(--ui-border-color, rgba(255,255,255,0.1));
  overflow-y: auto; overflow-x: hidden;
  background: var(--ui-bg-elevated, #111);
}

.ro-sidebar__corner {
  height: 36px;
  display: flex; align-items: center; justify-content: center;
  border-bottom: 1px solid var(--ui-border-color, rgba(255,255,255,0.1));
  position: sticky; top: 0; z-index: 3;
  background: var(--ui-bg-elevated, #111);
}

.ro-group-header {
  height: v-bind('GROUP_HEADER_HEIGHT + "px"');
  display: flex; align-items: center; gap: 6px;
  padding: 0 12px; width: 100%;
  background: var(--ui-bg-muted, rgba(255,255,255,0.03));
  border-bottom: 1px solid var(--ui-border-color, rgba(255,255,255,0.06));
  cursor: pointer; font-family: inherit; color: inherit; border: none;
  border-top: none; border-left: none; border-right: none;
  transition: background 0.15s ease;
}
.ro-group-header:hover {
  background: var(--ui-bg-elevated, rgba(255,255,255,0.06));
}
.ro-group-header--plain {
  cursor: default;
}
.ro-group-header__name {
  font-size: 0.75rem; font-weight: 600;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.ro-group-header__count {
  font-size: 0.65rem; color: var(--ui-text-muted, #888);
  white-space: nowrap;
}

.ro-sidebar__row {
  height: v-bind('ROW_HEIGHT + "px"');
  display: flex; align-items: center; gap: 8px;
  padding: 0 12px;
  border-bottom: 1px solid var(--ui-border-color, rgba(255,255,255,0.04));
}
.ro-sidebar__icon {
  width: 24px; height: 24px; border-radius: 6px;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
.ro-sidebar__info {
  display: flex; flex-direction: column; min-width: 0; gap: 0;
}
.ro-sidebar__name {
  font-size: 0.75rem; font-weight: 600;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.ro-sidebar__cap {
  font-size: 0.6rem; color: var(--ui-text-muted, #888);
}
.ro-sidebar__badge {
  margin-left: auto; flex-shrink: 0;
  font-size: 0.6rem; font-weight: 700;
  background: var(--color-primary-100, rgba(99,102,241,0.15));
  color: var(--color-primary-DEFAULT, #6366f1);
  padding: 1px 6px; border-radius: 9999px;
}

/* ---- Timeline (scrollable right) ---- */
.ro-timeline {
  flex: 1; overflow: auto; min-width: 0;
  position: relative;
}

/* ---- Time ruler ---- */
.ro-ruler {
  height: 36px; position: sticky; top: 0; z-index: 5;
  background: var(--ui-bg-elevated, #141414);
  border-bottom: 1px solid var(--ui-border-color, rgba(255,255,255,0.1));
  min-width: 100%;
}
.ro-ruler__mark {
  position: absolute; top: 0; height: 100%;
  display: flex; align-items: flex-end; padding-bottom: 6px;
  font-size: 0.65rem; font-weight: 600;
  color: var(--ui-text-muted, rgba(255,255,255,0.45));
  border-left: 1px solid var(--ui-border-color, rgba(255,255,255,0.1));
  padding-left: 6px; white-space: nowrap;
}
.ro-ruler__now {
  position: absolute; top: 2px; transform: translateX(-50%);
  font-size: 0.6rem; font-weight: 700;
  color: var(--color-primary-DEFAULT, #10b981);
  background: var(--ui-bg-elevated, #141414);
  padding: 2px 6px; border-radius: 4px;
  border: 1px solid var(--color-primary-DEFAULT, #10b981);
  z-index: 6;
}

/* ---- Rows ---- */
.ro-rows {
  min-width: 100%;
}
.ro-rows__group-spacer {
  height: v-bind('GROUP_HEADER_HEIGHT + "px"');
  background: var(--ui-bg-muted, rgba(255,255,255,0.02));
  border-bottom: 1px solid var(--ui-border-color, rgba(255,255,255,0.06));
}

.ro-row {
  height: v-bind('ROW_HEIGHT + "px"');
  position: relative;
  border-bottom: 1px solid var(--ui-border-color, rgba(255,255,255,0.04));
}

/* Vertical hour grid lines */
.ro-row__vline {
  position: absolute; top: 0; bottom: 0; width: 0;
  border-left: 1px solid var(--ui-border-color, rgba(255,255,255,0.05));
  pointer-events: none;
}

/* Now line */
.ro-row__now {
  position: absolute; top: 0; bottom: 0; width: 2px;
  background: var(--color-primary-DEFAULT, #10b981);
  opacity: 0.5; z-index: 4; pointer-events: none;
}

/* ---- Booking block ---- */
.ro-block {
  position: absolute; top: 3px; bottom: 3px;
  border-radius: 6px; border-left: 3px solid;
  padding: 3px 8px; cursor: pointer; overflow: hidden;
  display: flex; align-items: center; gap: 6px;
  transition: box-shadow 0.15s ease, filter 0.15s ease;
  z-index: 2; white-space: nowrap;
}
.ro-block:hover {
  box-shadow: 0 2px 12px rgba(0,0,0,0.4);
  filter: brightness(1.15);
  z-index: 5;
}
.ro-block__name {
  font-size: 0.7rem; font-weight: 600;
  overflow: hidden; text-overflow: ellipsis;
  color: var(--ui-text-default, #fff);
}
.ro-block__time {
  font-size: 0.6rem; font-weight: 500;
  opacity: 0.7;
  color: var(--ui-text-default, #fff);
}
.ro-block__party {
  display: inline-flex; align-items: center; gap: 2px;
  font-size: 0.6rem; opacity: 0.7;
  color: var(--ui-text-default, #fff);
}
.ro-block__dot {
  width: 6px; height: 6px; border-radius: 50%;
  flex-shrink: 0; margin-left: auto;
}

@media (max-width: 768px) {
  .ro-date-label { font-size: 0.8rem; }
  .ro-sidebar {
    width: 120px !important;
    min-width: 120px !important;
  }
}
</style>
