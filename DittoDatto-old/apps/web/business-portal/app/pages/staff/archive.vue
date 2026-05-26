<script setup lang="ts">
/**
 * Staff Archive — Former Team Members
 *
 * Read-only view of removed staff with tenure dates.
 * Accessible from the main staff page toolbar.
 */

definePageMeta({
  layout: 'dashboard',
})

const { archivedStaff, loading } = useStaff()
const { stores } = useStores()
const { isOwner, hasCapability } = useStaffPermissions()

const canManageStaff = computed(() => isOwner.value || hasCapability('can_manage_staff'))

// Format Firestore timestamp to readable date
function formatDate(ts: any): string {
  if (!ts) return '—'
  const date = ts instanceof Date ? ts : ts?.toDate?.() ?? new Date(ts)
  return date.toLocaleDateString('nb-NO', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  })
}

// Resolve store names
function getStoreNames(storeIds: string[]): string {
  if (!storeIds?.length) return 'No stores assigned'
  return storeIds
    .map((id) => stores.value?.find((s) => s.id === id)?.name ?? id)
    .join(', ')
}
</script>

<template>
  <UDashboardPanel id="staff-archive">
    <template #header>
      <UDashboardNavbar title="Staff Archive" :ui="{ right: 'gap-3' }">
        <template #leading>
          <UDashboardSidebarCollapse />
        </template>

        <template #right>
          <UButton
            icon="i-lucide-arrow-left"
            label="Back to Staff"
            color="neutral"
            variant="ghost"
            to="/staff"
          />
        </template>
      </UDashboardNavbar>

      <UDashboardToolbar>
        <template #left>
          <div class="flex items-center gap-2 text-sm text-muted">
            <UIcon name="i-lucide-archive" class="size-4" />
            <span>{{ archivedStaff.length }} former team member{{ archivedStaff.length !== 1 ? 's' : '' }}</span>
          </div>
        </template>
      </UDashboardToolbar>
    </template>

    <template #body>
      <div class="p-6">
        <!-- Loading State -->
        <div v-if="loading" class="space-y-4">
          <UCard v-for="i in 3" :key="i">
            <div class="flex items-center gap-4">
              <USkeleton class="size-12 rounded-full" />
              <div class="flex-1 space-y-2">
                <USkeleton class="h-5 w-48" />
                <USkeleton class="h-4 w-32" />
              </div>
              <USkeleton class="h-6 w-24" />
            </div>
          </UCard>
        </div>

        <!-- Empty State -->
        <UCard v-else-if="archivedStaff.length === 0" class="text-center py-12">
          <UIcon
            name="i-lucide-archive"
            class="size-16 mx-auto mb-4 text-muted opacity-50"
          />
          <h3 class="text-lg font-semibold mb-2">No archived staff</h3>
          <p class="text-muted mb-6">
            Removed team members will appear here for your records.
          </p>
          <UButton
            label="Back to Staff"
            icon="i-lucide-arrow-left"
            color="neutral"
            variant="soft"
            to="/staff"
          />
        </UCard>

        <!-- Archived Staff List -->
        <div v-else class="space-y-3">
          <UCard
            v-for="member in archivedStaff"
            :key="member.id"
          >
            <div class="flex items-center gap-4">
              <!-- Avatar -->
              <UAvatar
                :src="member.avatarUrl"
                :alt="member.displayName"
                size="lg"
                :icon="'i-lucide-user'"
                class="opacity-60"
              />

              <!-- Info -->
              <div class="flex-1 min-w-0">
                <div class="flex items-center gap-2">
                  <h4 class="font-semibold truncate text-muted">
                    {{ member.displayName }}
                  </h4>
                  <UBadge
                    color="error"
                    variant="subtle"
                    size="xs"
                  >
                    Removed
                  </UBadge>
                </div>
                <p class="text-sm text-muted truncate">
                  {{ member.email }}
                  <span v-if="member.position"> · {{ member.position }}</span>
                </p>
                <div class="flex items-center gap-2 mt-1">
                  <span class="text-xs text-muted flex items-center gap-1">
                    <UIcon name="i-lucide-store" class="size-3" />
                    {{ getStoreNames(member.storeIds) }}
                  </span>
                </div>
              </div>

              <!-- Dates -->
              <div class="text-right shrink-0 space-y-1">
                <div class="text-xs text-muted">
                  <span class="flex items-center gap-1 justify-end">
                    <UIcon name="i-lucide-log-in" class="size-3" />
                    Joined: {{ formatDate(member.joinedAt || member.createdAt) }}
                  </span>
                </div>
                <div class="text-xs text-error/70">
                  <span class="flex items-center gap-1 justify-end">
                    <UIcon name="i-lucide-log-out" class="size-3" />
                    Removed: {{ formatDate(member.updatedAt) }}
                  </span>
                </div>
              </div>
            </div>
          </UCard>
        </div>
      </div>
    </template>
  </UDashboardPanel>
</template>
