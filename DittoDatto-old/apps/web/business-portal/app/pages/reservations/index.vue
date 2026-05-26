<script setup lang="ts">
import type { Reservation } from "@dittodatto/shared-types";

definePageMeta({
  layout: "dashboard",
});

/** Safely coerce Firestore Timestamp | Date | string → ISO string */
function coerceToISO(val: any): string {
  if (typeof val === "string") return val;
  if (val?.toDate) return val.toDate().toISOString();
  if (val instanceof Date) return val.toISOString();
  return new Date(val).toISOString();
}

/** Coerce Firestore Timestamp | Date | string → "YYYY-MM-DD" */
function coerceToDateStr(val: any): string {
  if (typeof val === "string") return val.slice(0, 10);
  if (val?.toDate) return val.toDate().toISOString().slice(0, 10);
  if (val instanceof Date) return val.toISOString().slice(0, 10);
  return "";
}

const { allReservations, reservationsByDate, loading: reservationsLoading } = useReservations();
const { allBookings, loading: bookingsLoading } = useBookings(); // Fallback: marketplace bookings at restaurant stores
const { stores } = useStores();
const {
  allResources,
  loading: resourcesLoading,
  tableResources,
  fetchResources,
} = useResources();
const { allResourceGroups, groupsByStore, loading: groupsLoading } = useResourceGroups();
const { isOwner, hasCapability } = useStaffPermissions();

// RBAC
const canView = computed(
  () =>
    isOwner.value ||
    hasCapability("can_manage_bookings") ||
    hasCapability("can_view_all_bookings"),
);

// ---- View state ----
const scheduleDate = ref(new Date());
const scheduleStoreId = ref<string | null>(null);

// Only show stores that have table resources (restaurants)
const restaurantStores = computed(() => {
  return (stores.value ?? []).filter((s) =>
    tableResources(s.id).length > 0,
  );
});
const isMultiRestaurant = computed(() => restaurantStores.value.length > 1);

// Auto-select first restaurant store
watch(
  restaurantStores,
  (val) => {
    if (!val?.length) return;
    const saved = localStorage.getItem("dd_reservations_storeId");
    if (saved && val.some((s) => s.id === saved)) {
      scheduleStoreId.value = saved;
    } else {
      scheduleStoreId.value = val[0].id;
    }
  },
  { immediate: true },
);

watch(scheduleStoreId, (id) => {
  if (id) localStorage.setItem("dd_reservations_storeId", id);
});

// Store options — only restaurants
const scheduleStoreOptions = computed(() =>
  restaurantStores.value.map((s) => ({ label: s.name, value: s.id })),
);

// ---- Resource visibility toggles ----
const hiddenResourceIds = ref<Set<string>>(new Set());

onMounted(() => {
  try {
    const saved = localStorage.getItem("dd_reservations_hiddenResources");
    if (saved) hiddenResourceIds.value = new Set(JSON.parse(saved));
  } catch {
    /* ignore */
  }
});

watch(
  hiddenResourceIds,
  (ids) => {
    localStorage.setItem(
      "dd_reservations_hiddenResources",
      JSON.stringify([...ids]),
    );
  },
  { deep: true },
);

function toggleResourceVisibility(resourceId: string) {
  const next = new Set(hiddenResourceIds.value);
  if (next.has(resourceId)) {
    next.delete(resourceId);
  } else {
    next.add(resourceId);
  }
  hiddenResourceIds.value = next;
}

// ---- Resource colors ----
const RESOURCE_COLORS = [
  "#f59e0b", // amber
  "#10b981", // emerald
  "#6366f1", // indigo
  "#ec4899", // pink
  "#8b5cf6", // violet
  "#06b6d4", // cyan
  "#f97316", // orange
  "#14b8a6", // teal
];

// All table resources for the selected store
const storeTableResources = computed(() => {
  if (!scheduleStoreId.value) return [];
  return tableResources(scheduleStoreId.value);
});

// Visible resources → mapped to ReservationOverview interface
const scheduleResources = computed(() => {
  return storeTableResources.value
    .filter((r) => !hiddenResourceIds.value.has(r.id))
    .map((r, i) => ({
      id: r.id,
      name: r.name,
      type: r.type,
      groupId: r.resourceGroupId || undefined,
      color: RESOURCE_COLORS[i % RESOURCE_COLORS.length],
      capacity: {
        min: r.minCapacity ?? 1,
        max: r.maxCapacity ?? 1,
      },
    }));
});

// Resource groups for the selected store
const scheduleGroups = computed(() => {
  if (!scheduleStoreId.value) return [];
  return groupsByStore(scheduleStoreId.value).map((g) => ({
    id: g.id,
    name: g.name,
    resourceCount: storeTableResources.value.filter((r) => r.resourceGroupId === g.id).length,
  }));
});

// ---- Map Reservations → ReservationOverview slots ----
const UNASSIGNED_RESOURCE_ID = '__unassigned__';

const scheduleBookings = computed(() => {
  if (!scheduleStoreId.value) return [];
  const dateStr = scheduleDate.value.toISOString().slice(0, 10);

  // Source 1: Proper reservations from companies/{cid}/reservations
  const dayReservations = reservationsByDate(scheduleStoreId.value, dateStr);
  const fromReservations = dayReservations
    .filter((r) => r.status !== 'cancelled')
    .map((r) => {
      const dateVal = coerceToDateStr(r.date);
      const startTime = `${dateVal}T${r.time}:00`;
      const [startH, startM] = r.time.split(':').map(Number);
      const endTotalMin = startH * 60 + startM + r.duration;
      const endH = String(Math.floor(endTotalMin / 60) % 24).padStart(2, '0');
      const endM = String(endTotalMin % 60).padStart(2, '0');
      const endTime = `${dateVal}T${endH}:${endM}:00`;

      return {
        id: r.id,
        resourceId: r.tableId || UNASSIGNED_RESOURCE_ID,
        customerName: r.customerName,
        serviceTitle: r.experienceId ? 'Opplevelse' : 'Reservasjon',
        startTime,
        endTime,
        duration: r.duration,
        status: r.status === 'no_show' ? 'no-show' : r.status as any,
        partySize: r.guestCount,
      };
    });

  // Only return proper reservations originating from the reservations collection
  // Ignore standard bookings even if they are placed at a restaurant store
  return [...fromReservations];
});

// Add "Unassigned" row if any reservations lack a tableId
const hasUnassigned = computed(() =>
  scheduleBookings.value.some((b) => b.resourceId === UNASSIGNED_RESOURCE_ID),
);

const scheduleResourcesWithUnassigned = computed(() => {
  const resources = scheduleResources.value;
  if (!hasUnassigned.value) return resources;
  return [
    {
      id: UNASSIGNED_RESOURCE_ID,
      name: 'Ikke tildelt',
      type: 'table' as const,
      groupId: undefined,
      color: '#a1a1aa',
      capacity: { min: 0, max: 0 },
    },
    ...resources,
  ];
});

// Groups with potential unassigned pseudo-group
const scheduleGroupsWithUnassigned = computed(() => {
  const groups = scheduleGroups.value;
  if (!hasUnassigned.value) return groups;
  return [
    { id: '__unassigned_group__', name: 'Ikke tildelt', resourceCount: 1 },
    ...groups,
  ];
});

// ---- Event handlers ----
const selectedReservation = ref<Reservation | null>(null);
const slideoverOpen = ref(false);

function handleBookingClick(booking: any) {
  const original = (allReservations.value ?? []).find((r) => r.id === booking.id);
  if (original) {
    selectedReservation.value = original;
    slideoverOpen.value = true;
  }
}

function handleDateChange(date: Date) {
  scheduleDate.value = date;
}

const loading = computed(
  () => reservationsLoading.value || bookingsLoading.value || resourcesLoading.value || groupsLoading.value,
);

// ---- Type config for toggle icons ----
const typeIcons: Record<string, string> = {
  table: "i-lucide-armchair",
  room: "i-lucide-door-open",
  station: "i-lucide-monitor",
  equipment: "i-lucide-wrench",
  addon: "i-lucide-package-plus",
};
</script>

<template>
  <UDashboardPanel id="reservations">
    <template #header>
      <UDashboardNavbar title="Reservasjoner" :ui="{ right: 'gap-3' }">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-4 flex flex-col h-full overflow-hidden">
        <!-- Controls -->
        <div v-if="!loading" class="space-y-2 mb-3">
          <!-- Store selector (multiple restaurants only) -->
          <div v-if="isMultiRestaurant" class="flex items-center gap-2">
            <UIcon
              name="i-lucide-building-2"
              class="size-4 text-muted shrink-0"
            />
            <div class="flex gap-1 flex-wrap">
              <UButton
                v-for="store in scheduleStoreOptions"
                :key="store.value"
                :label="store.label"
                size="xs"
                :color="
                  scheduleStoreId === store.value ? 'primary' : 'neutral'
                "
                :variant="
                  scheduleStoreId === store.value ? 'subtle' : 'ghost'
                "
                @click="scheduleStoreId = store.value"
              />
            </div>
          </div>

          <!-- Resource visibility toggles -->
          <div
            v-if="storeTableResources.length > 0"
            class="flex items-center gap-2"
          >
            <UIcon
              name="i-lucide-armchair"
              class="size-4 text-muted shrink-0"
            />
            <div class="flex gap-1.5 flex-wrap">
              <button
                v-for="(resource, i) in storeTableResources"
                :key="resource.id"
                class="resource-toggle"
                :class="{
                  'resource-toggle--hidden': hiddenResourceIds.has(resource.id),
                }"
                :title="
                  (hiddenResourceIds.has(resource.id) ? 'Vis ' : 'Skjul ') +
                  resource.name
                "
                @click="toggleResourceVisibility(resource.id)"
              >
                <div
                  class="resource-toggle__icon"
                  :style="{
                    backgroundColor: `${RESOURCE_COLORS[i % RESOURCE_COLORS.length]}22`,
                    color: RESOURCE_COLORS[i % RESOURCE_COLORS.length],
                  }"
                >
                  <UIcon
                    :name="typeIcons[resource.type] || 'i-lucide-box'"
                    class="size-3.5"
                  />
                </div>
                <span class="resource-toggle__name">{{ resource.name }}</span>
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

        <!-- No table resources -->
        <div
          v-else-if="storeTableResources.length === 0"
          class="flex flex-col items-center justify-center py-24 text-center"
        >
          <span class="text-4xl mb-4">🪑</span>
          <h3 class="text-lg font-semibold mb-2">Ingen bordressurser</h3>
          <p class="text-muted text-sm max-w-md">
            Legg til bordressurser for dette etablissementet via
            <NuxtLink
              to="/establishments"
              class="text-primary hover:underline"
            >
              Establishments → Resources
            </NuxtLink>
            for å se reservasjonsoversikten.
          </p>
        </div>

        <!-- Reservation Grid -->
        <ReservationsReservationOverview
          v-else
          :bookings="scheduleBookings"
          :resources="scheduleResourcesWithUnassigned"
          :groups="scheduleGroupsWithUnassigned"
          :date="scheduleDate"
          :pixels-per-minute="2.5"
          @booking-click="handleBookingClick"
          @date-change="handleDateChange"
        />
      </div>
    </template>
  </UDashboardPanel>

  <!-- Reservation Detail Slideover -->
  <ReservationsReservationSlideover
    v-model:open="slideoverOpen"
    :reservation="selectedReservation"
    :resources="scheduleResources"
  />
</template>

<style scoped>
.resource-toggle {
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

.resource-toggle:hover {
  border-color: var(--color-primary-DEFAULT, #6366f1);
  background: var(--color-primary-50, rgba(99, 102, 241, 0.08));
}

.resource-toggle--hidden {
  opacity: 0.35;
  border-style: dashed;
}

.resource-toggle--hidden:hover {
  opacity: 0.7;
}

.resource-toggle__icon {
  width: 22px;
  height: 22px;
  border-radius: 6px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.resource-toggle__name {
  font-size: 0.7rem;
  font-weight: 500;
  white-space: nowrap;
  max-width: 80px;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
