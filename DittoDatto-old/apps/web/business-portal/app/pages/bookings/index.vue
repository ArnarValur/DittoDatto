<script setup lang="ts">
import { format, isToday, isTomorrow, isThisWeek } from "date-fns";
import type { Booking } from "@dittodatto/shared-types";

definePageMeta({
  layout: "dashboard",
});

/** Safely coerce Firestore Timestamp | Date | string → ISO string */
function coerceToISO(val: any): string {
  if (typeof val === "string") return val;
  if (val?.toDate) return val.toDate().toISOString(); // Firestore Timestamp
  if (val instanceof Date) return val.toISOString();
  return new Date(val).toISOString();
}

/** Safely coerce Firestore Timestamp | Date | string → Date object */
function coerceToDate(val: any): Date {
  if (val instanceof Date) return val;
  if (val?.toDate) return val.toDate(); // Firestore Timestamp
  return new Date(val);
}

const {
  bookings,
  allBookings,
  stats,
  loading,
  isEmpty,
  statusFilter,
  storeFilter,
  staffFilter,
} = useBookings();
const { isOwner, hasCapability } = useStaffPermissions();
const { stores } = useStores();
const { allStaff } = useStaff();

// Resources — used to filter out table-resource bookings (they go to Reservations)
const { tableResources } = useResources();

// RBAC: manage = full CRUD, viewAll = read-only calendar
const canManageBookings = computed(
  () => isOwner.value || hasCapability("can_manage_bookings"),
);
const canViewBookings = computed(
  () => canManageBookings.value || hasCapability("can_view_all_bookings"),
);

// ---- View mode toggle: 'list' | 'schedule' ----
const viewMode = ref<"list" | "schedule">("schedule");

// ---- Schedule view state ----
const scheduleDate = ref(new Date());
const scheduleStoreId = ref<string | null>(null);

// Exclude restaurant stores (those with table resources) — they go to Reservations
const restaurantStoreIds = computed(() => {
  const ids = new Set<string>();
  for (const s of stores.value ?? []) {
    if (tableResources(s.id).length > 0) ids.add(s.id);
  }
  return ids;
});
// Allow all stores in Bookings tab, since a restaurant can have standard bookings too.
const serviceStores = computed(() => stores.value ?? []);
const isMultiStore = computed(() => serviceStores.value.length > 1);

// Auto-select first service store (or restore from localStorage)
watch(
  serviceStores,
  (val) => {
    if (!val?.length) return;
    const saved = localStorage.getItem('dd_bookings_storeId');
    if (saved && val.some((s) => s.id === saved)) {
      scheduleStoreId.value = saved;
    } else {
      scheduleStoreId.value = val[0].id;
    }
  },
  { immediate: true },
);

// Persist store selection
watch(scheduleStoreId, (id) => {
  if (id) localStorage.setItem('dd_bookings_storeId', id);
});

// ---- Staff Visibility Toggles ----
const hiddenStaffIds = ref<Set<string>>(new Set());

onMounted(() => {
  try {
    const saved = localStorage.getItem('dd_bookings_hiddenStaff');
    if (saved) hiddenStaffIds.value = new Set(JSON.parse(saved));
  } catch { /* ignore corrupt data */ }
});

watch(hiddenStaffIds, (ids) => {
  localStorage.setItem('dd_bookings_hiddenStaff', JSON.stringify([...ids]));
}, { deep: true });

function toggleStaffVisibility(staffId: string) {
  const next = new Set(hiddenStaffIds.value);
  if (next.has(staffId)) {
    next.delete(staffId);
  } else {
    next.add(staffId);
  }
  hiddenStaffIds.value = next;
}

function staffInitials(name: string): string {
  return name.split(' ').map((n) => n[0]).join('').slice(0, 2).toUpperCase();
}

// Store options for schedule view — service stores only (restaurants go to Reservations)
const scheduleStoreOptions = computed(() =>
  serviceStores.value.map((s) => ({ label: s.name, value: s.id })),
);

// Map DD bookings → BookingOverview's BookingSlot interface
const scheduleBookings = computed(() => {
  const all = allBookings.value ?? [];
  const dateStr = scheduleDate.value.toISOString().slice(0, 10);
  return all
    .filter((b) => {
      // Date filter — coerce Firestore Timestamps safely
      const bDate = coerceToISO(b.startTime).slice(0, 10);
      if (bDate !== dateStr) return false;
      // Store filter
      if (scheduleStoreId.value && b.storeId !== scheduleStoreId.value)
        return false;
      // We removed the restaurantStoreIds filter since restaurant stores can have standard bookings.
      return true;
    })
    .map((b) => ({
      id: b.id,
      staffId: b.staffId || b.personId || "_unassigned",
      customerName: b.userName,
      serviceTitle: b.serviceTitle,
      startTime: coerceToISO(b.startTime),
      endTime: coerceToISO(b.endTime),
      duration: b.duration,
      status: b.status as any,
      price: b.priceAtTimeOfBooking,
      currency: b.currency,
    }));
});

// Map DD staff → BookingOverview's StaffMember interface
const STAFF_COLORS = [
  "#97a4e2",
  "#abbbce",
  "#6ee7bf",
  "#fdba74",
  "#fea4b3",
  "#b5c2ec",
];

// All bookable staff for the selected store (for toggle display)
const storeStaff = computed(() => {
  return (allStaff.value ?? []).filter((s) => {
    if (s.status !== "active" || !s.isBookable) return false;
    if (scheduleStoreId.value && !s.storeIds?.includes(scheduleStoreId.value))
      return false;
    return true;
  });
});

// Visible staff after toggle filter → mapped to BookingOverview interface
const scheduleStaff = computed(() => {
  // If the store has no bookable staff, show a single 'Schedules' column
  if (storeStaff.value.length === 0) {
    return [
      {
        id: "_unassigned",
        name: "Schedules",
        avatar: null,
        color: "#a1a1aa",
      },
    ];
  }

  const bookable = storeStaff.value
    .filter((s) => !hiddenStaffIds.value.has(s.id))
    .map((s, i) => ({
      id: s.id,
      name: s.displayName || s.email || "Staff",
      avatar: null,
      color: STAFF_COLORS[i % STAFF_COLORS.length],
    }));

  // Add "Unassigned" column if there are bookings without staffId for staff-enabled stores
  const hasUnassigned = scheduleBookings.value.some(
    (b) => b.staffId === "_unassigned",
  );
  if (hasUnassigned) {
    bookable.push({
      id: "_unassigned",
      name: "Ikke tildelt",
      avatar: null,
      color: "#a1a1aa",
    });
  }

  return bookable;
});

function handleScheduleBookingClick(booking: any) {
  // Find the original DD booking by id and open the slideover
  const original = (allBookings.value ?? []).find((b) => b.id === booking.id);
  if (original) {
    openBooking(original);
  }
}

function handleScheduleDateChange(date: Date) {
  scheduleDate.value = date;
}

// ---- Slideover ----
const selectedBooking = ref<Booking | null>(null);
const slideoverOpen = ref(false);

function openBooking(booking: Booking) {
  selectedBooking.value = booking;
  slideoverOpen.value = true;
}

// Group bookings by date for timeline view
const groupedBookings = computed(() => {
  if (!bookings.value) return [];

  const groups: { label: string; bookings: typeof bookings.value }[] = [];
  const today: typeof bookings.value = [];
  const tomorrow: typeof bookings.value = [];
  const thisWeek: typeof bookings.value = [];
  const older: typeof bookings.value = [];

  for (const booking of bookings.value) {
    const date = coerceToDate(booking.startTime);
    if (isToday(date)) {
      today.push(booking);
    } else if (isTomorrow(date)) {
      tomorrow.push(booking);
    } else if (isThisWeek(date)) {
      thisWeek.push(booking);
    } else {
      older.push(booking);
    }
  }

  if (today.length) groups.push({ label: "Today", bookings: today });
  if (tomorrow.length) groups.push({ label: "Tomorrow", bookings: tomorrow });
  if (thisWeek.length) groups.push({ label: "This Week", bookings: thisWeek });
  if (older.length) groups.push({ label: "Earlier", bookings: older });

  return groups;
});

// Format time for display
const formatTime = (date: Date | any) => {
  return format(coerceToDate(date), "HH:mm");
};

const formatDate = (date: Date | any) => {
  return format(coerceToDate(date), "EEE, MMM d");
};

// Status color mapping
const statusColors: Record<
  string,
  "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral"
> = {
  confirmed: "success",
  completed: "primary",
  pending: "warning",
  cancelled: "error",
  "no-show": "error",
};

// Format price for display
const formatPrice = (price: number, currency: string) => {
  return new Intl.NumberFormat("nb-NO", {
    style: "currency",
    currency: currency || "NOK",
  }).format(price);
};

// ---- Filter options ----
const statusOptions = [
  { label: "All", value: "all" },
  { label: "Confirmed", value: "confirmed" },
  { label: "Pending", value: "pending" },
  { label: "Completed", value: "completed" },
  { label: "Cancelled", value: "cancelled" },
  { label: "No-Show", value: "no-show" },
];

const storeOptions = computed(() => [
  { label: "All Stores", value: "" },
  ...serviceStores.value.map((s) => ({ label: s.name, value: s.id })),
]);

const staffOptions = computed(() => [
  { label: "All Staff", value: "" },
  ...(allStaff.value ?? [])
    .filter((s) => s.status === "active" && s.isBookable)
    .map((s) => ({ label: s.displayName || s.email, value: s.id })),
]);

function setStoreFilter(val: string) {
  storeFilter.value = val || null;
}

function setStaffFilter(val: string) {
  staffFilter.value = val || null;
}
</script>

<template>
  <UDashboardPanel id="bookings">
    <template #header>
      <UDashboardNavbar title="Bookings" :ui="{ right: 'gap-3' }">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>

        <template #right>
          <!-- View mode toggle -->
          <div class="flex items-center gap-1 bg-elevated rounded-lg p-0.5">
            <UTooltip text="Timeplan">
              <UButton
                icon="i-lucide-calendar-days"
                :color="viewMode === 'schedule' ? 'primary' : 'neutral'"
                :variant="viewMode === 'schedule' ? 'subtle' : 'ghost'"
                size="xs"
                @click="viewMode = 'schedule'"
              />
            </UTooltip>
            <UTooltip text="Liste">
              <UButton
                icon="i-lucide-list"
                :color="viewMode === 'list' ? 'primary' : 'neutral'"
                :variant="viewMode === 'list' ? 'subtle' : 'ghost'"
                size="xs"
                @click="viewMode = 'list'"
              />
            </UTooltip>
          </div>
        </template>
      </UDashboardNavbar>

      <!-- Stats Bar (list mode only — schedule view has its own stats) -->
      <UDashboardToolbar v-if="viewMode === 'list' && !loading && !isEmpty">
        <template #left>
          <div class="flex items-center gap-4 text-sm">
            <span class="flex items-center gap-1.5">
              <UIcon
                name="i-lucide-calendar-check"
                class="size-4 text-success-500"
              />
              <span class="font-medium">{{ stats.confirmed }}</span>
              <span class="text-muted">Confirmed</span>
            </span>
            <span class="flex items-center gap-1.5">
              <UIcon name="i-lucide-clock" class="size-4 text-warning-500" />
              <span class="font-medium">{{ stats.pending }}</span>
              <span class="text-muted">Pending</span>
            </span>
            <span class="flex items-center gap-1.5">
              <UIcon
                name="i-lucide-check-circle"
                class="size-4 text-primary-500"
              />
              <span class="font-medium">{{ stats.completed }}</span>
              <span class="text-muted">Completed</span>
            </span>
          </div>
        </template>
      </UDashboardToolbar>
    </template>

    <template #body>
      <!-- ═══ Schedule View (default) ═══ -->
      <div v-if="viewMode === 'schedule'" class="p-4 flex flex-col h-full overflow-hidden">
        <!-- Schedule controls -->
        <div v-if="!loading" class="space-y-2 mb-3">
          <!-- Store selector (multi-store only) -->
          <div v-if="isMultiStore" class="flex items-center gap-2">
            <UIcon name="i-lucide-building-2" class="size-4 text-muted shrink-0" />
            <div class="flex gap-1 flex-wrap">
              <UButton
                v-for="store in scheduleStoreOptions"
                :key="store.value"
                :label="store.label"
                size="xs"
                :color="scheduleStoreId === store.value ? 'primary' : 'neutral'"
                :variant="scheduleStoreId === store.value ? 'subtle' : 'ghost'"
                @click="scheduleStoreId = store.value"
              />
            </div>
          </div>

          <!-- Staff visibility toggles -->
          <div v-if="storeStaff.length > 0" class="flex items-center gap-2">
            <UIcon name="i-lucide-users" class="size-4 text-muted shrink-0" />
            <div class="flex gap-1.5 flex-wrap">
              <button
                v-for="member in storeStaff"
                :key="member.id"
                class="staff-toggle"
                :class="{ 'staff-toggle--hidden': hiddenStaffIds.has(member.id) }"
                :title="(hiddenStaffIds.has(member.id) ? 'Vis ' : 'Skjul ') + member.displayName"
                @click="toggleStaffVisibility(member.id)"
              >
                <div class="staff-toggle__avatar">
                  <img
                    v-if="member.avatarUrl"
                    :src="member.avatarUrl"
                    :alt="member.displayName"
                    class="size-full object-cover"
                  />
                  <span v-else class="text-[9px] font-bold">
                    {{ staffInitials(member.displayName || 'S') }}
                  </span>
                </div>
                <span class="staff-toggle__name">{{ member.displayName?.split(' ')[0] }}</span>
              </button>
            </div>
          </div>
        </div>

        <!-- Loading -->
        <div v-if="loading" class="flex items-center justify-center py-24">
          <UIcon
            name="i-lucide-loader-2"
            class="size-8 text-muted animate-spin"
          />
        </div>

        <!-- Schedule Grid -->
        <BookingsBookingOverview
          v-else
          :bookings="scheduleBookings"
          :staff="scheduleStaff"
          :date="scheduleDate"
          :slot-interval="30"
          :pixels-per-minute="2"
          @booking-click="handleScheduleBookingClick"
          @date-change="handleScheduleDateChange"
        />
      </div>

      <!-- ═══ List View ═══ -->
      <div v-else class="p-6">
        <!-- Filter Bar -->
        <div
          v-if="!loading && !isEmpty"
          class="flex flex-wrap items-center gap-3 mb-6"
        >
          <USelectMenu
            :model-value="statusOptions.find((o) => o.value === statusFilter)"
            :items="statusOptions"
            value-attribute="value"
            option-attribute="label"
            class="w-36"
            @update:model-value="
              (val: any) => (statusFilter = val?.value ?? 'all')
            "
          />
          <USelectMenu
            :model-value="
              storeOptions.find((o) => o.value === (storeFilter || ''))
            "
            :items="storeOptions"
            value-attribute="value"
            option-attribute="label"
            class="w-40"
            @update:model-value="(val: any) => setStoreFilter(val?.value ?? '')"
          />
          <USelectMenu
            v-if="staffOptions.length > 1"
            :model-value="
              staffOptions.find((o) => o.value === (staffFilter || ''))
            "
            :items="staffOptions"
            value-attribute="value"
            option-attribute="label"
            class="w-40"
            @update:model-value="(val: any) => setStaffFilter(val?.value ?? '')"
          />
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="space-y-4">
          <UCard v-for="i in 5" :key="i">
            <div class="flex items-center gap-4">
              <USkeleton class="size-12 rounded-lg" />
              <div class="flex-1 space-y-2">
                <USkeleton class="h-5 w-48" />
                <USkeleton class="h-4 w-32" />
              </div>
              <USkeleton class="h-6 w-20" />
            </div>
          </UCard>
        </div>

        <!-- Empty State -->
        <UCard v-else-if="isEmpty" class="text-center py-12">
          <UIcon
            name="i-lucide-calendar-x"
            class="size-16 mx-auto mb-4 text-muted opacity-50"
          />
          <h3 class="text-lg font-semibold mb-2">No bookings yet</h3>
          <p class="text-muted mb-4">
            When customers book your services, they'll appear here.
          </p>
        </UCard>

        <!-- No results for filters -->
        <UCard v-else-if="!groupedBookings.length" class="text-center py-8">
          <UIcon
            name="i-lucide-filter-x"
            class="size-12 mx-auto mb-3 text-muted opacity-50"
          />
          <h3 class="text-base font-semibold mb-1">No matching bookings</h3>
          <p class="text-muted text-sm">Try adjusting your filters.</p>
        </UCard>

        <!-- Bookings Timeline -->
        <div v-else class="space-y-6">
          <div v-for="group in groupedBookings" :key="group.label">
            <h3 class="text-sm font-medium text-muted mb-3">
              {{ group.label }}
            </h3>
            <div class="space-y-3">
              <UCard
                v-for="booking in group.bookings"
                :key="booking.id"
                class="cursor-pointer hover:bg-muted/50 transition-colors"
                @click="openBooking(booking)"
              >
                <div class="flex items-center gap-4">
                  <div class="shrink-0 text-center">
                    <p class="text-2xl font-bold">
                      {{ formatTime(booking.startTime) }}
                    </p>
                    <p class="text-xs text-muted">
                      {{ formatDate(booking.startTime) }}
                    </p>
                  </div>
                  <div class="flex-1 min-w-0">
                    <h4 class="font-semibold truncate">
                      {{ booking.serviceTitle }}
                    </h4>
                    <p class="text-sm text-muted truncate">
                      {{ booking.userName }} · {{ booking.userEmail }}
                    </p>
                    <div class="flex items-center gap-2 mt-1">
                      <span class="text-xs text-muted flex items-center gap-1">
                        <UIcon name="i-lucide-clock" class="size-3" />
                        {{ booking.duration }} min
                      </span>
                    </div>
                  </div>
                  <div class="text-right shrink-0">
                    <p class="font-semibold">
                      {{
                        formatPrice(
                          booking.priceAtTimeOfBooking,
                          booking.currency,
                        )
                      }}
                    </p>
                    <UBadge
                      :color="statusColors[booking.status] || 'neutral'"
                      variant="subtle"
                      size="xs"
                      class="capitalize"
                    >
                      {{ booking.status }}
                    </UBadge>
                  </div>
                </div>
              </UCard>
            </div>
          </div>
        </div>
      </div>
    </template>
  </UDashboardPanel>

  <!-- Booking Detail Slideover -->
  <BookingsBookingDetailSlideover
    v-model:open="slideoverOpen"
    :booking="selectedBooking"
  />
</template>

<style scoped>
.staff-toggle {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 2px 8px 2px 2px;
  border-radius: 9999px;
  border: 1px solid var(--ui-border-color, rgba(255, 255, 255, 0.1));
  background: var(--ui-bg-elevated, rgba(255, 255, 255, 0.03));
  cursor: pointer;
  transition: all 0.15s ease;
  font-family: inherit;
  color: inherit;
}

.staff-toggle:hover {
  border-color: var(--color-primary-DEFAULT, #6366f1);
  background: var(--color-primary-50, rgba(99, 102, 241, 0.08));
}

.staff-toggle--hidden {
  opacity: 0.35;
  border-style: dashed;
}

.staff-toggle--hidden:hover {
  opacity: 0.7;
}

.staff-toggle__avatar {
  width: 22px;
  height: 22px;
  border-radius: 50%;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-primary-100, rgba(99, 102, 241, 0.15));
  color: var(--color-primary-DEFAULT, #6366f1);
  flex-shrink: 0;
}

.staff-toggle__name {
  font-size: 0.7rem;
  font-weight: 500;
  white-space: nowrap;
  max-width: 60px;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
