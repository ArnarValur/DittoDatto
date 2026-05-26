<script setup lang="ts">
/**
 * SystemAlertBanner — Compact alert indicator for the portal navbar
 *
 * Shows as a small badge/chip next to the notification bell.
 * Clicking it reveals a popover with alert details.
 * Non-intrusive — doesn't push layout content.
 */
import { useSystemAlerts } from '~/composables/useSystemAlerts'

const { visibleAlerts, dismiss } = useSystemAlerts('business')

const open = ref(false)

const severityStyles: Record<string, { bg: string; text: string; icon: string; dot: string }> = {
  info: {
    bg: 'bg-blue-500/10',
    text: 'text-blue-400',
    icon: 'i-lucide-info',
    dot: 'bg-blue-500',
  },
  warning: {
    bg: 'bg-amber-500/10',
    text: 'text-amber-400',
    icon: 'i-lucide-alert-triangle',
    dot: 'bg-amber-500',
  },
  critical: {
    bg: 'bg-red-500/10',
    text: 'text-red-400',
    icon: 'i-lucide-alert-octagon',
    dot: 'bg-red-500',
  },
}

// Highest severity for the badge color
const highestSeverity = computed(() => {
  if (visibleAlerts.value.some(a => a.severity === 'critical')) return 'critical'
  if (visibleAlerts.value.some(a => a.severity === 'warning')) return 'warning'
  return 'info'
})
</script>

<template>
  <UPopover v-if="visibleAlerts.length > 0" v-model:open="open">
    <!-- Trigger: compact indicator button -->
    <button
      class="relative p-1.5 rounded-md transition-colors"
      :class="[
        severityStyles[highestSeverity]?.text || 'text-muted',
        open ? severityStyles[highestSeverity]?.bg : 'hover:bg-elevated',
      ]"
    >
      <UIcon :name="severityStyles[highestSeverity]?.icon || 'i-lucide-info'" class="size-4.5" />
      <!-- Count badge -->
      <span
        class="absolute -top-0.5 -right-0.5 flex items-center justify-center min-w-[16px] h-[16px] px-0.5 rounded-full text-white text-[9px] font-bold leading-none"
        :class="severityStyles[highestSeverity]?.dot || 'bg-blue-500'"
      >
        {{ visibleAlerts.length > 9 ? '9+' : visibleAlerts.length }}
      </span>
    </button>

    <!-- Popover content -->
    <template #content>
      <div class="w-80 max-h-96 overflow-y-auto">
        <div class="px-3 py-2 border-b border-default">
          <p class="text-xs font-semibold text-muted uppercase tracking-wider">System Alerts</p>
        </div>
        <div class="divide-y divide-default">
          <div
            v-for="alert in visibleAlerts"
            :key="alert.id"
            class="px-3 py-2.5 flex items-start gap-2.5"
          >
            <UIcon
              :name="severityStyles[alert.severity]?.icon || 'i-lucide-info'"
              class="size-4 shrink-0 mt-0.5"
              :class="severityStyles[alert.severity]?.text"
            />
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium leading-tight">{{ alert.title }}</p>
              <p class="text-xs text-muted mt-0.5 line-clamp-2">{{ alert.body }}</p>
              <NuxtLink
                v-if="alert.actionUrl"
                :to="alert.actionUrl"
                target="_blank"
                class="text-xs text-primary hover:underline mt-1 inline-block"
              >
                {{ alert.actionLabel || 'Les mer' }} →
              </NuxtLink>
            </div>
            <UButton
              variant="ghost"
              size="xs"
              icon="i-lucide-x"
              color="neutral"
              class="shrink-0 -mr-1"
              @click.stop="dismiss(alert.id)"
            />
          </div>
        </div>
      </div>
    </template>
  </UPopover>
</template>
