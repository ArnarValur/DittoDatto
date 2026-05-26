<script setup lang="ts">
import type { StaffMember, WeeklyShift, DateOverride } from '@dittodatto/shared-types'

definePageMeta({
  layout: 'dashboard',
})

const route = useRoute()
const router = useRouter()
const staffId = computed(() => route.params.id as string)

const { staff, loading, updateStaff } = useStaff()
const { stores } = useStores()
const { isOwner, hasCapability } = useStaffPermissions()
const { saveWeeklyShifts, saveDateOverrides, defaultWeeklyShifts } = useStaffSchedule()
const { company } = useCompany()
const toast = useToast()

const canManageStaff = computed(() => isOwner.value || hasCapability('can_manage_staff'))

// Find the specific staff member
const member = computed(() =>
  staff.value?.find((s) => s.id === staffId.value)
)

// Redirect if not found after loading
watch([loading, member], ([isLoading, m]) => {
  if (!isLoading && !m) {
    toast.add({ title: 'Staff member not found', color: 'warning' })
    router.push('/staff')
  }
})

// Is this the company owner?
const isOwnerMember = computed(() => {
  if (!member.value?.userId || !company.value) return false
  return member.value.userId === company.value.ownerId
})

// Schedule state
const scheduleShifts = ref<WeeklyShift>(defaultWeeklyShifts())
const scheduleOverrides = ref<DateOverride[]>([])
const scheduleSaving = ref(false)
const scheduleModified = ref(false)

// Sync schedule from member data
watch(member, (m) => {
  if (m) {
    scheduleShifts.value = m.weeklyShifts
      ? JSON.parse(JSON.stringify(m.weeklyShifts))
      : defaultWeeklyShifts()
    scheduleOverrides.value = m.dateOverrides
      ? JSON.parse(JSON.stringify(m.dateOverrides))
      : []
    scheduleModified.value = false
  }
}, { immediate: true })

// Track schedule modifications
watch(scheduleShifts, () => {
  scheduleModified.value = true
}, { deep: true })

// Save schedule
async function handleSaveSchedule() {
  if (!staffId.value) return
  scheduleSaving.value = true
  try {
    await saveWeeklyShifts(staffId.value, scheduleShifts.value)
    await saveDateOverrides(staffId.value, scheduleOverrides.value)
    scheduleModified.value = false
  } catch (err: unknown) {
    toast.add({ title: 'Error saving schedule', description: (err as Error).message, color: 'error' })
  } finally {
    scheduleSaving.value = false
  }
}

// Slideover for editing details
const showSlideover = ref(false)
function openEdit() {
  showSlideover.value = true
}
function onSaved() {
  showSlideover.value = false
}

// Status badge colors
const statusColors: Record<string, 'success' | 'info' | 'warning' | 'error' | 'neutral'> = {
  active: 'success',
  invited: 'info',
  suspended: 'warning',
  removed: 'error',
}

// Resolve store names
function getStoreNames(storeIds: string[]): string[] {
  if (!storeIds?.length) return ['No stores assigned']
  return storeIds.map((id) => stores.value?.find((s) => s.id === id)?.name ?? id)
}

// Day labels for schedule display
const dayLabels: { key: keyof WeeklyShift; label: string; short: string }[] = [
  { key: 'mon', label: 'Monday', short: 'Mon' },
  { key: 'tue', label: 'Tuesday', short: 'Tue' },
  { key: 'wed', label: 'Wednesday', short: 'Wed' },
  { key: 'thu', label: 'Thursday', short: 'Thu' },
  { key: 'fri', label: 'Friday', short: 'Fri' },
  { key: 'sat', label: 'Saturday', short: 'Sat' },
  { key: 'sun', label: 'Sunday', short: 'Sun' },
]

// Compute total weekly hours
function totalHours(shifts: WeeklyShift): number {
  let minutes = 0
  for (const day of dayLabels) {
    const d = shifts[day.key]
    if (d.isWorking) {
      for (const block of d.blocks) {
        const start = parseTime(block.start)
        const end = parseTime(block.end)
        if (end > start) minutes += end - start
      }
    }
  }
  return Math.round((minutes / 60) * 10) / 10
}

function parseTime(t: string): number {
  const parts = t.split(':').map(Number)
  return (parts[0] ?? 0) * 60 + (parts[1] ?? 0)
}

function formatTimeRange(blocks: { start: string; end: string }[]): string {
  return blocks.map((b) => `${b.start}–${b.end}`).join(', ')
}

// Capability display
const capabilityLabels: Record<string, { label: string; icon: string }> = {
  can_manage_bookings: { label: 'Manage Bookings', icon: 'i-lucide-calendar-check' },
  can_view_all_bookings: { label: 'View All Bookings', icon: 'i-lucide-calendar-search' },
  can_manage_schedule: { label: 'Manage Schedule', icon: 'i-lucide-clock' },
  can_manage_services: { label: 'Manage Services', icon: 'i-lucide-briefcase' },
  can_manage_media: { label: 'Manage Media', icon: 'i-lucide-image' },
  can_manage_events: { label: 'Manage Events', icon: 'i-lucide-party-popper' },
  can_manage_staff: { label: 'Manage Staff', icon: 'i-lucide-users' },
  can_manage_settings: { label: 'Manage Settings', icon: 'i-lucide-settings' },
  can_view_financials: { label: 'View Financials', icon: 'i-lucide-chart-bar' },
}

// Toggle day working status on the schedule grid
function toggleDayWorking(dayKey: keyof WeeklyShift, value: boolean) {
  scheduleShifts.value[dayKey].isWorking = value
  if (value && scheduleShifts.value[dayKey].blocks.length === 0) {
    scheduleShifts.value[dayKey].blocks = [{ start: '09:00', end: '17:00' }]
  }
}
</script>

<template>
  <UDashboardPanel id="staff-detail">
    <template #header>
      <UDashboardNavbar :ui="{ right: 'gap-3' }">
        <template #leading>
          <div class="flex items-center gap-2">
            <UDashboardSidebarCollapse />
            <UButton
              icon="i-lucide-arrow-left"
              color="neutral"
              variant="ghost"
              size="sm"
              to="/staff"
            />
          </div>
        </template>

        <template #title>
          <div class="flex items-center gap-1.5">
            <NuxtLink to="/staff" class="text-muted hover:text-highlighted transition-colors text-sm">
              Staff
            </NuxtLink>
            <UIcon name="i-lucide-chevron-left" class="size-3.5 text-muted" />
            <span v-if="member" class="truncate font-semibold">{{ member.displayName }}</span>
            <span v-else class="text-muted">Loading...</span>
          </div>
        </template>

        <template #right>
          <UButton
            v-if="canManageStaff && member"
            icon="i-lucide-pencil"
            label="Edit Details"
            color="neutral"
            variant="soft"
            @click="openEdit"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <!-- Loading State -->
      <div v-if="loading" class="p-6 space-y-6">
        <div class="flex items-center gap-6">
          <USkeleton class="size-20 rounded-full" />
          <div class="space-y-3 flex-1">
            <USkeleton class="h-7 w-48" />
            <USkeleton class="h-5 w-64" />
          </div>
        </div>
        <USkeleton class="h-48 w-full rounded-xl" />
      </div>

      <!-- Staff Detail -->
      <div v-else-if="member" class="p-6 space-y-6 max-w-5xl">
        <!-- Profile Header -->
        <div class="flex items-start gap-6">
          <UAvatar
            :src="member.avatarUrl"
            :alt="member.displayName"
            size="3xl"
            :icon="'i-lucide-user'"
            class="ring-2 ring-primary/20"
          />

          <div class="flex-1 min-w-0 space-y-2">
            <div class="flex items-center gap-3 flex-wrap">
              <h1 class="text-2xl font-bold truncate">{{ member.displayName }}</h1>
              <UBadge
                :color="statusColors[member.status] || 'neutral'"
                variant="subtle"
                size="sm"
                class="capitalize"
              >
                {{ member.status }}
              </UBadge>
              <UBadge
                v-if="isOwnerMember"
                color="primary"
                variant="subtle"
                size="sm"
              >
                <UIcon name="i-lucide-crown" class="size-3 mr-1" />
                Owner
              </UBadge>
            </div>

            <p class="text-muted flex items-center gap-2">
              <UIcon name="i-lucide-mail" class="size-4" />
              {{ member.email }}
            </p>

            <p v-if="member.position" class="text-muted flex items-center gap-2">
              <UIcon name="i-lucide-badge" class="size-4" />
              {{ member.position }}
            </p>

            <div class="flex items-center gap-2 flex-wrap mt-1">
              <UBadge
                v-for="storeName in getStoreNames(member.storeIds)"
                :key="storeName"
                color="neutral"
                variant="outline"
                size="xs"
              >
                <UIcon name="i-lucide-store" class="size-3 mr-1" />
                {{ storeName }}
              </UBadge>
            </div>

            <div class="flex items-center gap-3 mt-1">
              <UBadge
                v-if="member.isBookable"
                color="primary"
                variant="subtle"
                size="sm"
              >
                <UIcon name="i-lucide-calendar-check" class="size-3 mr-1" />
                Bookable
              </UBadge>
              <UBadge
                v-if="member.showOnStorefront"
                color="info"
                variant="subtle"
                size="sm"
              >
                <UIcon name="i-lucide-eye" class="size-3 mr-1" />
                Visible on Storefront
              </UBadge>
            </div>
          </div>
        </div>

        <USeparator />

        <!-- Weekly Schedule Section -->
        <section>
          <div class="flex items-center justify-between mb-4">
            <div class="flex items-center gap-2">
              <UIcon name="i-lucide-calendar" class="size-5 text-primary" />
              <h2 class="text-lg font-semibold">Weekly Schedule</h2>
              <span class="text-sm text-muted ml-2">
                {{ totalHours(scheduleShifts) }}h / week
              </span>
            </div>
            <UButton
              v-if="canManageStaff && scheduleModified"
              icon="i-lucide-save"
              label="Save Schedule"
              color="primary"
              size="sm"
              :loading="scheduleSaving"
              @click="handleSaveSchedule"
            />
          </div>

          <!-- Visual Schedule Grid -->
          <div class="schedule-grid rounded-xl border border-default overflow-hidden">
            <!-- Time header -->
            <div class="schedule-header">
              <div class="schedule-day-label"></div>
              <div class="schedule-timeline">
                <span v-for="h in [6, 8, 10, 12, 14, 16, 18, 20, 22]" :key="h" class="schedule-hour-mark">
                  {{ String(h).padStart(2, '0') }}:00
                </span>
              </div>
            </div>

            <!-- Day rows -->
            <div
              v-for="day in dayLabels"
              :key="day.key"
              class="schedule-row"
              :class="{ 'schedule-row--off': !scheduleShifts[day.key].isWorking }"
            >
              <!-- Day label + toggle -->
              <div class="schedule-day-label">
                <UCheckbox
                  v-if="canManageStaff"
                  :model-value="scheduleShifts[day.key].isWorking"
                  @update:model-value="toggleDayWorking(day.key, $event)"
                />
                <span class="text-sm font-medium" :class="scheduleShifts[day.key].isWorking ? 'text-highlighted' : 'text-muted'">
                  {{ day.short }}
                </span>
              </div>

              <!-- Timeline bar area -->
              <div class="schedule-timeline">
                <template v-if="scheduleShifts[day.key].isWorking">
                  <div
                    v-for="(block, bi) in scheduleShifts[day.key].blocks"
                    :key="bi"
                    class="schedule-block"
                    :style="{
                      left: `${((parseTime(block.start) - 360) / (24 * 60 - 360)) * 100}%`,
                      width: `${((parseTime(block.end) - parseTime(block.start)) / (24 * 60 - 360)) * 100}%`
                    }"
                    :title="`${block.start} – ${block.end}`"
                  >
                    <span class="schedule-block-text">{{ block.start }}–{{ block.end }}</span>
                  </div>
                </template>
                <span v-else class="text-xs text-muted italic pl-2">Day off</span>
              </div>
            </div>
          </div>

          <!-- Inline Schedule Editor (when canManageStaff) -->
          <div v-if="canManageStaff" class="mt-4">
            <UAccordion
              :items="[{ label: 'Edit Shift Blocks', icon: 'i-lucide-clock', slot: 'editor' }]"
            >
              <template #editor>
                <div class="pt-2">
                  <ScheduleWeeklyShiftEditor v-model="scheduleShifts" />
                </div>
              </template>
            </UAccordion>
          </div>

          <!-- Date Overrides -->
          <div v-if="canManageStaff" class="mt-4">
            <UAccordion
              :items="[{ label: `Date Overrides (${scheduleOverrides.length})`, icon: 'i-lucide-calendar-off', slot: 'overrides' }]"
            >
              <template #overrides>
                <div class="pt-2">
                  <ScheduleDateOverrideManager v-model="scheduleOverrides" />
                </div>
              </template>
            </UAccordion>
          </div>
        </section>

        <USeparator />

        <!-- Permissions Section -->
        <section>
          <div class="flex items-center gap-2 mb-4">
            <UIcon name="i-lucide-shield" class="size-5 text-primary" />
            <h2 class="text-lg font-semibold">Permissions</h2>
            <span class="text-sm text-muted ml-2">
              {{ member.defaultCapabilities?.length ?? 0 }} active
            </span>
          </div>

          <div v-if="isOwnerMember" class="p-4 rounded-lg bg-primary/5 border border-primary/10">
            <p class="text-sm text-muted">
              <UIcon name="i-lucide-crown" class="size-4 inline mr-1 text-primary" />
              Company owner has all permissions by default.
            </p>
          </div>

          <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
            <div
              v-for="(cap, key) in capabilityLabels"
              :key="key"
              class="flex items-center gap-2 p-3 rounded-lg border border-default"
              :class="member.defaultCapabilities?.includes(key as any)
                ? 'bg-primary/5 border-primary/20'
                : 'bg-muted/10 opacity-50'"
            >
              <UIcon
                :name="cap.icon"
                class="size-4"
                :class="member.defaultCapabilities?.includes(key as any)
                  ? 'text-primary'
                  : 'text-muted'"
              />
              <span class="text-sm">{{ cap.label }}</span>
              <UIcon
                v-if="member.defaultCapabilities?.includes(key as any)"
                name="i-lucide-check"
                class="size-3.5 text-success ml-auto"
              />
            </div>
          </div>
        </section>
      </div>
    </template>
  </UDashboardPanel>

  <!-- Edit Slideover (without schedule) -->
  <StaffFormSlideover
    v-if="member"
    v-model:open="showSlideover"
    :staff-member="member"
    @saved="onSaved"
    @close="showSlideover = false"
  />
</template>

<style scoped>
/* ── Schedule Grid ── */
.schedule-grid {
  background: var(--ui-bg);
}

.schedule-header {
  display: flex;
  align-items: center;
  border-bottom: 1px solid var(--ui-border);
  padding: 0.5rem 0;
  background: var(--ui-bg-elevated);
}

.schedule-day-label {
  width: 100px;
  padding: 0 0.75rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-shrink: 0;
}

.schedule-timeline {
  flex: 1;
  position: relative;
  height: 36px;
  display: flex;
  align-items: center;
}

.schedule-header .schedule-timeline {
  height: 20px;
  justify-content: space-between;
  padding: 0 0.5rem;
}

.schedule-hour-mark {
  font-size: 0.65rem;
  color: var(--ui-text-muted);
  font-variant-numeric: tabular-nums;
}

.schedule-row {
  display: flex;
  align-items: center;
  border-bottom: 1px solid var(--ui-border);
  transition: background 0.15s;
}

.schedule-row:last-child {
  border-bottom: none;
}

.schedule-row:hover {
  background: var(--ui-bg-elevated);
}

.schedule-row--off {
  opacity: 0.6;
}

.schedule-block {
  position: absolute;
  height: 24px;
  border-radius: 6px;
  background: linear-gradient(135deg, var(--ui-color-primary-500), var(--ui-color-primary-600));
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  cursor: default;
  min-width: 48px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.15);
}

.schedule-block:hover {
  transform: scaleY(1.1);
  box-shadow: 0 2px 8px rgba(99, 102, 241, 0.3);
}

.schedule-block-text {
  font-size: 0.65rem;
  font-weight: 600;
  color: white;
  white-space: nowrap;
  padding: 0 6px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}
</style>
