<script setup lang="ts">
/**
 * DDStaffGrid - Staff Portrait Grid
 * 
 * Displays bookable staff as circular portraits with name and position.
 * Used on the establishment page's "Our People" tab.
 * Inspired by noon.is "Fólkið okkar" section.
 */
import type { StaffMember } from '@dittodatto/shared-types'

interface Props {
  /** List of staff members to display */
  staff: StaffMember[]
  /** Loading state */
  loading?: boolean
}

withDefaults(defineProps<Props>(), {
  loading: false,
})

const emit = defineEmits<{
  /** Emitted when a staff portrait is clicked */
  (e: 'select', staff: StaffMember): void
}>()

/**
 * Get initials from a display name for avatar fallback.
 */
function getInitials(name: string): string {
  return name
    .split(' ')
    .map((n) => n[0])
    .join('')
    .toUpperCase()
    .slice(0, 2)
}
</script>

<template>
  <div>
    <!-- Loading State -->
    <div v-if="loading" class="grid grid-cols-3 sm:grid-cols-4 lg:grid-cols-5 gap-6">
      <div v-for="i in 5" :key="i" class="flex flex-col items-center gap-3">
        <USkeleton class="size-20 sm:size-24 rounded-full" />
        <USkeleton class="h-4 w-20" />
        <USkeleton class="h-3 w-16" />
      </div>
    </div>

    <!-- Empty State -->
    <div v-else-if="staff.length === 0" class="text-center py-12 text-muted">
      <UIcon name="i-lucide-users" class="size-12 mx-auto mb-4 opacity-50" />
      <p class="font-medium text-default">No team members listed</p>
      <p class="text-sm mt-1">Check back later to see who's on the team!</p>
    </div>

    <!-- Staff Grid -->
    <div v-else class="grid grid-cols-3 sm:grid-cols-4 lg:grid-cols-5 gap-6">
      <button
        v-for="member in staff"
        :key="member.id"
        class="group flex flex-col items-center gap-2 p-3 rounded-xl transition-all duration-200 hover:bg-muted/40 hover:scale-[1.03] active:scale-[0.98] focus:outline-none focus-visible:ring-2 focus-visible:ring-primary"
        @click="emit('select', member)"
      >
        <!-- Portrait Avatar -->
        <div class="relative">
          <div
            class="size-20 sm:size-24 rounded-full overflow-hidden ring-2 ring-transparent group-hover:ring-primary/50 transition-all duration-200 shadow-sm group-hover:shadow-md"
          >
            <img
              v-if="member.avatarUrl"
              :src="member.avatarUrl"
              :alt="member.displayName"
              class="size-full object-cover"
            />
            <div
              v-else
              class="size-full flex items-center justify-center bg-primary/10 text-primary font-semibold text-lg sm:text-xl"
            >
              {{ getInitials(member.displayName) }}
            </div>
          </div>
          <!-- Online/bookable indicator dot -->
          <div
            class="absolute bottom-0 right-0 size-4 sm:size-5 bg-emerald-500 rounded-full border-2 border-bg shadow-sm"
          />
        </div>

        <!-- Name & Position -->
        <div class="text-center min-w-0 w-full">
          <p class="text-sm font-semibold truncate group-hover:text-primary transition-colors">
            {{ member.displayName }}
          </p>
          <p v-if="member.position" class="text-xs text-muted truncate">
            {{ member.position }}
          </p>
        </div>
      </button>
    </div>
  </div>
</template>
