<script setup lang="ts">
import type { NavigationMenuItem } from '@nuxt/ui'

const links: NavigationMenuItem[][] = [
  [
    {
      label: 'Overview',
      icon: 'i-lucide-layout-dashboard',
      to: '/dashboard'
    },
    {
      label: 'Keywords Analysis',
      icon: 'i-lucide-search-check',
      to: '/dashboard/keywords'
    },
    {
      label: 'Zero-Results',
      icon: 'i-lucide-search-x',
      to: '/dashboard/zero-results'
    }
  ],
  [
    {
      label: 'Settings',
      icon: 'i-lucide-settings',
      to: '/settings'
    }
  ]
]
</script>

<template>
  <UDashboardGroup>
    <UDashboardSidebar
      collapsible
      resizable
      :ui="{ footer: 'border-t border-default' }"
    >
      <template #header="{ collapsed }">
        <div class="flex items-center gap-2 overflow-hidden">
          <UIcon
            name="i-lucide-bar-chart-3"
            class="w-6 h-6 text-primary shrink-0"
          />
          <span
            v-if="!collapsed"
            class="font-bold text-lg truncate tracking-tight"
          >SearchAnalytics</span>
        </div>
      </template>

      <template #default="{ collapsed }">
        <UNavigationMenu
          :collapsed="collapsed"
          :items="links[0]"
          orientation="vertical"
        />
        <UNavigationMenu
          :collapsed="collapsed"
          :items="links[1]"
          orientation="vertical"
          class="mt-auto"
        />
      </template>

      <template #footer="{ collapsed }">
        <UserMenu v-if="!collapsed" />
        <UButton
          v-else
          icon="i-lucide-user"
          color="neutral"
          variant="ghost"
          class="w-full"
          block
        />
      </template>
    </UDashboardSidebar>

    <UDashboardPanel resizable>
      <UDashboardNavbar>
        <template #left>
          <!-- Page title can be injected here or handled per page, but for now we put a placeholder -->
          <span class="font-semibold lg:hidden">SearchAnalytics</span>
        </template>
        <template #right>
          <UColorModeButton />
        </template>
      </UDashboardNavbar>

      <!-- Main Scrollable Content -->
      <div class="flex-1 overflow-y-auto p-4 sm:p-6 lg:p-8 bg-gray-50 dark:bg-gray-950">
        <slot />
      </div>
    </UDashboardPanel>
  </UDashboardGroup>
</template>
