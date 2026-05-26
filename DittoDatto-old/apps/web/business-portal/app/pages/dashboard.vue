<script setup lang="ts">
/**
 * Owner Dashboard — Business Portal Landing
 *
 * Shows at-a-glance overview of the business:
 * - Greeting + today's date
 * - Today's bookings timetable (staff × time)
 *   → Store filter (pill-buttons, auto-hidden for single-store)
 *   → Staff visibility toggles (clickable avatar pills)
 */
import type { Booking, StaffMember } from '@dittodatto/shared-types'

definePageMeta({
  layout: 'dashboard'
})

const { isNotificationsSlideoverOpen } = useDashboard()
const { unreadCount } = useNotifications()
const { company, loading: companyLoading } = useCompany()
const { allStaff, loading: staffLoading } = useStaff()
const { allBookings, loading: bookingsLoading } = useBookings()
const { stores, loading: storesLoading } = useStores()

// ---- Store Filter ----
const isMultiStore = computed(() => (stores.value?.length ?? 0) > 1)
const selectedStoreId = ref<string | null>(null)

// Auto-select first store (or restore from localStorage)
watch(stores, (val) => {
  if (!val?.length) return
  // Try to restore
  const saved = localStorage.getItem('dd_dashboard_storeId')
  if (saved && val.some(s => s.id === saved)) {
    selectedStoreId.value = saved
  } else {
    selectedStoreId.value = val[0].id
  }
}, { immediate: true })

// Persist store selection
watch(selectedStoreId, (id) => {
  if (id) localStorage.setItem('dd_dashboard_storeId', id)
})

// ---- Staff Visibility Toggles ----
const hiddenStaffIds = ref<Set<string>>(new Set())

// Restore from localStorage
onMounted(() => {
  try {
    const saved = localStorage.getItem('dd_dashboard_hiddenStaff')
    if (saved) hiddenStaffIds.value = new Set(JSON.parse(saved))
  } catch { /* ignore corrupt data */ }
})

// Persist hidden staff
watch(hiddenStaffIds, (ids) => {
  localStorage.setItem('dd_dashboard_hiddenStaff', JSON.stringify([...ids]))
}, { deep: true })

function toggleStaffVisibility(staffId: string) {
  const next = new Set(hiddenStaffIds.value)
  if (next.has(staffId)) {
    next.delete(staffId)
  } else {
    next.add(staffId)
  }
  hiddenStaffIds.value = next
}

// ---- Today's Bookings ----
const today = new Date()
const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`

const todaysBookings = computed<Booking[]>(() => {
  return (allBookings.value ?? []).filter(b => {
    if (!b.startTime) return false
    const bookingDate = typeof b.startTime === 'string'
      ? b.startTime.slice(0, 10)
      : ''
    if (bookingDate !== todayStr || b.status === 'cancelled') return false
    // Store filter
    if (selectedStoreId.value && b.storeId !== selectedStoreId.value) return false
    return true
  }).sort((a, b) => {
    const aTime = typeof a.startTime === 'string' ? a.startTime : ''
    const bTime = typeof b.startTime === 'string' ? b.startTime : ''
    return aTime.localeCompare(bTime)
  })
})

// Staff for the selected store — bookable + active + visible
const storeStaff = computed<StaffMember[]>(() => {
  return (allStaff.value ?? []).filter(s => {
    if (s.status !== 'active' || !s.isBookable) return false
    if (selectedStoreId.value && !s.storeIds?.includes(selectedStoreId.value)) return false
    return true
  })
})

// Visible staff (after toggle filter)
const visibleStaff = computed<StaffMember[]>(() => {
  return storeStaff.value.filter(s => !hiddenStaffIds.value.has(s.id))
})

// Group today's bookings by visible staff
const bookingsByStaff = computed<Record<string, Booking[]>>(() => {
  const map: Record<string, Booking[]> = {}

  for (const s of visibleStaff.value) {
    map[s.id] = []
  }
  map['_unassigned'] = []

  for (const b of todaysBookings.value) {
    const staffId = b.staffId || b.personId
    if (staffId && map[staffId]) {
      map[staffId].push(b)
    } else {
      map['_unassigned'].push(b)
    }
  }

  return map
})

// ---- Helpers ----

function statusColor(status: string) {
  switch (status) {
    case 'confirmed': return 'primary'
    case 'completed': return 'success'
    case 'pending': return 'warning'
    case 'no-show': return 'error'
    case 'cancelled': return 'neutral'
    default: return 'neutral'
  }
}

function formatTime(iso: string | Date | undefined): string {
  if (!iso) return '—'
  const str = typeof iso === 'string' ? iso : iso.toISOString()
  const match = str.match(/T(\d{2}:\d{2})/)
  return match ? match[1] : '—'
}

function formatDateDisplay(date: Date): string {
  return new Intl.DateTimeFormat('nb-NO', {
    weekday: 'long',
    day: 'numeric',
    month: 'long'
  }).format(date)
}

function staffInitials(name: string): string {
  return name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
}

const greeting = computed(() => {
  const hour = today.getHours()
  if (hour < 12) return 'God morgen'
  if (hour < 17) return 'God ettermiddag'
  return 'God kveld'
})
</script>

<template>
  <UDashboardPanel id="dashboard">
    <template #header>
      <UDashboardNavbar :ui="{ right: 'gap-3' }">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>

        <template #title>
          <div v-if="companyLoading" class="flex items-center gap-2">
            <USkeleton class="h-6 w-40" />
          </div>
          <div v-else-if="company" class="flex items-center gap-2">
            <UIcon name="i-lucide-building-2" class="size-5" />
            <span class="font-semibold">{{ company.name }}</span>
          </div>
          <span v-else class="text-muted">No company found</span>
        </template>

        <template #right>
          <SystemAlertBanner />
          <UTooltip text="Notifications" :shortcuts="['N']">
            <button
              class="relative p-2 rounded-md text-muted hover:text-primary hover:bg-elevated transition-colors"
              @click="isNotificationsSlideoverOpen = true"
            >
              <UIcon name="i-lucide-bell" class="size-5 shrink-0" />
              <span
                v-if="unreadCount > 0"
                class="absolute -top-0.5 -right-0.5 flex items-center justify-center min-w-[16px] h-[16px] px-0.5 rounded-full bg-primary-500 text-white text-[9px] font-bold leading-none"
              >
                {{ unreadCount > 9 ? '9+' : unreadCount }}
              </span>
            </button>
          </UTooltip>
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6 space-y-6">
        <!-- Greeting -->
        <div>
          <h1 class="text-2xl font-bold">
            {{ greeting }}<span v-if="company">, {{ company.name }}</span>
          </h1>
          <p class="text-muted text-sm mt-1">
            {{ formatDateDisplay(today) }}
          </p>
        </div>



        <!-- Today's Bookings — Staff Overview -->
        <UCard>
          <template #header>
            <div class="space-y-3">
              <!-- Row 1: Title + count + link -->
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                  <UIcon name="i-lucide-calendar-days" class="size-5 text-primary" />
                  <h3 class="font-semibold">Dagens timeplan</h3>
                  <UBadge v-if="todaysBookings.length > 0" color="primary" variant="subtle" size="xs">
                    {{ todaysBookings.length }} {{ todaysBookings.length === 1 ? 'booking' : 'bookinger' }}
                  </UBadge>
                </div>
                <UButton
                  label="Se alle"
                  variant="ghost"
                  size="sm"
                  icon="i-lucide-arrow-right"
                  trailing
                  to="/bookings"
                />
              </div>

              <!-- Row 2: Store selector (multi-store only) -->
              <div v-if="isMultiStore && !storesLoading" class="flex items-center gap-2">
                <UIcon name="i-lucide-building-2" class="size-4 text-muted shrink-0" />
                <div class="flex gap-1 flex-wrap">
                  <UButton
                    v-for="store in stores"
                    :key="store.id"
                    :label="store.name"
                    size="xs"
                    :color="selectedStoreId === store.id ? 'primary' : 'neutral'"
                    :variant="selectedStoreId === store.id ? 'subtle' : 'ghost'"
                    @click="selectedStoreId = store.id"
                  />
                </div>
              </div>

              <!-- Row 3: Staff visibility toggles -->
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
          </template>

          <!-- Loading state -->
          <div v-if="bookingsLoading || staffLoading || storesLoading" class="py-8 flex justify-center">
            <UIcon name="i-lucide-loader-2" class="size-6 animate-spin text-muted" />
          </div>

          <div v-else-if="todaysBookings.length === 0" class="text-center py-8 text-muted">
            <UIcon name="i-lucide-calendar-check-2" class="size-12 mx-auto mb-3 opacity-50" />
            <p class="font-medium">Ingen bookinger i dag</p>
            <p class="text-sm mt-1">Nyt den rolige dagen ✨</p>
          </div>

          <!-- Staff columns with bookings -->
          <div v-else class="overflow-x-auto">
            <div class="grid gap-4" :style="{ gridTemplateColumns: `repeat(${Math.max(visibleStaff.length + (bookingsByStaff['_unassigned']?.length ? 1 : 0), 1)}, minmax(200px, 1fr))` }">
              <!-- Per-staff column -->
              <div
                v-for="staffMember in visibleStaff"
                :key="staffMember.id"
                class="space-y-2"
              >
                <!-- Staff header -->
                <div class="flex items-center gap-2 px-2 py-1.5 rounded-lg bg-muted/30 border border-default">
                  <div class="size-7 rounded-full overflow-hidden shrink-0 bg-primary/10">
                    <img
                      v-if="staffMember.avatarUrl"
                      :src="staffMember.avatarUrl"
                      :alt="staffMember.displayName"
                      class="size-full object-cover"
                    />
                    <div v-else class="size-full flex items-center justify-center text-primary font-semibold text-[10px]">
                      {{ staffMember.displayName?.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase() }}
                    </div>
                  </div>
                  <div class="min-w-0">
                    <p class="text-sm font-medium truncate">{{ staffMember.displayName }}</p>
                    <p class="text-[11px] text-muted">{{ staffMember.position || 'Staff' }}</p>
                  </div>
                  <UBadge
                    v-if="bookingsByStaff[staffMember.id]?.length"
                    color="primary"
                    variant="subtle"
                    size="xs"
                    class="ml-auto"
                  >
                    {{ bookingsByStaff[staffMember.id].length }}
                  </UBadge>
                </div>

                <!-- Booking cards for this staff -->
                <div
                  v-for="booking in bookingsByStaff[staffMember.id]"
                  :key="booking.id"
                  class="p-3 rounded-lg border border-default bg-elevated/50 hover:border-primary/40 transition-colors cursor-pointer space-y-1.5"
                  @click="navigateTo(`/bookings?id=${booking.id}`)"
                >
                  <div class="flex items-center justify-between">
                    <span class="text-sm font-semibold">
                      {{ formatTime(booking.startTime) }}–{{ formatTime(booking.endTime) }}
                    </span>
                    <UBadge :color="statusColor(booking.status)" variant="subtle" size="xs">
                      {{ booking.status }}
                    </UBadge>
                  </div>
                  <p class="text-sm font-medium truncate">{{ booking.serviceTitle }}</p>
                  <p class="text-xs text-muted truncate">
                    <UIcon name="i-lucide-user" class="size-3 inline" />
                    {{ booking.userName || booking.userEmail }}
                  </p>
                  <p v-if="booking.priceAtTimeOfBooking" class="text-xs text-primary font-medium">
                    {{ booking.priceAtTimeOfBooking }} {{ booking.currency || 'NOK' }}
                  </p>
                </div>

                <!-- Empty slot indicator -->
                <div
                  v-if="!bookingsByStaff[staffMember.id]?.length"
                  class="p-4 rounded-lg border border-dashed border-default text-center text-muted text-sm"
                >
                  Ingen bookinger
                </div>
              </div>

              <!-- Unassigned column -->
              <div
                v-if="bookingsByStaff['_unassigned']?.length"
                class="space-y-2"
              >
                <div class="flex items-center gap-2 px-2 py-1.5 rounded-lg bg-warning/10 border border-warning/20">
                  <div class="size-7 rounded-full bg-warning/20 flex items-center justify-center">
                    <UIcon name="i-lucide-user-x" class="size-4 text-warning" />
                  </div>
                  <div class="min-w-0">
                    <p class="text-sm font-medium">Ikke tildelt</p>
                    <p class="text-[11px] text-muted">Trenger ansatt</p>
                  </div>
                  <UBadge color="warning" variant="subtle" size="xs" class="ml-auto">
                    {{ bookingsByStaff['_unassigned'].length }}
                  </UBadge>
                </div>

                <div
                  v-for="booking in bookingsByStaff['_unassigned']"
                  :key="booking.id"
                  class="p-3 rounded-lg border border-warning/30 bg-warning/5 hover:border-warning/50 transition-colors cursor-pointer space-y-1.5"
                  @click="navigateTo(`/bookings?id=${booking.id}`)"
                >
                  <div class="flex items-center justify-between">
                    <span class="text-sm font-semibold">
                      {{ formatTime(booking.startTime) }}–{{ formatTime(booking.endTime) }}
                    </span>
                    <UBadge :color="statusColor(booking.status)" variant="subtle" size="xs">
                      {{ booking.status }}
                    </UBadge>
                  </div>
                  <p class="text-sm font-medium truncate">{{ booking.serviceTitle }}</p>
                  <p class="text-xs text-muted truncate">
                    <UIcon name="i-lucide-user" class="size-3 inline" />
                    {{ booking.userName || booking.userEmail }}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </UCard>

      </div>
    </template>
  </UDashboardPanel>
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
