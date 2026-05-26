<script setup lang="ts">
// import type { NavigationMenuItem } from '@nuxt/ui'

const route = useRoute()
const toast = useToast()

const open = ref(false)

// Get company for feature flags
const { company } = useCompany()

// Resources — check if company has table resources for conditional Reservations nav
const { allResources, loading: resourcesLoading } = useResources()
const hasTableResources = computed(() =>
  allResources.value.some((r) => r.type === 'table' && r.isBookable),
)

// Notifications — slideover state + unread badge count
const { isNotificationsSlideoverOpen } = useDashboard()
const { unreadCount } = useNotifications()

// RBAC: capability-gated navigation
const { isOwner, hasCapability } = useStaffPermissions()

// Auto-claim staff invites on first portal load
const { checkAndClaimInvite } = useClaimInvite()

// Compute links to react to feature flags AND capabilities
const links = computed(() => {
  const generalLinks: any[] = [{
    label: 'Dashboard',
    icon: 'i-lucide-layout-dashboard',
    to: '/dashboard',
    onSelect: () => { open.value = false }
  }, {
    label: 'Meldinger',
    icon: 'i-lucide-mail',
    to: '/inbox',
    badge: unreadCount.value > 0 ? String(unreadCount.value) : undefined,
    onSelect: () => { open.value = false }
  }, {
    label: 'Establishments',
    icon: 'i-lucide-building-2',
    to: '/establishments',
    onSelect: () => { open.value = false }
  }]

  // Services — visible if owner or can_manage_services
  if (isOwner.value || hasCapability('can_manage_services')) {
    generalLinks.push({
      label: 'Services',
      icon: 'i-lucide-briefcase',
      to: '/services',
      onSelect: () => { open.value = false }
    })

    // Resources — same permission as services (rooms, halls, equipment, etc.)
    generalLinks.push({
      label: 'Resources',
      icon: 'i-lucide-boxes',
      to: '/resources',
      onSelect: () => { open.value = false }
    })
  }

  // Customers (CRM) — visible if owner or can_manage_customers
  if (isOwner.value || hasCapability('can_manage_customers')) {
    generalLinks.push({
      label: 'Customers',
      icon: 'i-lucide-users', // reusing users icon, will change staff to a different one if needed or keep both
      to: '/customers',
      onSelect: () => { open.value = false }
    })
  }

  // Staff — visible if owner or can_manage_staff
  if (isOwner.value || hasCapability('can_manage_staff')) {
    generalLinks.push({
      label: 'Staff',
      icon: 'i-lucide-users',
      to: '/staff',
      onSelect: () => { open.value = false }
    })
  }

  // Bookings — visible if owner, can_manage_bookings, can_view_all_bookings
  if (isOwner.value || hasCapability('can_manage_bookings') || hasCapability('can_view_all_bookings')) {
    generalLinks.push({
      label: 'Bookings',
      icon: 'i-lucide-calendar-clock',
      to: '/bookings',
      onSelect: () => { open.value = false }
    })

    // Reservations — visible only if company has table resources
    if (hasTableResources.value) {
      generalLinks.push({
        label: 'Reservasjoner',
        icon: 'i-lucide-utensils',
        to: '/reservations',
        onSelect: () => { open.value = false }
      })
    }
  }

  // Media — visible if owner or can_manage_media
  if (isOwner.value || hasCapability('can_manage_media')) {
    generalLinks.push({
      label: 'Media',
      icon: 'i-lucide-image',
      to: '/media',
      onSelect: () => { open.value = false }
    })
  }

  // Conditional: Events (requires eventSystem feature flag)
  if (company.value?.enabledFeatures?.eventSystem) {
    if (isOwner.value || hasCapability('can_manage_events')) {
      generalLinks.push({
        label: 'Events',
        icon: 'i-lucide-calendar-days',
        to: '/events',
        onSelect: () => { open.value = false }
      })
    }
  }

  // Settings group — visible if owner or can_manage_settings
  if (isOwner.value || hasCapability('can_manage_settings')) {
    generalLinks.push({
      label: 'Settings',
      to: '/settings',
      icon: 'i-lucide-settings',
      // @ts-expect-error - 'type' property is valid for navigation items but might fail strict check
      type: 'trigger',
      children: [{
        label: 'General',
        to: '/settings',
        exact: true,
        onSelect: () => { open.value = false }
      }, {
        label: 'Notifications',
        to: '/settings/notifications',
        onSelect: () => { open.value = false }
      }]
    })
  }

  const supportLinks = [{
    label: 'Help & Support',
    icon: 'i-lucide-info',
    to: 'https://dittodatto.no/support',
    target: '_blank'
  }]

  return [generalLinks, supportLinks]
})

// Feedback slideover state (must be outside computed for template access)
const isFeedbackOpen = ref(false)

const groups = computed(() => [{
  id: 'links',
  label: 'Go to',
  items: links.value.flat()
}])

onMounted(async () => {
  // Auto-claim staff invites on first portal load
  checkAndClaimInvite()

  const cookie = useCookie('cookie-consent')
  if (cookie.value === 'accepted') {
    return
  }

  toast.add({
    title: 'We use first-party cookies to enhance your experience on our website.',
    duration: 0,
    close: false,
    actions: [{
      label: 'Accept',
      color: 'neutral',
      variant: 'outline',
      onClick: () => {
        cookie.value = 'accepted'
      }
    }, {
      label: 'Opt out',
      color: 'neutral',
      variant: 'ghost'
    }]
  })
})
</script>

<template>
  <UDashboardGroup unit="rem">
    <UDashboardSidebar
      id="default"
      v-model:open="open"
      collapsible
      resizable
      class="bg-elevated/25"
      :ui="{ footer: 'lg:border-t lg:border-default' }"
    >
      <template #header="{ collapsed }">
        <div class="flex items-center justify-between w-full">
          <CompanyMenu :collapsed="collapsed" />
          <!-- Right side: alert indicator + bell (mobile/tablet) -->
          <div v-if="!collapsed" class="flex items-center gap-1 lg:hidden">
            <SystemAlertBanner />
            <button
              class="relative p-1.5 rounded-md text-muted hover:text-primary hover:bg-elevated transition-colors"
              @click="isNotificationsSlideoverOpen = true"
            >
              <UIcon name="i-lucide-bell" class="size-4.5" />
              <span
                v-if="unreadCount > 0"
                class="absolute -top-0.5 -right-0.5 flex items-center justify-center min-w-[16px] h-[16px] px-0.5 rounded-full bg-primary-500 text-white text-[9px] font-bold leading-none"
              >
                {{ unreadCount > 9 ? '9+' : unreadCount }}
              </span>
            </button>
          </div>
        </div>
      </template>

      <template #default="{ collapsed }">
        <UDashboardSearchButton :collapsed="collapsed" class="bg-transparent ring-default" />

        <UNavigationMenu
          :collapsed="collapsed"
          :items="links[0]"
          orientation="vertical"
          tooltip
          popover
        />

        <!-- Feedback button (standalone — not in nav menu since it opens a slideover) -->
        <div class="mt-auto space-y-1">
          <UButton
            :icon="collapsed ? 'i-lucide-message-circle' : undefined"
            :block="!collapsed"
            variant="ghost"
            color="neutral"
            size="sm"
            :class="collapsed ? 'justify-center' : 'justify-start gap-2'"
            @click="isFeedbackOpen = true"
          >
            <UIcon v-if="!collapsed" name="i-lucide-message-circle" class="size-4" />
            <span v-if="!collapsed">Feedback</span>
          </UButton>

          <UNavigationMenu
            :collapsed="collapsed"
            :items="links[1]"
            orientation="vertical"
            tooltip
          />
        </div>
      </template>

      <template #footer="{ collapsed }">
        <UserMenu :collapsed="collapsed" />
      </template>
    </UDashboardSidebar>

    <UDashboardSearch :groups="groups" />

    <slot />

    <NotificationsSlideover />
    <FeedbackSlideover v-model="isFeedbackOpen" />
  </UDashboardGroup>
</template>
